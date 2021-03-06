import { UserDao } from "../daos/userDao";
import bcrypt from "bcrypt";
import { ApplicationError } from "../errors/applicationError";
import { ApplicationErrorCodes } from "../errors/errorCodes";
import jwt from "jsonwebtoken";
import { Constants } from "../config/constants";
import { ReviewDao } from "../daos/reviewDao";
import { RestaurantDao } from "../daos/restaurantDao";
import { print } from "../utils";
import { IUser, Role } from "../models/user";
import { IRestaurant } from "../models/restaurant";
import { IReview } from "../models/review";

export class UserController {
  private userDao = new UserDao();
  private reviewDao = new ReviewDao();
  private restaurantDao = new RestaurantDao();
  public async create(
    name: string,
    password: string,
    email: string
  ): Promise<any> {
    let hash = bcrypt.hashSync(password, 10);
    let user = await this.userDao
      .create(name, email, hash)
      .catch(function (error) {
        return Promise.reject(error);
      });
    return user.toJSON();
  }

  public async getUser(id: string): Promise<any> {
    return this.userDao
      .findById(id)
      .then(function (user) {
        if (user == null) {
          let error = new ApplicationError();
          error.title = "There is no user with this id";
          error.code = ApplicationErrorCodes.USER_DOES_NOT_EXIST;
          return Promise.reject(error);
        }
        return user.toJSON();
      })
      .catch(function (err) {
        return Promise.reject(err);
      });
  }

  private async deleteRestaurantInfo(user: IUser) {
    console.log("Deleting resturant info for user " + user);
    for (let restaurant of user.ownedRestaurants) {
      console.log("Owned restaurant resturant info for user " + restaurant);
      await this.reviewDao.deleteReviewsForRestaurant(restaurant);
    }
    console.log(user._id);
    await this.restaurantDao.deleteOwnerRestaurants(user._id);
  }

  public async edit(id: string, name: string, role: string): Promise<any> {
    let user = await this.userDao.findById(id);
    var roleEnum: Role;
    if (role == Role.Admin) {
      await this.deleteRestaurantInfo(user);
      roleEnum = Role.Admin;
    } else if (role == Role.Owner) {
      roleEnum = Role.Owner;
    } else if (role == Role.Regular) {
      await this.deleteRestaurantInfo(user);
      roleEnum = Role.Regular;
    }
    await this.userDao.edit(id, name, roleEnum);
    return "OK";
  }

  public async delete(id: string): Promise<any> {
    let user = await this.userDao.findById(id);
    for (var restaurant of user.ownedRestaurants) {
      await this.reviewDao.deleteReviewsForRestaurant(restaurant._id);
    }
    await this.restaurantDao.deleteOwnerRestaurants(id);
    let ghostUser = await this.userDao.getGhostUser();
    await this.reviewDao.changeReviewerId(id, ghostUser._id);
    await this.userDao.delete(id);
    return "OK";
  }

  public async authorise(email: string, password: string): Promise<any> {
    return this.userDao
      .findByEmail(email)
      .then(function (user) {
        if (!bcrypt.compareSync(password, user.hash)) {
          let error = new ApplicationError();
          error.title = "Passwords do not match";
          error.code = ApplicationErrorCodes.PASSWORDS_DO_NOT_MATCH;
          return Promise.reject(error);
        }
        const token = jwt.sign(
          {
            sub: user.toJSON().id,
          },
          Constants.JWT_SECRET
        );
        return {
          ...user.toJSON(),
          token,
        };
      })
      .catch(function (error) {
        return Promise.reject(error);
      });
  }

  public async findAllUsers(): Promise<any[]> {
    return this.userDao.findAll().then(function (users) {
      return users.map((user) => user.toJSON());
    });
  }

  public async findPendingReviews(ownerId: string): Promise<any[]> {
    let user = await this.userDao.findById(ownerId);
    let response: any[] = [];
    let restaurant: IRestaurant;
    let reviews: IReview[];
    for (var restaurantId of user.ownedRestaurants) {
      try {
        restaurant = await this.restaurantDao.findById(restaurantId);
        reviews = await this.reviewDao.findPendingReviews(restaurantId);
      } catch {
        continue;
      }

      if (reviews.length == 0) {
        continue;
      }
      response.push({
        restaurantName: restaurant.name,
        restaurantId: restaurant._id,
        pendingReviews: reviews.map(function (review) {
          return {
            id: review.id,
            restaurantId: review.restaurantId,
            visitedDate: review.visitedDate,
            rating: review.rating,
            review: review.reviewString,
            reviewer: review.reviewerId,
          };
        }),
      });
    }
    return response;
  }
}

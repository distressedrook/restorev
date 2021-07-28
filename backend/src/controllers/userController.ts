import { UserDao } from "../daos/userDao";
import bcrypt from "bcrypt";
import { ApplicationError } from "../errors/applicationError";
import { ApplicationErrorCodes } from "../errors/errorCodes";
import jwt from "jsonwebtoken";
import { Constants } from "../config/constants";
import { ReviewDao } from "../daos/reviewDao";
import { RestaurantDao } from "../daos/restaurantDao";
import { print } from "../utils";
import { Role } from "../models/user";

export class UserController {
  private userDao = new UserDao();
  private reviewDao = new ReviewDao();
  private restaurantDao = new RestaurantDao();
  public async create(
    name: string,
    password: string,
    email: string,
    role: string
  ): Promise<any> {
    let hash = bcrypt.hashSync(password, 10);
    let user = await this.userDao
      .create(name, email, hash, role)
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

  public async edit(id: string, name: string, role: string): Promise<any> {
    var roleEnum: Role;
    if (role == Role.Admin) {
      roleEnum = Role.Admin;
    } else if (role == Role.Owner) {
      roleEnum = Role.Owner;
    } else if (role == Role.Regular) {
      roleEnum = Role.Regular;
    }
    return this.userDao.edit(id, name, roleEnum).then(function () {
      return "OK";
    });
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
            role: user.role,
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
    for (let restaurantId of user.ownedRestaurants) {
      let restaurant = await this.restaurantDao.findById(restaurantId);
      print(restaurant);
      let reviews = await this.reviewDao.findPendingReviews(restaurantId);
      if (reviews.length == 0) {
        continue;
      }
      response.push({
        restaurantName: restaurant.name,
        restaurantId: restaurant._id,
        pendingReviews: reviews.map((review) => review.toJSON()),
      });
    }
    return response;
  }
}

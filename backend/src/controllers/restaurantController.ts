import { RestaurantDao } from "../daos/restaurantDao";
import { ReviewDao } from "../daos/reviewDao";
import { UserDao } from "../daos/userDao";
import { IRestaurant } from "../models/restaurant";
import { IReview } from "../models/review";

export class RestaurantController {
  restaurantDao = new RestaurantDao();
  reviewsDao = new ReviewDao();
  userDao = new UserDao();
  public async create(name: string, ownerId: string): Promise<any> {
    let rest = await this.restaurantDao
      .create(name, ownerId)
      .then(function (restaurant) {
        return restaurant.toJSON();
      });
    await this.userDao.addRestaurantToOwner(ownerId, rest.id);
    return rest;
  }

  public async editRestaurant(restaurantId: string, name: string) {
    return this.restaurantDao.edit(restaurantId, name);
  }

  public async deleteRestaurant(restaurantId: string) {
    let restaurant = await this.restaurantDao.findById(restaurantId);
    let owner = await this.userDao.findById(restaurant.ownerId);
    owner.ownedRestaurants = owner.ownedRestaurants.filter(function (element) {
      return element != restaurantId;
    });
    await owner.save();
    await this.reviewsDao.deleteReviewsForRestaurant(restaurantId);
    await restaurant.delete();
    return "OK";
  }

  public async addReview(
    reviewString: string,
    reviewerId: string,
    restaurantId: string,
    visitedDate: number,
    rating: number
  ): Promise<any> {
    await this.findRestaurantById(restaurantId);
    let review = await this.reviewsDao.create(
      reviewString,
      reviewerId,
      restaurantId,
      visitedDate,
      rating
    );
    await review.save();
    await this.restaurantDao.addReview(review._id, restaurantId);
    return review.toJSON();
  }

  public async findAll(): Promise<any> {
    let cThis = this;
    return this.restaurantDao.findAllRestaurants().then(function (restaurants) {
      let restaurantsJSON = restaurants.map(function (restaurant) {
        let averageRating = cThis.calculateAverageRating(restaurant.reviews);
        let restaurantJSON = restaurant.toJSON();
        delete restaurantJSON.reviews;
        delete restaurantJSON.ownerId;
        restaurantJSON.averageRating = averageRating;
        return restaurantJSON;
      });
      restaurantsJSON.sort(function (a, b) {
        if (a.averageRating > b.averageRating) {
          return 1;
        }
        return 0;
      });
      return restaurantsJSON;
    });
  }

  private calculateAverageRating(reviews: IReview[]): number {
    if (reviews.length == 0) {
      return 0;
    }
    let sum = 0;
    let averageRaging = 0;
    for (let review of reviews) {
      sum += review.rating;
    }
    let averageRating = 0;
    averageRating = sum / reviews.length;
    return averageRating;
  }

  private async transformRestaurant(restaurant: IRestaurant): Promise<any> {
    var restsaurantJSON = restaurant.toJSON();
    let restaurntRes: any = {
      name: restaurant.name,
      ownerId: restaurant.ownerId,
      id: restaurant.id,
    };
    let reviews: any[] = [];
    for (let review of restaurant.reviews) {
      let reviewRes: any = {
        restaurantId: review.restaurantId,
        visitedDate: review.visitedDate,
        rating: review.rating,
        ownerComment: review.ownerComment,
        id: review.id,
        review: review.reviewString,
      };
      let reviewer = await this.userDao.findById(review.reviewerId);
      reviewRes.reviewer = reviewer.toJSON();
      reviews.push(reviewRes);
    }
    restaurntRes.reviews = reviews;
    return restaurntRes;
  }

  public async findRestaurantById(id: string): Promise<any> {
    let cThis = this;
    return this.restaurantDao.findById(id).then(function (restaurant) {
      let averageRating = cThis.calculateAverageRating(restaurant.reviews);
      return cThis
        .transformRestaurant(restaurant)
        .then(function (restaurantJSON) {
          restaurantJSON.averageRating = averageRating;
          return restaurantJSON;
        });
    });
  }
}

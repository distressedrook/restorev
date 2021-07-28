import { RestaurantDao } from "../daos/restaurantDao";
import { ReviewDao } from "../daos/reviewDao";
import { UserDao } from "../daos/userDao";

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
    return this.restaurantDao.findAllRestaurants().then(function (restaurants) {
      return restaurants.map(function (restaurant) {
        return restaurant.toJSON();
      });
    });
  }

  public async findRestaurantById(id: string): Promise<any> {
    return this.restaurantDao.findById(id).then(function (restaurant) {
      return restaurant.toJSON();
    });
  }
}

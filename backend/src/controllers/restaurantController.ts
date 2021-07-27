import { RestaurantDao } from "../daos/restaurantDao";
import { ReviewDao } from "../daos/reviewDao";
import { UserDao } from "../daos/userDao";
import { print, wrapSuccess } from "../utils";

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

  public async addReview(
    reviewString: string,
    reviewerId: string,
    restaurantId: string,
    visitedDate: number,
    rating: number
  ): Promise<any> {
    print("Is is coming here?");
    await this.findRestaurantById(restaurantId);
    let review = await this.reviewsDao.create(
      reviewString,
      reviewerId,
      restaurantId,
      visitedDate,
      rating
    );
    print(review);
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

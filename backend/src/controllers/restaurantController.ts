import { ResturantDao } from "../dal/restaurantDao";
import { ReviewDao } from "../dal/reviewDao";
import { print } from "../utils";

export class RestaurantController {
  restaurantDao = new ResturantDao();
  reviewsDao = new ReviewDao();
  public async create(name: string, ownerId: string): Promise<any> {
    return this.restaurantDao.create(name, ownerId).then(function (restaurant) {
      return restaurant.toJSON();
    });
  }

  public async addReview(
    reviewString: string,
    reviewerId: string,
    restaurantId: string,
    visitedDate: number,
    rating: number
  ): Promise<any> {
    let review = await this.reviewsDao.create(
      reviewString,
      reviewerId,
      restaurantId,
      visitedDate,
      rating
    );
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

  public async findById(id: string): Promise<any> {
    return this.restaurantDao.findById(id).then(function (restaurant) {
      return restaurant.toJSON();
    });
  }
}

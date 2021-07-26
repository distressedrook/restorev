import { ResturantDao } from "../dal/restaurantDao";

export class RestaurantController {
  restaurantDao = new ResturantDao();
  public create(name: string, ownerId: string): Promise<any> {
    return this.restaurantDao.create(name, ownerId).then(function (restaurant) {
      return restaurant.toJSON();
    });
  }
}

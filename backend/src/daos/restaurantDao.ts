import { StatusCodes } from "http-status-codes";
import { ApplicationError } from "../errors/applicationError";
import { ApplicationErrorCodes } from "../errors/errorCodes";
import { IRestaurant, Restaurant } from "../models/restaurant";
import { print } from "../utils";

export class RestaurantDao {
  public async create(name: string, ownerId: string): Promise<IRestaurant> {
    var restaurant = new Restaurant({
      name: name,
      ownerId: ownerId,
    });
    await restaurant
      .save()
      .then(function (doc) {
        return doc.toJSON();
      })
      .catch(function (err) {
        let error = new ApplicationError();
        error.title = "A restaurant with this name already exists";
        error.code = ApplicationErrorCodes.RESTAURANT_EXISTS;
        return Promise.reject(error);
      });
    return restaurant;
  }

  public async edit(restaurantId: string, name: string) {
    return Restaurant.updateOne(
      { _id: restaurantId },
      {
        $set: {
          name: name,
        },
      }
    )
      .exec()
      .then(function (doc) {
        return;
      });
  }

  public async delete(restaurantId: string) {
    return Restaurant.deleteOne({ _id: restaurantId })
      .exec()
      .then(function (doc) {
        return;
      });
  }

  public async findByName(name: string): Promise<IRestaurant> {
    let cThis = this;
    return Restaurant.findOne({ name: name })
      .exec()
      .catch(function (err) {
        return cThis.getGenericReject(err);
      })
      .then(function (doc) {
        if (doc === null) {
          let error = new ApplicationError();
          error.title = "A resturant with this name does not exist.";
          error.code = ApplicationErrorCodes.RESTAURANT_DOES_NOT_EXIST;
          return Promise.reject(error);
        }
        return doc;
      });
  }

  public async deleteOwnerRestaurants(ownerId: string) {
    let cThis = this;
    Restaurant.deleteMany({
      ownerId: ownerId,
    })
      .exec()
      .catch(function (err) {
        return cThis.getGenericReject(err);
      });
  }

  public async findAllRestaurants(): Promise<IRestaurant[]> {
    let cThis = this;
    return Restaurant.find({})
      .populate("reviews")
      .exec()
      .catch(function (err) {
        return cThis.getGenericReject(err);
      })
      .then(function (doc) {
        if (doc == null) {
          return [];
        }
        print(doc);
        return doc;
      });
  }

  public async findRestaurants(ownerId: string): Promise<IRestaurant[]> {
    let cThis = this;
    return Restaurant.find({ ownerId: ownerId })
      .exec()
      .catch(function (err) {
        return cThis.getGenericReject(err);
      })
      .then(function (doc) {
        if (doc == null) {
          let error = new ApplicationError();
          error.title =
            "This user does not exist or does not own any restaurants";
          error.code = ApplicationErrorCodes.OWNER_DOES_NOT_EXIST;
          return Promise.reject(error);
        }
        return doc;
      });
  }

  public async findById(id: string): Promise<IRestaurant> {
    let cThis = this;
    return Restaurant.findOne({ _id: id })
      .populate("reviews")
      .exec()
      .catch(function (err) {
        return cThis.getGenericReject(err);
      })
      .then(function (doc) {
        if (doc == null) {
          let error = new ApplicationError();
          error.title = "There is no restaurant with that id";
          error.code = ApplicationErrorCodes.RESTAURANT_DOES_NOT_EXIST;
          return Promise.reject(error);
        }
        return doc;
      });
  }

  public async addReview(reviewId: string, restaurantId: string) {
    print("Adding review " + reviewId);
    let cThis = this;
    return Restaurant.updateOne(
      { _id: restaurantId },
      {
        $push: { reviews: reviewId },
      }
    )
      .exec()
      .catch(function (err) {
        print(err);
        return cThis.getGenericReject(err);
      });
  }

  private getGenericReject(err) {
    let error = new ApplicationError();
    error.title = "Internal Server Error";
    error.code = "" + StatusCodes.INTERNAL_SERVER_ERROR;
    return Promise.reject(error);
  }
}

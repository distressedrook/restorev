import { StatusCodes } from "http-status-codes";
import { ApplicationError } from "../errors/applicationError";
import { ApplicationErrorCodes } from "../errors/errorCodes";
import { IRestaurant, Restaurant } from "../models/restaurant";

export class ResturantDao {
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
          error.title = "There is no user with that email";
          error.code = ApplicationErrorCodes.RESTAURANT_DOES_NOT_EXIST;
          return Promise.reject(error);
        }
        return doc;
      });
  }

  public async getAllRestaurants(): Promise<IRestaurant[]> {
    let cThis = this;
    return Restaurant.find({})
      .exec()
      .catch(function (err) {
        return cThis.getGenericReject(err);
      })
      .then(function (doc) {
        if (doc == null) {
          return [];
        }
        return doc;
      });
  }

  public async getRestaurants(ownerId: string): Promise<IRestaurant[]> {
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

  private getGenericReject(err) {
    let error = new ApplicationError();
    error.title = "Internal Server Error";
    error.code = "" + StatusCodes.INTERNAL_SERVER_ERROR;
    return Promise.reject(error);
  }
}

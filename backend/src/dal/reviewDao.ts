import { StatusCodes } from "http-status-codes";
import { ApplicationError } from "../errors/applicationError";
import { ApplicationErrorCodes } from "../errors/errorCodes";
import { IRestaurant, Restaurant } from "../models/restaurant";
import { IReview, Review } from "../models/review";
import { print } from "../utils";

export class ReviewDao {
  public async create(
    reviewString: string,
    reviewerId: string,
    restaurantId: string,
    visitedDate: number,
    rating: number
  ): Promise<IReview> {
    let cThis = this;

    await this.findById(restaurantId);

    let review = new Review({
      reviewString: reviewString,
      reviewerId: reviewerId,
      restaurantId: restaurantId,
      visitedDate: visitedDate,
      rating: rating,
    });
    await review
      .save()
      .then(function (doc) {
        return doc.toJSON();
      })
      .catch(function (err) {
        print(err);
        return cThis.getGenericReject(err);
      });
    return review;
  }

  public async findReviewsByRestaurantId(
    restaurantId: string
  ): Promise<IReview[]> {
    let cThis = this;
    return Review.find({ restaurantId: restaurantId })
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

  public async findById(id: string): Promise<IRestaurant> {
    let cThis = this;
    return Restaurant.findOne({ _id: id })
      .exec()
      .catch(function (err) {
        return cThis.noRestaurantReject();
      })
      .then(function (doc) {
        if (doc == null) {
          return cThis.noRestaurantReject();
        }
        return doc;
      });
  }

  private noRestaurantReject() {
    let error = new ApplicationError();
    error.status = ApplicationErrorCodes.RESTAURANT_DOES_NOT_EXIST;
    error.title = "This restaurant does not exist";
    return Promise.reject(error);
  }

  private getGenericReject(err) {
    let error = new ApplicationError();
    error.title = "Internal Server Error";
    error.code = "" + StatusCodes.INTERNAL_SERVER_ERROR;
    return Promise.reject(error);
  }
}

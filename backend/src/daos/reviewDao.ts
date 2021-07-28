import { StatusCodes } from "http-status-codes";
import { ApplicationError } from "../errors/applicationError";
import { ApplicationErrorCodes } from "../errors/errorCodes";
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

    let review = new Review({
      reviewString: reviewString,
      reviewerId: reviewerId,
      restaurantId: restaurantId,
      visitedDate: visitedDate,
      rating: rating,
    });
    print(review);
    await review
      .save()
      .then(function (doc) {
        return doc.toJSON();
      })
      .catch(function (err) {
        print(err);
        return cThis.getGenericReject(err);
      });
    print(review);
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

  public async findPendingReviews(restaurantId: string): Promise<IReview[]> {
    let cThis = this;
    return Review.find({ restaurantId: restaurantId, ownerComment: null })
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

  public async findById(id: string): Promise<IReview> {
    let cThis = this;
    return Review.findOne({ _id: id })
      .exec()
      .catch(function (err) {
        return cThis.noReviewReject();
      })
      .then(function (doc) {
        if (doc == null) {
          return cThis.noReviewReject();
        }
        return doc;
      });
  }

  public async comment(id: string, commentString: string): Promise<IReview> {
    let cThis = this;
    return Review.findOne({ _id: id })
      .exec()
      .catch(function (err) {
        return cThis.noReviewReject();
      })
      .then(function (doc) {
        if (doc == null) {
          return cThis.noReviewReject();
        }
        if (doc.ownerComment == null) {
          doc.ownerComment = commentString;
          doc.save();
          return doc;
        } else {
          let error = new ApplicationError();
          error.status = ApplicationErrorCodes.COMMENT_ALREADY_EXISTS;
          error.status = "You cannot add a comment again";
          return Promise.reject(error);
        }
      });
  }

  public async edit(
    id: string,
    reviewString: string,
    rating: number,
    visitedDate: number
  ) {
    let cThis = this;

    Review.updateOne(
      { _id: id },
      {
        $set: {
          reviewString: reviewString,
          rating: rating,
          visitedDate: visitedDate,
        },
      }
    )
      .exec()
      .catch(function (err) {
        return cThis.noReviewReject();
      });
  }

  public async changeReviewerId(
    curReviewerId: string,
    toReviewerId: string
  ): Promise<any> {
    let cThis = this;
    Review.updateMany(
      {
        reviewerId: curReviewerId,
      },
      {
        $set: {
          reviewerId: toReviewerId,
        },
      }
    )
      .exec()
      .catch(function (err) {
        return cThis.noReviewReject();
      });
  }

  public async deleteReviewsForRestaurant(restaurantId: string) {
    let cThis = this;
    return Review.deleteMany({
      restaurantId: restaurantId,
    })
      .exec()
      .catch(function (error) {
        return cThis.getGenericReject(error);
      });
  }

  private noReviewReject() {
    let error = new ApplicationError();
    error.status = ApplicationErrorCodes.REVIEW_DOES_NOT_EXIST;
    error.title = "This review does not exist";
    return Promise.reject(error);
  }

  private getGenericReject(err) {
    let error = new ApplicationError();
    error.title = "Internal Server Error";
    error.code = "" + StatusCodes.INTERNAL_SERVER_ERROR;
    return Promise.reject(error);
  }
}

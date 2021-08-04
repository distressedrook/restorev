import { RestaurantDao } from "../daos/restaurantDao";
import { ReviewDao } from "../daos/reviewDao";

export class ReviewController {
  reviewDao = new ReviewDao();
  restaurantDao = new RestaurantDao();
  public async comment(reviewId: string, comment: string): Promise<any> {
    return this.reviewDao.comment(reviewId, comment).then(function (review) {
      return review.toJSON();
    });
  }

  public async editReview(
    id: string,
    reviewString: string,
    rating: number,
    visitedDate: number
  ): Promise<any> {
    return this.reviewDao
      .edit(id, reviewString, rating, visitedDate)
      .then(function () {
        return "OK";
      });
  }

  public async deleteReview(id: string): Promise<any> {
    let review = await this.reviewDao.findById(id);
    let restaurant = await this.restaurantDao.findById(review.restaurantId);
    await this.restaurantDao.updateReviews(
      restaurant._id,
      restaurant.reviews.filter((reviewId) => reviewId != id)
    );
    await this.reviewDao.deleteReview(id);
    return "OK";
  }

  public async editComment(reviewId: string, comment: string): Promise<any> {
    let review = await this.reviewDao.findById(reviewId);
    review.ownerComment = comment;
    await review.save();
    return "OK";
  }

  public async deleteComment(id: string): Promise<any> {
    await this.reviewDao.deleteComment(id);
    return "OK";
  }

  public async findById(id: string): Promise<any> {
    return this.reviewDao.findById(id).then(function (review) {
      return review.toJSON();
    });
  }
}

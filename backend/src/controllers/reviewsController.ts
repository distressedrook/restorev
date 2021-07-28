import { ReviewDao } from "../daos/reviewDao";

export class ReviewController {
  reviewDao = new ReviewDao();
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

  public async findById(id: string): Promise<any> {
    return this.reviewDao.findById(id).then(function (review) {
      return review.toJSON();
    });
  }
}

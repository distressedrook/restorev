import { ReviewDao } from "../daos/reviewDao";

export class ReviewController {
  reviewDao = new ReviewDao();
  public async comment(reviewId: string, comment: string): Promise<any> {
    return this.reviewDao.comment(reviewId, comment).then(function (review) {
      return review.toJSON();
    });
  }

  public async findById(id: string): Promise<any> {
    return this.reviewDao.findById(id).then(function (review) {
      return review.toJSON();
    });
  }
}

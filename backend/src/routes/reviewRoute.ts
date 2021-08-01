import express from "express";
const router = express.Router();

import { body } from "express-validator";
import { ReviewController } from "../controllers/reviewsController";
import {
  checkCommentPrivilege,
  fillRestaurantId,
  isOwner,
  isAdmin,
} from "../middlewares/generalMiddlewares";
import { requestValidator } from "../middlewares/validators";
import { wrapError, wrapSuccess } from "../utils";
import { UserController } from "../controllers/userController";
import { StatusCodes } from "http-status-codes";

const COMMENT = "comment";

const REVIEW = "review";
const RATING = "rating";
const VISITED_DATE = "visitedDate";

let commentValidators = [
  body(COMMENT).isLength({
    min: 10,
  }),
  body(COMMENT).isString(),
];

let editReviewValidators = [
  body(REVIEW).isLength({
    min: 2,
  }),
  body(RATING).isInt(),
  body(VISITED_DATE).isInt(),
];

function comment(req, res, next) {
  let reviewController = new ReviewController();
  reviewController
    .comment(req.params.id, req.body.comment)
    .then(function (review) {
      res.send(wrapSuccess(review));
    })
    .catch(function (err) {
      res.send(wrapError([err]));
    });
}

function getPendingReviews(req, res, next) {
  let userController = new UserController();
  userController
    .findPendingReviews(req.user.sub)
    .then(function (reviews) {
      let responseBody = wrapSuccess(reviews);
      res.send(responseBody);
    })
    .catch(function (err) {
      err.status = "" + StatusCodes.BAD_REQUEST;
      res.status(StatusCodes.BAD_REQUEST);
      let responseBody = wrapError([err]);
      res.send(responseBody);
    });
}

function editReview(req, res, next) {
  let reviewController = new ReviewController();
  reviewController
    .editReview(
      req.params.id,
      req.body.review,
      req.body.rating,
      req.body.visitedDate
    )
    .then(function (response) {
      res.send(wrapSuccess(response));
    })
    .catch(function (error) {
      res.send(wrapError([error]));
    });
}

function deleteReview(req, res, next) {
  let reviewController = new ReviewController();
  reviewController
    .deleteReview(req.params.id)
    .then(function (response) {
      res.send(wrapSuccess(response));
    })
    .catch(function (error) {
      res.send(wrapError([error]));
    });
}

function deleteComment(req, res, next) {
  let reviewController = new ReviewController();
  reviewController
    .deleteComment(req.params.id)
    .then(function (response) {
      res.send(wrapSuccess(response));
    })
    .catch(function (error) {
      res.send(wrapError([error]));
    });
}

router.post(
  "/:id/comment",
  commentValidators,
  requestValidator,
  isOwner,
  fillRestaurantId,
  checkCommentPrivilege,
  comment
);

router.get("/pending", isOwner, getPendingReviews);
router.put(
  "/:id/edit",
  isAdmin,
  editReviewValidators,
  requestValidator,
  editReview
);

router.delete("/:id/delete", isAdmin, deleteReview);
router.delete("/:id/deleteComment", isAdmin, deleteComment);

export default router;

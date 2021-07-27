import express from "express";
const router = express.Router();

import { body } from "express-validator";
import { ReviewController } from "../controllers/reviewsController";
import {
  checkCommentPrivilege,
  fillRestaurantId,
  isOwner,
} from "../middlewares/generalMiddlewares";
import { requestValidator } from "../middlewares/validators";
import { print, wrapError, wrapSuccess } from "../utils";
import { UserController } from "../controllers/userController";
import { StatusCodes } from "http-status-codes";

const COMMENT = "comment";

var commentValidators = [
  body(COMMENT).isLength({
    min: 10,
  }),
  body(COMMENT).isString(),
];

function comment(req, res, next) {
  print("The review id is " + req.params.id);
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

router.post(
  "/:id/comment",
  commentValidators,
  requestValidator,
  isOwner,
  checkCommentPrivilege,
  fillRestaurantId,
  comment
);

router.get("/pending", isOwner, getPendingReviews);

export default router;

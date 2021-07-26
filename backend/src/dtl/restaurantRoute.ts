import express from "express";
const router = express.Router();

import { body } from "express-validator";
import { StatusCodes } from "http-status-codes";
import { RestaurantController } from "../controllers/restaurantController";
import { isOwner, isRegular } from "../middlewares/permissionCheckers";
import { isValidRating, requestValidator } from "../middlewares/validators";
import { wrapError, wrapSuccess } from "../utils";

const NAME = "name";
const OWNER_ID = "ownerId";
const REVIEW = "review";
const RATING = "rating";
const VISITED_DATE = "visitedDate";

function addRestaurant(req, res, next) {
  const requestBody = req.body;
  let controller = new RestaurantController();
  controller
    .create(requestBody.name, requestBody.ownerId)
    .then(function (restaurant) {
      res.status(StatusCodes.CREATED);
      res.send(wrapSuccess(restaurant));
    })
    .catch(function (error) {
      res.status(StatusCodes.OK);
      res.send(wrapError([error]));
    });
}

function addReview(req, res, next) {
  console.log("Is it coming here?");
  const requestBody = req.body;
  let controller = new RestaurantController();
  controller
    .addReview(
      requestBody.review,
      req.user.sub,
      req.params.restaurantId,
      requestBody.visitedDate,
      requestBody.rating
    )
    .then(function (review) {
      res.status(StatusCodes.CREATED);
      res.send(wrapSuccess(review));
    })
    .catch(function (err) {
      res.send(wrapError([err]));
    });
}

let createValidators = [
  body(NAME).isLength({
    min: 1,
  }),
  body(OWNER_ID).isLength({
    min: 1,
  }),
];

let addReviewValidators = [
  body(REVIEW).isLength({
    min: 2,
  }),
  body(RATING).isInt(),
  body(VISITED_DATE).isInt(),
];

router.post("/add", createValidators, requestValidator, isOwner, addRestaurant);

router.post(
  "/:restaurantId/addReview",
  addReviewValidators,
  requestValidator,
  isValidRating,
  isRegular,
  addReview
);

export default router;

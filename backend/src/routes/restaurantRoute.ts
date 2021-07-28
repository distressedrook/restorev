import express from "express";
const router = express.Router();

import { body } from "express-validator";
import { StatusCodes } from "http-status-codes";
import { RestaurantController } from "../controllers/restaurantController";
import { isAdmin, isOwner, isRegular } from "../middlewares/generalMiddlewares";
import { isValidRating, requestValidator } from "../middlewares/validators";
import { print, wrapError, wrapSuccess } from "../utils";

const NAME = "name";
const OWNER_ID = "ownerId";
const REVIEW = "review";
const RATING = "rating";
const VISITED_DATE = "visitedDate";

function getRestaurants(req, res, next) {
  let controller = new RestaurantController();
  controller
    .findAll()
    .then(function (restaurants) {
      print(restaurants);
      res.send(wrapSuccess(restaurants));
    })
    .catch(function (error) {
      res.status(StatusCodes.OK);
      res.send(wrapError([error]));
    });
}

function getRestaurantForId(req, res, next) {
  let controller = new RestaurantController();
  controller
    .findRestaurantById(req.params.id)
    .then(function (restaurant) {
      res.send(wrapSuccess(restaurant));
    })
    .catch(function (error) {
      res.status(StatusCodes.OK);
      res.send(wrapError([error]));
    });
}

function addRestaurant(req, res, next) {
  const requestBody = req.body;
  let controller = new RestaurantController();
  controller
    .create(requestBody.name, req.user.sub)
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

function editRestaurant(req, res, next) {
  let controller = new RestaurantController();
  controller
    .editRestaurant(req.params.id, req.body.name)
    .then(function () {
      res.send(wrapSuccess("OK"));
    })
    .catch(function (err) {
      res.status(StatusCodes.BAD_REQUEST);
      res.send(wrapError([err]));
    });
}

let createValidators = [
  body(NAME).isLength({
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

router.get("/", getRestaurants);
router.get("/:id", getRestaurantForId);
router.put("/:id/edit", isAdmin, editRestaurant);

export default router;

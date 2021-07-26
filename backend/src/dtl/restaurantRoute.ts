import express from "express";
const router = express.Router();

import { body } from "express-validator";
import { StatusCodes } from "http-status-codes";
import { RestaurantController } from "../controllers/restaurantController";
import { isOwner } from "../middlewares/permissionCheckers";
import { requestValidator } from "../middlewares/validators";
import { wrapError, wrapSuccess } from "../utils";

const NAME = "name";
const OWNER_ID = "ownerId";

var createValidators = [
  body(NAME).isLength({
    min: 1,
  }),
  body(OWNER_ID).isLength({
    min: 1,
  }),
];

router.post(
  "/add",
  createValidators,
  requestValidator,
  isOwner,
  function (req, res, next) {
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
);

export default router;

import { StatusCodes } from "http-status-codes";
import { RestaurantController } from "../controllers/restaurantController";
import { ReviewController } from "../controllers/reviewsController";
import { UserController } from "../controllers/userController";
import { ApplicationError } from "../errors/applicationError";
import { ApplicationErrorCodes } from "../errors/errorCodes";
import { print, sendForbidden, wrapError } from "../utils";

export function isOwner(req, res, next) {
  let controller = new UserController();
  controller.getUser(req.user.sub).then(function (user) {
    if (user.role != "owner") {
      sendForbidden(res);
      return;
    }
    print("Has been found to be a owner");
    next();
  });
}

export function isRegular(req, res, next) {
  let controller = new UserController();
  controller.getUser(req.user.sub).then(function (user) {
    if (user.role != "regular") {
      sendForbidden(res);
      return;
    }
    next();
  });
}

export function isAdmin(req, res, next) {
  let controller = new UserController();
  controller.getUser(req.user.sub).then(function (user) {
    if (user.role != "admin") {
      sendForbidden(res);
      return;
    }
    next();
  });
}

export function checkCommentPrivilege(req, res, next) {
  let restaurantController = new RestaurantController();
  restaurantController
    .findRestaurantById(req.body.restaurantId)
    .then(function (restaurant) {
      if (restaurant.ownerId != req.user.sub) {
        sendForbidden(res);
        return;
      }
      next();
    })
    .catch(function (err) {
      let error = new ApplicationError();
      error.code = ApplicationErrorCodes.RESTAURANT_DOES_NOT_EXIST;
      error.title = "A restaurant with this id does not exist";
      res.send(wrapError([error]));
    });
}

export function fillRestaurantId(req, res, next) {
  if (req.body.restaurantId != null) {
    next();
    return;
  }
  let reviewsController = new ReviewController();
  reviewsController.findById(req.params.id).then(function (review) {
    if (review == null) {
      let error = new ApplicationError();
      error.code = ApplicationErrorCodes.REVIEW_DOES_NOT_EXIST;
      error.title = "A review with this id does not exist";
      res.status(StatusCodes.NOT_FOUND);
      res.send(wrapError([error]));
      return;
    }
    req.body.restaurantId = review.restaurantId;
    next();
  });
}

import { UserController } from "../controllers/userController";
import { sendForbidden } from "../utils";

export function isOwner(req, res, next) {
  let controller = new UserController();
  controller.getUser(req.user.sub).then(function (user) {
    if (user.role != "owner") {
      sendForbidden(res);
      return;
    }
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

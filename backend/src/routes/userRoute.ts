import express, { response } from "express";
const router = express.Router();

import { UserController } from "../controllers/userController";
import { ApplicationErrorCodes } from "../errors/errorCodes";
import { isAdmin } from "../middlewares/generalMiddlewares";
import { wrapError, wrapSuccess } from "../utils";

function getAllUsers(req, res, next) {
  let userController = new UserController();
  userController
    .findAllUsers()
    .then(function (users) {
      res.send(wrapSuccess(users));
    })
    .catch(function (err) {
      res.send(wrapError([err]));
    });
}

function isSameUser(req, res, next) {
  if (req.params.id == req.user.sub) {
    res.send(
      wrapError([
        {
          code: ApplicationErrorCodes.CANNOT_DELETE,
        },
      ])
    );
    return;
  }
  next();
}

function getUserById(req, res, next) {
  let userController = new UserController();
  userController
    .getUser(req.params.id)
    .then(function (user) {
      res.send(wrapSuccess(user));
    })
    .catch(function (err) {
      res.send(wrapError([err]));
    });
}

function editUser(req, res, next) {
  let userController = new UserController();
  userController
    .edit(req.params.id, req.body.name, req.body.role)
    .then(function (user) {
      res.send(wrapSuccess(user));
    })
    .catch(function (err) {
      res.send(wrapError([err]));
    });
}

function deleteUser(req, res, next) {
  let userController = new UserController();
  userController
    .delete(req.params.id)
    .then(function (user) {
      res.send(wrapSuccess(user));
    })
    .catch(function (err) {
      res.send(wrapError([err]));
    });
}

router.get("/", isAdmin, getAllUsers);
router.get("/:id", isAdmin, getUserById);
router.put("/:id/edit", isAdmin, editUser);

router.delete("/:id/delete", isAdmin, isSameUser, deleteUser);

export default router;

import express from "express";
const router = express.Router();

import { UserController } from "../controllers/userController";
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

router.get("/", isAdmin, getAllUsers);
router.get("/:id", isAdmin, getUserById);
router.post("/:id/edit", isAdmin, editUser);

export default router;

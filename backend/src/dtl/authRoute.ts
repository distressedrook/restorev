import express from "express";
const router = express.Router();

import { body } from "express-validator";
import { StatusCodes } from "http-status-codes";
import { UserController } from "../controllers/userController";
import { requestValidator } from "../middlewares/validators";
import { wrapError, wrapSuccess } from "../utils";

const NAME = "name";
const EMAIL = "email";
const ROLE = "role";
const PASSWORD = "password";

const MIN_PASSWORD_LENGTH = 5;

var validators = [
  body(NAME).isLength({
    min: 1,
  }),
  body(EMAIL).isEmail(),
  body(PASSWORD).isLength({
    min: 5,
  }),
  body(ROLE).isLength({
    min: 1,
  }),
];

router.post(
  "/register",
  validators,
  requestValidator,
  function (req, res, next) {
    const userInfo = req.body;
    let userController = new UserController();
    userController
      .create(userInfo.name, userInfo.password, userInfo.email, userInfo.role)
      .then(function (user) {
        res.status(StatusCodes.CREATED);
        let responseBody = wrapSuccess(user);
        res.send(responseBody);
      })
      .catch(function (err) {
        err.status = "" + StatusCodes.BAD_REQUEST;
        res.status(StatusCodes.BAD_REQUEST);
        let responseBody = wrapError([err]);
        res.send(responseBody);
      });
  }
);

export default router;

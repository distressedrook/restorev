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

function register(req, res, next) {
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

function login(req, res, next) {
  const userInfo = req.body;
  let userController = new UserController();
  userController
    .authorise(userInfo.email, userInfo.password)
    .then(function (user) {
      res.status(StatusCodes.OK);
      let responseBody = wrapSuccess(user);
      res.send(responseBody);
    })
    .catch(function (err) {
      res.status(StatusCodes.OK);
      let responseBody = wrapError([err]);
      res.send(responseBody);
    });
}

var signupValidators = [
  body(NAME).isLength({
    min: 1,
  }),
  body(EMAIL).isEmail(),
  body(PASSWORD).isLength({
    min: MIN_PASSWORD_LENGTH,
  }),
  body(ROLE).isLength({
    min: 1,
  }),
];

var loginValidators = [
  body(EMAIL).isEmail(),
  body(PASSWORD).isLength({
    min: 5,
  }),
];

router.post("/register", signupValidators, requestValidator, register);

router.post("/login", loginValidators, requestValidator, login);

export default router;

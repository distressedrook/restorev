import { ApplicationError } from "../errors/applicationError";
import { validationResult } from "express-validator";
import { StatusCodes } from "http-status-codes";
import { ApplicationErrorCodes } from "../errors/errorCodes";
import { print, wrapError } from "../utils";

export function requestValidator(req, res, next) {
  const vErrors = validationResult(req);
  if (!vErrors.isEmpty()) {
    let errors: ApplicationError[] = new Array();
    for (var vError of vErrors.array()) {
      let error = new ApplicationError();
      error.status = StatusCodes.BAD_REQUEST.toString();
      error.title = vError.msg;
      errors.push(error);
    }
    res.status(StatusCodes.BAD_REQUEST);
    res.send({
      errors,
    });
    return;
  }
  next();
}

export function isValidRating(req, res, next) {
  if (req.body.rating < 1 || req.body.rating > 5) {
    let error = new ApplicationError();
    error.status = ApplicationErrorCodes.INVALID_RATING;
    error.message = "The rating has to be between 1 an 5";
    res.send(wrapError([error]));
    return;
  }
  next();
}

import { ApplicationError } from "../errors/applicationError";
import { validationResult } from "express-validator";
import { StatusCodes } from "http-status-codes";

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

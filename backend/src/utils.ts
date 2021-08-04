import { StatusCodes } from "http-status-codes";
import { ApplicationError } from "./errors/applicationError";

export function wrapSuccess(body: any): any {
  print(body);
  return {
    success: {
      data: body,
    },
  };
}

export function wrapError(err: any[]): any {
  console.log(err);
  return {
    errors: err,
  };
}

export function sendForbidden(res) {
  let error = new ApplicationError();
  error.status = "" + StatusCodes.FORBIDDEN;
  error.message = "This user is not allowed to access this resource";
  res.status(StatusCodes.FORBIDDEN);
  res.send(wrapError([error]));
}

export function print(val) {
  console.log(val);
}

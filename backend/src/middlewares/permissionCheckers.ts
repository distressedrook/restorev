import { StatusCodes } from "http-status-codes";
import { ApplicationError } from "../errors/applicationError";
import { wrapError } from "../utils";

export function isOwner(req, res, next) {
  if (req.user.role != "owner" || req.user.sub != req.body.ownerId) {
    let error = new ApplicationError();
    error.status = "" + StatusCodes.FORBIDDEN;
    error.message = "This user cannot create a restaurant";
    res.status(StatusCodes.FORBIDDEN);
    res.send(wrapError([error]));
    return;
  }
  next();
}

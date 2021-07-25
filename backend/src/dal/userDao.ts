import { ApplicationError } from "../errors/applicationError";
import { EMAIL_EXISTS_ERROR_CODE } from "../errors/errorCodes";
import { IUser, User } from "../models/user";

export class UserDao {
  public async create(
    name: string,
    email: string,
    hash: string,
    role: string
  ): Promise<IUser> {
    var user = new User({
      name: name,
      email: email,
      hash: hash,
      role: role,
    });
    await user
      .save()
      .then(function (doc) {
        return Promise.resolve(doc.toJSON());
      })
      .catch(function (err) {
        let error = new ApplicationError();
        error.title = "A user with this email already exists";
        error.code = EMAIL_EXISTS_ERROR_CODE;
        return Promise.reject(error);
      });
    return user;
  }
}

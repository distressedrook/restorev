import { UserDao } from "../dal/userDao";
import bcrypt from "bcrypt";
import { ApplicationError } from "../errors/applicationError";
import { ApplicationErrorCodes } from "../errors/errorCodes";
import jwt from "jsonwebtoken";
import { Constants } from "../config/constants";

export class UserController {
  private userDao = new UserDao();
  public async create(
    name: string,
    password: string,
    email: string,
    role: string
  ): Promise<any> {
    let hash = bcrypt.hashSync(password, 10);
    let user = await this.userDao
      .create(name, email, hash, role)
      .catch(function (error) {
        return Promise.reject(error);
      });
    return user.toJSON();
  }

  public async getUser(id: string): Promise<any> {
    return this.userDao
      .findById(id)
      .then(function (user) {
        if (user == null) {
          let error = new ApplicationError();
          error.title = "There is no user with this id";
          error.code = ApplicationErrorCodes.USER_DOES_NOT_EXIST;
          return Promise.reject(error);
        }
        return user.toJSON();
      })
      .catch(function (err) {
        return Promise.reject(err);
      });
  }

  public async authorise(email: string, password: string): Promise<any> {
    return this.userDao
      .findByEmail(email)
      .then(function (user) {
        if (!bcrypt.compareSync(password, user.hash)) {
          let error = new ApplicationError();
          error.title = "Passwords do not match";
          error.code = ApplicationErrorCodes.PASSWORDS_DO_NOT_MATCH;
          return Promise.reject(error);
        }
        const token = jwt.sign(
          {
            sub: user.toJSON().id,
            role: user.role,
          },
          Constants.JWT_SECRET
        );
        return {
          ...user.toJSON(),
          token,
        };
      })
      .catch(function (error) {
        return Promise.reject(error);
      });
  }
}

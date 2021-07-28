import { StatusCodes } from "http-status-codes";
import { ApplicationError } from "../errors/applicationError";
import { ApplicationErrorCodes } from "../errors/errorCodes";
import { IUser, Role, User } from "../models/user";

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
        error.code = ApplicationErrorCodes.EMAIL_EXISTS;
        return Promise.reject(error);
      });
    return user;
  }

  public async edit(id: string, name: string, role: Role) {
    let cThis = this;
    User.updateOne(
      { _id: id },
      {
        $set: {
          name: name,
          role: role,
        },
      }
    )
      .exec()
      .catch(function (err) {
        return cThis.getGenericReject(err);
      });
  }

  public async delete(id: string) {
    let cThis = this;
    User.deleteOne({ _id: id })
      .exec()
      .catch(function (err) {
        return cThis.getGenericReject(err);
      });
  }

  public async getGhostUser(): Promise<IUser> {
    let cThis = this;
    return User.findOne({
      role: Role.Ghost,
    })
      .exec()
      .catch(function (err) {
        return cThis.getGenericReject(err);
      });
  }

  public async findByEmail(email: string): Promise<IUser> {
    let cThis = this;
    return User.findOne({ email: email })
      .exec()
      .catch(function (err) {
        return cThis.getGenericReject(err);
      })
      .then(function (doc) {
        if (doc === null) {
          let error = new ApplicationError();
          error.title = "There is no user with that email";
          error.code = ApplicationErrorCodes.USER_DOES_NOT_EXIST;
          return Promise.reject(error);
        }
        return doc;
      });
  }

  public async findById(id: string): Promise<IUser> {
    let cThis = this;
    return User.findOne({ _id: id })
      .exec()
      .catch(function (err) {
        return cThis.getGenericReject(err);
      })
      .then(function (doc) {
        if (doc == null) {
          let error = new ApplicationError();
          error.title = "There is no user with that id";
          error.code = ApplicationErrorCodes.ID_DOES_NOT_EXIST;
          return Promise.reject(error);
        }
        return doc;
      });
  }

  public async findAll(): Promise<IUser[]> {
    let cThis = this;
    return User.find({})
      .exec()
      .catch(function (err) {
        return cThis.getGenericReject(err);
      })
      .then(function (doc) {
        if (doc == null) {
          return [];
        }
        return doc;
      });
  }

  public async addRestaurantToOwner(userId: string, restaurantId: string) {
    return User.updateOne(
      { _id: userId },
      { $push: { ownedRestaurants: restaurantId } }
    );
  }

  private getGenericReject(err) {
    let error = new ApplicationError();
    error.title = "Internal Server Error";
    error.code = "" + StatusCodes.INTERNAL_SERVER_ERROR;
    return Promise.reject(error);
  }
}

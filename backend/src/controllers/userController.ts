import { UserDao } from "../dal/userDao";
import bcrypt from "bcrypt";

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
}

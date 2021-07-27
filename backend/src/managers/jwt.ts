import expressJwt from "express-jwt";
import { Constants } from "../config/constants";
import { UserDao } from "../daos/userDao";
const userDao = new UserDao();

export function jwt() {
  const secret = Constants.JWT_SECRET;
  return expressJwt({
    secret,
    algorithms: ["HS256"],
    isRevoked,
  }).unless({
    path: ["/auth/register", "/auth/login"],
  });
}

async function isRevoked(req, payload, done) {
  await userDao.findById(payload.sub).catch(function (err) {
    return done(err, true);
  });
  done();
}

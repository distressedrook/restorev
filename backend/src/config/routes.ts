import { Express } from "express";
import authRoute from "../dtl/authRoute";
module.exports = function (app: Express) {
  app.use("/auth", authRoute);
};

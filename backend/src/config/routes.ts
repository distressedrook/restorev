import { Express } from "express";
import authRoute from "../dtl/authRoute";
import restaurantRoute from "../dtl/restaurantRoute";
module.exports = function (app: Express) {
  app.use("/auth", authRoute);
  app.use("/restaurants", restaurantRoute);
};

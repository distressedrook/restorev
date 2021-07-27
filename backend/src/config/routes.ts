import { Express } from "express";
import authRoute from "../dtl/authRoute";
import restaurantRoute from "../dtl/restaurantRoute";
import reviewRoute from "../dtl/reviewRoute";
module.exports = function (app: Express) {
  app.use("/auth", authRoute);
  app.use("/restaurants", restaurantRoute);
  app.use("/reviews", reviewRoute);
};

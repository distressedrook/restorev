import { Express } from "express";
import authRoute from "../routes/authRoute";
import restaurantRoute from "../routes/restaurantRoute";
import reviewRoute from "../routes/reviewRoute";
module.exports = function (app: Express) {
  app.use("/auth", authRoute);
  app.use("/restaurants", restaurantRoute);
  app.use("/reviews", reviewRoute);
};

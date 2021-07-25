const path = require("path");
const cookieParser = require("cookie-parser");
const logger = require("morgan");
import express from "express";
import { jwt } from "../managers/jwt";

module.exports = function (app: express.Express) {
  app.use(logger("dev"));
  app.use(express.json());
  app.use(express.urlencoded({ extended: false }));
  app.use(jwt());
  app.use(cookieParser());
  app.use(express.static(path.join(__dirname, "public")));
};

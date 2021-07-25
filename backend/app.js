const express = require("express");
const db = require("./.www/config/db");
const startExpressConfig = require("./.www/config/express");
const startRoutesConfig = require("./.www/config/routes");

const app = express();

db.start(function () {
  startExpressConfig(app);
  startRoutesConfig(app);
});

module.exports = app;

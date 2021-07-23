"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const path = require('path');
const cookieParser = require('cookie-parser');
const logger = require('morgan');
const express_1 = __importDefault(require("express"));
module.exports = function (app) {
    app.use(logger('dev'));
    app.use(express_1.default.json());
    app.use(express_1.default.urlencoded({ extended: false }));
    app.use(cookieParser());
    app.use(express_1.default.static(path.join(__dirname, 'public')));
};
//# sourceMappingURL=express.js.map
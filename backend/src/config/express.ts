const path = require('path');
const cookieParser = require('cookie-parser');
const logger = require('morgan');
import express from 'express';

module.exports = function(app) {
    app.use(logger('dev'));
    app.use(express.json());
    app.use(express.urlencoded({ extended: false }));
    app.use(cookieParser());
    app.use(express.static(path.join(__dirname, 'public')));
}


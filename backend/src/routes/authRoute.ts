import express from 'express';
const router = express.Router();

import { body } from 'express-validator';
import { requestValidator } from '../helpers/validators';

const NAME = 'name';
const EMAIL = 'email';
const ROLE = 'role';
const PASSWORD = 'password';

const MIN_PASSWORD_LENGTH = 5;

var validators = [body(NAME).isLength({
        min: 1
    }),
    body(EMAIL).isEmail(),
    body(PASSWORD).isLength({
        min: 5
    }),
    body(ROLE).isLength( {
        min: 1
    }
)];

router.post('/register', validators, requestValidator, function(req, res, next) {
    res.send({
        "message": "It works!"
    });
});

export default router

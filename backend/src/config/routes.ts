import { Express } from 'express';
import authRoute from '../routes/authRoute';
module.exports = function(app: Express) {
    app.use('/auth', authRoute)
}
"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.mongoose = exports.start = void 0;
// Bring Mongoose into the app
const mongoose_1 = __importDefault(require("mongoose"));
function start(success) {
    // Build the connection string
    var dbURI = 'mongodb://localhost/restorev'; //when using without docker replace <db:27017> to <localhost>
    // Create the database connection
    mongoose_1.default.connect(dbURI, {
        useNewUrlParser: true,
        useUnifiedTopology: true
    });
    // CONNECTION EVENTS
    // When successfully connected
    mongoose_1.default.connection.on('connected', function () {
        success();
        console.log('Mongoose default connection open to ' + dbURI);
    });
    // If the connection throws an error
    mongoose_1.default.connection.on('error', function (err) {
        console.log('Mongoose default connection error: ' + err);
    });
    // When the connection is disconnected
    mongoose_1.default.connection.on('disconnected', function () {
        console.log('Mongoose default connection disconnected');
    });
    // If the Node process ends, close the Mongoose connection
    process.on('SIGINT', function () {
        exports.mongoose.connection.close(function () {
            console.log('Mongoose default connection disconnected through app termination');
            process.exit(0);
        });
    });
}
exports.start = start;
exports.mongoose = mongoose_1.default;
//# sourceMappingURL=db.js.map
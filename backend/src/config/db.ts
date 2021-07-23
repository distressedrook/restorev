// Bring Mongoose into the app
import mong from 'mongoose';
export function start(success: () => void) {
    // Build the connection string
    var dbURI = 'mongodb://localhost/restorev'; //when using without docker replace <db:27017> to <localhost>

    // Create the database connection
    mong.connect(dbURI, {
        useNewUrlParser: true,
        useUnifiedTopology: true
    });

    // CONNECTION EVENTS
    // When successfully connected
    mong.connection.on('connected', function () {
        success();
        console.log('Mongoose default connection open to ' + dbURI);
    });

    // If the connection throws an error
    mong.connection.on('error', function (err) {
        console.log('Mongoose default connection error: ' + err);
    });

    // When the connection is disconnected
    mong.connection.on('disconnected', function () {
        console.log('Mongoose default connection disconnected');
    });

    // If the Node process ends, close the Mongoose connection
    process.on('SIGINT', function () {
        mongoose.connection.close(function () {
            console.log('Mongoose default connection disconnected through app termination');
            process.exit(0);
        });
    });

}

export const mongoose = mong;

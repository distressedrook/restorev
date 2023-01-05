import mong from "mongoose";
export function start(success: () => void) {
  var dbURI = "mongodb://127.0.0.1/restorev"; //when using without docker replace <db:27017> to <localhost>

  mong.connect(dbURI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
    useCreateIndex: true,
  });

  mong.connection.on("connected", function () {
    success();
    console.log("Mongoose default connection open to " + dbURI);
  });

  mong.connection.on("error", function (err) {
    console.log("Mongoose default connection error: " + err);
  });

  mong.connection.on("disconnected", function () {
    console.log("Mongoose default connection disconnected");
  });

  process.on("SIGINT", function () {
    mongoose.connection.close(function () {
      console.log(
        "Mongoose default connection disconnected through app termination"
      );
      process.exit(0);
    });
  });
}

export const mongoose = mong;

import mongoose from "mongoose";

export interface IUser extends mongoose.Document {
  name: string;
  email: string;
  jwtToken: string;
  role: Role;
  hash: string;
}

const Schema = mongoose.Schema;
const UserSchema = new Schema(
  {
    name: String,
    email: { type: String, unique: true },
    jwtToken: String,
    role: String,
    hash: String,
  },
  {
    collection: "users",
    toJSON: {
      transform: function (doc, ret) {
        ret.id = ret._id;
        delete ret.hash;
        delete ret._id;
      },
      versionKey: false,
      virtuals: true,
    },
  }
);

enum Role {
  Regular = "regular",
  Admin = "admin",
  Owner = "owner",
}

export const User = mongoose.model<IUser>("User", UserSchema);

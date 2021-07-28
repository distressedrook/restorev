import mongoose from "mongoose";

export interface IUser extends mongoose.Document {
  name: string;
  email: string;
  jwtToken: string;
  role: Role;
  hash: string;
  ownedRestaurants: any[];
}

const Schema = mongoose.Schema;
const UserSchema = new Schema(
  {
    name: String,
    email: { type: String, unique: true },
    jwtToken: String,
    role: String,
    hash: String,
    ownedRestaurants: [{ type: Schema.Types.ObjectId, ref: "Restaurant" }],
  },
  {
    collection: "users",
    toJSON: {
      transform: function (doc, ret) {
        ret.id = ret._id;
        delete ret.ownedRestaurants;
        delete ret.hash;
        delete ret._id;
      },
      versionKey: false,
      virtuals: true,
    },
  }
);

export enum Role {
  Regular = "regular",
  Admin = "admin",
  Owner = "owner",
  Ghost = "ghost",
}

export const User = mongoose.model<IUser>("User", UserSchema);

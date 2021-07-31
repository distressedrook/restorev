import mongoose from "mongoose";

export interface IRestaurant extends mongoose.Document {
  name: string;
  ownerId: string;
  reviews: any[];
  averageRating: number;
}

const Schema = mongoose.Schema;
const RestaurantSchema = new Schema(
  {
    name: { type: String, unique: true },
    ownerId: { type: Schema.Types.ObjectId, ref: "User" },
    reviews: { type: [{ type: Schema.Types.ObjectId, ref: "Review" }] },
  },
  {
    collection: "restaurants",
    toJSON: {
      transform: function (doc, ret) {
        ret.id = ret._id;
        delete ret._id;
      },
      versionKey: false,
      virtuals: true,
    },
  }
);

export const Restaurant = mongoose.model<IRestaurant>(
  "IRestaurant",
  RestaurantSchema
);

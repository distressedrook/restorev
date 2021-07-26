import mongoose from "mongoose";

export interface IReview extends mongoose.Document {
  reviewString: string;
  reviewerId: string;
  restaurantId: string;
  ownerComment: string;
  visitedDate: number;
  rating: number;
}

const Schema = mongoose.Schema;
const ReviewSchema = new Schema(
  {
    reviewString: String,
    restaurantId: { type: Schema.Types.ObjectId, ref: "Restaurant" },
    reviewerId: { type: Schema.Types.ObjectId, ref: "User" },
    visitedDate: Number,
    rating: Number,
  },
  {
    collection: "reviews",
    toJSON: {
      transform: function (doc, ret) {
        ret.id = ret._id;
        ret.review = ret.reviewString;
        delete ret.reviewString;
        delete ret._id;
      },
      versionKey: false,
      virtuals: true,
    },
  }
);

export const Review = mongoose.model<IReview>("Review", ReviewSchema);

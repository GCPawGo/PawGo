const mongoose = require('mongoose')
const Schema = mongoose.Schema;

const FavouriteUserSchema = new Schema({
    userId: { type: String, required: true },
    favouriteUserId: { type: String, required: true },
    favouriteUserDogId: { type: String, required: true },
    createDate: { type: Date, default: Date.now }
})

const FavouriteUserModel = mongoose.model("FavouriteUser", FavouriteUserSchema);

module.exports = FavouriteUserModel
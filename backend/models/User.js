const mongoose = require('mongoose')
const Schema = mongoose.Schema;

const UserSchema = new Schema({
    userId: { type: String, required: true },
    userAge: { type: String, default: "18" },
    userDesc: { type: String, default: "Update your desc here" },
    userDogs: [{ type: ObjectId, required: false, default: null }],
    createDate: { type: Date, default: Date.now }
})

const UserModel = mongoose.model("User", UserSchema);

module.exports = UserModel
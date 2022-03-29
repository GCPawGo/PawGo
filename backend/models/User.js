const mongoose = require('mongoose')
const Schema = mongoose.Schema;

const UserSchema = new Schema({
    userId: { type: String, required: true },
    userAge: { type: String, default: "18"},
    userDesc: { type: String, default: "Update your desc here"},
    data: {type: Date, default: Date.now}
})

const UserModel = mongoose.model("User", UserSchema);

module.exports = UserModel
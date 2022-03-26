const mongoose = require("mongoose");
const Schema = mongoose.Schema;
const ObjectId = mongoose.Types.ObjectId;
const Date = mongoose.Schema.Types.Date;

// Schemas
const UserSchema = new Schema({
    userId: { type: String, required: true },
    data: {type: Date, default: Date.now}
});

const UserModel = mongoose.model("User", UserSchema);

module.exports = UserModel

exports.connection = mongoose.connection;
exports.ObjectId = ObjectId;
exports.Date = Date;

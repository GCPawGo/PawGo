const mongoose = require("mongoose");
const Schema = mongoose.Schema;
const ObjectId = mongoose.Types.ObjectId;
const Date = mongoose.Schema.Types.Date;

// Schemas
const UserSchema = new Schema({
    userId: { type: String, required: true }
});

exports.User = mongoose.model("User", UserSchema);

exports.connection = mongoose.connection;
exports.ObjectId = ObjectId;
exports.Date = Date;

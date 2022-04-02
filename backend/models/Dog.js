const mongoose = require('mongoose')
const Schema = mongoose.Schema;

const DogSchema = new Schema({
    userId: { type: String, required: true },
    dogName: { type: String, required: true },
    dogAge: { type: String, required: true },
    dogBreed: { type: String, required: true },
    dogHobby: { type: String, required: false, default: "What's your dog's hobbies?" },
    dogPersonality: { type: String, required: false, default: "What's your dog's personality?" },
    createDate: { type: Date, default: Date.now }
})

const DogModel = mongoose.model("Dog", DogSchema);

module.exports = DogModel
var express = require('express');
var app = express();
app.use(express.json());
var bodyParser = require('body-parser')
app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json())

const UserModel = require('../models/User');
const DogModel = require('../models/Dog');

app.post('/addDog', async (req, res) => {
    const dog = req.body

    const newDog = new DogModel({
        userId: req.body.userId,
        dogName: req.body.dogName,
        dogAge: req.body.dogAge,
        dogBreed: req.body.dogBreed,
        dogHobby: req.body.dogHobby,
        dogPersonality: req.body.dogPersonality
    })

    if(newDog.dogHobby == "") {
        newDog.dogHobby = "What's your dog's hobbies?"
    }

    if(newDog.dogPersonality == "") {
        newDog.dogPersonality = "What's your dog's personality?"
    }
  
    const user = await UserModel.findOne({ userId: dog.userId })

    if (!user) {
        console.log('Cannot find the user!\n');
    }else {
        await UserModel.findOneAndUpdate({ userId: dog.userId }, { $push: { userDogs: newDog._id }})
        await newDog.save()
        res.send(newDog)
    }
});

app.post('/updateDogByDogId', async (req, res) => {
    const dog = req.body

    console.log(dog.dogHobby)
    
    if(dog.dogHobby == "") {
        dog.dogHobby = "What's your dog's hobbies?"
    }

    if(dog.dogPersonality == "") {
        dog.dogPersonality = "What's your dog's personality?"
    }

    const oldDog = await DogModel.findOne({ _id: dog._id })

    if (!oldDog) {
        console.log('Cannot find the dog!\n');
    }else {
        await DogModel.findByIdAndUpdate({_id: dog._id}, dog)
        res.send({msg: 'Successfully update the dog!'})
    }
});

app.get('/getDogsByUserId', async (req, res) => {
    const userId = req.query.userId;
    if (userId) {
        const user = await UserModel.findOne({ userId: userId })
        res.send(user.userDogs)
    }
});

app.get('/getDogsByDogId', async (req, res) => {
    const _id = req.query._id;
    if (_id) {
        const dog = await DogModel.findOne({ _id: _id })
        res.send(dog)
    }
});

app.post('/removeDogByDogId', async (req, res) => {
    const dogId = req.body._id;
    const userId = req.body.userId
    if (dogId && userId) {
        await UserModel.findOneAndUpdate({ userId: userId }, { $pull: { userDogs: dogId }})
        await DogModel.findByIdAndRemove({ _id: dogId })
        res.send("Successfully remove the dog")
    }
});

module.exports = app;
  
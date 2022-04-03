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
        dogBreed: req.body.dogBreed
    })
  
    const user = await UserModel.findOne({ userId: dog.userId })

    if (!user) {
        console.log('Cannot find the user!\n');
    }else {
        await UserModel.findOneAndUpdate({ userId: dog.userId }, { $push: { userDogs: newDog._id }})
        await newDog.save()
        res.send({msg: 'Successfully add the dog!'})
    }
});

module.exports = app;
  
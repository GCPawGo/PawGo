var express = require('express');
var app = express();
app.use(express.json());
var bodyParser = require('body-parser')
app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json())

const UserModel = require('../models/User');
const DogModel = require('../models/Dog');

app.post('/addDog', async (req, res) => {
    console.log(req.body)

    const newDog = new DogModel({
        userId: req.body.userId,
        dogName: req.body.dogName,
        dogAge: req.body.dogAge,
        dogBreed: req.body.dogBreed
    })
  
    const user = UserModel.findOne({ userId: req.body.userId })

    if (!user) {
        console.log('Cannot find the user!\n');
    }else {
        // user.userDogs.push(newDog._id);
        newDog.save()
        // user.save()
        res.send({msg: 'Successfully add the dog!'})
    }
  });

  module.exports = app;
  
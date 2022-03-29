var express = require('express');
var app = express();
app.use(express.json());
var bodyParser = require('body-parser')
app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json())

const UserModel = require('../models/User');

app.post('/initUser', async (req, res) => {

  const newUser = new UserModel({
    userId: req.body.userId
  })

  await newUser.save()

  res.send({status: 200, msg: 'Successfully initialize the user'})
});

app.post('/updateUserAge', async (req, res) => {
  const user = req.body
  UserModel.findOneAndUpdate({userId: user.userId}, {userAge: user.userAge})
    .then(oldUser => {
      res.send({status: 200, msg: 'Successfully update the user age'})
    })
});

app.get('/getUser', async (req, res) => {
  const user = req.query
  UserModel.findOne({userId: user.userId})
    .then(user => {
      res.send({status: 200, data: user})
    })
});

module.exports = {
  router: app
}
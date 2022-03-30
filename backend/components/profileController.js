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

  res.send({msg: 'Successfully initialize the user'})
});

app.post('/updateUserInfo', async (req, res) => {
  const user = req.body
  UserModel.findOneAndUpdate({userId: user.userId}, {userAge: user.userAge}, {userDesc: user.userDesc})
    .then(oldUser => {
      res.send({msg: 'Successfully update the user Infomation'})
    })
});

app.get('/getUser', async (req, res) => {
  const user = req.query
  UserModel.findOne({userId: user.userId})
    .then(user => {
      res.send(user)
    })
});

module.exports = {
  router: app
}
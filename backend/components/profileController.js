var express = require('express');
var app = express();
app.use(express.json());
var bodyParser = require('body-parser')
app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json())

const UserModel = require('../models/User');

app.post('/initUser', async (req, res) => {
  console.log('Received initUser POST request:');
  console.log(req.query.userId);

  const newUser = new UserModel({
    userId: req.query.userId
  })

  await newUser.save()

  res.send({status: 200, msg: '0'})
});

module.exports = {
  router: app
}
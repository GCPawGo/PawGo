var express = require('express');
var app = express();
app.use(express.json());
const User = require('../schemas.js').User;

app.post('/initUser', (req, res) => {
  console.log('Received initUser POST request:');
  console.log( req.body.userId);
  res.send({status: 0, msg: '0'})
});

module.exports = {
  router: app
}
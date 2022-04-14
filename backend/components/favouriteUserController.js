var express = require('express');
var app = express();
app.use(express.json());
var bodyParser = require('body-parser')
app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json())

const FavouriteUserModel = require('../models/FavouriteUser');

app.post('/addFavouriteUser', async (req, res) => {
    const favouriteUser = req.body

    const newfavouriteUser = new FavouriteUserModel({
        userId: favouriteUser.userId,
        favouriteUserId: favouriteUser.favouriteUserId,
        favouriteUserDogId: favouriteUser.favouriteUserDogId,
    })

    await newfavouriteUser.save()
    res.send({msg: "Successfully add favourite user"})
});

module.exports = app;
  
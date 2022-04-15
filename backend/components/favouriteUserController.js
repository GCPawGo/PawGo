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

    const oldFavouriteUser = await FavouriteUserModel.findOne({
        userId: favouriteUser.userId,
        favouriteUserId: favouriteUser.favouriteUserId,
        favouriteUserDogId: favouriteUser.favouriteUserDogId,
    })

    if(oldFavouriteUser) {
        res.send({msg: "Duplicate addition"})
    }else {
        await newfavouriteUser.save()
        res.send({msg: "Successfully add favourite user"})
    }
});

app.get('/getFavouriteUserListByUserId', async (req, res) => {
    const userId = req.query.userId;
    
    if (userId) {
        const favouriteUserList = await FavouriteUserModel.find({userId: userId})
        res.send(favouriteUserList)
    }
});

module.exports = app;
  
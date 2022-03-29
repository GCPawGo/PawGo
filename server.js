const express = require('express')
const mongoose = require('mongoose')
const app = express()
app.use(express.json())
require('dotenv').config()

process.env.authURI

// cross origin
var cors = require('cors')
// client port
const PORT = process.env.PORT || '8000'
// mongoDB location
const MONGO_URI = process.env.authURI

// connect to the MongoDB
mongoose.connect("mongodb+srv://PawGo:globalclass-PawGo-2022@pawgo0.s9yqz.mongodb.net/PawGo0?retryWrites=true&w=majority", {useNewUrlParser: true})
    .then((response) => {
        console.log('Connected to database!')
    })
    .catch(err => {
        console.error(`Error connecting to the database.\n${err}`)
    })

// deal with cross origin
mongoose.Promise = Promise;
app.use(cors());
app.use(function(req, res, next) {
    res.header("Access-Control-Allow-Origin", '*');
    next();
});

// listen to the client port
var listener = app.listen(PORT, () => {
    console.log('Listening on port ' + listener.address().port);
});

var usersRouter = require('./backend/components/profileController').router;

app.use('/users', usersRouter);

app.get('/', (req, res) => {
    res.send('<h1>Welcome to PawGo!<h1>');
});

module.exports = app;

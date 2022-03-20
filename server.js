require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
var cors = require('cors');
const PORT = process.env.PORT || 8000;
const MONGO_URI = process.env.MONGO_URI;

const connectionParams = {
    useNewUrlParser: true,
    useUnifiedTopology: true
};

const app = express();
app.use(express.json());
if (process.env.NODE_ENV !== 'test') {
    mongoose.connect(MONGO_URI,connectionParams)
        .then( () => {
            console.log('Connected to database!')
        })
        .catch( (err) => {
            console.error(`Error connecting to the database.\n${err}`);
        })
    mongoose.Promise = Promise;
    app.use(cors());
    app.use(function(req, res, next) {
        res.header("Access-Control-Allow-Origin", '*');
        next();
    });
    var listener = app.listen(PORT, () => {
        console.log('Listening on port ' + listener.address().port);
    });
}


var usersRouter = require('./backend/components/profileController').router;
var teamsRouter = require('./backend/components/teamController');
var ridesRouter = require('./backend/components/rideHandler');
var rewardsRoutes = require('./backend/components/rewardController');
var eventRoutes = require('./backend/components/eventHandler');

var swaggerUi = require('swagger-ui-express');
var swaggerDocument = require('./backend/swagger.json');

app.use('/users', usersRouter);
app.use('/teams', teamsRouter);
app.use('/rides', ridesRouter);
app.use('/rewards', rewardsRoutes);
app.use('/events', eventRoutes.app);

app.use('/tests', require('./backend/components/genBadgesInfo.js'));

var options = {
    swaggerOptions: {
        defaultModelsExpandDepth: -1,
        supportedSubmitMethods: []
    }
};

app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument,options));


app.get('/', (req, res) => {
    res.send('<h1>Welcome to PawGo!<h1>');
});

module.exports = app;

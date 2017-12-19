'use strict';
var express = require('express');

module.exports = function(app) {
    var highScoresController = require('../controllers/highScoresController');

    var apiRouter = express.Router();
    var versionRouter = express.Router();

    app.use('/api', apiRouter);
    apiRouter.use("/v1", versionRouter);


    /* Chess routes **/

    // //TODO
    //
    // versionRouter.route('/chess/1ply')
    //     .get(highScoresController.lisTopHighScores);
    //
    // versionRouter.route('/chess/2ply')
    //     .get(highScoresController.lisTopHighScores);
    //

    /** Highscores routes **/

    versionRouter.route('/highscores')
        .get(highScoresController.lisTopHighScores);

    versionRouter.route('/highscores/add')
        .post(highScoresController.addNewPlayer);

};

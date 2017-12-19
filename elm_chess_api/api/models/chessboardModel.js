'use strict';

var mongoose = require('mongoose');

var ChessBoardSchema = new mongoose.Schema({


});

var StatusSchema = new mongoose.Schema({
    status: {
        type: String
    },
    game_over_status: {
        type: Boolean
    }
});

module.exports = mongoose.model('Status', StatusSchema);



var PossibleMovesSchema = new mongoose.Schema({
    moves: [{ type: String }]
});

module.exports = mongoose.model('Moves', PossibleMovesSchema);

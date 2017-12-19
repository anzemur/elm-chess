'use strict';
var mongoose = require('mongoose');

var Chess = require('chess.js').Chess;
var chess = null;

var Status = mongoose.model('Status');

exports.startNewGame = function(req, res) {
    chess = new Chess();
    var status = new Status();

    res.json(status);

};

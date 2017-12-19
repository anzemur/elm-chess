'use strict';

var mongoose = require('mongoose');
var chessAi = require('chess-ai-kong');
var Chess = require('chess.js').Chess;
var chess = null;

var AIMoves = mongoose.model('AIMoves');
var Moves = mongoose.model('Moves');
var Status = mongoose.model('Status');
var status = new Status();

var movesArr = [];


exports.startNewGame = function(req, res) {
    chess = new Chess();
    status.status = "new game started";
    res.json(status);

    printChessboard();

};

/** Params: a pgn position in json as {position: currentPosition} **/
exports.listPosibleMoves = function(req, res) {
    if(chess != null) {
        var sq = req.body.position;

        var moves = new Moves();

        var posibleMoves = chess.moves({square: sq});

        for(var i = 0; i < posibleMoves.length; i++) {
            if(posibleMoves[i].length > 2) {
                var tmp = posibleMoves[i];
                while(tmp.length > 2) {
                    tmp = tmp.substring(1);
                }
                posibleMoves[i] = tmp;

            }

        }

        moves.moves = posibleMoves;
        res.json(moves);

    } else {
        status.status = "error: chess was not initialized!";
        res.json(status);

    }
};

/**  Params: from(pgn currentPosition) -> to(pgn desiredPosition) **/
exports.move = function(req, res) {
    if(chess != null) {
        var fromSq = req.body.from;
        var toSq = req.body.to;

        var move = chess.move({ from: fromSq, to: toSq });
        if(move != null) {
            status.status = "figure moved"
            res.json(status);
            movesArr.push(toSq);



            printChessboard();

        } else {
            status.status = "error: invalid move!";
            res.json(status);
        }

    } else {
        status.status = "error: chess was not initialized!";
        res.json(status);

    }
};


exports.checkGameOver = function(req, res) {
    if(chess != null) {
        if(chess.game_over()) {
            status.game_over_status = true;

            if(chess.in_checkmate()) {
                status.status = "check mate";
                res.json(status);
                console.log("Check mate!");

            } else if (chess.in_draw()) {
                status.status = "draw";
                res.json(status);
                console.log("Draw!");

            } else if (chess.in_stalemate()) {
                status.status = "in stalemate";
                res.json(status);

            } else if (chess.in_threefold_repetition()) {
                status.status = "in threefold repetition";
                res.json(status);

            } else if (chess.insufficient_material()) {
                status.status = "insufficient material";
                res.json(status);

            }

            chess.clear();

        } else {
            status.status = "game continues"
            res.json(status);

        }

    } else {
        status.status = "error: chess was not initialized!";
        res.json(status);

    }
};

exports.moveAI = function(req, res) {
    // console.log(movesArr);
    if(chess != null) {
        // console.log(chess.fen());
        var move = chessAi.play(movesArr);
        var moveToCompare = move;
        move = move.toLowerCase();

        // console.log(move);

        var from = 0;

        var chessBoardFen = chess.fen();
        var tmp = (chessBoardFen + "").split(" ");
        var chessBoard = (tmp[0] + "").split("/");
        // console.log(chessBoard);

        var figure = "RNBQKrnbqk";

        if(figure.includes(move.charAt(0))) {
            var figura = move.charAt(0);

            var found = false;
            // console.log("dela1");
            for(var i = 0; i < chessBoard.length; i++) {

                // console.log("iscem " + i);
                if(chessBoard[i].includes(figura)) {
                    // console.log("vsebuje " + i);
                    var idxFigure = 0;
                    for(var j = 0; j < chessBoard[i].length; j++ ) {
                        if(chessBoard[i].charAt(j) == figura) {
                            var coll = chessBoard.length - i;
                            // console.log("vrstica " + coll);
                            var row = returnRow(idxFigure);
                            // console.log("row " + row);

                            var poz = row + coll;
                            // console.log(poz);

                            var posibleMoves = chess.moves({square: poz});

                            // console.log(posibleMoves);

                            if(posibleMoves.indexOf(moveToCompare) != -1){
                                found = true;
                                from = poz;
                                // console.log(from);

                                break;

                            } else {
                                idxFigure++;

                            }

                        } else if (!isNaN(chessBoard[i].charAt(idxFigure))) {
                            idxFigure += chessBoard[i].charAt(j);


                        } else {
                            idxFigure++;

                        }
                    }
                    if(found) break;
                }
            }

        } else {
            var figura = "p";

            var found = false;
            // console.log("dela1");
            for(var i = 0; i < chessBoard.length; i++) {

                // console.log("iscem " + i);
                if(chessBoard[i].includes(figura)) {
                    // console.log("vsebuje " + i);
                    var idxFigure = 0;
                    for(var j = 0; j < chessBoard[i].length; j++ ) {
                        if(chessBoard[i].charAt(j) == figura) {
                            var coll = chessBoard.length - i;
                            // console.log("vrstica " + coll);
                            var row = returnRow(idxFigure);
                            // console.log("row " + row);

                            var poz = row + coll;
                            // console.log(poz);

                            var posibleMoves = chess.moves({square: poz});

                            // console.log(posibleMoves);

                            if(posibleMoves.indexOf(move) != -1){
                                found = true;
                                from = poz;
                                // console.log(from);

                                break;

                            } else {
                                idxFigure++;

                            }

                        } else if (!isNaN(chessBoard[i].charAt(j))) {
                            idxFigure += chessBoard[i].charAt(j);


                        } else {
                            idxFigure++;

                        }
                    }

                    if(found) break;
                }
            }
        }


        var makeMove = chess.move(moveToCompare);
        if(makeMove != null) {
            movesArr.push(moveToCompare);
            var aiMoves = new AIMoves();

            aiMoves.status = "AI moved!";
            aiMoves.from = from;

            if(moveToCompare.length > 2) {
                var tmp = moveToCompare;
                while(tmp.length > 2) {
                    tmp = tmp.substring(1);

                }
                aiMoves.to = tmp;
            } else {
                aiMoves.to = moveToCompare;

            }

            res.json(aiMoves);

            printChessboard();

        } else {
            status.status = "error: invalid move!";
            res.json(status);
        }

    } else {
        status.status = "error: chess was not initialized!";
        res.json(status);

    }

};



function returnRow(row) {
    switch (row) {
        case 0:
            return "a";
            break;

        case 1:
            return "b";
            break;

        case 2:
            return "c";
            break;

        case 3:
            return "d";
            break;

        case 4:
            return "e";
            break;

        case 5:
            return "f";
            break;

        case 6:
            return "g";
            break;

        case 7:
            return "h";
            break;

        default:
            break;

    }
}



function printChessboard() {
    console.log();
    console.log("##########################################");
    console.log();
    console.log(chess.ascii());

    var turn = ""
    if(chess.turn() == "w") {
        turn = "white";
    }  else {
        turn = "black";
    }

    console.log("Turn: " + turn );
}

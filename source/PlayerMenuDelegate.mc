using Toybox.WatchUi as Ui;
using Toybox.System  as Sys;
using PongModule     as Pong;

class PlayerMenuDelegate extends Ui.MenuInputDelegate {
    // Stores a pointer to the game instance
    var mGame;

    function initialize( game )
    {
        mGame = game;
    }

    function onMenuItem(item) {
        if (item == :item_1) {
            mGame.setPlayer( Pong.PONG_PLAYER_0 );
        } else if (item == :item_2) {
            mGame.setPlayer( Pong.PONG_PLAYER_1 );
        }
    }

}
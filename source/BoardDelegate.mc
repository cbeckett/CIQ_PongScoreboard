using Toybox.WatchUi as Ui;
using Toybox.System  as Sys;
using PongModule     as Pong;

class BoardDelegate extends Ui.BehaviorDelegate {
    // Stores a pointer to the game instance
    var mGame;

    /////////////////////////////////////////////
    // Called when object is initialized
    // Parameters:
    //  none
    // Returns:
    //  none
    /////////////////////////////////////////////
    function initialize( game )
    {
        mGame = game;
    }

    /////////////////////////////////////////////
    // Called when menu button is pressed
    // Parameters:
    //  none
    // Returns:
    //  true - button event has been handled
    /////////////////////////////////////////////
    function onMenu() {
       // End game and go back to setup
       mGame.stopGame();
       mGame.release();
       mGame = new Pong.PongGame();
       Ui.switchToView(new SetupView( mGame ), new SetupDelegate( mGame ), Ui.SLIDE_LEFT);

        return true;
    }

}
using Toybox.WatchUi as Ui;
using Toybox.System  as Sys;
using PongModule     as Pong;

// Handles user events while game is in progress
class BoardDelegate extends Ui.BehaviorDelegate
{
    // Stores a pointer to the game instance
    var mGame;

    /////////////////////////////////////////////
    // Called when object is initialized
    // Parameters:
    //  game - Pointer to the game instance
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
    function onMenu()
    {
        // End game and go back to setup
        mGame.stopGame();

        // This is to handle a bug in the sim where a channel could not be re-opened (1.1.0)
        mGame.release();
        mGame = new Pong.PongGame();

        //! TODO: 4.3 Change to SetupView here

        return true;
    }

}
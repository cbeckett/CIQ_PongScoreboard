using Toybox.WatchUi as Ui;
using Toybox.System  as Sys;
using PongModule     as Pong;

// Handles user events while game is being set-up
class SetupDelegate extends Ui.BehaviorDelegate
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
        // Check if a player has been selected
        if( Pong.PONG_PLAYER_INVALID == mGame.getPlayer() )
        {
            // Player has not been selected, display player selection menu
            Ui.pushView( new Rez.Menus.PlayerMenu(), new PlayerMenuDelegate( mGame ), Ui.SLIDE_UP );
        }
        else
        {
            // Player has been selected, display scoreboard and start searching for new game
            mGame.startGame();
            Ui.switchToView( new BoardView( mGame ), new BoardDelegate( mGame ), Ui.SLIDE_RIGHT );
        }

        return true;
    }

}
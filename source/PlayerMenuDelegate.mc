using Toybox.WatchUi as Ui;
using Toybox.System  as Sys;
using PongModule     as Pong;

// Handles player selection
class PlayerMenuDelegate extends Ui.MenuInputDelegate
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
    // Caled when menu item is selected
    // Parameters:
    //  item - User selected item
    // Returns:
    //  none
    /////////////////////////////////////////////
    function onMenuItem( item )
    {
        if ( :item_1 == item )
        {
            // Player 0 selected
            mGame.setPlayer( Pong.PONG_PLAYER_0 );
        }
        //! TODO 4.4 Add code to allow user to choose Player 1
    }

}
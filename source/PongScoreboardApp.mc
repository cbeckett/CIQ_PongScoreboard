using Toybox.Application as App;
using Toybox.WatchUi     as Ui;
using PongModule         as Pong;

// The main application base
class PongScoreboardApp extends App.AppBase
{
    // Stores a pointer to the game instance
    var mGame;

    /////////////////////////////////////////////
    // Called on application start up
    // Parameters:
    //  none
    // Returns:
    //  none
    /////////////////////////////////////////////
    function onStart()
    {
        mGame = new Pong.PongGame();
    }

    /////////////////////////////////////////////
    // Called when your application is exiting
    // Parameters:
    //  none
    // Returns:
    //  none
    /////////////////////////////////////////////
    function onStop()
    {
        // Release the game instance
        mGame.release();
    }

    /////////////////////////////////////////////
    // Return the initial view of application
    // Parameters:
    //  none
    // Returns:
    //  none
    /////////////////////////////////////////////
    function getInitialView()
    {
        return [ new SetupView( I_AM_ERROR ), new SetupDelegate( mGame ) ];
    }

}
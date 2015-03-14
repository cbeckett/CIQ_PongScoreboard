using Toybox.Application as App;
using Toybox.WatchUi     as Ui;
using PongModule         as Pong;

class PongScoreboardApp extends App.AppBase {
    // Stores a pointer to the game instance
    var mGame;

    //! onStart() is called on application start up
    function onStart() {
        mGame = new Pong.PongGame();
    }

    //! onStop() is called when your application is exiting
    function onStop() {
        // Release the game instance
        mGame.release();
    }

    //! Return the initial view of your application here
    function getInitialView() {
        return [ new SetupView( mGame ), new SetupDelegate( mGame ) ];
    }

}
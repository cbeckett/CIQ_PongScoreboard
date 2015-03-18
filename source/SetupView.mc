using Toybox.WatchUi  as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System   as Sys;
using PongModule      as Pong;

// Controls the display while a game is being set-up
class SetupView extends Ui.View
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

    //! Load your resources here
    function onLayout(dc)
    {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    /////////////////////////////////////////////
    // Update the view
    // Parameters:
    //  dc - Display context to update
    // Returns:
    //  none
    /////////////////////////////////////////////
    function onUpdate(dc)
    {
        // Declare variables
        var text;
        var font;
        var textDimensions;

        // Initialize variables
        font = Gfx.FONT_SMALL;
        text = "Hello World!";

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        // Check if a player has been selected
        //! TODO 4.2.1 if( Pong.PONG_PLAYER_INVALID == mGame.getPlayer() )
        //! TODO 4.2.1 {
            // Player has not been selected, prompt user to select a player
            //! TODO 4.2.1 text = "Press Menu to Select Player";
        //! TODO 4.2.1}
        //! TODO 4.2.1 else
        //! TODO 4.2.1 {
            // Player has been selected, prompt user to start game
            //! TODO 4.2.1 text = "Press Menu to Start";
        //! TODO 4.2.1 }

        // Determine size of text
        textDimensions = dc.getTextDimensions(text, font);

        // Set the text color and draw it to screen
        dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
        dc.drawText(dc.getWidth() / 2, dc.getHeight() - textDimensions[1], font, text, Gfx.TEXT_JUSTIFY_CENTER);
    }

}
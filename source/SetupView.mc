using Toybox.WatchUi  as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System   as Sys;
using PongModule      as Pong;

class SetupView extends Ui.View {
    // Stores a pointer to the game instance
    var mGame;

    function initialize( game )
    {
        mGame = game;
    }

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    //! Update the view
    function onUpdate(dc) {
        // Declare variables
        var text;
        var font;
        var textDimensions;

        // Initialize variables
        font = Gfx.FONT_SMALL;

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        // Check if a player has been selected
        if( Pong.PONG_PLAYER_INVALID == mGame.getPlayer() )
        {
            // Player has not been selected, prompt user to select a player
            text = "Press Menu to Select Player";
        }
        else
        {
            // Player has been selected, prompt user to start game
            text = "Press Menu to Start";
        }

        // Determine size of text
        textDimensions = dc.getTextDimensions(text, font);

        // Set the text color and draw it to screen
        dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
        dc.drawText(dc.getWidth() / 2, dc.getHeight() - textDimensions[1], font, text, Gfx.TEXT_JUSTIFY_CENTER);
    }

}
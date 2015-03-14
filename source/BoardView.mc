using Toybox.WatchUi  as Ui;
using Toybox.Graphics as Gfx;
using PongModule      as Pong;

class BoardView extends Ui.View {
    // Stores parameters used to control watch vibration
    var mVibrateData;
    // Stores a pointer to the game instance
    var mGame;

    function initialize( game )
    {
        mGame        = game;
        mVibrateData = [
                        new Attention.VibeProfile(  25, 100 ),
                        new Attention.VibeProfile(  50, 100 ),
                        new Attention.VibeProfile(  75, 100 ),
                        new Attention.VibeProfile( 100, 100 ),
                        new Attention.VibeProfile(  75, 100 ),
                        new Attention.VibeProfile(  50, 100 ),
                        new Attention.VibeProfile(  25, 100 )
                      ];
    }

    //! Load your resources here
    function onLayout( dc ) {
        setLayout( Rez.Layouts.BoardLayout( dc ) );
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
    }

    //! Update the view
    function onUpdate( dc ) {
        // First clear the display before we update it
        dc.clear();

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate( dc );

        updateGameState( dc );

        updateGameScores( dc );
    }

    //! Called when a point is scored
    function onPoint(key) {
        Attention.playTone( 6 );
        Attention.vibrate( mVibrateData );
    }

    //! Called when the game ends
    function onGameEnd(key) {
        Attention.playTone( 15 );
        Attention.vibrate( mVibrateData );
    }

    function updateGameState(dc) {
        // Declare variables
        var text;
        var font;
        var textDimensions;
        var textColor;

        // Initialize variables
        text      = "Invalid";
        font      = Gfx.FONT_SMALL;
        textColor = Gfx.COLOR_RED;

        // Determine what the game state is
        if( Pong.PONG_GAME_STATE_SEARCH == mGame.getGameState() )
        {
            text      = "Searching...";
            textColor = Gfx.COLOR_RED;
        }
        else if( Pong.PONG_GAME_STATE_IDLE == mGame.getGameState() )
        {
            text      = "Idle";
            textColor = Gfx.COLOR_YELLOW;
        }
        else if( Pong.PONG_GAME_STATE_DATA == mGame.getGameState() )
        {
            text      = "Data";
            textColor = Gfx.COLOR_YELLOW;
        }
        else if( Pong.PONG_GAME_STATE_READY == mGame.getGameState() )
        {
            text      = "Ready";
            textColor = Gfx.COLOR_YELLOW;
        }
        else if( Pong.PONG_GAME_STATE_GAME == mGame.getGameState() )
        {
            text      = "Game";
            textColor = Gfx.COLOR_GREEN;
        }
        else if( Pong.PONG_GAME_STATE_GAME_OVER == mGame.getGameState() )
        {
            // Get winning player
            if( mGame.getPlayer() == mGame.getWinningPlayer() )
            {
                text      = "Game Over - YOU WON!";
            }
            else
            {
                text      = "Game Over - YOU LOST!";
            }

            // If game has just ended, notify user
            if( mGame.getGameState() != mGame.getPastGameState() )
            {
                onGameEnd();
            }

            textColor = Gfx.COLOR_GREEN;
        }
        else if( Pong.PONG_GAME_STATE_INVALID == mGame.getGameState() )
        {
            text      = "Invalid State";
            textColor = Gfx.COLOR_RED;
        }

        // Determine the size of the text
        textDimensions = dc.getTextDimensions(text, font);

        // Set the text color and draw it to the display
        dc.setColor( textColor, Gfx.COLOR_TRANSPARENT );
        dc.drawText(dc.getWidth() / 2, dc.getHeight() - textDimensions[1], font, text, Gfx.TEXT_JUSTIFY_CENTER);
    }

    function updateGameScores( dc )
    {
        // Declare variables
        var currentScore;
        var pastScore;
        var text;
        var font;
        var textDimensions;
        var textColor;
        var scoreChanged;

        // Initialize variables
        font         = Gfx.FONT_LARGE;
        textColor    = Gfx.COLOR_WHITE;
        scoreChanged = false;

        // Get Player 0's score
        currentScore = mGame.getPlayerScore( Pong.PONG_PLAYER_0 );
        pastScore    = mGame.getPastPlayerScore( Pong.PONG_PLAYER_0 );
        // Check if score changed
        if( currentScore != pastScore )
        {
            scoreChanged = true;
        }
        // Update score text
        text = currentScore.toString();
        // Determine the size of the text
        textDimensions = dc.getTextDimensions( text, font );
        // Set the text color and draw it to the display
        dc.setColor( textColor, Gfx.COLOR_TRANSPARENT );
        dc.drawText( dc.getWidth() / 4, dc.getHeight() / 2, font, text, Gfx.TEXT_JUSTIFY_CENTER );

        // Get Player 1's score
        currentScore = mGame.getPlayerScore( Pong.PONG_PLAYER_1 );
        pastScore    = mGame.getPastPlayerScore( Pong.PONG_PLAYER_1 );
        // Check if score changed
        if( currentScore != pastScore )
        {
            scoreChanged = true;
        }
        // Update score text
        text = currentScore.toString();
        // Determine the size of the text
        textDimensions = dc.getTextDimensions( text, font );
        // Set the text color and draw it to the display
        dc.setColor( textColor, Gfx.COLOR_TRANSPARENT );
        dc.drawText( dc.getWidth() * 3 / 4, dc.getHeight() / 2, font, text, Gfx.TEXT_JUSTIFY_CENTER );

        // If score has changed, notify user
        if( scoreChanged )
        {
            onPoint();
        }
    }
}
using Toybox.WatchUi  as Ui;
using Toybox.Graphics as Gfx;
using PongModule      as Pong;

// Displays data of game in progress
class BoardView extends Ui.View
{
    // Stores parameters used to control watch vibration
    var mVibrateData;
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
        // Initialize the board view data
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

    /////////////////////////////////////////////
    // Initializes layout resources
    // Parameters:
    //  none
    // Returns:
    //  none
    /////////////////////////////////////////////
    function onLayout( dc )
    {
        setLayout( Rez.Layouts.BoardLayout( dc ) );
    }

    /////////////////////////////////////////////
    // Update the view
    // Parameters:
    //  dc - Display context to update
    // Returns:
    //  none
    /////////////////////////////////////////////
    function onUpdate( dc )
    {
        // First clear the display before we update it
        dc.clear();

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate( dc );

        updateGameState( dc );

        updateGameScores( dc );
    }

    /////////////////////////////////////////////
    // Called when a point is scored
    // Parameters:
    //  none
    // Returns:
    //  none
    /////////////////////////////////////////////
    function onPoint()
    {
        //! TODO 4.6 Vibrate the watch and play a tone
    }

    /////////////////////////////////////////////
    // Called when the game ends
    // Parameters:
    //  ifWon - Boolean representing if user has won
    // Returns:
    //  none
    /////////////////////////////////////////////
    function onGameEnd( ifWon )
    {
        if( ifWon )
        {
            //! TODO 4.6 Play a winning tone
        }
        else
        {
            //! TODO 4.6 Play a losing tone
        }
        //! TODO 4.6 Vibrate the watch
    }

    /////////////////////////////////////////////
    // Updates the display of the game's state
    // Parameters:
    //  dc - Display context to update
    // Returns:
    //  none
    /////////////////////////////////////////////
    function updateGameState( dc )
    {
        // Declare variables
        var text;
        var font;
        var textDimensions;
        var textColor;
        var ifWon;

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
        //! TODO 4.2 Fill in other states here
        else if( Pong.PONG_GAME_STATE_GAME_OVER == mGame.getGameState() )
        {
            // Get winning player
            ifWon = ( mGame.getPlayer() == mGame.getWinningPlayer() );
            // Set text and color
            if( ifWon )
            {
                text      = "Game Over - YOU WON!";
            }
            else
            {
                text      = "Game Over - YOU LOST!";
            }
            textColor = Gfx.COLOR_GREEN;
            // If game has just ended, notify user
            if( mGame.getGameState() != mGame.getPastGameState() )
            {
                onGameEnd( ifWon );
            }

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
        dc.drawText(25, 50, font, text, Gfx.TEXT_JUSTIFY_CENTER);
    }

    /////////////////////////////////////////////
    // Updates the display of the player's scores
    // Parameters:
    //  dc - Display context to update
    // Returns:
    //  none
    /////////////////////////////////////////////
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
        textColor    = Gfx.COLOR_BLACK;
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
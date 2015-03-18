using Toybox.Ant     as Ant;
using Toybox.WatchUi as Ui;
using Toybox.System  as Sys;

// Stores classes used to represent a game instance and to parse game ANT messages
module PongModule
{
    // Message offset of message id
    const OFFSET_MSG_ID        = 0;
    // Size of a byte in bits
    const SIZE_OF_BYTE         = 8;
    // Used to mask single byte out of an integer
    const BYTE_MASK            = 0xFF;
    // Invalid player score
    const INVALID_PLAYER_SCORE = -1;

    // Pong Player
    enum
    {
        PONG_PLAYER_0       = 0,
        PONG_PLAYER_1       = 1,
        PONG_PLAYER_INVALID = 2
    }

    // Pong Game State
    enum
    {
        PONG_GAME_STATE_SEARCH    = 0,
        PONG_GAME_STATE_IDLE      = 1,
        PONG_GAME_STATE_DATA      = 2,
        PONG_GAME_STATE_READY     = 3,
        PONG_GAME_STATE_GAME      = 4,
        PONG_GAME_STATE_GAME_OVER = 5,
        PONG_GAME_STATE_INVALID   = 6
    }

    // Sent when the radio is first activiated. Used for pairing.
    class IdleMessage
    {
        // Message structure
        static const MSG_ID                   = 0x01;
        static const OFFSET_STATUS            = 5;
        static const STATUS_MASK              = 0x01;
        static const OFFSET_MESSAGE_COUNT_L   = 6;
        static const OFFSET_MESSAGE_COUNT_H   = 7;

        // Master status
        var isMasterReady;
        // Message count
        var messageCount;

        /////////////////////////////////////////////
        // Parses a raw ANT message
        // Parameters:
        //  payload - Raw ANT data payload
        // Returns:
        //  none
        /////////////////////////////////////////////
        function parse( payload )
        {
            isMasterReady  = ( payload[OFFSET_STATUS] & STATUS_MASK ) ? true : false;
            messageCount   = ( payload[OFFSET_MESSAGE_COUNT_L] | ( payload[OFFSET_MESSAGE_COUNT_H] << SIZE_OF_BYTE ) );
        }
    }

    // Transmits game board parameters
    class DataMessage
    {
        // Message structure
        static const MSG_ID                   = 0x02;
        static const OFFSET_STATUS            = 5;
        static const STATUS_MASK              = 0x01;
        static const OFFSET_MESSAGE_COUNT_L   = 6;
        static const OFFSET_MESSAGE_COUNT_H   = 7;

        // Master status
        var isMasterReady;
        // Message count
        var messageCount;

        /////////////////////////////////////////////
        // Parses a raw ANT message
        // Parameters:
        //  payload - Raw ANT data payload
        // Returns:
        //  none
        /////////////////////////////////////////////
        function parse( payload )
        {
            isMasterReady  = ( payload[OFFSET_STATUS] & STATUS_MASK ) ? true : false;
            messageCount   = ( payload[OFFSET_MESSAGE_COUNT_L] | ( payload[OFFSET_MESSAGE_COUNT_H] << SIZE_OF_BYTE ) );
        }
    }

    // Transmits game player parameters
    class ReadyMessage
    {
        // Message structure
        //! TODO 4.5 define the message structure

        // Score of Player 0
        var player0Score;
        // Score of Player 1
        var player1Score;
        // Status of Player 0
        var isPlayer0Ready;
        // Status of Player 1
        var isPlayer1Ready;
        // Message count
        var messageCount;

        /////////////////////////////////////////////
        // Parses a raw ANT message
        // Parameters:
        //  payload - Raw ANT data payload
        // Returns:
        //  none
        /////////////////////////////////////////////
        function parse( payload )
        {
            //! TODO 4.5 parse the ready message
        }

        /////////////////////////////////////////////
        // Converts self to raw payload format
        // Parameters:
        //  payload - Raw ANT data payload
        // Returns:
        //  none
        /////////////////////////////////////////////
        function toPayload()
        {
            var payload = new [8];

            payload[OFFSET_MSG_ID]          = MSG_ID;
            payload[OFFSET_PLAYER_0_SCORE]  = player0Score;
            payload[OFFSET_PLAYER_1_SCORE]  = player1Score;
            payload[OFFSET_PLAYER_0_STATUS] = ( isPlayer0Ready ) ? PLAYER_STATUS_READY : PLAYER_STATUS_NOT_READY;
            payload[OFFSET_PLAYER_1_STATUS] = ( isPlayer1Ready ) ? PLAYER_STATUS_READY : PLAYER_STATUS_NOT_READY;
            payload[OFFSET_MESSAGE_COUNT_L] = BYTE_MASK & ( messageCount );
            payload[OFFSET_MESSAGE_COUNT_H] = BYTE_MASK & ( messageCount >> SIZE_OF_BYTE );

            return payload;
        }
    }

    // Transmits runtime game parameters
    class GameMessage
    {
        // Message structure
        static const MSG_ID                = 0x04;
        static const OFFSET_GAME_STATUS    = 7;
        static const GAME_IN_PROGRESS_MASK = 0x01;
        static const PLAYER_0_SCORED_MASK  = 0x02;
        static const PLAYER_1_SCORED_MASK  = 0x04;
        static const PLAYER_0_WON_MASK     = 0x08;
        static const PLAYER_1_WON_MASK     = 0x10;

        // Game progress
        var isGameInProgress;
        // Player 0 scored
        var player0Scored;
        // Player 1 scored
        var player1Scored;
        // Player 0 won
        var player0Won;
        // Player 1 won
        var player1Won;

        /////////////////////////////////////////////
        // Parses a raw ANT message
        // Parameters:
        //  payload - Raw ANT data payload
        // Returns:
        //  none
        /////////////////////////////////////////////
        function parse( payload )
        {
            isGameInProgress  = ( payload[OFFSET_GAME_STATUS] & GAME_IN_PROGRESS_MASK ) ? true : false;
            player0Scored     = ( payload[OFFSET_GAME_STATUS] & PLAYER_0_SCORED_MASK ) ? true : false;
            player1Scored     = ( payload[OFFSET_GAME_STATUS] & PLAYER_1_SCORED_MASK ) ? true : false;
            player0Won        = ( payload[OFFSET_GAME_STATUS] & PLAYER_0_WON_MASK ) ? true : false;
            player1Won        = ( payload[OFFSET_GAME_STATUS] & PLAYER_1_WON_MASK ) ? true : false;
        }
    }

    // Represents a game instance
    class PongGame extends Ant.GenericChannel
    {
        // Offsets for ANT Response Messsages
        static const OFFSET_ANT_RESPONSE_ID   = 0;
        static const OFFSET_ANT_RESPONSE_CODE = 1;

        // Channel configuration defaults
        static const DEVICE_NUMBER            = 0;
        static const DEVICE_TYPE              = 1;
        static const FREQUENCY                = 66;
        static const PERIOD                   = 3277;
        static const SEARCH_TIMEOUT_HP        = 2;
        static const SEARCH_TIMEOUT_LP        = 10;
        static const SEARCH_THRESHOLD         = 0;
        static const TRANS_TYPE               = 0;

        // Private game variables
        hidden var mChosenPlayer;
        hidden var mGameState;
        hidden var mPastGameState;
        hidden var mPastPlayer0Score;
        hidden var mPastPlayer1Score;
        hidden var mPlayer0Score;
        hidden var mPlayer1Score;
        hidden var mWinningPlayer;

        /////////////////////////////////////////////
        // Called when object is initialized
        // Parameters:
        //  none
        // Returns:
        //  none
        /////////////////////////////////////////////
        function initialize()
        {
            var channelAssignment;
            var deviceConfiguration;

            // Get the channel
            channelAssignment = new Ant.ChannelAssignment(
                Ant.CHANNEL_TYPE_RX_NOT_TX,
                Ant.NETWORK_PUBLIC );
            GenericChannel.initialize(
                method(:onMessage),
                channelAssignment );

            // Set the configuration
            deviceConfiguration = new Ant.DeviceConfig( {
                :deviceNumber => DEVICE_NUMBER,
                :deviceType => DEVICE_TYPE,
                :transmissionType => TRANS_TYPE,
                :messagePeriod => PERIOD,
                :radioFrequency => FREQUENCY,
                :searchTimeoutLowPriority => SEARCH_TIMEOUT_LP,
                :searchTimeoutHighPriority => SEARCH_TIMEOUT_HP,
                :searchThreshold => SEARCH_THRESHOLD } );
            GenericChannel.setDeviceConfig( deviceConfiguration );

            // Set initial game state
            mGameState         = PONG_GAME_STATE_INVALID;
            mChosenPlayer      = PONG_PLAYER_INVALID;
            mPlayer0Score      = INVALID_PLAYER_SCORE;
            mPlayer1Score      = INVALID_PLAYER_SCORE;
            mPastGameState     = PONG_GAME_STATE_INVALID;
            mPastPlayer0Score  = INVALID_PLAYER_SCORE;
            mPastPlayer1Score  = INVALID_PLAYER_SCORE;
            mWinningPlayer     = PONG_PLAYER_INVALID;
        }

        /////////////////////////////////////////////
        // Called when ANT message is received over the air
        // Parameters:
        //  antMessage - Received ANT message
        // Returns:
        //  none
        /////////////////////////////////////////////
        function onMessage( antMessage )
        {
            //Parse the payload
            var payload    = antMessage.getPayload();
            var messageId  = payload[OFFSET_MSG_ID] & BYTE_MASK;

            if( Ant.MSG_ID_BROADCAST_DATA == antMessage.messageId )
            {
                //Process the message if we can
                if( IdleMessage.MSG_ID == messageId )
                {
                    processIdleMessage( payload );
                }
                else if( DataMessage.MSG_ID == messageId )
                {
                    processDataMessage( payload );
                }
                //! TODO 4.5 Check if it is a ready message
                else if( GameMessage.MSG_ID == messageId )
                {
                    processGameMessage( payload );
                }
            }
            else if( Ant.MSG_ID_CHANNEL_RESPONSE_EVENT == antMessage.messageId )
            {
                if( Ant.MSG_ID_RF_EVENT == ( payload[OFFSET_ANT_RESPONSE_ID] & BYTE_MASK ) )
                {
                    if( Ant.MSG_CODE_EVENT_RX_SEARCH_TIMEOUT == ( payload[OFFSET_ANT_RESPONSE_CODE] & BYTE_MASK ) )
                    {
                        // Channel closed, re-open
                        startGame();
                    }
                }
            }
            //Update the ui
            Ui.requestUpdate();
        }

        /////////////////////////////////////////////
        // Starts a new Pong game
        // Parameters:
        //  none
        // Returns:
        //  none
        /////////////////////////////////////////////
        function startGame()
        {
            // Reset game data
            mGameState         = PONG_GAME_STATE_SEARCH;
            mPlayer0Score      = INVALID_PLAYER_SCORE;
            mPlayer1Score      = INVALID_PLAYER_SCORE;
            mPastGameState     = PONG_GAME_STATE_SEARCH;
            mPastPlayer0Score  = INVALID_PLAYER_SCORE;
            mPastPlayer1Score  = INVALID_PLAYER_SCORE;
            mWinningPlayer     = PONG_PLAYER_INVALID;

            // Open the channel
            GenericChannel.open();
        }

        /////////////////////////////////////////////
        // Stops an existing Pong game
        // Parameters:
        //  none
        // Returns:
        //  none
        /////////////////////////////////////////////
        function stopGame()
        {
            mChosenPlayer  = PONG_PLAYER_INVALID;
            mGameState     = PONG_GAME_STATE_INVALID;
            mPastGameState = PONG_GAME_STATE_INVALID;

            // Close the channel
            GenericChannel.close();
        }

        /////////////////////////////////////////////
        // Gets the current game state
        // Parameters:
        //  none
        // Returns:
        //  mGameState - Current game state (see enum)
        /////////////////////////////////////////////
        function getGameState()
        {
            return mGameState;
        }

        /////////////////////////////////////////////
        // Gets the past game state
        // Parameters:
        //  none
        // Returns:
        //  mPastGameState - Past game state (see enum)
        /////////////////////////////////////////////
        function getPastGameState()
        {
            return mPastGameState;
        }

        /////////////////////////////////////////////
        // Gets the chosen player
        // Parameters:
        //  none
        // Returns:
        //  mChosenPlayer - Chosen player (see enum)
        /////////////////////////////////////////////
        function getPlayer()
        {
            return mChosenPlayer;
        }

        /////////////////////////////////////////////
        // Sets the chosen player
        // Parameters:
        //  player - New chosen player (see enum)
        // Returns:
        //  none
        /////////////////////////////////////////////
        function setPlayer( player )
        {
            if( PONG_PLAYER_0 == player )
            {
                mChosenPlayer = player;
            }
            else if( PONG_PLAYER_1 == player )
            {
                mChosenPlayer = player;
            }
            else
            {
                // Failsafe if an invalid player was passed in
                mChosenPlayer = PONG_PLAYER_INVALID;
            }
        }

        /////////////////////////////////////////////
        // Gets the past score of a player
        // Parameters:
        //  player - Player to get score of (see enum)
        // Returns:
        //  score - Past score of the player
        /////////////////////////////////////////////
        function getPastPlayerScore( player )
        {
            var score;

            score = INVALID_PLAYER_SCORE;

            if( PONG_PLAYER_0 == player )
            {
                score = mPastPlayer0Score;
            }
            else if( PONG_PLAYER_1 == player )
            {
                score = mPastPlayer1Score;
            }

            return score;
        }

        /////////////////////////////////////////////
        // Gets the current score of a player
        // Parameters:
        //  player - Player to get score of (see enum)
        // Returns:
        //  score - Current score of the player
        /////////////////////////////////////////////
        function getPlayerScore( player )
        {
            var score;

            score = INVALID_PLAYER_SCORE;

            if( PONG_PLAYER_0 == player )
            {
                score = mPlayer0Score;
            }
            else if( PONG_PLAYER_1 == player )
            {
                score = mPlayer1Score;
            }

            return score;
        }

        /////////////////////////////////////////////
        // Gets the winning player player
        // Parameters:
        //  none
        // Returns:
        //  mWinningPlayer - Winning player (see enum)
        /////////////////////////////////////////////
        function getWinningPlayer()
        {
            return mWinningPlayer;
        }

        /////////////////////////////////////////////
        // Processes an ANT Idle Message. Updates self as appropriate.
        // Parameters:
        //  payload - Raw ANT data payload
        // Returns:
        //  none
        /////////////////////////////////////////////
        hidden function processIdleMessage( payload )
        {
            // Declare variables
            var pongMessage;

            // Initialize variables
            pongMessage = new IdleMessage();

            // Parse message
            pongMessage.parse( payload );

            // Update game state
            mPastGameState = mGameState;
            mGameState     = PONG_GAME_STATE_IDLE;
        }

        /////////////////////////////////////////////
        // Processes an ANT Data Message. Updates self as appropriate.
        // Parameters:
        //  payload - Raw ANT data payload
        // Returns:
        //  none
        /////////////////////////////////////////////
        hidden function processDataMessage( payload )
        {
            // Declare variables
            var pongMessage;

            // Initialize variables
            pongMessage = new DataMessage();

            // Parse message
            pongMessage.parse( payload );

            // Update game state
            mPastGameState = mGameState;
            mGameState     = PONG_GAME_STATE_DATA;
        }

        /////////////////////////////////////////////
        // Processes an ANT Ready Message. Updates self as appropriate.
        // Parameters:
        //  payload - Raw ANT data payload
        // Returns:
        //  none
        /////////////////////////////////////////////
        hidden function processReadyMessage( payload )
        {
            //! TODO 4.5 process the ready message
        }

        /////////////////////////////////////////////
        // Processes an ANT Game Message. Updates self as appropriate.
        // Parameters:
        //  payload - Raw ANT data payload
        // Returns:
        //  none
        /////////////////////////////////////////////
        hidden function processGameMessage( payload )
        {
            // Declare variables
            var pongMessage;

            // Initialize variables
            pongMessage = new GameMessage();

            // Parse message
            pongMessage.parse( payload );

            // Update player scores
            mPastPlayer0Score = mPlayer0Score;
            mPastPlayer1Score = mPlayer1Score;
            if( pongMessage.player0Scored )
            {
                mPlayer0Score++;
            }
            if( pongMessage.player1Scored )
            {
                mPlayer1Score++;
            }

            // Update game state
            mPastGameState = mGameState;
            if( pongMessage.isGameInProgress )
            {
                mGameState = PONG_GAME_STATE_GAME;
            }
            else
            {
                // Get winning player
                mWinningPlayer = ( pongMessage.player0Won ) ? PONG_PLAYER_0 : PONG_PLAYER_1;
                mGameState     = PONG_GAME_STATE_GAME_OVER;
            }
        }
    }
}
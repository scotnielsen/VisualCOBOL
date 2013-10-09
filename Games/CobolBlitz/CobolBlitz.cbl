      ********************************************************************************************************
      *
      *  This sample is provided under the terms of the Microsoft Public License agreement(Ms-Pl).
      *  For more information, review the ms-pl.txt file in the demonstration folder.
      *
      *  This sample code is supplied for demonstration purposes only on an "as is" basis and "is for use at
      *  your own risk".
      *
      ********************************************************************************************************

       class-id CobolBlitz.CobolBlitz is partial
                 inherits type System.Windows.Forms.Form.

       working-storage section.
       01 timer        type System.Diagnostics.Stopwatch.
       01 lastTime     float-long.
       01 frameCounter binary-long.
       01 gameState    type CobolBlitz.GameState.
       01 style        type ControlStyles.

       method-id NEW.
       procedure division.
           set timer to new type System.Diagnostics.Stopwatch()
           invoke self::InitializeComponent()

           set style to type ControlStyles::AllPaintingInWmPaint B-OR type ControlStyles::UserPaint B-OR type ControlStyles::OptimizedDoubleBuffer
           invoke self::SetStyle(style, true)

           *> Startup the game state
           set gameState to new type CobolBlitz.GameState(self::ClientSize as type System.Drawing.SizeF)

           invoke self::initialize()

           goback.
       end method.


       method-id initialize.
       procedure division.
           invoke gameState::Initialize()
           set lastTime to 0
           invoke timer::Reset()
           invoke timer::Start()
           goback.
       end method.

       method-id CobolBlitzPaint final private.
       local-storage section.
       01 gameTime     float-long.
       01 elapsedTime  float-long.
       procedure division using by value sender as object e as type System.Windows.Forms.PaintEventArgs.

            *> Work out how long since we were last here in seconds
            move timer::ElapsedMilliseconds to gameTime
            divide 1000 into gameTime
            compute elapsedTime = gameTime - lastTime
            set lastTime to gameTime
            compute frameCounter = frameCounter + 1

            *>Perform any animation and updates
            invoke gameState::Update(gameTime, elapsedTime)

            *> Draw everything
            invoke gameState::Draw(e::Graphics)

            *> Force the next Paint()
            invoke self::Invalidate()
            goback.

       end method.



       method-id CobolBlitzKeyDown final private.
       procedure division using by value sender as object e as type System.Windows.Forms.KeyEventArgs.
           *> If we are not playing then a keypress starts the game
            if gameState::State not = type CobolBlitz.GameStateEnum::Playing
               *> If we are currently at gameover then need to reset everything
               if gameState::State = type CobolBlitz.GameStateEnum::GameOver
                   invoke self::initialize()
               end-if
               set gameState::State to type CobolBlitz.GameStateEnum::Playing
           end-if

           invoke type CobolBlitz.Keyboard::KeyDown(e::KeyCode)
           goback.
       end method.

       method-id CobolBlitzKeyUp final private.
       procedure division using by value sender as object e as type System.Windows.Forms.KeyEventArgs.
           invoke type CobolBlitz.Keyboard::KeyUp(e::KeyCode)
           goback.
       end method.

       end class.

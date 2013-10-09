      ********************************************************************************************************
      *
      *  This sample is provided under the terms of the Microsoft Public License agreement(Ms-Pl).
      *  For more information, review the ms-pl.txt file in the demonstration folder.
      *
      *  This sample code is supplied for demonstration purposes only on an "as is" basis and "is for use at
      *  your own risk".
      *
      ********************************************************************************************************

       class-id CobolBlitz.Saucer inherits type Sprite.

       working-storage section.
       01 saucer-y         float-short value 34.
       01 initialVelocity  type System.Drawing.PointF static.

       method-id NEW.
       procedure division using by value gameState as type GameState.
           invoke super::Construct(gameState gameState::GameArea::Width saucer-y "graphics\saucer64x32_1.bmp" "graphics\saucer64x32_2.bmp" type GameObjectEnum::Saucer)
           set initialVelocity to new type System.Drawing.PointF(-80 0)
           set super::Velocity to initialVelocity
       end method.

       method-id Update override.
       local-storage section.
       01 tmp      float-short.
       01 curf     float-short.
       procedure division using by value gameTime as float-long by value elapsedTime as float-long.
               compute tmp = gameTime * 2 
               compute curf = function mod(tmp as binary-long, 2)
               set super::CurrentFrame to curf
               invoke super::Update(gameTime elapsedTime)
       end method.

       end class.

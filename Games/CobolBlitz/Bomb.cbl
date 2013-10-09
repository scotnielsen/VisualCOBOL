      ********************************************************************************************************
      *
      *  This sample is provided under the terms of the Microsoft Public License agreement(Ms-Pl).
      *  For more information, review the ms-pl.txt file in the demonstration folder.
      *
      *  This sample code is supplied for demonstration purposes only on an "as is" basis and "is for use at
      *  your own risk".
      *
      ********************************************************************************************************

       class-id CobolBlitz.Bomb inherits type Sprite.

       working-storage section.
       01 initialVelocity  type System.Drawing.PointF static.

       method-id. NEW.
       local-storage section.
       procedure division using by value gameState as type GameState l-x as float-short l-y as float-short.
           invoke super::Construct(gameState l-x l-y "graphics\bomb6x20.bmp" type GameObjectEnum::Bomb)
           set initialVelocity to new type System.Drawing.PointF(0 80)
           set super::Velocity to initialVelocity
       end method.

       method-id CheckCollisions.
       local-storage section.
       01 collide condition-value.
       procedure division returning ret as type Sprite.
           set ret to null
           perform varying thing as type GameObject through super::GameState::GameObjects
               if thing::ObjectType = type GameObjectEnum::BaseShip or
                  thing::ObjectType = type GameObjectEnum::Base
                   set collide  to false
                   invoke super::Collision(self thing as type Sprite) returning collide
                   if collide
                       set ret to thing as type Sprite
                       exit perform
                   end-if
               end-if
           end-perform
       end method.

       end class.

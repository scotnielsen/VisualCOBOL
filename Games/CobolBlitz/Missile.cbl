      ********************************************************************************************************
      *
      *  This sample is provided under the terms of the Microsoft Public License agreement(Ms-Pl).
      *  For more information, review the ms-pl.txt file in the demonstration folder.
      *
      *  This sample code is supplied for demonstration purposes only on an "as is" basis and "is for use at
      *  your own risk".
      *
      ********************************************************************************************************

       class-id CobolBlitz.Missile inherits type Sprite.

       working-storage section.
       01 initialVelocity      type System.Drawing.PointF.

       method-id NEW.
       procedure division using by value gameState as type GameState l-x as float-short l-y as float-short.
           invoke super::Construct(gameState l-x l-y "graphics\bomb6x20.bmp" type GameObjectEnum::Missile)
           set initialVelocity to new type System.Drawing.PointF(0 -300)
           set super::Velocity to initialVelocity
       end method.

       method-id CheckCollisions.
       local-storage section.
       01 spr  type Sprite.
       01 aln  type Aliens.
       01 cnd  condition-value.
       procedure division returning ret as type Sprite.
           set ret to null
           *> Missiles can collide with bases, aliens and saucers
           perform varying obj as type GameObject through super::GameState::GameObjects

               evaluate obj::ObjectType
               when type GameObjectEnum::Base
               when type GameObjectEnum::Saucer
                   invoke type Sprite::Collision(self obj as type Sprite) returning cnd
                   if cnd = true
                       set ret to (obj as type Sprite)
                       exit perform
                   end-if
               when type GameObjectEnum::Alien
                   set aln to obj as type Aliens
                   invoke aln::CheckCollisions(self as type Sprite) returning spr
                   if spr not = null
                       set ret to spr
                       exit perform
                   end-if
               end-evaluate
           end-perform
       end method.

       end class.

      ********************************************************************************************************
      *
      *  This sample is provided under the terms of the Microsoft Public License agreement(Ms-Pl).
      *  For more information, review the ms-pl.txt file in the demonstration folder.
      *
      *  This sample code is supplied for demonstration purposes only on an "as is" basis and "is for use at
      *  your own risk".
      *
      ********************************************************************************************************

       class-id CobolBlitz.BaseShip inherits type Sprite.

       working-storage section.
       01 speed                float-long  value 150.

       method-id NEW.
       local-storage section.
       01 sz       type System.Drawing.SizeF.
       procedure division using by value l-gameState as type GameState l-x as float-short l-y as float-short.
           invoke self::Construct(l-gamestate l-x l-y "graphics\Shooter40x32.bmp" type GameObjectEnum::BaseShip)
           set sz to super::Size
       end method.

       method-id Update override.
       local-storage section.
       01 velocity     float-short.
       procedure division using by value gameTime as float-long by value elapsedTime as float-long.
           set velocity to 0
            *> Set the velocity of the sprite based on which keys are pressed
            if type Keyboard::Left
                compute velocity = velocity - speed
            end-if
            if type Keyboard::Right
                compute velocity = velocity + speed
            end-if
            invoke self::setVelocity(new type System.Drawing.PointF(velocity 0))

            *> Perform any animation
            invoke super::Update(gameTime elapsedTime)

            *> Limit the animation to the screen
            if super::Location::X < 0
               set super::Location::X to 0
            end-if
            if super::Location::X > (super::GameState::GameArea::Width - super::Size::Width)
               set super::Location::X to (super::GameState::GameArea::Width - super::Size::Width)
            end-if
       end method.

       end class.

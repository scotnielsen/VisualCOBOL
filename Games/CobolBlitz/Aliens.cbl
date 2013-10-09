      ********************************************************************************************************
      *
      *  This sample is provided under the terms of the Microsoft Public License agreement(Ms-Pl).
      *  For more information, review the ms-pl.txt file in the demonstration folder.
      *
      *  This sample code is supplied for demonstration purposes only on an "as is" basis and "is for use at
      *  your own risk".
      *
      ********************************************************************************************************

       class-id CobolBlitz.Aliens inherits type GameObject.

       working-storage section.
       01 initialSpeed             float-short value 30.
       01 initialDirection         type System.Drawing.PointF.
       01 initialMovement          type AlienMovementEnum.
       01 maximumSpeed             binary-long value 200.
       01 numberAliensX            binary-long value 11.
       01 numberAliensY            binary-long value 5.
       01 maxAliens                binary-long value 55.
       01 startY                   binary-long value 55.

       01 aliens                   list[type Sprite].
       01 direction                type System.Drawing.PointF.
       01 speed                    float-short.
       01 movement                 type AlienMovementEnum.
       01 nextMovement             type AlienMovementEnum.
       01 verticalResetPosition    float-short.
       01 gameState                type GameState.
       01 rnd                      type System.Random.

       method-id NEW.
       local-storage section.
       procedure division using by value l-gameState as type GameState.
           set initialDirection to new type System.Drawing.PointF(1 0)
           set initialMovement to type AlienMovementEnum::MoveRight
           compute maxAliens = numberAliensX * numberAliensY
           set aliens to new List[type Sprite]
           set speed to initialSpeed
           set movement to initialMovement
           set rnd to new type  System.Random()
           set super::ObjectType to type GameObjectEnum::Alien
           set gameState to l-gameState
           invoke self::CreateAliens()
       end method.

       method-id CreateAliens.
       local-storage section.
       01 l-x  binary-long.
       01 l-y  binary-long.
       01 sz   type AlienSizeEnum.
       procedure division.
           invoke aliens::Clear()
           perform varying x as binary-long from 0 by 1 until x >= numberALiensX
               perform varying y as binary-long from 0 by 1 until y >= numberAliensY
                   set sz to type AlienSizeEnum::Large
                   evaluate y
                       when 0
                           set sz to type AlienSizeEnum::Small
                       when 1
                       when 2
                           set sz to type AlienSizeEnum::Medium
                   end-evaluate
                   compute l-x = x * type Alien::Width
                   compute l-y = y + 1
                   compute l-y = l-y * type Alien::Height
                   invoke aliens::Add(new type Alien(gameState l-x l-y sz))
               end-perform
           end-perform
           set direction to initialDirection
           set speed to initialSpeed
           set movement to initialMovement
       end method.

       method-id BombAlien public.
       local-storage section.
       01 spr      type Sprite.
       procedure division returning ret as type Sprite.
           set spr to aliens[rnd::Next(aliens::Count)]
           perform varying sprloop as type Sprite through aliens
               if sprloop not = spr
                   if spr::Location::X = sprloop::Location::X and spr::Location::Y < sprloop::Location::Y
                       set spr to sprloop
                   end-if
               end-if
           end-perform
           set ret to spr
           goback.
       end method.

       method-id Update override.
       local-storage section.
       01 minLocation      type System.Drawing.PointF.
       01 maxLocation      type System.Drawing.PointF.
       01 curf             binary-long.
       01 tmp              float-short.
       procedure division using by value gameTime as float-long by value elapsedTime as float-long.
           set minLocation to new type System.Drawing.PointF(type System.Single::MaxValue type System.Single::MaxValue)
           set maxLocation to new type System.Drawing.PointF(type System.Single::MinValue type System.Single::MinValue)
           invoke self::CalculateSpeed(aliens::Count) returning speed

           *> Update each alien
           perform varying spr as type Sprite through aliens
               invoke type PointFMath::Min(spr::Location, minLocation) returning minLocation
               invoke type PointFMath::Max(spr::Location, maxLocation) returning maxLocation

               set spr::Velocity to new type System.Drawing.PointF((direction::X * speed) (direction::Y * speed))

               compute tmp = (gameTime * speed) / 50
               compute curf = function mod(tmp as binary-long, 2)
               set spr::CurrentFrame to curf

               invoke spr::Update(gameTime, elapsedTime)

           end-perform


           *>Set up the direction for the next frame
           evaluate movement
               when type AlienMovementEnum::MoveLeft
               when type AlienMovementEnum::MoveRight
                   *> If we have hit the edge of the screen we are moving towards
                   if minLocation::X < 0 and movement = type AlienMovementEnum::MoveLeft
                       or (maxLocation::X + type Alien::Width > gameState::GameArea::Width and movement = type AlienMovementEnum::MoveRight)
                       *> Remember which direction we will go next
                       if movement = type AlienMovementEnum::MoveLeft
                           set nextMovement to type AlienMovementEnum::MoveRight
                       else
                           set nextMovement to type AlienMovementEnum::MoveLeft
                       end-if

                       *> Then we move down
                       set direction::X to 0
                       set direction::Y to 1
                       set movement to type AlienMovementEnum::MoveDown
                       compute verticalResetPosition = type Alien::Height / 4
                       compute verticalResetPosition = minLocation::Y + verticalResetPosition
                   end-if

               when type AlienMovementEnum::MoveDown
                   *>If the lowest alien is below the level of the base ship
                   if (maxLocation::Y + type Alien::Height) > (gameState::GameArea::Height - 32)
                       set gameState::State to type GameStateEnum::GameOver
                   end-if

                   *> If we have moved down far enough
                   if minLocation::Y > verticalResetPosition
                       *> then head off back in the opposite direction
                       if nextMovement = type AlienMovementEnum::MoveLeft
                           set direction::X to -1
                       else
                           set direction::X to 1
                       end-if
                       set direction::Y to 0
                       set movement to nextMovement
                   end-if
           end-evaluate

       end method.

       method-id CalculateSpeed.
       local-storage section.
       01 tmp1             float-short.
       01 tmp2             float-short.
       01 tmp3             float-short.
       procedure division using l-numOfAliens as binary-long returning ret as float-short.
           compute tmp1 = initialSpeed - maximumSpeed
           compute tmp2 = maxAliens - l-numOfAliens
           compute tmp3 = tmp1 * tmp2
           compute tmp2 = tmp3 / maxAliens
           compute tmp1 = initialSpeed - tmp2
           set ret to tmp1
       end method.


       method-id Draw override.
       procedure division using by value graphics as type System.Drawing.Graphics.
           *> Render each sprite in the collection
           perform varying spr as type Sprite through aliens
               invoke spr::Draw(graphics)
           end-perform
       end method.

       method-id Remove.
       local-storage section.
       procedure division using l-sprite as type Sprite.
           invoke aliens::Remove(l-sprite)
       end method.

       method-id CheckCollisions.
       procedure division using by value collider as type Sprite returning ret as type Sprite.
           set ret to null
           perform varying spr as type Sprite through aliens
               if type Sprite::Collision(collider, spr) not = null
                   set ret to spr
               end-if
           end-perform
       end method.

       method-id CheckCollisionsAndErode.
       procedure division using collider as type Base returning ret as type Sprite.
           set ret to null
           perform varying spr as type Sprite through aliens
              if type Sprite::Collision(collider spr) not = null
                  invoke collider::ErodeRectangle(spr)
              end-if
           end-perform
       end method.


       method-id Count.
       local-storage section.
       01 cnt      binary-long.
       procedure division returning ret as binary-long.
           set ret to aliens::Count
       end method.
       end class.

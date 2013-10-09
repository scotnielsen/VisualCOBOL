      ********************************************************************************************************
      *
      *  This sample is provided under the terms of the Microsoft Public License agreement(Ms-Pl).
      *  For more information, review the ms-pl.txt file in the demonstration folder.
      *
      *  This sample code is supplied for demonstration purposes only on an "as is" basis and "is for use at
      *  your own risk".
      *
      ********************************************************************************************************

       class-id CobolBlitz.GameState.

       working-storage section.
       78 initialLives     value 3.

       01 score            binary-long property as "Score".
       01 lives            binary-long property as "Lives".
       01 gameArea         type System.Drawing.SizeF property as "GameArea".

       01 state            type GameStateEnum value 0 property as "State".
       01 gameObjects      list[type GameObject] property as "GameObjects".

       01 isSaucerVisible  condition-value value false.
       01 saucer           type Saucer.
       01 isBombDropping   condition-value value false.

       01 bomb             type Bomb.
       01 aliens           type Aliens.
       01 isMissileVisible condition-value.
       01 missile          type Missile.
       01 baseShip         type BaseShip.
       01 bases            type Base occurs 4.
       01 explosion        type Sprite.
       01 isExploding      condition-value.
       01 explosionStart   float-long.

       01 shoot            type System.Media.SoundPlayer.
       01 explode          type System.Media.SoundPlayer.
       01 dead             type System.Media.SoundPlayer.

       01 font             type System.Drawing.Font.
       01 brush            type System.Drawing.Brush.
       01 rnd              type System.Random.


       method-id NEW.
       procedure division using l-gameArea as type System.Drawing.SizeF.
           set gameObjects to new type System.Collections.Generic.List[type GameObject]()
           set shoot to new type System.Media.SoundPlayer("sounds\shoot.wav")
           set explode to new type System.Media.SoundPlayer("sounds\explode.wav")
           set dead to new type System.Media.SoundPlayer("sounds\dead.wav")
           set font to new type System.Drawing.Font("Arial" 24)
           set brush to new type  System.Drawing.SolidBrush(type System.Drawing.Color::White)
           set rnd to new type System.Random()
           set gameArea to l-gameArea

           invoke shoot::Load()
           invoke dead::Load()
           invoke explode::Load()
           goback.
       end method.

       method-id Draw.
       local-storage section.
       01 x            binary-long.
       procedure division using graphics as type System.Drawing.Graphics.

            *> Draw the game objects
            perform varying obj as type GameObject through GameObjects
               invoke obj::Draw(graphics)
            end-perform

            *> Draw the scores and any text
            if State not equals type GameStateEnum::Playing
                invoke graphics::DrawString("Press any key to play"  font  brush  240  300)
            end-if

            if  State equals type GameStateEnum::GameOver
                invoke graphics::DrawString("GAME OVER" font brush 300 260)
            end-if

            *> Score goes on the right hand side of the screen so calculate the correct position by measuring the string
            compute x = GameArea::Width - graphics::MeasureString(type System.Convert::ToString(Lives) font)::Width - 50
            invoke graphics::DrawString(type System.Convert::ToString(Score) font brush x 0)

            *> Number of lives left
            invoke graphics::DrawString(type System.Convert::ToString(Lives) font brush  40 0)

       end method.

       method-id Update.
       local-storage section.
       01 curf         binary-long.
       01 tmp          binary-long.
       procedure division using gameTime as float-long elapsedTime as float-long.

            *> Updates all the game objects
            if State = type GameStateEnum::Playing

                *> Create or destroy any transient objects
                invoke self::handleSaucer()
                invoke self::handleBomb()
                invoke self::handleMissile()

                if isExploding
                    if explosionStart < 0
                        invoke GameObjects::Remove(baseShip)
                        invoke GameObjects::Add(explosion)
                        *> Start the counter for the length of this animation
                        set explosionStart to gameTime
                    end-if

                    set explosion::Location to baseShip::Location
                   compute tmp = gameTime * 10
                   compute curf = function mod(tmp as binary-long, 2)
                   set explosion::CurrentFrame to curf

                    if gameTime - explosionStart > 2.0
                        *> Turn off the explosion animation
                        set isExploding to false
                        invoke GameObjects::Add(baseShip)
                        invoke GameObjects::Remove(explosion)
                    end-if
                end-if

               perform varying obj as type GameObject through GameObjects
                   invoke obj::Update(gameTime elapsedTime)
               end-perform

               *> Check for any collisions
               invoke self::checkBombCollisions()
               invoke self::checkMissileCollisions()
               invoke self::checkAlienCollisions()

            end-if
       end method.

       method-id checkAlienCollisions.
       procedure division.
            *> If the aliens overlap the bases the bases need to be eroded correctly
            perform varying spr as type Sprite through bases
                invoke aliens::CheckCollisionsAndErode(spr as type Base)
            end-perform
       end method.

       method-id checkMissileCollisions.
       local-storage section.
       01 missileHit       type Sprite.
       01 baseSpr          type Base.
       01 base             type Base.
       procedure division.
           if isMissileVisible
               invoke missile::CheckCollisions() returning missileHit
               if missileHit not = null
                   evaluate missileHit::ObjectType
                   when type GameObjectEnum::Alien
                       *> An alien is hit 10 points
                       invoke aliens::Remove(missileHit)
                       invoke GameObjects::Remove(missile)
                       set isMissileVisible to false
                       compute Score = Score + 10
                       invoke explode::Play()
                       *> If this is the last alien then reset the level
                       if aliens::Count = 0
                           invoke aliens::CreateAliens()
                           perform varying baseSpr through bases
                               invoke baseSpr::Reset()
                           end-perform
                       end-if
                   when type GameObjectEnum::Saucer
                       *> A saucer is hit 100 points
                       invoke GameObjects::Remove(missileHit)
                       invoke GameObjects::Remove(missile)
                       invoke explode::Play()
                       set isMissileVisible to false
                       compute Score = Score + 100
                   when type GameObjectEnum::Base
                       *> A base may have been hit - check the pixels to be sure
                       set base to (missileHit as type Base)
                       if base::CheckPixel(missile::Location) = true
                           *> Base is hit - erode where the hit occurred
                           invoke base::Erode(missile::Location)
                           invoke GameObjects::Remove(missile)
                           set isMissileVisible to false
                       end-if
                   end-evaluate
               end-if
           end-if
       end method.

       method-id checkBombCollisions.
       local-storage section.
       01 bombHit      type Sprite.
       01 base         type Base.
       procedure division.

           if isBombDropping
               invoke bomb::CheckCollisions() returning bombHit
               if bombHit not = null
                   evaluate bombHit::ObjectType
                   when type GameObjectEnum::BaseShip
                       *> Alien bomb hits a base ship
                       invoke GameObjects::Remove(bomb)
                       set isBombDropping to false
                       invoke dead::Play()
                       if Lives = 0
                           set State to type GameStateEnum::GameOver
                       else
                           compute Lives = Lives - 1
                       end-if
                       set isExploding to true
                       set explosionStart to -1
                   when type GameObjectEnum::Base
                       *> A missile may have hit a base - check the actual pixels
                       set base to (bombHit as type Base)
                       if base::CheckPixel(new PointF(bomb::Location::X, bomb::Location::Y + bomb::Size::Height)) = true
                           *> Missile did hit a base - erode around the collision point
                           invoke base::Erode(new PointF(bomb::Location::X, bomb::Location::Y + bomb::Size::Height))
                           invoke GameObjects::Remove(bomb)
                           set isBombDropping to false
                       end-if
                   end-evaluate
               end-if
           end-if
       end method.

       method-id handleMissile.
       local-storage section.
       01 x        float-short.
       01 y        float-short.
       procedure division.
           *> Decide if we should create missile - no current missile and player is pressing Fire
           *> and not in the middle of an explosion
           if isMissileVisible = false and isExploding = false and type Keyboard::Fire = true
               invoke shoot::Play()
               set isMissileVisible to true
               compute x = baseShip::Size::Width / 2
               compute x = x  + baseShip::Location::X
               compute y = baseShip::Location::Y - 20
               set missile to new type Missile(self, x, y)
               invoke GameObjects::Add(missile)
           end-if

           *> Decide if its time to remove the missile
           if isMissileVisible = true and missile::Location::Y < 0
               invoke GameObjects::Remove(missile)
               set isMissileVisible to false
           end-if
       end method.

       method-id handleBomb.
       local-storage section.
       01 bombAlien    type Sprite.
       01 x            float-short.
       01 y            float-short.
       procedure division.
          *> Decide if we should create a bomb
          if isBombDropping = false and rnd::Next(100) = 0
               set bombAlien to aliens::BombAlien
               set isBombDropping to true
               compute x = bombAlien::Size::Width / 2
               compute x = x + bombAlien::Location::X
               compute y = bombAlien::Location::Y + bombAlien::Size::Height
               set bomb to new type Bomb(self, x, y)
               invoke GameObjects::Add(bomb)
           end-if
           *> Decide if its time to remove the bomb
           if isBombDropping and bomb::Location::Y > GameArea::Height
               invoke GameObjects::Remove(bomb)
               set isBombDropping to false
           end-if
       end method.

       method-id handleSaucer.
       procedure division.
           *> Decide if we should create a saucer
           if isSaucerVisible = false and rnd::Next(1000) = 0
               set saucer to new type Saucer(self)
               invoke GameObjects::Add(saucer)
               set isSaucerVisible to true
           end-if
           *> Decide if its time to remove the saucer
           if isSaucerVisible = true and saucer::Location::X + saucer::Size::Width < 0
               invoke GameObjects::Remove(saucer)
               set isSaucerVisible to false
           end-if
       end method.

       method-id Initialize.
       local-storage section.
       01 xpos         float-short.
       01 ypos         float-short.
       procedure division.

           *> Create all the main gameobjects
           invoke GameObjects::Clear()

           compute xpos = GameArea::Width / 2
           compute xpos = xpos - 20
           compute ypos = GameArea::Height - 46
           set baseShip to new type BaseShip(self xpos ypos)
           invoke GameObjects::Add(baseShip)

           compute ypos = GameArea::Height - 140

           set xpos to GameArea::Width
           compute xpos = xpos * 0.15
           compute xpos = xpos - 40
           set bases(1) to new type Base(self, xpos, ypos)

           set xpos to GameArea::Width
           compute xpos = xpos * 0.375
           compute xpos = xpos - 40
           set bases(2) to new type Base(self, xpos, ypos)

           set xpos to GameArea::Width
           compute xpos = xpos * 0.625
           compute xpos = xpos - 40
           set bases(3) to new type Base(self, xpos, ypos)

           set xpos to GameArea::Width
           compute xpos = xpos * 0.85
           compute xpos = xpos - 40
           set bases(4) to new type Base(self, xpos, ypos)

           perform varying baseSpr as type Base through bases
               invoke GameObjects::Add(baseSpr)
           end-perform

           set aliens to new type Aliens(self)
           invoke GameObjects::Add(aliens)

           *> Extra sprite for the 'lives' display
           invoke GameObjects::Add(new type Sprite(self, 0, 0, "graphics\shooter40x32.bmp", type GameObjectEnum::Lives))

           *> Setup explosion sprite ready to use. Not drawn every frame so not added
           *> to GameObjects yet
           set explosion to new type Sprite(self, 0, 0, "graphics\shooterexplosion40x32_1.bmp", "graphics\shooterexplosion40x32_2.bmp", type GameObjectEnum::Explosion)
           set isExploding to false

           *> Reset the game state
           set Score to 0
           set Lives to initialLives
           set isBombDropping to false
           set isSaucerVisible to false
           set isMissileVisible to false
       end method.

       end class.

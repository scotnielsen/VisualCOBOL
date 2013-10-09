      ********************************************************************************************************
      *
      *  This sample is provided under the terms of the Microsoft Public License agreement(Ms-Pl).
      *  For more information, review the ms-pl.txt file in the demonstration folder.
      *
      *  This sample code is supplied for demonstration purposes only on an "as is" basis and "is for use at
      *  your own risk".
      *
      ********************************************************************************************************

       class-id CobolBlitz.Sprite inherits type GameObject.

       working-storage section.
       01 vel          type System.Drawing.PointF property as "Velocity".
       01 loc          type System.Drawing.PointF property as "Location".
       01 sz           type System.Drawing.SizeF property as "Size".
       01 currentFrame binary-long property as "CurrentFrame".

       01 frames       list[type System.Drawing.Bitmap] property as "Frames".
       01 gameState    type GameState property as "GameState".

       *> Default constructor does nothing
       method-id NEW.
       procedure division.
           goback.
       end method.

       method-id NEW.
       procedure division using by value l-gameState as type GameState l-x as float-short l-y as float-short l-filename as string l-objtype as type GameObjectEnum.
           invoke self::Construct(l-gamestate l-x l-y l-filename l-objtype)
       end method.

       method-id NEW.
       procedure division using by value l-gameState as type GameState l-x as float-short l-y as float-short l-filename1 as string l-filename2 as string l-objtype as type GameObjectEnum.
           invoke self::Construct(l-gameState l-x l-y l-filename1 l-filename2 l-objtype)
       end method.

       method-id Construct.
       procedure division using by value l-gameState as type GameState l-x as float-short l-y as float-short l-filename as string l-objtype as type GameObjectEnum.
           set frames to new List[type System.Drawing.Bitmap]
           set self::ObjectType to l-objtype
           invoke frames::Add(new type System.Drawing.Bitmap(l-filename))
           invoke self::initialize(l-gameState l-x l-y frames[0]::Width frames[0]::Height)
       end method.

       method-id Construct.
       procedure division using by value l-gameState as type GameState l-x as float-short l-y as float-short l-filename1 as string l-filename2 as string l-objtype as type GameObjectEnum.
           set frames to new List[type System.Drawing.Bitmap]
           set self::ObjectType to l-objtype
           invoke frames::Add(new type System.Drawing.Bitmap(l-filename1))
           invoke frames::Add(new type System.Drawing.Bitmap(l-filename2))
           invoke self::initialize(l-gameState l-x l-y frames[0]::Width frames[0]::Height)
       end method.

       method-id initialize private.
       procedure division using by value l-gameState as type GameState l-x as float-short l-y as float-short l-width as float-short l-height as float-short.
           set gameState to l-gameState
           set loc to new type System.Drawing.PointF(l-x, l-y)
           set vel to new type System.Drawing.PointF(0  0)
           set sz to new type System.Drawing.SizeF(l-width  l-height)
           set currentFrame to 0
       end method.

       method-id setVelocity.
       procedure division using l-velocity as type System.Drawing.PointF.
           set vel to l-velocity
       end method.

       method-id Update override.
       local-storage section.
       01 tmp          float-short.
       procedure division using by value gameTime as float-long elapsedTime as float-long.
           compute tmp = vel::X * elapsedTime
           compute loc::X = loc::X + tmp
           compute tmp = vel::Y * elapsedTime
           compute loc::Y = loc::Y + tmp
       end method.

       method-id Draw override.
       local-storage section.
       procedure division using by value graphics as type System.Drawing.Graphics.
           invoke graphics::DrawImage(frames[CurrentFrame] loc::X loc::Y sz::Width sz::Height)
       end method.

       method-id Collision static.
       procedure division using by value spr1 as type Sprite spr2 as type Sprite returning ret as condition-value.
           set ret to true
           if spr1::Location::X > (spr2::Location::X + spr2::Size::Width)
              or (spr1::Location::X + spr1::Size::Width) < spr2::Location::X
              or spr1::Location::Y > (spr2::Location::Y + spr2::Size::Height)
              or (spr1::Location::Y + spr1::Size::Height) < spr2::Location::Y
             set ret to false
           end-if
       end method.

       end class.


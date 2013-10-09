      ********************************************************************************************************
      *
      *  This sample is provided under the terms of the Microsoft Public License agreement(Ms-Pl).
      *  For more information, review the ms-pl.txt file in the demonstration folder.
      *
      *  This sample code is supplied for demonstration purposes only on an "as is" basis and "is for use at
      *  your own risk".
      *
      ********************************************************************************************************

       class-id CobolBlitz.Base inherits type Sprite.

       working-storage section.
       01 sizeX            float-short value 10.
       01 sizeY            float-short value 20.

       method-id NEW.
       procedure division using by value l-gameState as type GameState l-x as float-short l-y as float-short.
           invoke super::Construct(l-gameState, l-x, l-y, "graphics\Base.bmp", type GameObjectEnum::Base)
       end method.

       method-id CheckPixel.
       local-storage section.
       01 result       condition-value.
       procedure division using l-point as type System.Drawing.PointF returning ret as condition-value.
           *> Check this pixel and one 6 to its right (the size of missiles and bombs) to see if we have hit anything
           invoke self::isPixelOpaque(((l-point::X - super::Location::X) as binary-long) ((l-point::Y - super::Location::Y) as binary-long)) returning result
           if result = false
               invoke self::isPixelOpaque(((l-point::X - super::Location::X + 6) as binary-long) ((l-point::Y - super::Location::Y) as binary-long)) returning result
           end-if
           set ret to result
       end method.

       method-id isPixelOpaque private.
       local-storage section.
       procedure division using x as binary-long y as binary-long returning ret as condition-value.
            *> If the pixel is out of range that counts as black
           if x < 0 or x > (super::Frames[0]::Width - 1) or y < 0 or y > (super::Frames[0]::Height - 1)
              set ret to false
           else
              *> Otherwise check for anything that is not black
              if super::Frames[0]::GetPixel(x y) not equals type System.Drawing.Color::FromArgb(0 0 0)
                  set ret to true
              else
                  set ret to false
              end-if
           end-if
       end method.

       method-id Erode.
       local-storage section.
       01 graphics     type System.Drawing.Graphics.
       01 x            float-short.
       01 y            float-short.
       01 tmp          float-short.
       procedure division using l-point as type System.Drawing.PointF.

           *>Draw a black circle in the bitmap over the point of intersection
           set graphics to type System.Drawing.Graphics::FromImage(super::Frames[0])
           *> compute x = l-point::X - Location.X - sizeX / 2 + 3
           compute tmp = sizeX / 2
           compute tmp = l-point::X - super::Location::X - tmp
           compute x = tmp + 3
           *> compute y = l-point::Y - super::Location::Y - sizeY / 2
           compute tmp = sizeY / 2
           compute y = l-point::Y - super::Location::Y - tmp

           invoke graphics::FillEllipse(type System.Drawing.Brushes::Black x y sizeX sizeY)

       end method.


       method-id ErodeRectangle.
       local-storage section.
       01 graphics     type System.Drawing.Graphics.
       01 x            float-short.
       01 y            float-short.
       procedure division using l-spr as type Sprite.
           *>Draw a black rectangle where the sprite will be drawn, thus eroding the bases as the aliens pass over them
           set graphics to type System.Drawing.Graphics::FromImage(super::Frames[0])
           compute x = l-spr::Location::X - super::Location::X
           compute y = l-spr::Location::Y - super::Location::Y
           invoke graphics::FillRectangle(type System.Drawing.Brushes::Black x y l-spr::Size::Width l-spr::Size::Height)
       end method.

       method-id Reset.
       procedure division.
           *>This is called on a new level and restores any eroded bitmaps back to their full glory
           set super::Frames[0] to new type System.Drawing.Bitmap("graphics\Base.bmp")
       end method.

       end class.

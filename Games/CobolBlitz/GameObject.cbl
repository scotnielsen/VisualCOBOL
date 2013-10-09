      ********************************************************************************************************
      *
      *  This sample is provided under the terms of the Microsoft Public License agreement(Ms-Pl).
      *  For more information, review the ms-pl.txt file in the demonstration folder.
      *
      *  This sample code is supplied for demonstration purposes only on an "as is" basis and "is for use at
      *  your own risk".
      *
      ********************************************************************************************************

       class-id CobolBlitz.GameObject is abstract.

       working-storage section.
       01 obj-type type GameObjectEnum property as "ObjectType" value 0 public.

       method-id Update.
       procedure division using by value gameTime as float-long by value elapsedTime as float-long.
           goback.
       end method.

       method-id Draw.
       procedure division using by value graphics as type System.Drawing.Graphics.
           goback.
       end method.

       end class.

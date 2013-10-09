      ********************************************************************************************************
      *
      *  This sample is provided under the terms of the Microsoft Public License agreement(Ms-Pl).
      *  For more information, review the ms-pl.txt file in the demonstration folder.
      *
      *  This sample code is supplied for demonstration purposes only on an "as is" basis and "is for use at
      *  your own risk".
      *
      ********************************************************************************************************

       class-id CobolBlitz.Keyboard.

       working-storage section.
       01 keyLeft      condition-value value false property as "Left" static.
       01 keyRight     condition-value value false property as "Right" static.
       01 keyFire      condition-value value false property as "Fire" static.

       method-id KeyDown static.
       procedure division using keys as type System.Windows.Forms.Keys.
           evaluate keys
           when type System.Windows.Forms.Keys::Left
               set keyLeft to true
           when type System.Windows.Forms.Keys::Right
               set keyRight to true
           when type System.Windows.Forms.Keys::Space
               set keyFire to true
           end-evaluate
           goback.
       end method.

       method-id KeyUp static.
       procedure division using keys as type System.Windows.Forms.Keys.
           evaluate keys
           when type System.Windows.Forms.Keys::Left
               set keyLeft to false
           when type System.Windows.Forms.Keys::Right
               set keyRight to false
           when type System.Windows.Forms.Keys::Space
               set keyFire to false
           end-evaluate
           goback.
       end method.

       end class.

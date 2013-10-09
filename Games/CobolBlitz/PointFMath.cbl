      ********************************************************************************************************
      *
      *  This sample is provided under the terms of the Microsoft Public License agreement(Ms-Pl).
      *  For more information, review the ms-pl.txt file in the demonstration folder.
      *
      *  This sample code is supplied for demonstration purposes only on an "as is" basis and "is for use at
      *  your own risk".
      *
      ********************************************************************************************************

       class-id CobolBlitz.PointFMath.

       working-storage section.

       method-id Min public static.
       local-storage section.
       01 res      type System.Drawing.PointF.
       procedure division using val1 as type System.Drawing.PointF val2 as type System.Drawing.PointF returning ret as type System.Drawing.PointF.
           set res to new type System.Drawing.PointF(type System.Math::Min(val1::X val2::X) type System.Math::Min(val1::Y val2::Y))
           set ret to res
           goback.
       end method.

       method-id Max public static.
       local-storage section.
       01 res      type System.Drawing.PointF.
       procedure division using val1 as type System.Drawing.PointF val2 as type System.Drawing.PointF returning ret as type System.Drawing.PointF.
           set res to new type System.Drawing.PointF(type System.Math::Max(val1::X val2::X) type System.Math::Max(val1::Y val2::Y))
           set ret to res
           goback.
       end method.

       end class.

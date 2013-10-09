      ********************************************************************************************************
      *
      *  This sample is provided under the terms of the Microsoft Public License agreement(Ms-Pl).
      *  For more information, review the ms-pl.txt file in the demonstration folder.
      *
      *  This sample code is supplied for demonstration purposes only on an "as is" basis and "is for use at
      *  your own risk".
      *
      ********************************************************************************************************

       class-id CobolBlitz.Main.

       working-storage section.

       method-id Main static
           custom-attribute is type System.STAThreadAttribute.
       local-storage section.
       01 mainForm type CobolBlitz.
       procedure division.

           set mainForm to new CobolBlitz()
           invoke type System.Windows.Forms.Application::Run(mainForm)

       end method.

       end class.

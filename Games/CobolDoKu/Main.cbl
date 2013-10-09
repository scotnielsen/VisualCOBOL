      ********************************************************************************************************
      *
      * Copyright (C) Micro Focus 2010-2013.
      * All rights reserved.
      *
      *  This sample code is supplied for demonstration purposes only on an "as is" basis and "is for use at
      *  your own risk".
      *
      ********************************************************************************************************

       class-id CobolDoKu.Main.

      *>> <summary>
      *>> The application entry point.
      *>> </summary>
       method-id Main is static attribute System.STAThreadAttribute.
       local-storage section.
       01 mainForm type CobolDoKu.Form1.
       procedure division.
           set mainForm to new CobolDoKu.Form1()
           invoke type System.Windows.Forms.Application::EnableVisualStyles()
           invoke type System.Windows.Forms.Application::Run(mainForm)
       end method.

       end class.

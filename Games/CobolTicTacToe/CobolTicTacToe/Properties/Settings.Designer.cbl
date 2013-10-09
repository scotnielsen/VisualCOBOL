      ***************************************************************
      * Copyright (C) Micro Focus 1976-2013.
      * All rights reserved.
      *
      *  This sample code is supplied for demonstration purposes only on an "as is" basis and "is for use at
      *  your own risk".
      ***************************************************************
      
      *> Namespace: CobolTicTacToe.Properties

       class-id CobolTicTacToe.Properties.Settings is partial is final 
                 inherits type System.Configuration.ApplicationSettingsBase
                 custom-attribute is type System.Runtime.CompilerServices.CompilerGeneratedAttribute()
                 custom-attribute is type System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.VisualStudio.Editors.SettingsDesigner.SettingsSingleFileGenerator", "8.0.0.0")
                 .
           

       working-storage section.
       01 defaultInstance type CobolTicTacToe.Properties.Settings static.
       
	   method-id get property Default static final.
       procedure division returning return-item as type CobolTicTacToe.Properties.Settings.
       set return-item to defaultInstance
       goback
       end method.      

       end class.

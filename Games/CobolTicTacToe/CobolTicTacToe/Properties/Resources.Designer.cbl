﻿      ***************************************************************
      * Copyright (C) Micro Focus 1976-2013.
      * All rights reserved.
      *
      *  This sample code is supplied for demonstration purposes only on an "as is" basis and "is for use at
      *  your own risk".
      ***************************************************************      
      
      $set sourceformat(variable)

      *> Namespace: CobolTicTacToe.Properties

      *>> <summary>
      *>>   A strongly-typed resource class, for looking up localized strings, etc.
      *>> </summary>
      *> This class was auto-generated by the StronglyTypedResourceBuilder
      *> class via a tool like ResGen or Visual Studio.
      *> To add or remove a member, edit your .ResX file then rerun ResGen
      *> with the /str option, or rebuild your VS project.
       class-id CobolTicTacToe.Properties.Resources
           attribute System.CodeDom.Compiler.GeneratedCodeAttribute("System.Resources.Tools.StronglyTypedResourceBuilder", "4.0.0.0")
           attribute System.Diagnostics.DebuggerNonUserCodeAttribute()
           attribute System.Runtime.CompilerServices.CompilerGeneratedAttribute()
       .

       working-storage section.
       01 resourceMan type System.Resources.ResourceManager static.
       01 resourceCulture type System.Globalization.CultureInfo static.

       method-id get property ResourceManager static
           attribute System.ComponentModel.EditorBrowsableAttribute(type System.ComponentModel.EditorBrowsableState::Advanced) final.
       local-storage section.
       01 temp type System.Resources.ResourceManager.
       procedure division returning return-item as type System.Resources.ResourceManager.
       if type System.Object::ReferenceEquals(resourceMan null) then 
           set temp to new System.Resources.ResourceManager( "CobolTicTacToe.Properties.Resources" type of CobolTicTacToe.Properties.Resources::Assembly)
           set resourceMan to temp
       end-if
       set return-item to resourceMan
       end method.

       method-id get property Culture static
           attribute System.ComponentModel.EditorBrowsableAttribute(type System.ComponentModel.EditorBrowsableState::Advanced) final.
       procedure division returning return-item as type System.Globalization.CultureInfo.
       set return-item to resourceCulture
       end method.

       method-id set property Culture static final.
       procedure division using by value #value as type System.Globalization.CultureInfo.
       set resourceCulture to #value
       end method.

       method-id get property blank static final.
       local-storage section.
       01 obj object.
       procedure division returning return-item as type System.Drawing.Bitmap.
       set obj to self::ResourceManager::GetObject("blank" resourceCulture)
       set return-item to obj as type System.Drawing.Bitmap
       end method.

       method-id get property Notes static final.
       procedure division returning return-item as string.
       set return-item to self::ResourceManager::GetString("Notes" resourceCulture)
       end method.

       method-id get property o static final.
       local-storage section.
       01 obj object.
       procedure division returning return-item as type System.Drawing.Bitmap.
       set obj to self::ResourceManager::GetObject("o" resourceCulture)
       set return-item to obj as type System.Drawing.Bitmap
       end method.

       method-id get property x static final.
       local-storage section.
       01 obj object.
       procedure division returning return-item as type System.Drawing.Bitmap.
       set obj to self::ResourceManager::GetObject("x" resourceCulture)
       set return-item to obj as type System.Drawing.Bitmap
       end method.

       method-id NEW protected
                    custom-attribute is type System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1811:AvoidUncalledPrivateCode").
       procedure division.
       end method.

       end class.

      ********************************************************************************************************
      *
      *  This sample is provided under the terms of the Microsoft Public License agreement(Ms-Pl). 
      *  For more information, review the ms-pl.txt file in the demonstration folder.
      *
      *  This sample code is supplied for demonstration purposes only on an "as is" basis and "is for use at
      *  your own risk".
      *
      ********************************************************************************************************
       
       class-id CobolBlitz.CobolBlitz
				 is partial inherits type System.Windows.Forms.Form.
       
       01 components type System.ComponentModel.IContainer.
      
      *> Required method for Designer support - do not modify
      *> the contents of this method with the code editor.
       method-id InitializeComponent private.
       procedure division.
       invoke self::SuspendLayout
      *> 
      *> CobolBlitz
      *> 
       set self::BackColor to type System.Drawing.Color::Black
       set self::ClientSize to new System.Drawing.Size( 782 556)
       set self::FormBorderStyle to type System.Windows.Forms.FormBorderStyle::FixedSingle
       set self::Name to "CobolBlitz"
       set self::Text to "CobolBlitz"
       invoke self::add_Paint(new System.Windows.Forms.PaintEventHandler(self::CobolBlitzPaint))
       invoke self::add_KeyDown(new System.Windows.Forms.KeyEventHandler(self::CobolBlitzKeyDown))
       invoke self::add_KeyUp(new System.Windows.Forms.KeyEventHandler(self::CobolBlitzKeyUp))
       invoke self::ResumeLayout(False)
       end method.

      *> Clean up any resources being used.      
       method-id Dispose override is protected.
       procedure division using by value disposing as condition-value.
           if disposing then
               if components not = null then
                   invoke components::Dispose()
               end-if
           end-if
           invoke super::Dispose(by value disposing)
           goback.
       end method.

       end class.

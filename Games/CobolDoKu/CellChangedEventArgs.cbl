      ********************************************************************************************************
      *
      * Copyright (C) Micro Focus 2010-2013.
      * All rights reserved.
      *
      *  This sample code is supplied for demonstration purposes only on an "as is" basis and "is for use at
      *  your own risk".
      *
      ********************************************************************************************************

      *> An EventArgs derived class used to send our events
       class-id CobolDoKu.CellChangedEventArgs
               inherits type System.EventArgs.

       working-storage section.

      *> Row where the click occurred
      *> Row is a valid COBOL name and this property will be exposed in a case-sensitive manner
       01  _row binary-long public.

      *> Column where the click occurred.
      *> We can't call the underlying COBOL name for this item "column" because that is a reserved word.
      *> However we can give it any valid COBOL name and explicitly define the field name exposed to .NET
      *> with an AS clause.
       01  _colx binary-long public as "Column".

       end class.

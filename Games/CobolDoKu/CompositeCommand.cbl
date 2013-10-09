      ********************************************************************************************************
      *
      * Copyright (C) Micro Focus 2010-2013.
      * All rights reserved.
      *
      *  This sample code is supplied for demonstration purposes only on an "as is" basis and "is for use at
      *  your own risk".
      *
      ********************************************************************************************************

      *> Implements a Composite Command i.e. a command that is made up of other
      *> commands. This is used for the "Smart Play" feature, where it will play
      *> into any cells which can only take a single value. It allows us an easy
      *> mechanism to undo these commands.
       class-id CobolDoKu.CompositeCommand implements type CobolDoKu.ICommand.

       working-storage section.
       01 _commands  list[type CobolDoKu.ICommand].

      *>> <summary>
      *>> Create a new instance of the CompositeCommand class
      *>> </summary>
       method-id New public.
       procedure division.
           
           set _commands to new List[type CobolDoKu.ICommand]()
           goback.

       end method.


      *>> <summary>
      *>> Add a new command to the composite command
      *>> </summary>
       method-id AddCommand public.
       local-storage section.
       procedure division using by value command as type CobolDoKu.ICommand.
           invoke _commands::Add(command)
           goback.
       end method.


      *>> <summary>
      *>> Execute all the commands in the composite commands
      *>> </summary>
       method-id  Execute public.
       procedure division using by value view as type CobolDoKu.SudokuGridView.
           perform varying command as type CobolDoKu.ICommand thru _commands
               invoke command::Execute(view)
           end-perform
           goback.
       end method.

      *>> <summary>
      *>> Undo all the commands in the composite command
      *>> </summary>
       method-id  Undo public.
       procedure division using by value view as type CobolDoKu.SudokuGridView.
      *> execute the methods in reverse order from which they were executed
           perform varying i as binary-long from _commands::Count by -1 until i <= 0
               invoke _commands[i - 1]::Undo(view)
           end-perform
           goback.
       end method.

       end class.

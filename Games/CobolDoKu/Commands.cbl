      ********************************************************************************************************
      *
      * Copyright (C) Micro Focus 2010-2013.
      * All rights reserved.
      *
      *  This sample code is supplied for demonstration purposes only on an "as is" basis and "is for use at
      *  your own risk".
      *
      ********************************************************************************************************


      *> Declares an interface for executing commands. Used for Undo managements.
       interface-id CobolDoKu.ICommand.


       method-id Execute public.
       procedure division using by value view as type CobolDoKu.SudokuGridView.
       end method.

       method-id Undo public.
       procedure division using by value view as type CobolDoKu.SudokuGridView.
       end method.

       end interface.


       class-id. CobolDoKu.ChangeCellCommand implements type CobolDoKu.ICommand.

       working-storage section.
       01  old-value       binary-long.
       01  old-fixed       condition-value.
       01  new-value       binary-long.
       01  rowx            binary-long.
       01  colx            binary-long.

      *>> <summary>
      *>> Creates a new instance of the ChangeCellCommand class
      *>> </summary>
      *>> <param name="board">the sodoku board</param>
      *>> <param name="rowx">the row of the current square</param>
      *>> <param name="colx">the column of the current square</param>
      *>> <param name="new-value">the value to put in the current square</param>
       method-id New public.
       local-storage section.

       procedure division using by value board as type CobolDoKu.SudokuGrid
                                by value rowx as binary-long
                                by value colx as binary-long
                                by value new-value as binary-long.

           set self::rowx to rowx
           set self::colx to colx
           set self::new-value to new-value
      *> invalid value, means the command hasn't been executed yet
           set self::old-value to -1
       end method.

      *>> <summary>
      *>> Execute the ChangeCellCommand
      *>> </summary>
      *>> <param name="view"></param>
       method-id Execute public.
       local-storage section.
       01  cell     type CobolDoKu.SudokuCell.
       01  board    type CobolDoKu.SudokuGrid.

       procedure division using by value view as type CobolDoKu.SudokuGridView.
      *> store the old value
           set board to view::Board
           set cell to board[rowx, colx]

      *> save the old value (so we can undo it)
           set old-value to cell::Value
           set old-fixed to cell::Fixed

      *> update the value
           set cell::Value to new-value
           if new-value = 0
      *> if the cell is cleared, we clear the fixed setting
               set cell::Fixed to false
           else
      *> if template mode, the value is now fixed
               if view::TemplateMode
                   set cell::Fixed to true
               end-if
           end-if
           invoke view::UpdateViewAfterCellChange()
       end method.

      *>> <summary>
      *>> Undo the ChangeCellCommand
      *>> </summary>
      *>> <param name="view"></param>
       method-id Undo public.

       local-storage section.
       01  cell     type CobolDoKu.SudokuCell.
       01  board    type CobolDoKu.SudokuGrid.

       procedure division using by value view as type CobolDoKu.SudokuGridView.
      *> update the selection to what it was when the move was created
           set view::SelectRow to rowx
           set view::SelectCol to colx

           set board to view::Board
           set cell to board[rowx, colx]
      *> update the value
           set cell::Value to old-value
           set cell::Fixed to old-fixed

           invoke view::UpdateViewAfterCellChange()
       end method.

       end class.

      ********************************************************************************************************
      *
      * Copyright (C) Micro Focus 2010-2013.
      * All rights reserved.
      *
      *  This sample code is supplied for demonstration purposes only on an "as is" basis and "is for use at
      *  your own risk".
      *
      ********************************************************************************************************

      *> Delegate for CellChanged events, sent when the user changes the
      *> value of a cell.
       delegate-id CobolDoKu.CellChangeDelegate.

       procedure division using by value sender as object
                                by value e as type CobolDoKu.CellChangedEventArgs.
       end delegate.


      *> Custom control for drawing a Sudoku Grid
       class-id CobolDoKu.SudokuGridView
                                    inherits type System.Windows.Forms.Control.

       working-storage section.
       78  THICK-LINE-WIDTH value 3.       *> width for separating sub-grids
       78  BORDER-WIDTH value 6.           *> width for separating border

       01  template-mode  condition-value property as "TemplateMode"
                               attribute System.ComponentModel.CategoryAttribute("Sudoku")
                               attribute System.ComponentModel.DescriptionAttribute("Template Mode").

       01  show-hints  condition-value value false.

       01  board        type CobolDoKu.SudokuGrid property as "Board" no set.      *> underlying board

      *> An event for informing us when the player has changed a cell (played into it)
      *> The parameters are the row and col of the cell changed. NB: 1-based

       01  cell-changed-event  type CobolDoKu.CellChangeDelegate event public as "CellChanged"
                               attribute System.ComponentModel.CategoryAttribute("Sudoku")
                               attribute System.ComponentModel.DescriptionAttribute("Fires when the player changes a cell").

       01  command-stack  type System.Collections.Generic.Stack[type CobolDoKu.ICommand].

       01  boardrect   type System.Drawing.Rectangle.  *> size of the board
       01  spacingX    binary-long.          *> X spacing for cells
       01  spacingY    binary-long.          *> Y spacing for cells
       01  selectedRow binary-long value 0 property as "SelectRow".    *> currently selected row
       01  selectedCol binary-long value 0 property as "SelectCol".    *> selected column
       01  bigFont      type System.Drawing.Font.         *> font to use for drawing big cells
       01  smallFont    type System.Drawing.Font.         *> small font used for drawing grid hints
       01  errorpen     type System.Drawing.Pen.          *> pen used to draw circles round illegal cells

       01  grid-color   type System.Drawing.Color.        *> color used to draw the grid lines

      *>> <summary>
      *>> Constructs a new instance of the SudokuGridView class
      *>> </summary>
       method-id New public.
       local-storage section.
       procedure division.
           set command-stack to new System.Collections.Generic.Stack[type CobolDoKu.ICommand]()

           *> Allocate the resource we need - pens, etc
           set grid-color to type System.Drawing.Color::Black
           set errorpen to new System.Drawing.Pen(type System.Drawing.Color::Red, 2)
           set bigFont to new System.Drawing.Font("MS Comic Sans", 16, type System.Drawing.FontStyle::Bold)
           set smallFont to new System.Drawing.Font("small fonts", 7, type System.Drawing.FontStyle::Regular)

           invoke self::InitBoard
           invoke self::SetStyle(type System.Windows.Forms.ControlStyles::DoubleBuffer b-or type System.Windows.Forms.ControlStyles::Selectable, true)

           set board to new CobolDoKu.SudokuGrid()
           goback.
       end method.

       method-id OnSizeChanged protected override.
       local-storage section.
      *> don't have to specify BY VALUE here, but do on "OnPaint"
       procedure division using by value e as type System.EventArgs.
           invoke self::InitBoard.
           invoke super::OnSizeChanged(e)
       end method.


       method-id OnPaint protected override.
       procedure division using by value pe as type System.Windows.Forms.PaintEventArgs.
           invoke super::OnPaint(pe)
           invoke self::DrawGrid(pe::Graphics())
       end method.


      *>> <summary>
      *>> Initializes the Sudoku board
      *>> </summary>
       method-id InitBoard private.
       local-storage section.
       01  i           binary-long.
       01  j           binary-long.
       procedure division.
           set boardrect to self::ClientRectangle()
           invoke boardrect::Inflate(0 - BORDER-WIDTH,  0 - BORDER-WIDTH)
           compute spacingX = function integer (boardrect::Width / 9)
           compute spacingY = function integer (boardrect::Height / 9)

           compute boardrect::Height = spacingY * 9
           compute boardrect::Width = spacingX * 9
           invoke boardrect::Inflate(BORDER-WIDTH, BORDER-WIDTH)
       end method.


      *>> <summary>
      *>> Draws the Sudoku board
      *>> </summary>
      *>> <param name="g"></param>
       method-id DrawGrid private.
       local-storage section.
       01  x       binary-long.
       01  y       binary-long.
       01  cell        type CobolDoKu.SudokuCell.
       01  text-color  type System.Drawing.Brush.
       01  formatCenter type System.Drawing.StringFormat.
       01  formatHint  type System.Drawing.StringFormat.
       01  cell-rectf  type System.Drawing.RectangleF.
       01  hint-string string.
       01  pen-border  type System.Drawing.Pen.         *> pen for drawing border of the grid
       01  thickpen    type System.Drawing.Pen.         *> thick pen for drawing 3 x 3 sub divisions
       01  thinpen     type System.Drawing.Pen.
       procedure division using by value g as type System.Drawing.Graphics.
           set pen-border to new System.Drawing.Pen(grid-color, BORDER-WIDTH)
           set thickpen to new System.Drawing.Pen(grid-color, THICK-LINE-WIDTH)
           set thinpen to new System.Drawing.Pen(grid-color)

           if selectedRow > 0 and selectedCol > 0
               *> color the background of the selected cell
              invoke g::FillRectangle(type System.Drawing.Brushes::DarkGray,
                                        self::GetCellRectangle(selectedRow, selectedCol))
           end-if

           invoke g::DrawRectangle(pen-border, boardrect)

           *> draw grid lines.
           perform varying i as binary-long from 1 by 1 until i > 8
               compute x = boardrect::Left + i * spacingX + BORDER-WIDTH
               compute y = boardrect::Top + i * spacingY + BORDER-WIDTH
               if function mod(i, 3) = 0
                   invoke g::DrawLine(thickpen, boardrect::Left, y, boardrect::Right, y)
                   invoke g::DrawLine(thickpen, x, boardrect::Top, x, boardrect::Bottom)
               else
                   invoke g::DrawLine(thinpen, boardrect::Left, y, boardrect::Right, y)
                   invoke g::DrawLine(thinpen, x, boardrect::Top, x, boardrect::Bottom)
               end-if
           end-perform

           *> Draw the cells
           *> format for drawing cells
           set formatCenter to new System.Drawing.StringFormat()
           set formatCenter::LineAlignment to type System.Drawing.StringAlignment::Center
           set formatCenter::Alignment to type System.Drawing.StringAlignment::Center

           set formatHint to new System.Drawing.StringFormat()

           perform varying colx as binary-long from 1 by 1 until colx > 9
                       after rowx as binary-long from 1 by 1 until rowx > 9
               set cell to board[rowx, colx]

               if cell::Value not = 0
                   evaluate true
                   when cell::Fixed
                       set text-color to type System.Drawing.Brushes::Black
                   when other
                       set text-color to type System.Drawing.Brushes::Red
                   end-evaluate
                   set cell-rectf to self::GetCellRectangleF(rowx, colx)
                   invoke g::DrawString(cell::Value::ToString(),
                               bigFont,
                               text-color,
                               cell-rectf,
                               formatCenter)

                   *> if the cell isn't legal draw a circle around it
                   if not cell::Legal
                       invoke cell-rectf::Inflate(-3, -3)
                       invoke g::DrawEllipse(errorpen, self::GetCellRectangleF(rowx, colx))
                   end-if
               else
                   if show-hints
                          set hint-string to cell::GetValidValues()
                       *> If there's no comma in the string, then there's only 1 value, so we can
                       *> just draw the number big - but still in a darker color to show the user there
                       *> is just one possibility
                       evaluate true
                       when hint-string::Length = 0   *> cell has no hints - this means there is no possible value you can place there
                           invoke g::DrawString("?",
                                           bigFont,
                                           type System.Drawing.Brushes::DarkGray
                                           self::GetCellRectangleF(rowx, colx),
                                           formatCenter)

                       when hint-string::Contains(",")
                           invoke g::DrawString(hint-string,
                                           smallFont,
                                           type System.Drawing.Brushes::Blue,
                                           self::GetCellRectangleF(rowx, colx),
                                           formatHint)
                       when other
                           invoke g::DrawString(hint-string,
                                           bigFont,
                                           type System.Drawing.Brushes::Blue,
                                           self::GetCellRectangleF(rowx, colx),
                                           formatCenter)

                          end-evaluate
                       end-if
           end-perform

           *> dispose of drawing objects
           invoke pen-border::Dispose()
           invoke thickpen::Dispose()

       end method.

       method-id OnMouseDown protected override.
       local-storage section.
       01  rowx        binary-long.
       01  colx        binary-long.
       procedure division using by value e as type System.Windows.Forms.MouseEventArgs.
           compute colx = (e::Location::X / spacingX) + 1
           compute rowx = (e::Location::Y / spacingY) + 1
           if (colx >= 1 and <= 9) and (rowx >= 1 and <= 9)
               move rowx to selectedRow
               move colx to selectedCol
               invoke self::Invalidate()     *> force redraw
           end-if
           invoke super::OnMouseDown(e)
           invoke self::Focus()
       end method.

      *>> <summary>
      *>> This method always returns true. All keys are valid input keys
      *>> </summary>
      *>> <param name="keys"></param>
      *>> <returns></returns>
       method-id IsInputKey protected override.
       local-storage section.
       procedure division using by value keys as type System.Windows.Forms.Keys
                   returning valid as condition-value.
           set valid to true
       end method.


       method-id OnKeyPress protected override.
       local-storage section.
       01  keypress         character.
       procedure division using by value e as type System.Windows.Forms.KeyPressEventArgs.

           if selectedRow = 0 or selectedCol = 0
      *> no cell selected - nothing to do
               goback
           end-if

           set keypress to e::KeyChar()
           evaluate true
           when keypress >= "1" and <= "9"
               invoke self::PlayInCurrentCell(keypress - 48)
           when keypress = space
               invoke self::PlayInCurrentCell(0)
           end-evaluate
           *> call base class
           invoke super::OnKeyPress(e)
       end method.


      *>> <summary>
      *>> Helper method to update the current cell.
      *>> </summary>
      *>> <param name="new-value">the new value of the cell</param>
      *>> <returns>if the operation succeeded</returns>
       method-id PlayInCurrentCell private.
       local-storage section.
       01  cell     type CobolDoKu.SudokuCell.
       01  play     type CobolDoKu.ChangeCellCommand.
       procedure division using by value new-value as binary-long
                           returning return-value as condition-value.
           set cell to board[selectedRow, selectedCol]

           *> if we're not in template mode, then don't allow fixed values to be changed
           if cell::Fixed and not template-mode
               invoke type System.Media.SystemSounds::Exclamation::Play()    *> play a standard sound
               set return-value to false
               goback
           end-if

           *> Beyond here we know the command is valid. We create the object for the "PLAY" and Execute it.
           set play to new CobolDoKu.ChangeCellCommand(board, selectedRow, selectedCol, new-value)
           invoke self::ExecuteCommand(play)
       end method.


      *>> <summary>
      *>> Execute the specified command and update the board.
      *>> </summary>
      *>> <param name="command">the command to execute</param>
       method-id ExecuteCommand public.
       local-storage section.
       procedure division using by value command as type CobolDoKu.ICommand.
           invoke command-stack::Push(command)
           invoke command::Execute(self)
           invoke self::Redraw()
           goback.
       end method.

      *>> <summary>
      *>> Play into all obvious cells.
      *>> </summary>
       method-id SmartPlay public.
       local-storage section.
       01  command      type CobolDoKu.CompositeCommand.
       01  fg-change    condition-value.          *> detects how many cells we play into
       01  cell         type CobolDoKu.SudokuCell.
       01  newvalue    binary-long.
       01  newcommand   type CobolDoKu.ICommand.
       procedure division.
           set command to new CobolDoKu.CompositeCommand()

           set fg-change to true
           perform until not fg-change
               set fg-change to false
               perform varying colx as binary-long from 1 by 1 until colx > 9
                       after rowx as binary-long from 1 by 1 until rowx > 9
                   set cell to board[rowx, colx]
                   if cell::Value = 0
                       set newvalue to cell::GetSingleValidValue()
                       if newvalue not = 0
                           set fg-change to true
                           *> create a command
                           set newcommand to new CobolDoKu.ChangeCellCommand(board, rowx, colx, newvalue)

                           *> We actually play the command. This forces a redraw, and the cells to
                           *> be updated. So we never execute the composite command separately.
                           invoke newcommand::Execute(self)
                           invoke type System.Threading.Thread::Sleep(100)     *> delay 1/10th second so user sees animation
                           invoke command::AddCommand(newcommand)
                       end-if
                   end-if
               end-perform
           end-perform
           invoke command-stack::Push(command)
           invoke self::Redraw
           goback.
       end method.

       method-id OnKeyDown override protected.
       local-storage section.

       procedure division using by value e as type System.Windows.Forms.KeyEventArgs.
           evaluate e::KeyCode
           when type System.Windows.Forms.Keys::Up
               if selectedRow > 1
                   subtract 1 from selectedRow
                   invoke self::Redraw
               end-if
           when type System.Windows.Forms.Keys::Down
               if selectedRow < 9
                   add 1 to selectedRow
                   invoke self::Redraw
               end-if
           when type System.Windows.Forms.Keys::Left
               if selectedCol > 1
                   subtract 1 from selectedCol
                   invoke self::Redraw
               end-if
           when type System.Windows.Forms.Keys::Right
               if selectedCol < 9
                   add 1 to selectedCol
                   invoke self::Redraw
               end-if
           when type System.Windows.Forms.Keys::Back
              invoke self::Undo()
           end-evaluate
           invoke super::OnKeyDown(e)
       end method.

      *>> <summary>
      *>> Get the rectangle for the specifies cell
      *>> </summary>
      *>> <param name="rowx">the row of the rectangle cell</param>
      *>> <param name="colx">the column of the rectangle cell</param>
      *>> <returns>the rectangle at the specified cell</returns>
       method-id GetCellRectangleF public.
       local-storage section.
       01  rect type System.Drawing.Rectangle.
       procedure division using by value rowx as binary-long
                                by value colx as binary-long
                                returning rectf as type System.Drawing.RectangleF.

           set rect to self::GetCellRectangle(rowx, colx)
           set rectf to new System.Drawing.RectangleF(rect::Left, rect::Top, rect::Width, rect::Height)

           goback.
       end method.

       method-id GetCellRectangle public.
       local-storage section.
       procedure division using by value rowx as binary-long
                                by value colx as binary-long
                                returning rect as type System.Drawing.Rectangle.

           set rect to new System.Drawing.Rectangle(boardRect::Left + (colx - 1)* spacingX + BORDER-WIDTH,
                                                    boardRect::Top + (rowx - 1) * spacingY + BORDER-WIDTH,
                                                    spacingX,
                                                    spacingY)
           goback.
       end method.

      *>> <summary>
      *>> Load the Sudoku board from the specified file
      *>> </summary>
      *>> <param name="filename">the file to load the Sudoku board from</param>
       method-id Load public.
       procedure division using by value filename as string.
           invoke command-stack::Clear() *> clearing the board clears the undo stack.
           invoke board::Load(filename)
           invoke self::Redraw()
           goback.
       end method.

      *>> <summary>
      *>> Save the current board to the specified file
      *>> </summary>
      *>> <param name="filename">the file to save the Sudoku board to</param>
       method-id Save public.
       procedure division using by value filename as string.
           invoke board::Save(filename)
           goback.
       end method.


      *>> <summary>
      *>> Helper method to re-draw the grid. Currently just does an invalidate, but we could implement
      *>> something more efficient and avoid the potential flicker
      *>> </summary>
       method-id Redraw private.
       local-storage section.

       procedure division.
           invoke self::Refresh()
           goback.
       end method.

      *> Gets whether hints are shown on the board
       property-id ShowHints condition-value
           attribute System.ComponentModel.CategoryAttribute("Sudoku")
           attribute System.ComponentModel.DescriptionAttribute("Shows possible values empty cells could take").
       getter.
            set property-value to show-hints
       setter.
           set show-hints to property-value
           invoke self::Redraw
       end property.

      *> Read-only property to determine if there are unfilled cells on the board
       Property-id CellsRemaining binary-long
               attribute System.ComponentModel.CategoryAttribute("Sudoku")
               attribute System.ComponentModel.DescriptionAttribute("Count on unfilled cells").
       Getter.
            set property-value to board::CellsRemaining
       end property.


      *> Read-only property for determining if the grid is valid.
       Property-id IsValid condition-value
               attribute System.ComponentModel.CategoryAttribute("Sudoku")
               attribute System.ComponentModel.DescriptionAttribute("True if the solution is currently valid").
       Getter.
            set property-value to board::IsValid
       end property.


      *> Read-only property for determining if the puzzle is solved.
       Property-id IsSolved condition-value
               attribute System.ComponentModel.CategoryAttribute("Sudoku")
               attribute System.ComponentModel.DescriptionAttribute("True if the solution is complete").
       Getter.
            set property-value to board::IsValid and (board::CellsRemaining = 0)
       end property.


      *>> <summary>
      *>> Clears the grid. If not in template mode, only clears the non-fixed entries.
      *>> </summary>
       method-id Clear public.
       local-storage section.
       01  cell         type CobolDoKu.SudokuCell.
       procedure division.
           invoke command-stack::Clear() *> clearing the board clears the undo stack
           invoke board::Clear(template-mode)
           invoke self::Redraw()
       end method.

      *>> <summary>
      *>> Undo the last command
      *>> </summary>
       method-id Undo public.
       local-storage section.
       01  command          type CobolDoKu.ICommand.
       procedure division.
           if command-stack::Count = 0
               invoke type System.Media.SystemSounds::Exclamation::Play()  *> no commands to undo
           else
               set command to command-stack::Pop()
               invoke command::Undo(self)
           end-if
           goback.
       end method.


      *>> <summary>
      *>> After a cell has been changed, redraws, creates events, etc.
      *>> </summary>
       method-id UpdateViewAfterCellChange internal.
       local-storage section.
       01  e        type CobolDoKu.CellChangedEventArgs.
       procedure division.
           invoke board::UpdateAllHints()

           *> re-draw and send events - really this should be done in the Execute
           invoke self::Redraw()
           *> fire event to anyone listening - typically the form
           if cell-changed-event <> null
               set e to new CobolDoKu.CellChangedEventArgs()
               set e::_row to selectedRow
               set e::Column to selectedCol
               invoke cell-changed-event::Invoke(self, e)
           end-if

           goback.
       end method.

       end class.

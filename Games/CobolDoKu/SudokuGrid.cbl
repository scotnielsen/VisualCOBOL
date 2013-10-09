      ********************************************************************************************************
      *
      * Copyright (C) Micro Focus 2010-2013.
      * All rights reserved.
      *
      *  This sample code is supplied for demonstration purposes only on an "as is" basis and "is for use at
      *  your own risk".
      *
      ********************************************************************************************************

       class-id CobolDoKu.SudokuGrid.

       working-storage section.
      *> the cells
       01  _cells                      type CobolDoKu.SudokuCell occurs 9 9.
      *> number of empty cells
       01  _emptyCellCount             binary-long property as "CellsRemaining" with no set.
      *> indicates if the solution so far is valid
       01  _isValid                    condition-value property as "IsValid" with no set.

      *>> <summary>
      *>> Construct a new instance of the SudokuGrid class
      *>> </summary>
       method-id New public.
       procedure division.
           perform varying i as binary-long from 1 by 1 until i > 9
                   after j as binary-long from 1 by 1 until j > 9
               set _cells(j, i) to new CobolDoKu.SudokuCell()
           end-perform
      *> just sets the masks (very inefficiently)
           invoke self::UpdateAllHints()
       end method.


      *>> <summary>
      *>> Load a predefined Sudoku grid from file
      *>> </summary>
      *>> <param name="filename">the name of the file to load the Sudoku grid from</param>
       method-id Load.
       local-storage section.
       01  xdoc        type System.Xml.XmlDocument.
       01  nodes       type System.Xml.XmlNodeList.
       procedure division using by value filename as string.
           set xdoc to new System.Xml.XmlDocument()
           try
      *> clear the existing grid - need because we only read nodes with real numbers and otherwise
               invoke self::Clear(true)

               invoke xdoc::Load(filename)
      *> read in the fixed hint nodes
               set nodes to xdoc::SelectNodes("//Hints/Rows/*")
               invoke self::ParseHintNodes(nodes, true)
      *> read in the player's guesses
               set nodes to xdoc::SelectNodes("//Guesses/Rows/*")
               invoke self::ParseHintNodes(nodes, false)
      *> update all the hints
               invoke self::UpdateAllHints()
           catch
               continue
           end-try

           goback.
       end method.


      *>> <summary>
      *>> Save the current Sudoku grid to file
      *>> </summary>
      *>> <param name="filename">the name of the file to save the current Sudoku grid to</param>
       method-id Save public.
       local-storage section.
       01  xdoc          type System.Xml.XmlDocument.
       01  hints-node    type System.Xml.XmlNode.
       01  hint-rows     type System.Xml.XmlNode.
       01  guess-node    type System.Xml.XmlNode.
       01  guess-rows    type System.Xml.XmlNode.
       01  sudoku-node   type System.Xml.XmlNode.
       01  hint-row      type System.Xml.XmlNode.
       01  guess-row     type System.Xml.XmlNode.
       01  gridcell      type CobolDoKu.SudokuCell.
       01  hint-sb       type System.Text.StringBuilder.
       01  guess-sb      type System.Text.StringBuilder.
       01  guess-value   string.
       01  hint-value    string.

       procedure division using by value filename as string.

           set xdoc to new System.Xml.XmlDocument()

           set hint-rows to xdoc::CreateElement("Rows")
           set guess-rows to xdoc::CreateElement("Rows")
           set hints-node to xdoc::CreateElement("Hints")
           set guess-node to xdoc::CreateElement("Guesses")
           set sudoku-node to xdoc::CreateElement("Sudoku")
           invoke sudoku-node::AppendChild(hints-node)
           invoke hints-node::AppendChild(hint-rows)
           invoke guess-node::AppendChild(guess-rows)
           invoke sudoku-node::AppendChild(hints-node)
           invoke sudoku-node::AppendChild(guess-node)
           invoke xdoc::AppendChild(sudoku-node)

           perform varying rowx as binary-long from 1 by 1 until rowx > 9
      *> create new nodes for hints and guesses !
               set hint-row to xdoc::CreateElement("Row")
               set guess-row to xdoc::CreateElement("Row")
               invoke hint-rows::AppendChild(hint-row)
               invoke guess-rows::AppendChild(guess-row)
      *> string buffer for building up answers
               set hint-sb to new System.Text.StringBuilder()
               set guess-sb to new System.Text.StringBuilder()

               perform varying colx as binary-long from 1 by 1 until colx > 9
                   set gridcell to _cells(rowx, colx)
                   set hint-value guess-value to "-"
                   set hint-value, guess-value to "-"

                   if gridcell::Value not = 0
      *> cell is a template/fixed value
                       if gridcell::Fixed
                           set hint-value to gridcell::Value::ToString()
                       else
                           set guess-value to gridcell::Value::ToString()
                       end-if
                   end-if
                   invoke hint-sb::Append(hint-value)
                   invoke guess-sb::Append(guess-value)
                   if colx < 9
                       invoke hint-sb::Append("," as character)
                       invoke guess-sb::Append("," as character)
                   end-if
               end-perform
               set hint-row::InnerText to hint-sb::ToString()
               set guess-row::InnerText to guess-sb::ToString()
           end-perform

      *> now save the document to disk.
           invoke xdoc::Save(filename)
       end method.

      *>> <summary>
      *>> Parse and set the hints from the hint nodes
      *>> </summary>
      *>> <param name="nodelist">the hint nodes</param>
      *>> <param name="isFixed"></param>
       method-id ParseHintNodes private.
       local-storage section.
       01  rowx        binary-long.
       01  row-values  string occurs any.
       01  row-text    string.
       01  cell-value  binary-long.
       01  cell        type CobolDoKu.SudokuCell.
       procedure division using by value nodelist as type System.Xml.XmlNodeList
                                by value isFixed as condition-value.
           if nodelist = null
               goback
           end-if
           set rowx to 1

      *> reading a list of <row> elements.
      *> split the text using the Split method in the string class
      *> don't do any error check if not exact 9 x 9 board (we should)
            perform varying node as type System.Xml.XmlNode thru nodelist
                set row-text to node::InnerText()
                set row-values to row-text::Split(",")

                perform varying colx as binary-long from 1 by 1 until colx > row-values::Length or colx > 9
                   set cell to self[rowx, colx]
                   if binary-long::TryParse(row-values(colx), cell-value)
                       set cell::Value to cell-value
                       if isFixed
      *> known value, user can't type here
                           set cell::Fixed to true
                       end-if
                   end-if
                end-perform
                add 1 to rowx
           end-perform

       end method.

      *> Returns the Sudoku cell at the specified row and column
       indexer-id type CobolDoKu.SudokuCell.
       procedure division using by value rowx as binary-long
                                by value colx as binary-long.
       getter.                                
            set property-value to _cells(rowx, colx)
       end indexer.


      *>> <summary>
      *>> Clear the grid.
      *>> </summary>
      *>> <param name="clear-all">If clear-all is false, only the non-fixed cells are cleared</param>
       method-id Clear public.
       procedure division using clear-all as condition-value.
           perform varying cell as type CobolDoKu.SudokuCell thru _cells
               if clear-all or not cell::Fixed
                   set cell::Value to 0
               end-if
               if clear-all
                   set cell::Fixed to false
               end-if
           end-perform
      *> just sets the masks (very inefficiently)
           invoke self::UpdateAllHints()
       end method.

      *>> <summary>
      *>> UpdateValidValues for a cell. This is stored as bit settings bit1 = 1, bit2 = 2, etc.
      *>> </summary>
      *>> <param name="rowx">the cell row</param>
      *>> <param name="colx">the cell column</param>
      *>> <returns>the valid values for the cell as a bit mask</returns>
       method-id UpdateCellHints private.
       local-storage section.
       01  cellval binary-long.
       01  subgrid-row binary-long.
       01  subgrid-col binary-long.

       procedure division using by value rowx as binary-long
                                by value colx as binary-long
                          returning mask as binary-long.
      *> set all mask bits to 1
           compute mask = (2**9 - 1) * 2
      *> go horizontal and vertical
           perform varying i as binary-long from 1 by 1 until i > 9
      *> check the row - means we never evaluate rowx, colx
               if i <> colx
                   set cellval to _cells(rowx, i)::Value
                   invoke type CobolDoKu.SudokuCell::UpdateMask(mask, cellval)
               end-if
      *> check the column - means we never evaluate rowx, colx
               if i <> rowx
                   set cellval to _cells(i, colx)::Value
                   invoke type CobolDoKu.SudokuCell::UpdateMask(mask, cellval)
               end-if
           end-perform

      *> Evaluate the subgrid (3 x 3 square containing the numbers)
           compute subgrid-row = (rowx - 1) / 3
           multiply 3 by subgrid-row
           compute subgrid-col = (colx - 1) / 3
           multiply 3 by subgrid-col

           perform varying j as binary-long from 1 by 1 until j > 3
                   after i as binary-long from 1 by 1 until i > 3
               if (subgrid-row + i) <> rowx or (subgrid-col + j) <> colx
                   set cellval to _cells(subgrid-row + i, subgrid-col + j)::Value
                   invoke type CobolDoKu.SudokuCell::UpdateMask(mask, cellval)
               end-if
           end-perform

           set _cells(rowx, colx)::Mask to mask
       end method.


      *>> <summary>
      *>> Updates the status of the grid after changes to the cells. Computes the valid cells.
      *>> </summary>
       method-id UpdateAllHints public.
       local-storage section.
       01  mask        binary-long.
       01  cell-value  binary-long.
       procedure division.
           set _isValid to true
           set _emptyCellCount to 0
           perform varying colx as binary-long from 1 by 1 until colx > 9
                   after rowx as binary-long from 1 by 1 until rowx > 9
      *> mark as legal until we know otherwise
               set _cells(rowx, colx)::Legal to true
               set mask to self::UpdateCellHints(rowx, colx)
               set cell-value to _cells(rowx, colx)::Value
               if cell-value = 0
                   add 1 to _emptyCellCount
      *> mask we calculated for this cell must leave only 1 value for the solution to be valid
               else
                   if mask b-and (2 ** cell-value) = 0
                       set _cells(rowx, colx)::Legal to false
                       set _isValid to false
                   end-if
               end-if
           end-perform
           goback.
       end method.

       end class.

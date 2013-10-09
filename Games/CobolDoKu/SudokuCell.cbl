      ********************************************************************************************************
      *
      * Copyright (C) Micro Focus 2010-2013.
      * All rights reserved.
      *
      *  This sample code is supplied for demonstration purposes only on an "as is" basis and "is for use at
      *  your own risk".
      *
      ********************************************************************************************************

       class-id CobolDoKu.SudokuCell.

       working-storage section.

      *> value in the cell
       01  _val     binary-long property as "Value".
      *> indicates value is fixed
       01  _known   condition-value property as "Fixed".
       01  _mask    binary-long property as "Mask" with no get.
      *> indicate the cell is legal
       01  _legal   condition-value property as "Legal".

      *>> <summary>
      *>> Update the cell mask, which represents the numbers in the cell
      *>> </summary>
      *>> <param name="mask">the resulting mask</param>
      *>> <param name="cell-value"></param>
       method-id UpdateMask public static.
       local-storage section.
       procedure division using by reference maskx as binary-long
                                by value cell-value as binary-long.
           if cell-value not = 0
               compute maskx = maskx b-and (b-not (2 ** cell-value))
           end-if
       end method.


      *>> <summary>
      *>> Get the valid values for the cell as
      *>> </summary>
      *>> <returns>the string with the valid values separated by comma</returns>
       method-id GetValidValues public.

       local-storage section.
       01  temp    binary-long.
       01  sb      type System.Text.StringBuilder.
       procedure division returning return-value as string.
           set sb to new System.Text.StringBuilder()
           set temp to _mask
           perform varying i as binary-long from 1 by 1 until temp = 0
      *> bit2 actually represents 1 !
               divide 2 into temp
               if (temp b-and 1) not = 0
                   if sb::Length not = 0
                       invoke sb::Append("," as character)
                   end-if
                   invoke sb::Append(i::ToString())
               end-if
           end-perform
           set return-value to sb::ToString()
           goback.
       end method.


      *>> <summary>
      *>> If a cell has a single valid value, then the return it. Otherwise, return 0.
      *>> </summary>
      *>> <returns>the single valid value</returns>
       method-id GetSingleValidValue public.
       local-storage section.
       01  temp    binary-long.
       procedure division returning return-value as binary-long.
           set return-value to 0
           set temp to _mask
           perform varying i as binary-long from 1 by 1 until temp = 0
      *> bit2 actually represents 1 !
               divide 2 into temp
               if (temp b-and 1) not = 0
      *> if return value is non-zero, we've already hit a valid value
                   if return-value not = 0
      *> return 0 to indicate mulitiple values
                       set return-value to 0
                       exit perform
                   else
      *> sets the first value
                       set return-value to i
                   end-if
               end-if
           end-perform
           goback.
       end method.

       end class.

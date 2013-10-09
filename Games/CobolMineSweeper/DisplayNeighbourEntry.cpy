      ********************************************************************************************************
      *
      *  Copyright (C) Micro Focus 2010-2013. All rights reserved.
      *
      *  This sample code is supplied for demonstration purposes only on an "as is" basis and "is for use at
      *  your own risk".
      *
      ********************************************************************************************************

       entry "display-neighbourhoods" using by value l-row by value l-column.
         perform varying ls-counter from -1 by 1 until ls-counter > 1
             perform varying ls-counter2 from -1 by 1 until ls-counter2 > 1

                 if l-row + ls-counter > 0 and l-row + ls-counter <= field-length and
                    l-column + ls-counter2 > 0 and l-column + ls-counter2 <= field-width

                     if not cell-type of cells(l-row + ls-counter, l-column + ls-counter2) = CELL-TYPE-BOMB
                        and cell-state of cells(l-row + ls-counter, l-column + ls-counter2) = STATE-COVERED

                         compute current-row = l-row + ls-counter
                         compute current-column = l-column + ls-counter2
                         move cells(current-row, current-column) to current-cell

                         perform display-cell-value

                         if cell-type of current-cell = CELL-TYPE-EMPTY
                             call "display-neighbourhoods" using by value current-row by value current-column
                         end-if
                     end-if
                 end-if

             end-perform
         end-perform
         goback.

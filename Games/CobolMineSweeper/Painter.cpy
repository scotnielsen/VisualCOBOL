      ********************************************************************************************************
      *
      *  Copyright (C) Micro Focus 2010-2013. All rights reserved.
      *
      *  This sample code is supplied for demonstration purposes only on an "as is" basis and "is for use at
      *  your own risk".
      *
      ********************************************************************************************************

      *> Init draw characters
       init-draw-characters section.
         move 0 to chars2-function-code
         call "CBL_GET_SCR_LINE_DRAW" using
                         chars2-function-code
                         chars2-parameter-block-0
       .

      *>Clears the content of the panel
       clear-screen section.
         call "CBL_CLEAR_SCR" using ws-character ws-attribute
         call "CBL_GET_SCR_SIZE" using screen-rows screen-columns
       .

      *>Draws the content of the panel.
       draw-content-panel section.

       multiply num-cells-vert by cell-height giving num-rows
       multiply num-cells-horiz by cell-width giving num-columns

       set offset-row to 4

       compute offset-column = (screen-columns - num-columns) / 2

      *> draw the border
       call "draw-horizontal-line" using by value offset-row by value offset-column by value num-columns
       call "draw-char" using by value line-draw-character(17) offset-row offset-column

       call "draw-horizontal-line" using by value offset-row + num-rows by value offset-column by value num-columns
       call "draw-char" using by value line-draw-character(65) offset-row + num-rows offset-column

       call "draw-vertical-line" using by value offset-row by value offset-column by value num-rows
       call "draw-char" using by value line-draw-character(20) offset-row offset-column + num-columns

       call "draw-vertical-line" using by value offset-row by value offset-column + num-columns by value num-rows
       call "draw-char" using by value line-draw-character(68) offset-row + num-rows offset-column + num-columns

      *> Draw the cells
       perform varying ws-counter from 1 by 1 until ws-counter = num-cells-horiz
          multiply cell-width by ws-counter giving ws-temp-column
          add offset-column to ws-temp-column
          call "draw-vertical-line" using by value offset-row by value ws-temp-column by value num-rows
          call "draw-char" using by value line-draw-character(21) offset-row ws-temp-column
          call "draw-char" using by value line-draw-character(69) offset-row + num-rows ws-temp-column
       end-perform

       perform varying ws-counter from 1 by 1 until ws-counter = num-cells-vert
          multiply cell-height by ws-counter giving ws-temp-row
          add offset-row to ws-temp-row
          call "draw-horizontal-line" using by value ws-temp-row offset-column num-columns
          call "draw-char" using by value line-draw-character(84) ws-temp-row offset-column + num-columns
          call "draw-char" using by value line-draw-character(81) ws-temp-row offset-column

          perform varying ws-counter2 from 1 by 1 until ws-counter2 = num-cells-horiz
            multiply cell-width by ws-counter2 giving ws-temp-column
            add offset-column to ws-temp-column
            call "draw-char" using by value line-draw-character(85) ws-temp-row ws-temp-column
          end-perform

       end-perform.

      *>Draws the content of the panel.
       draw-menu-selection section.
          display "Choose difficulty level [1-3]:" line 5 column 20
          display "1. Beginner" line 6 column 22
          display "2. Advanced" line 7 column 22
          display "3. Expert"   line 8 column 22
          accept ws-temp-level line 5 column 52
          move ws-temp-level to ws-level
          perform clear-screen
       .

       exit-section section.
         exit
       .

      *> Draw horizontal line
      *> Input parameters:
      *>    line-row - row where the line has to be drawn
      *>    line-column - column where the line has to be drawn
      *>    line-len - the len of the line
       entry "draw-horizontal-line" using
                                       by value line-row
                                       by value line-column
                                       by value line-len

        perform varying ls-counter from 1 by 1 until ls-counter = line-len
            string line-draw-character(5) character-buffer into character-buffer
        end-perform

        display character-buffer(1:line-len) line line-row column line-column
        goback
       .

      *> Draw vertical line
      *> Input parameters:
      *>    line-row - row where the line has to be drawn
      *>    line-column - column where the line has to be drawn
      *>    line-len - the len of the line
       entry "draw-vertical-line" using
                                       by value line-row
                                       by value line-column
                                       by value line-len

         perform varying ls-counter from 1 by 1 until ls-counter = line-len
            display line-draw-character(80) line line-row + ls-counter column line-column
         end-perform
         goback
       .

      *> Draw char
      *> Input parameters:
      *>    chr - the char has to be drawn
      *>    char-row - the row where the char has to be drawn
      *>    char-column - the column where the char has to be drawn
       entry "draw-char" using
                              by value chr
                              by value char-row
                              by value char-column
         display chr line char-row column char-column
         goback.

       entry "get-cell" using
                            by reference l-row
                            by reference l-column
                            by reference l-cell
          move l-row to ws-temp-row
          subtract offset-row from ws-temp-row
          divide ws-temp-row by cell-height giving ws-temp-row remainder ws-temp
          add 1 to ws-temp-row

          move l-column to ws-temp-column
          subtract offset-column from ws-temp-column
          divide ws-temp-column by cell-width giving ws-temp-column remainder ws-temp
      *> Add 1 to the column to handle corner cases
          add 1 to ws-temp-column

          move ws-temp-row to l-row
          move ws-temp-column to l-column
          if ws-temp-row > 0 and ws-temp-row <= field-length
             and ws-temp-column > 0 and ws-temp-column <= field-width

               move cells(ws-temp-row, ws-temp-column) to l-cell
          else
               set is-valid of l-cell to CELL-INVALID
          end-if

       goback.

       entry "calculate-middle-column" using by reference mid-column
                                             by value text-len
          compute mid-column =  offset-column + (field-width * cell-width) / 2 - (text-len + 1) / 2
       goback.

       restart-game section.
          compute reset-game-row =  offset-row + field-length * cell-height + 1
          call "calculate-middle-column" using by reference reset-game-column by value 33
          display "Do you want to play again? [Y/N]:" line reset-game-row column reset-game-column
          accept ws-restart-game line reset-game-row column reset-game-column + 33
          if ws-restart-game = "Y" or ws-restart-game = "y"
              perform reset-game
          else
              stop run
          end-if
       .

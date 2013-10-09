      ********************************************************************************************************
      *
      * Copyright (C) Micro Focus 2010-2013.
      * All rights reserved.
      *
      *  This sample code is supplied for demonstration purposes only on an "as is" basis and "is for use at
      *  your own risk".
      *
      ********************************************************************************************************

       *> Important: In order for the grid to be displayed correctly, please
       *> change the font of the console to 'Lucida Console'.
       program-id. Minesweeper as "Minesweeper".

       environment division.
       special-names.
           crt status is key-status.

       working-storage section.
       01 key-status.
           03 key-type           pic x.
           03 key-code-1         pic 9(2) comp-x value 0.
           03 key-code-2         pic 9(2) comp-x.

       01 mouse-handle           pic x(4) value spaces.
       01 mouse-buttons             pic x(2) comp-x.

       01 mouse-pos.
         03 mpos-row             pic x(2) comp-x.
         03 mpos-col             pic x(2) comp-x.

       01 event-data.
         03 event-type           pic x(2) comp-x.
         03 event-time           pic x(4) comp-x.
         03 event-row            pic x(2) comp-x.
         03 event-col            pic x(2) comp-x.

       copy "PainterWorkingStorage.cpy".
       copy "FieldMap.cpy".

       01 current-cell           cell.
       01 current-row            pic 9(2) comp.
       01 current-column         pic 9(2) comp.
       78 B_TRUE                 value 1.
       78 B_FALSE                value 0.
       01 GAME-IS-OVER           pic 9 value B_FALSE.

       01 ws-cell-center-row               pic 9(2) comp.
       01 ws-cell-center-column            pic 9(2) comp.

       77 KEYBOARD-CHARACTER PIC X(1) VALUE SPACE.

       01 FIELD-IS-CLEAR         pic 9 value B_FALSE.
       01 disp-row               pic 9(2) comp.
       01 disp-column            pic 9(2) comp.


       local-storage section.
       copy "PainterLocalStorage.cpy".

       linkage section.
       copy "PainterLinkageStorage.cpy".

       procedure division.

       perform init-mouse
       perform init-draw-characters
       perform start-game
       perform TERMINATE-MOUSE
       goback.

       start-game.
       perform clear-screen
       set ws-level to 0
       perform draw-menu-selection until ws-level > 0 and ws-level < 4

       call "ConfigReader" using ws-level mine-field
       set num-cells-horiz to field-length
       set num-cells-vert to field-width

       perform clear-screen
       perform draw-content-panel
       perform handle-mouse-event until 0 <> 0
       .

       init-mouse.
         call "CBL_INIT_MOUSE" using by reference mouse-handle mouse-buttons
         call "CBL_SHOW_MOUSE" using mouse-handle
       .

       TERMINATE-MOUSE.

      *> This function ends mouse support, and releases any
      *> system resources that were committed for mouse
      *> handling.

      *> After using this function, you must initialize the
      *> mouse (cbl_init_mouse) before using any other mouse
      *> function.

       CALL "CBL_TERM_MOUSE" USING
       BY REFERENCE MOUSE-HANDLE
       END-CALL.
      *> This CBL function updates RETURN-CODE or STATUS-CODE
      *> (if specified). A non-zero return indicates failure.


      *-----------------------------------------------------------------
       HIDE-MOUSE.

      *> Supply the mouse-handle returned from cbl_init_mouse.

       CALL "CBL_HIDE_MOUSE" USING
       BY REFERENCE MOUSE-HANDLE
       END-CALL.
      *> This CBL function updates RETURN-CODE or STATUS-CODE
      *> (if specified). A non-zero return indicates failure.

       handle-mouse-event.
         call "CBL_READ_MOUSE_EVENT" using mouse-handle event-data 0

         if return-code = zero
           if event-type = 2
               perform show-cell
               perform check-game-finished
           end-if
           if event-type = 4
               perform mark-cell
               perform check-game-finished
           end-if
         end-if
       .

       calculate-center-of-the-cell.
           move current-row to ws-cell-center-row

           multiply cell-height by ws-cell-center-row giving ws-cell-center-row
           add offset-row to ws-cell-center-row

           divide 2 into cell-height giving ws-temp
           subtract ws-temp from ws-cell-center-row

           move current-column to ws-cell-center-column

           multiply cell-width by ws-cell-center-column giving ws-cell-center-column
           add offset-column to ws-cell-center-column

           divide 2 into cell-width giving  ws-temp
           subtract ws-temp from ws-cell-center-column
       .

       display-all-cell.
           perform varying ws-counter from 1 by 1
                               until ws-counter > field-length
               perform varying ws-counter2 from 1 by 1
                               until ws-counter2 > field-width

                  move ws-counter to current-row
                  move ws-counter2 to current-column
                  perform calculate-center-of-the-cell

                  evaluate cell-type of cells(ws-counter, ws-counter2)
                     when CELL-TYPE-EMPTY
                        call "draw-char" using by value "-" ws-cell-center-row ws-cell-center-column
                     when CELL-TYPE-BOMB
                        call "draw-char" using by value "*" ws-cell-center-row ws-cell-center-column
                     when other
                        call "draw-char" using by value cell-type of cells(ws-counter, ws-counter2) ws-cell-center-row ws-cell-center-column
                  end-evaluate

              end-perform
           end-perform
       .

       display-cell-value.
           perform calculate-center-of-the-cell

           set cell-state of current-cell to STATE-UNCOVERED
           move current-cell to cells(current-row, current-column)

           evaluate cell-type of current-cell
             when CELL-TYPE-EMPTY
                call "draw-char" using by value "-" ws-cell-center-row ws-cell-center-column
             when CELL-TYPE-BOMB
                call "draw-char" using by value "*" ws-cell-center-row ws-cell-center-column
             when other
                call "draw-char" using by value cell-type of current-cell ws-cell-center-row ws-cell-center-column
           end-evaluate
       .

       show-cell.
         if GAME-IS-OVER = B_FALSE
            move event-row to current-row
            add 1 to current-row

            move event-col to current-column
            add 1 to current-column

            call "get-cell" using current-row current-column current-cell
            if is-valid of current-cell = CELL-VALID

                evaluate cell-type of current-cell
                when CELL-TYPE-BOMB
                   perform display-all-cell
                   perform display-game-over
                when CELL-TYPE-EMPTY
                   call "display-neighbourhoods" using by value current-row by value current-column
                when other
                   perform display-cell-value
                end-evaluate
             end-if
         end-if
       .

       mark-cell.
         if GAME-IS-OVER = B_FALSE
            move event-row to current-row
            add 1 to current-row

            move event-col to current-column
            add 1 to current-column

            call "get-cell" using current-row current-column current-cell
            if is-valid of current-cell = CELL-VALID

                if cell-state of current-cell = STATE-COVERED
                     set cell-state of current-cell to STATE-MARKED
                     move current-cell to cells(current-row, current-column)

                     perform calculate-center-of-the-cell
                     call "draw-char" using by value "!" ws-cell-center-row ws-cell-center-column
                else
                   if cell-state of current-cell = STATE-MARKED
                        set cell-state of current-cell to STATE-COVERED
                        move current-cell to cells(current-row, current-column)

                        perform calculate-center-of-the-cell
                        call "draw-char" using by value " " ws-cell-center-row ws-cell-center-column
                   end-if
                end-if
            end-if
         end-if
       .

      *-----------------------------------------------------------------
       READ-ANY-KEY.

       CALL "CBL_READ_KBD_CHAR" USING
       BY REFERENCE KEYBOARD-CHARACTER
       END-CALL.

      *-----------------------------------------------------------------
       check-game-finished.

           set FIELD-IS-CLEAR to B_TRUE
           perform varying ws-counter from 1 by 1
                               until ws-counter > field-length or FIELD-IS-CLEAR = B_FALSE
               perform varying ws-counter2 from 1 by 1
                               until ws-counter2 > field-width or FIELD-IS-CLEAR = B_FALSE

                  evaluate cell-state of cells(ws-counter, ws-counter2)
                     when STATE-COVERED
                        set FIELD-IS-CLEAR to B_FALSE
                     when STATE-MARKED
                        if cell-type of cells(ws-counter, ws-counter2) <> CELL-TYPE-BOMB
                           set FIELD-IS-CLEAR to B_FALSE
                        end-if
                  end-evaluate

              end-perform
           end-perform

           if FIELD-IS-CLEAR = B_TRUE
               perform display-game-won
           end-if
       .

       display-game-over section.
           call "calculate-middle-column" using by reference disp-column by value 9
           display "GAME OVER" line 2 column disp-column
           set GAME-IS-OVER to B_TRUE
           perform restart-game
       .

       display-game-won section.
           call "calculate-middle-column" using by reference disp-column by value 25
           display "CONGRATULATIONS! YOU WIN!" line 2 column disp-column
           set GAME-IS-OVER to B_TRUE
           perform restart-game
       .

       reset-game section.
           set GAME-IS-OVER to B_FALSE
           perform start-game
       .

       goback-para.
           goback.

       copy "Painter.cpy".
       copy "DisplayNeighbourEntry.cpy".

       end program Minesweeper.

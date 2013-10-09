      ********************************************************************************************************
      *
      * Copyright (C) Micro Focus 2010-2013.
      * All rights reserved.
      *
      *  This sample code is supplied for demonstration purposes only on an "as is" basis and "is for use at
      *  your own risk".
      *
      ********************************************************************************************************


       identification division.
       program-id. "CobolSnake".

       environment division.
       special-names.
           crt status is key-status.

       working-storage section.
       01 tot-num-row           pic s9(3) comp.
       01 tot-num-col           pic s9(3) comp.
       01 tot-num-row-unsigned  pic x comp-x.
       01 tot-num-col-unsigned  pic x comp-x.
       01 head-row              pic s999 comp value 10.
       01 head-col              pic s999 comp value 10.
       01 head-dir              pic 9 value 4.
       01 head-dir-old          pic 9 value 4.
       01 tail                  occurs 1010.
           03 tail-row          pic s999 comp value 10.
           03 tail-col          pic s999 comp value 10.
       01 tail-length           pic 9(4) value 3.

      *>Variables used for random number generation
       01 random-row            pic 999 value 2.
       01 random-col            pic 999 value 2.
       01 random-num            pic 9.
       01 random-temp           pic 9v999.

       01 accept-time-out       pic 99 value 10.
       01 speed-index           pic 9 value 1.
       01 change-speed-score    pic 9(5) value 20.
       01 add-length            pic 999 value 0.
       01 insert-symbol         pic x.
       01 score                 pic 9(5) value 0.

       01 exit-flag             pic x(1) value "T".
       01 ws-count              pic 9(4) value 0.
       01 ws-row                pic s9(3) comp.
       01 ws-column             pic s9(3) comp.
       01 temp-char             pic 9.

       01 ws-character          pic x value " ".
       01 ws-attribute          pic x value x'0F'.

      *>Variable used for dynamic memory allocation
       01 mem-pointer-1         usage pointer.
       01 mem-pointer           usage pointer.
       01 mem-size              pic x(4) comp-5.
       01 flags                 pic x(4) comp-5 value 0.
       01 status-code           pic x(2) comp-5.
       01 num-cells             pic x(5) comp-5.
       01 num-cells-1           pic x(5) comp-5.
       01 mem-offset            pic s9(5).

       01 set-bit-pairs         pic 9(2) comp-x value 1.
       01 parameter-block.
           03 bit-pair-setting  pic 9(2) comp-x.
           03 bit-map-section   pic x value "6".
           03 bit-pair-number   pic 9(2) comp-x.
           03 filler            pic 9(2) comp-x value 1.
       01 adis-key-control.
           03 adis-key-setting pic 9(2) comp-x.
           03 filler pic x value "2".
           03 first-adis-key pic 9(2) comp-x.
           03 number-of-adis-keys pic 9(2) comp-x.
       01 key-status.
           03 key-type pic x.
           03 key-code-1 pic 9(2) comp-x value 0.
           03 key-code-2 pic 9(2) comp-x.

       linkage section.
       01 link-mem              pic x.

       procedure division.

       perform init-program.
       perform allocate-memory
       perform initialize-memory
       perform draw-outline
       perform initialize-snake
       perform display-snake
       perform display-random-number
       perform accept-user-input
       .

      *>Initial settings
       init-program section.
       call "CBL_CLEAR_SCR" using ws-character ws-attribute.
       call "CBL_GET_SCR_SIZE" using tot-num-row-unsigned tot-num-col-unsigned.

       move tot-num-row-unsigned to tot-num-row
       move tot-num-col-unsigned to tot-num-col

       move 14 to bit-pair-number
       move 1 to bit-pair-setting
       move 1 to set-bit-pairs
       move "6" to bit-map-section

      *>Call to accept time out in milli seconds
       call x"AF" using set-bit-pairs parameter-block

       move 1 to adis-key-setting
       move 3 to first-adis-key
       move 4 to number-of-adis-keys

      *>Call to accept arrow keys
       call x"AF" using set-bit-pairs adis-key-control
       .

      *>Allocates memory, equivalent to the screen in working storage
       allocate-memory section.
       multiply tot-num-row by tot-num-col giving mem-size
           call "CBL_ALLOC_MEM" using mem-pointer
                                by value mem-size
                                         flags
                                returning status-code
           if not (status-code = 0)
               display "FAIL"
           end-if
         subtract 1 from tot-num-row
        .

      *>Initialize the working storage memory with spaces.
       initialize-memory section.
          set address of link-mem to mem-pointer
          move all " " to link-mem(1:mem-size)
       .

      *>Create the initial snake
       initialize-snake section.
       move 3 to tail-length
       move 10 to head-row tail-row(1) tail-row(2) tail-row(3)
       move 5 to head-col
       move 4 to tail-col(1)
       move 3 to tail-col(2)
       move 2 to tail-col(3)
       .

      *>Displays the snake
       display-snake section.
       display "@" line head-row column head-col
       move head-row to ws-row
       move head-col to ws-column
       move "@" to insert-symbol
       perform add-to-ws-memory
       move tail-length to ws-count
       perform varying ws-count from 1 by 1 until ws-count > tail-length
           display "o" line tail-row(ws-count) column tail-col(ws-count)
           move tail-row(ws-count) to ws-row
           move tail-col(ws-count) to ws-column
           move "o" to insert-symbol
           perform add-to-ws-memory
       end-perform
       .

      *>Moves the tail of the snake
       move-tail section.
       if add-length = 0
           display " " line tail-row(tail-length) column tail-col(tail-length)
           move tail-row(tail-length) to ws-row
           move tail-col(tail-length) to ws-column
           move " " to insert-symbol
           perform add-to-ws-memory
       else
           add 1 to tail-length
           subtract 1 from add-length
       end-if
       perform varying ws-count from tail-length by -1 until ws-count = 1
       move tail(ws-count - 1) to tail(ws-count)
       end-perform
       move head-row to tail-row(1)
       move head-col to tail-col(1)
       display "*" line 1 column 1
       .

      *>Wait until the user enters an arrow key
       accept-valid-character section.
       perform until key-code-1 = 3 or key-code-1 = 4 or key-code-1 = 5 or key-code-1 = 6
           accept temp-char with auto-skip
           display "*" line 1 column 1
       end-perform
       display speed-index line tot-num-row + 1 column 48
       .

      *>If the timeout occurs, continue the processing with previous value
       accept-valid-char-with-time-out section.
       accept temp-char with auto-skip time-out accept-time-out
      *>Check for ENTER key and pause teh game
       if key-type = 0 and key-code-1 = 48 and key-code-2 = 13
           accept temp-char with auto-skip
       end-if
      *>Check for arrow key
       if key-type not = 2
           move head-dir-old to key-code-1
       end-if
       .

      *>Displays random numbers at random position
       display-random-number section.
       display " " line random-row column random-col
       move random-row to ws-row
       move random-col to ws-column
       move " " to insert-symbol
       perform add-to-ws-memory
       perform generate-random-numbers
       display random-num line random-row column random-col
       move random-row to ws-row
       move random-col to ws-column
       move random-num to insert-symbol
       perform add-to-ws-memory
       .

      *>Accept the keyboard input from user and respond according to it
       accept-user-input section.
       move "0" to exit-flag
       perform accept-valid-character
       perform until exit-flag = "1"
           move "T" to exit-flag
           perform until exit-flag = "F"
               move "T" to exit-flag
               perform move-tail
               move key-code-1 to head-dir
               evaluate head-dir
                   when 3              *>Left arrow
                       subtract 1 from head-col
                   when 4              *>Right arrow
                       add 1 to head-col
                   when 5              *>Up arrow
                       subtract 1 from head-row
                   when 6              *>Down arrow
                       add 1 to head-row
                   when other
                       move "F" to exit-flag
                   end-evaluate
               perform check-head-position
               perform display-snake
               move head-dir to head-dir-old
               perform accept-valid-char-with-time-out
           end-perform
       end-perform
       .

      *>Checks the data at the head position of the snake
       check-head-position section.
       move head-row to ws-row
       move head-col to ws-column
       move mem-pointer to mem-pointer-1
       multiply ws-row by tot-num-col giving mem-offset
       add ws-column to mem-offset
       set mem-pointer-1 up by mem-offset
       set address of link-mem to mem-pointer-1
       if link-mem = " "
           continue
       else if link-mem = random-num
           add random-num to score
           if score > 1000
               call "CBL_CLEAR_SCR" using ws-character ws-attribute
               display "!!! CONGRATULATIONS !!!" line 10 column 30
               display "PRESS RETURN KEY TO EXIT" line 20 column 29
               accept temp-char
               stop run
           end-if
           if score > change-speed-score
               if accept-time-out > 1
                   subtract 1 from accept-time-out
                   if speed-index = 9
                       display "MAX" line tot-num-row + 1 column 48
                   else
                       add 1 to speed-index
                       display speed-index line tot-num-row + 1 column 48
                   end-if
                   multiply 20 by speed-index giving change-speed-score
               end-if
           end-if
           add random-num to add-length
           perform display-random-number
           move "F" to exit-flag
           display score line tot-num-row + 1 column 28

       else if link-mem = "@" or link-mem = "o" or link-mem = "*"
           call "CBL_CLEAR_SCR" using ws-character ws-attribute
           display "!!! GAME IS OVER !!!" line 10 column 30
           display "YOUR SCORE IS : " line 14 column 30
           display score line 14 column 46
           display "PRESS RETURN KEY TO EXIT" line 20 column 29
           accept temp-char
           stop run
       end-if
       .

      *>Generate random numbers
       generate-random-numbers section.
       move tot-num-row to random-row
       perform until random-row < tot-num-row and random-row > 1
           move function random to random-temp
           multiply random-temp by 100 giving random-row
       end-perform

       move tot-num-col to random-col
       perform until random-col < tot-num-col and random-col > 1
           move function random to random-temp
           multiply random-temp by 100 giving random-col
       end-perform

      *>Check whether the position is on snakes body
       move mem-pointer to mem-pointer-1
       multiply random-row by tot-num-col giving mem-offset
       add random-col to mem-offset
       set mem-pointer-1 up by mem-offset
       set address of link-mem to mem-pointer-1
       if link-mem not = " "
           perform generate-random-numbers
       else
           move 0 to random-num
           perform until random-num > 0
               move function random to random-temp
               multiply random-temp by 10 giving random-num
           end-perform
       end-if
        .

      *>Draws the outline of the screen.
       draw-outline section.
       move "*" to insert-symbol
       move 1 to ws-row
       perform varying ws-column from 1 by 1 until ws-column = tot-num-col
       display "*" line ws-row column ws-column
       perform add-to-ws-memory
       end-perform

       move tot-num-row to ws-row
       perform varying ws-column from 1 by 1 until ws-column = tot-num-col
       display "*" line ws-row column ws-column
       perform add-to-ws-memory
       end-perform
       move 1 to ws-column
       perform varying ws-row from 1 by 1 until ws-row = tot-num-row
       display "*" line ws-row column ws-column
       perform add-to-ws-memory
       end-perform

       set address of link-mem to mem-pointer-1
       move tot-num-col to ws-column
       perform varying ws-row from 1 by 1 until ws-row = tot-num-row
       display "*" line ws-row column ws-column
       perform add-to-ws-memory
       end-perform

       display "SCORE : " line tot-num-row + 1 column 20
       display score line tot-num-row + 1 column 28
       display "SPEED : " line tot-num-row + 1 column 40
       display "0" line tot-num-row + 1 column 48
       .


      *>Inserts into the working storage memory corresponding to the screen area
       add-to-ws-memory section.
       move mem-pointer to mem-pointer-1
       multiply ws-row by tot-num-col giving mem-offset
       add ws-column to mem-offset
       set mem-pointer-1 up by mem-offset
       set address of link-mem to mem-pointer-1
       move insert-symbol to link-mem
       .

       End program "CobolSnake".

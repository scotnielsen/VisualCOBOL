      ********************************************************************************************************
      *
      *  Copyright (C) Micro Focus 2010-2013. All rights reserved.
      *
      *  This sample code is supplied for demonstration purposes only on an "as is" basis and "is for use at
      *  your own risk".
      *
      ********************************************************************************************************

      *> Cells
       01 num-cells-horiz          pic s9(2) comp.
       01 num-cells-vert           pic s9(2) comp.
       78 cell-width               value 4.
       78 cell-height              value 2.
       01 num-rows                 pic s9(2) comp.
       01 num-columns              pic s9(2) comp.
       01 offset-row               pic 99 comp-x value 3.
       01 offset-column            pic 99 comp-x value 10.

      *> Temporary variables
       01 ws-temp                  pic s9(2) comp.
       01 ws-temp-row              pic s9(2) comp.
       01 ws-temp-column           pic s9(2) comp.

       01 ws-character             pic x value " ".
       01 ws-attribute             pic x value x'0F'.

      *> Variable for holding drawing characters
       01 chars2-function-code       pic x comp-x.
       01 chars2-parameter-block-0.
          03 line-draw-code          pic x comp-x.
          03                         pic x.
          03 line-draw-character     pic x occurs 255.

       01 ws-counter               pic s9(2) comp.
       01 ws-counter2              pic s9(2) comp.
       01 ws-level                 pic 9.
       01 ws-temp-level            pic x.
       01 ws-restart-game          pic x.

       01 screen-rows              pic s9(2) comp.
       01 screen-columns           pic s9(2) comp.

       01 screen-position.
          03 scrp-row   pic x comp-x.
          03 scrp-col   pic x comp-x.

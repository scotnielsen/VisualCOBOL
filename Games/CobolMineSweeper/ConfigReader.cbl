      ********************************************************************************************************
      *
      * Copyright (C) Micro Focus 2010-2013.
      * All rights reserved.
      *
      *  This sample code is supplied for demonstration purposes only on an "as is" basis and "is for use at
      *  your own risk".
      *
      ********************************************************************************************************

       program-id. ConfigReader as "ConfigReader".
       environment division.
       file-control.
       select config-file assign to ws-config-file-name
                           organization is sequential.

       configuration section.
       data division.
       file section.
       fd config-file record contains 4 characters.
       01 cf-record.
           03 first-number     pic 9(2).
           03 second-number    pic 9(2).

       working-storage section.
       01 ws-counter           pic 99.
       01 ws-grid-size         pic 99.
       01 ws-mines-count       pic 99.
       01 ws-eof               pic 9 comp-x value 0.
       01 ws-config-file-name  pic x(100).
       01 ws-length-temp       pic 99.
       01 ws-width-temp        pic 99.

       *>Variables used for random number generation
       01 random-row            pic 99 value 2.
       01 random-col            pic 99 value 2.
       01 random-temp           pic 9v999.
       01 random-seed           pic 9(9). *> value function CURRENT-DATE.
       copy "FieldMap.cpy".

       linkage section.
       01 l-level pic 9.

       01 l-mine-field.
           03 l-field-length pic 99.
           03 l-field-width pic 99.
           03 l-cells-lines occurs 1 to 40 depending on
                           l-field-length.
               05 l-cells cell occurs 1 to 40 depending on l-field-width.

       procedure division using l-level l-mine-field.

           evaluate l-level
               when 1
                   set ws-grid-size to 5
                   set ws-mines-count to 5
               when 2
                   set ws-grid-size to 7
                   set ws-mines-count to 15
               when 3
                   set ws-grid-size to 10
                   set ws-mines-count to 30
               when other
                   set ws-grid-size to 7
                   set ws-mines-count to 15
           end-evaluate

           perform init-field
           perform init-random-generator
           perform randomize-mine-locations
           perform evaluate-neighbourhoods

           move mine-field to l-mine-field.

           goback.

       init-field section.
           move ws-grid-size to field-length
           move ws-grid-size to field-width
           move ws-mines-count to mines-count
           perform clear-field
       .

       init-random-generator section.
           *> CURRENT-DATE(9:6) holds the time component
           move function current-date(9:6) to random-seed
           move function random(random-seed) to random-temp
       .

       randomize-mine-locations section.
           perform varying ws-counter from 1 by 1 until ws-counter > ws-mines-count

               perform generate-random-numbers until cell-type of cells(random-row, random-col)
                                                       not = CELL-TYPE-BOMB

               set cell-type of cells(random-row, random-col)
                       to CELL-TYPE-BOMB

           end-perform
       .

       generate-random-numbers section.
           set random-row to 0
           perform until random-row <= field-length and random-row >= 1
               move function random to random-temp
               multiply random-temp by 100 giving random-row
           end-perform

           set random-col to 0
           perform until random-col <= field-width and random-col >= 1
               move function random to random-temp
               multiply random-temp by 100 giving random-col
           end-perform
       .

       open-config-file section.

           open input config-file
       .

       close-config-file section.

           close config-file
       .

       get-field-size section.
           if ws-eof < 1
               read config-file at end set ws-eof to 1
                   not at end
                   perform
                       move first-number to field-length
                       move second-number to field-width
                   end-perform
               end-read
           end-if
       .

       get-mines-locations section.
           perform get-next-mine-location until ws-eof = 1
       .

       get-next-mine-location section.
           read config-file at end move 1 to ws-eof
               not at end perform
                   set cell-type of cells(first-number, second-number)
                       to CELL-TYPE-BOMB
               end-perform
           end-read
       .
      * Compute for every cells the number of neighbour cells that have
      * bombs in them.
      *
       evaluate-neighbourhoods section.
           perform varying ws-length-temp from 1 by 1 until ws-length-temp > field-length
               perform varying ws-width-temp from 1 by 1 until ws-width-temp > field-width
                   if cell-type of cells(ws-length-temp, ws-width-temp) = CELL-TYPE-BOMB
                       if ws-length-temp - 1 > 0
                           if cell-type of cells(ws-length-temp - 1, ws-width-temp) < CELL-TYPE-BOMB
                               add 1 to cell-type of cells(ws-length-temp - 1, ws-width-temp)
                           end-if

                           if ws-width-temp - 1 > 0 and cell-type of cells(ws-length-temp - 1, ws-width-temp - 1) < CELL-TYPE-BOMB
                               add 1 to cell-type of cells(ws-length-temp - 1, ws-width-temp - 1)
                           end-if

                           if ws-width-temp + 1 <= field-width and cell-type of cells(ws-length-temp - 1, ws-width-temp + 1) < CELL-TYPE-BOMB
                               add 1 to cell-type of cells(ws-length-temp - 1, ws-width-temp + 1)
                           end-if
                       end-if
                       if ws-length-temp + 1 <= field-length
                           if cell-type of cells(ws-length-temp + 1, ws-width-temp) < CELL-TYPE-BOMB
                               add 1 to cell-type of cells(ws-length-temp + 1, ws-width-temp)
                           end-if

                           if ws-width-temp - 1 > 0 and cell-type of cells(ws-length-temp + 1, ws-width-temp - 1) < CELL-TYPE-BOMB
                               add 1 to cell-type of cells(ws-length-temp + 1, ws-width-temp - 1)
                           end-if

                           if ws-width-temp + 1 <= field-width and cell-type of cells(ws-length-temp + 1, ws-width-temp + 1) < CELL-TYPE-BOMB
                               add 1 to cell-type of cells(ws-length-temp + 1, ws-width-temp + 1)
                           end-if
                       end-if
                       if ws-width-temp - 1 > 0 and cell-type of cells(ws-length-temp, ws-width-temp - 1) < CELL-TYPE-BOMB
                           add 1 to cell-type of cells(ws-length-temp, ws-width-temp - 1)
                       end-if
                       if ws-width-temp + 1 <= field-width and cell-type of cells(ws-length-temp, ws-width-temp + 1) < CELL-TYPE-BOMB
                           add 1 to cell-type of cells(ws-length-temp, ws-width-temp + 1)
                       end-if
                   end-if
               end-perform
           end-perform
       .

       clear-field section.
           perform varying ws-length-temp from 1 by 1 until ws-length-temp > field-length
               perform varying ws-width-temp from 1 by 1 until ws-width-temp > field-width
                   set cell-type of cells(ws-length-temp, ws-width-temp) to CELL-TYPE-EMPTY
               end-perform
           end-perform
       .

       end program ConfigReader.

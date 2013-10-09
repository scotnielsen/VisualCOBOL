      ********************************************************************************************************
      *
      *  Copyright (C) Micro Focus 2010-2013. All rights reserved.
      *
      *  This sample code is supplied for demonstration purposes only on an "as is" basis and "is for use at
      *  your own risk".
      *
      ********************************************************************************************************

       78 CELL-INVALID             value 0.
       78 CELL-VALID               value 1.

       78 STATE-COVERED            value 0.
       78 STATE-UNCOVERED          value 1.
       78 STATE-MARKED             value 2.

       78 CELL-TYPE-EMPTY          value 0.
       78 CELL-TYPE-1-NB           value 1.
       78 CELL-TYPE-2-NB           value 2.
       78 CELL-TYPE-3-NB           value 3.
       78 CELL-TYPE-4-NB           value 4.
       78 CELL-TYPE-5-NB           value 5.
       78 CELL-TYPE-6-NB           value 6.
       78 CELL-TYPE-7-NB           value 7.
       78 CELL-TYPE-8-NB           value 8.
       78 CELL-TYPE-BOMB           value 9.

       01 cell typedef.
           03 cell-state  pic 9    value STATE-COVERED.
           03 cell-type   pic 9    value CELL-TYPE-EMPTY.
           03 is-valid    pic 9    value CELL-VALID.

       01 mine-field.
           03 mines-count pic 99.
           03 field-length pic 99.
           03 field-width pic 99.
           03 cells-lines occurs 1 to 40 depending on
                           field-length.
               05 cells cell occurs 1 to 40 depending on field-width.

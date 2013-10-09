      ********************************************************************************************************
      *
      * Copyright (C) Micro Focus 2010-2013.
      * All rights reserved.
      *
      *  This sample code is supplied for demonstration purposes only on an "as is" basis and "is for use at
      *  your own risk".
      *
      ********************************************************************************************************

       class-id CobolTicTacToe.Grid.

       working-storage section.
       01 ticTacGrid     binary-long occurs 9.

       method-id New.
       procedure division.
           set content of ticTacGrid to (0 0 0 0 0 0 0 0 0)
       end method.

       method-id New.
       procedure division using by value gameState as string.
           set content of ticTacGrid to (0 0 0 0 0 0 0 0 0)
           perform varying stringIndex as binary-long from 0 by 1 until stringIndex > 8
               evaluate gameState[stringIndex]
                   when '0'
                       set ticTacGrid[stringIndex] to 0
                   when '1'
                       set ticTacGrid[stringIndex] to 1
                   when '2'
                       set ticTacGrid[stringIndex] to 2
               end-evaluate
           end-perform
       end method.

       method-id New.
       procedure division using by value gameState as type CobolTicTacToe.Grid.
           set content of ticTacGrid to (0 0 0 0 0 0 0 0 0)
           perform varying gridIndex as binary-long from 0 by 1 until gridIndex > 8
               set self[gridIndex] to gameState[gridIndex]
           end-perform
       end method.

       indexer-id binary-long.
       procedure division using by value gridPos as binary-long.
       getter.
           set property-value to ticTacGrid[gridPos]
       setter.
           set ticTacGrid[gridPos] to property-value
       end indexer.

       method-id GetBestMove.
       01 termState binary-long value 1.
       01 winMoves  list[binary-long].
       01 drawMoves list[binary-long].
       01 moveNum   binary-long value 0.
       procedure division returning bestMove as binary-long.
           create winMoves
           create drawMoves
           set bestMove to 1
           perform varying gridIndex as binary-long from 0 by 1 until gridIndex > 8
               if(ticTacGrid[gridIndex] = 0)
                   set termState to self::CheckMove(gridIndex)
                   evaluate termState
                       when 2
                           write winMoves from gridIndex

                       when 3
                           write drawMoves from gridIndex
                   end-evaluate
               end-if
           end-perform

           if(size of winMoves > 0)
               set moveNum to self::RandomNumber(0 size of winMoves)
               set bestMove to winMoves[moveNum]
           else
               set moveNum to self::RandomNumber(0 size of drawMoves)
               set bestMove to drawMoves[moveNum]
           end-if
       end method.

       method-id RandomNumber.
       01 randClass type System.Random value new System.Random().
       procedure division using by value firstNum as binary-long rangeLength as binary-long
                                   returning ret as binary-long.
           set ret to randClass::Next(firstNum (firstNum + rangeLength - 1))
       end method.

       method-id CheckMove.
       01 baseGrid     type CobolTicTacToe.Grid.
       01 newGrid      type CobolTicTacToe.Grid.
       01 termState    binary-long value 0.
       01 drawStates   binary-long value 0.
       procedure division using by value gridPos as binary-long returning finishState as binary-long.
           set baseGrid to new CobolTicTacToe.Grid(self)
           set baseGrid[gridPos] to 2
           set termState to baseGrid::Eval()
           if not (termState = 0)
               set finishState to termState
               goback
           end-if

           perform varying gridIndex as binary-long from 0 by 1 until gridIndex > 8
               if(baseGrid[gridIndex] = 0)
                   set newGrid to new CobolTicTacToe.Grid(baseGrid)
                   set newGrid[gridIndex] to 1
                   set termState to newGrid::TryMoves()
                   evaluate termState
                       when 3
                           add 1 to drawStates
                       when 1
                           set finishState to termState
                           goback
                   end-evaluate
               end-if
           end-perform

           if(drawStates > 0)
               set finishState to 3
           else
               set finishState to 2
           end-if
       end method.

       method-id TryMoves.
           01 termState    binary-long value 0.
       procedure division returning finishState as binary-long.
           set termState to self::Eval()
           if not(termState = 0)
               set finishState to termState
               goback
           end-if

           set finishState to 1

           perform varying gridIndex as binary-long from 0 by 1 until gridIndex > 8
               if(ticTacGrid[gridIndex] = 0)
                   set termState to self::CheckMove(gridIndex)
                   evaluate termState
                       when 3
                           set finishState to 3
                       when 2
                           set finishState to 2
                           goback
                   end-evaluate
               end-if
           end-perform
       end method.

       method-id Eval.
       01 loopIndex binary-long value 0.
       procedure division returning ret as binary-long.
           set ret to 0
      *> Check horizontal
           perform varying loopIndex from 1 by 1 until loopIndex > 3
               if((ticTacGrid(loopIndex * 3) = ticTacGrid((loopIndex * 3) - 1)) and
                  (ticTacGrid(loopIndex * 3) = ticTacGrid((loopIndex * 3) - 2)) and
                  not (ticTacGrid(loopIndex * 3) = 0))
                   set ret to ticTacGrid(loopIndex * 3)
                   goback
               end-if
           end-perform

      *> Check vertical
           perform varying loopIndex from 1 by 1 until loopIndex > 3
               if((ticTacGrid(loopIndex) = ticTacGrid(loopIndex + 3)) and
                  (ticTacGrid(loopIndex) = ticTacGrid(loopIndex + 6)) and
                  not (ticTacGrid(loopIndex) = 0))
                   set ret to ticTacGrid(loopIndex)
                   goback
               end-if
           end-perform

      *> Check diagonals
           if((ticTacGrid(1) = ticTacGrid(5)) and
              (ticTacGrid(1) = ticTacGrid(9)) and
              not (ticTacGrid(1) = 0))
               set ret to ticTacGrid(1)
               goback
           end-if

           if((ticTacGrid(3) = ticTacGrid(5)) and
              (ticTacGrid(3) = ticTacGrid(7)) and
              not (ticTacGrid(3) = 0))
               set ret to ticTacGrid(3)
               goback
           end-if

      *> Check all filled with no winner
           perform varying loopIndex from 1 by 1 until loopIndex > 9
               if(ticTacGrid(loopIndex) = 0)
                   exit perform
               end-if
           end-perform
           if(loopIndex > 9)
               set ret to 3
           end-if
       end method.

       end class.

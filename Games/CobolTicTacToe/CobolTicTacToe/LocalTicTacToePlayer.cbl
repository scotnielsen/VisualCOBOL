      ********************************************************************************************************
      *
      * Copyright (C) Micro Focus 2010-2013.
      * All rights reserved.
      *
      *  This sample code is supplied for demonstration purposes only on an "as is" basis and "is for use at
      *  your own risk".
      *
      ********************************************************************************************************

       class-id CobolTicTacToe.LocalCobolTicTacToePlayer implements type CobolTicTacToe.ICobolTicTacToePlayer.

       working-storage section.
           01 player       type CobolTicTacToe.Screen.

       method-id New.
       procedure division using by value newPlayer as type CobolTicTacToe.Screen.
           set player to newPlayer
       end method.


       method-id PutNewGameState public.
           01 isValid          type System.Boolean.
           01 newGameState     string.
       procedure division using by value gameState as string.
           set isValid to self::ValidateGameState(gameState)

           if not(isValid)
               set newGameState to gameState[0:9] & "3"
           else
               set newGameState to self::MakeMove(gameState)
           end-if

           invoke player::SetGameState(newGameState)
       end method.

       method-id MakeMove private.
       01 gameTerminationState     string.
       01 gameStatePrefix          string.
       01 gameStatePostfix         string.
       01 moveIndex                binary-long.
       01 gameGrid                 type CobolTicTacToe.Grid.
       procedure division using by value gameState as string returning newGameState as string.
           set gameTerminationState to self::CalculateTerminationState(gameState)

           if not (gameTerminationState = "0")
               set gameStatePrefix to gameState[0:9]
               set newGameState to gameStatePrefix & gameTerminationState
           else
               set gameGrid to new CobolTicTacToe.Grid(gameState)
               set moveIndex to gameGrid::GetBestMove()
               set gameStatePrefix  to gameState[0:moveIndex]
               set gameStatePostfix to gameState[moveIndex + 1:]
               set newGameState to gameStatePrefix & "2" & gameStatePostfix
               set gameTerminationState to self::CalculateTerminationState(newGameState)
               set newGameState to newGameState[0:9] & gameTerminationState
           end-if
       end method.

       method-id CalculateTerminationState
       01 firstEmptySquare     binary-long value 9.
       procedure division using by value gameState as string returning termState as string.
           set termState to "0"

       *> Any horizontal lines
           perform varying loopIndex as binary-long from 0 by 1 until loopIndex > 2
               if((gameState[loopIndex * 3] = gameState[(loopIndex * 3) + 1]) and
                  (gameState[loopIndex * 3] = gameState[(loopIndex * 3) + 2]) and
                  not (gameState[loopIndex * 3] = '0'))
                   set termState to gameState[loopIndex * 3]
                  goback
               end-if
           end-perform

       *> Any vertical lines
           perform varying loopIndex as binary-long from 0 by 1 until loopIndex > 2
               if((gameState[loopIndex] = gameState[loopIndex + 3]) and
                  (gameState[loopIndex] = gameState[loopIndex + 6]) and
                  not (gameState[loopIndex] = '0'))
                   set termState to gameState[loopIndex]
                  goback
               end-if
           end-perform

       *> Any diagonal lines
           if((gameState[0] = gameState[4]) and
              (gameState[0] = gameState[8]) and
              not (gameState[0] = '0'))
               set termState to gameState[0]
               goback
           end-if

           if((gameState[2] = gameState[4]) and
              (gameState[2] = gameState[6]) and
              not (gameState[2] = '0'))
               set termState to gameState[2]
               goback
           end-if

       *> Are there any free spaces left
           set firstEmptySquare to self::FindEmptySquare(gameState)
           if (firstEmptySquare = 9)
               set termState to '3'
           end-if
       end method.

       method-id FindEmptySquare private
       procedure division using by value gameState as string returning emptySquare as binary-long.
           set emptySquare to 9
           perform varying statePos as binary-long from 0 by 1 until statePos > 8
               if(gameState[statePos] = '0')
                   set emptySquare to statePos
                   exit perform
               end-if
           end-perform
       end method.

       method-id ValidateGameState private.
       01 numPlayerMoves   binary-long value 0.
       01 numComputerMoves binary-long value 0.
       01 moveDiff         binary-long value 0.
       procedure division using by value gameState as string returning ret as type System.Boolean.
           set ret to false

           if size of gameState < 10
               goback
           end-if

           perform varying statePos as binary-long from 0 by 1 until statePos > 8
               if not((gameState[statePos] = '0') or
                      (gameState[statePos] = '1') or
                      (gameState[statePos] = '2'))
                   goback
               end-if
           end-perform

           set numPlayerMoves to self::FindNumMoves(gameState '1')
           set numComputerMoves to self::FindNumMoves(gameState '2')
           subtract numComputerMoves from numPlayerMoves giving moveDiff

           if((moveDiff = 0) or (moveDiff = 1))
               set ret to true
           end-if

           goback.
       end method.

       method-id FindNumMoves private.
       procedure division using by value gameState as string checkVal as character
                          returning ret as binary-long.
           set ret to 0.
           perform varying statePos as binary-long from 0 by 1 until statePos > 8
               if(gameState[statePos] = checkVal)
                   add 1 to ret giving ret
               end-if
           end-perform
       end method.

       end class.

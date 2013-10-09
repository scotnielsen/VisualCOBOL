      ********************************************************************************************************
      *
      * Copyright (C) Micro Focus 2010-2013.
      * All rights reserved.
      *
      *  This sample code is supplied for demonstration purposes only on an "as is" basis and "is for use at
      *  your own risk".
      *
      ********************************************************************************************************

       class-id CobolTicTacToe.Screen is partial
                 inherits type System.Windows.Window.

       working-storage section.
       01 blankImage       type BitmapImage.
       01 xImage           type BitmapImage.
       01 oImage           type BitmapImage.
       01 wonImage         type BitmapImage.
       01 lostImage        type BitmapImage.
       01 drawImage        type BitmapImage.
       01 invalidImage     type BitmapImage.
       01 images           type Image occurs any.
       01 bitmaps          type BitmapImage occurs any.
       01 current-image    binary-long occurs any.
       01 gameState        string value "unstarted!".
       01 otherPlayer      type CobolTicTacToe.ICobolTicTacToePlayer.
       method-id NEW.
       procedure division.
           invoke self::InitializeComponent()
           set blankImage to self::InitFromUri("Resources/blank.png")
           set xImage to self::InitFromUri("Resources/x.png")
           set oImage to self::InitFromUri("Resources/o.png")
           set wonImage to self::InitFromUri("Resources/won.png")
           set lostImage to self::InitFromUri("Resources/lost.png")
           set drawImage to self::InitFromUri("Resources/draw.png")
           set invalidImage to self::InitFromUri("Resources/invalid.png")
           set content of images to (image1 image2 image3 image4 image5 image6 image7 image8 image9)
           set content of bitmaps to (blankImage xImage oImage wonImage lostImage drawImage invalidImage)
           set content of current-image to (2 1 1 1 2 1 1 1 2)
           set otherPlayer to new CobolTicTacToe.LocalCobolTicTacToePlayer(self)
           goback.
       end method.

       method-id InitFromUri.
       procedure division using by value resource as string
                               returning bitMapImage as type BitmapImage.
           set bitMapImage to new BitmapImage
           invoke bitMapImage::BeginInit
           set bitMapImage::UriSource to new Uri(resource type UriKind::Relative)
           invoke bitmapImage::EndInit
       end method.
       
       method-id image1_MouseLeftButtonDown final private.
       procedure division using by value sender as object e as type System.Windows.Input.MouseButtonEventArgs.
           invoke self::HandleClickEvent(1)
       end method.

       method-id image2_MouseLeftButtonDown final private.
       procedure division using by value sender as object e as type System.Windows.Input.MouseButtonEventArgs.
           invoke self::HandleClickEvent(2)
       end method.

       method-id image3_MouseLeftButtonDown final private.
       procedure division using by value sender as object e as type System.Windows.Input.MouseButtonEventArgs.
           invoke self::HandleClickEvent(3)
       end method.

       method-id image4_MouseLeftButtonDown final private.
       procedure division using by value sender as object e as type System.Windows.Input.MouseButtonEventArgs.
           invoke self::HandleClickEvent(4)
       end method.

       method-id image5_MouseLeftButtonDown final private.
       procedure division using by value sender as object e as type System.Windows.Input.MouseButtonEventArgs.
           invoke self::HandleClickEvent(5)
       end method.

       method-id image6_MouseLeftButtonDown final private.
       procedure division using by value sender as object e as type System.Windows.Input.MouseButtonEventArgs.
           invoke self::HandleClickEvent(6)
       end method.

       method-id image7_MouseLeftButtonDown final private.
       procedure division using by value sender as object e as type System.Windows.Input.MouseButtonEventArgs.
           invoke self::HandleClickEvent(7)
       end method.

       method-id image8_MouseLeftButtonDown final private.
       procedure division using by value sender as object e as type System.Windows.Input.MouseButtonEventArgs.
           invoke self::HandleClickEvent(8)
       end method.

       method-id image9_MouseLeftButtonDown final private.
       procedure division using by value sender as object e as type System.Windows.Input.MouseButtonEventArgs.
           invoke self::HandleClickEvent(9)
       end method.

       method-id HandleClickEvent final private.
       01 stringIndex binary-long value 1.
       procedure division using by value imageIndex as binary-long.
           if (gameState[9] = '0')
               subtract 1 from imageIndex giving stringIndex
               if (gameState[stringIndex] = '0')
                   invoke type Console::WriteLine("Modifying game state")
                   invoke self::TickSquare(imageIndex)
                   invoke otherPlayer::PutNewGameState(gameState)
               end-if
           end-if
       end method.

       method-id TickSquare final private.
       01 stringIndex binary-long value 1.
       01 gameStatePrefix string.
       01 gameStatePostfix string.
       01 newGameState string value "".
       procedure division using by value imageIndex as binary-long.
           subtract 1 from imageIndex giving stringIndex
           set gameStatePrefix to gameState[0:stringIndex]
           set gameStatePostfix to gameState[imageIndex:]
           set newGameState to gameStatePrefix & "1" & gameStatePostfix
           invoke self::SetGameState(newGameState)
       end method.

       method-id SetImage final private.
       procedure division using by value imageIndex as binary-long bitmap-index as binary-long.
           set images(imageIndex)::Stretch to type Stretch::UniformToFill
           set images(imageIndex)::Source to bitmaps(bitmap-index)
           set current-image(imageIndex) to bitmap-index
       end method.

       method-id SetGameState final public.
       01 InvalidState type Exception value new Exception("New game state is invalid!").
       procedure division using by value newGameState as string.
           if size of newGameState < 10
               raise InvalidState
           else
               set gameState to newGameState
               invoke self::DrawGameState
           end-if
       end method.

       method-id DrawGameState final private.
       01 imageIndex binary-long value 1.
       procedure division.
           perform varying imageIndex from 1 by 1 until imageIndex > 9
               invoke self::DrawCell(imageIndex)
           end-perform
           evaluate gameState[9]
               when '1'
                   invoke self::SetImage(5 4)
               when '2'
                   invoke self::SetImage(5 5)
               when '3'
                   invoke self::SetImage(5 6)
               when '4'
                   invoke self::SetImage(5 7)
           end-evaluate
       end method.

       method-id DrawCell final private.
       01 stringIndex binary-long value 0.
       procedure division using by value imageIndex as binary-long.
           subtract 1 from imageIndex giving stringIndex
           evaluate gameState[stringIndex]
               when '0'
                   invoke self::SetImage(imageIndex 1)
               when '1'
                   invoke self::SetImage(imageIndex 2)
               when '2'
                   invoke self::SetImage(imageIndex 3)
           end-evaluate
       end method.

       method-id btnNewGame_Click final private.
       procedure division using by value sender as object e as type System.Windows.RoutedEventArgs.
           invoke self::SetGameState ("0000000000")
           if not (cbxPlayerStartsFirst::IsChecked::Value)
               invoke otherPlayer::PutNewGameState(gameState)
           end-if
       end method.

       end class.

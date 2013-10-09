      ********************************************************************************************************
      *
      * Copyright (C) Micro Focus 2010-2013.
      * All rights reserved.
      *
      *  This sample code is supplied for demonstration purposes only on an "as is" basis and "is for use at
      *  your own risk".
      *
      ********************************************************************************************************

       class-id CobolDoKu.Form1 is partial
                 inherits type System.Windows.Forms.Form.

       working-storage section.

      *>> <summary>
      *>> Initialize the main form.
      *>> </summary>
       method-id NEW.
       procedure division.
           invoke self::InitializeComponent
           declare puzzles-dir as string
           set puzzles-dir to type System.IO.Path::GetFullPath("..\..\puzzles")
           set openFileDialog1::InitialDirectory to puzzles-dir
           set saveFileDialog1::InitialDirectory to puzzles-dir
       end method.

      *>> <summary>
      *>> Open a new puzzle game
      *>> </summary>
      *>> <param name="sender"></param>
      *>> <param name="e"></param>
       method-id openPuzzleToolStripMenuItem_Click public.
       procedure division using by value sender as type System.Object e as type System.EventArgs.
           if openFileDialog1::ShowDialog() = type System.Windows.Forms.DialogResult::OK
               invoke grid1::Load(openFileDialog1::FileName)
           end-if
       end method.

      *>> <summary>
      *>> Save the played puzzle game
      *>> </summary>
       method-id  savePuzzleToolStripMenuItem_Click final private.
       procedure division using by value sender as type System.Object e as type System.EventArgs.
           if saveFileDialog1::ShowDialog() = type System.Windows.Forms.DialogResult::OK
               invoke grid1::Save(saveFileDialog1::FileName)
           end-if
       end method.

      *>> <summary>
      *>> Clear all typed numbers in the current game
      *>> </summary>
       method-id  clearToolStripMenuItem_Click final private.
       procedure division using by value sender as type System.Object e as type System.EventArgs.
           invoke grid1::Clear().
       end method.

      *>> <summary>
      *>> Show all possible numbers according to the current ones that are already typed
      *>> </summary>
      *>> <param name="sender"></param>
      *>> <param name="e"></param>
       method-id  showPossibleValuesToolStripMenu_Click final private.
       local-storage section.
       01  menuitem     type System.Windows.Forms.ToolStripMenuItem.
       linkage section.
       procedure division using by value sender as type System.Object e as type System.EventArgs.
           set menuitem to sender as type System.Windows.Forms.ToolStripMenuItem
           set grid1::ShowHints  to menuitem::Checked
       end method.

      *>> <summary>
      *>> The event method is raised when updating the status bar to show how many squares remain and
      *>> when the puzzle is complete to congratulate the user.
      *>> </summary>
      *>> <param name="SENDER"></param>
      *>> <param name="E"></param>
       method-id  grid1_CellChanged final private.
       local-storage section.
       01  msg string.
       procedure division using by value SENDER as type System.Object E as type CobolDoKu.CellChangedEventArgs.
      *> Update the status bar to show how many squares remain
           set msg to string::Format ("{0} squares to complete", grid1::CellsRemaining)
           invoke self::SetStatusText(msg)

      *> If the puzzle is complete, congratulate the user.
           if grid1::IsSolved
               invoke type System.Windows.Forms.MessageBox::Show("Congratulations. You have solved the puzzle")
           end-if
       end method.

      *>> <summary>
      *>> Set the text in the status tool strip
      *>> </summary>
      *>> <param name="msg">the status text</param>
       method-id SetStatusText public.
       local-storage section.
       01  status-label   type System.Windows.Forms.ToolStripStatusLabel.
       procedure division using by value msg as string.
           set status-label to statusStrip1::Items[0] as type System.Windows.Forms.ToolStripStatusLabel
           set status-label::Text to msg
       end method.

      *>> <summary>
      *>> Activate template mode.
      *>> </summary>
      *>> <param name="sender"></param>
      *>> <param name="e"></param>
       method-id templateModeToolStripMenuItem_Click final private.
       local-storage section.
       01  menuitem type System.Windows.Forms.ToolStripMenuItem.
       procedure division using by value sender as type System.Object e as type System.EventArgs.
           set menuitem to sender as type System.Windows.Forms.ToolStripMenuItem
           set grid1::TemplateMode  to menuitem::Checked
       end method.

      *>> <summary>
      *>> Activate smart play.
      *>> </summary>
      *>> <param name="sender"></param>
      *>> <param name="e"></param>
       method-id  playObviousCellsToolStripMenuItem_Click final private.
       linkage section.
       01 sender object.
       01 e type System.EventArgs.
       procedure division using by value  sender e.
           invoke  grid1::SmartPlay()
       end method.

      *>> <summary>
      *>> Reduce the sets of possible numbers in the neighbour playing desks.
      *>> </summary>
      *>> <param name="sender"></param>
      *>> <param name="e"></param>
       method-id  btnSmartPlay_Click final private.
       procedure division using by value sender as type System.Object e as type System.EventArgs.
           invoke grid1::SmartPlay()
       end method.

      *>> <summary>
      *>> Clear the last one typed number in the current puzzle game.
      *>> </summary>
      *>> <param name="sender"></param>
      *>> <param name="e"></param>
       method-id  btnUndo_Click final private.
       procedure division using by value sender as type System.Object e as type System.EventArgs.
           invoke grid1::Undo()
       end method.

      *>> <summary>
      *>> Clear all typed numbers in the current puzzle game.
      *>> </summary>
      *>> <param name="sender"></param>
      *>> <param name="e"></param>
       method-id  btnClear_Click final private.
       procedure division using by value sender as type System.Object e as type System.EventArgs.
           invoke grid1::Clear()
       end method.

       method-id statusStrip1_ItemClicked final private.
       procedure division using by value sender as object e as type System.Windows.Forms.ToolStripItemClickedEventArgs.
       end method.

       method-id grid1_Click final private.
       procedure division using by value sender as object e as type System.EventArgs.
       end method.

       end class.

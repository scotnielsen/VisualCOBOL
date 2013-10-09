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
       
       
       01 components type System.ComponentModel.IContainer.
       01 menuStrip1 type System.Windows.Forms.MenuStrip.
       01 fileToolStripMenuItem type System.Windows.Forms.ToolStripMenuItem.
       01 openPuzzleToolStripMenuItem type System.Windows.Forms.ToolStripMenuItem.
       01 savePuzzleToolStripMenuItem type System.Windows.Forms.ToolStripMenuItem.
       01 editToolStripMenuItem type System.Windows.Forms.ToolStripMenuItem.
       01 templateModeToolStripMenuItem type System.Windows.Forms.ToolStripMenuItem.
       01 clearToolStripMenuItem type System.Windows.Forms.ToolStripMenuItem.
       01 viewToolStripMenuItem type System.Windows.Forms.ToolStripMenuItem.
       01 showPossibleValuesToolStripMenu type System.Windows.Forms.ToolStripMenuItem.
       01 openFileDialog1 type System.Windows.Forms.OpenFileDialog.
       01 saveFileDialog1 type System.Windows.Forms.SaveFileDialog.
       01 statusStrip1 type System.Windows.Forms.StatusStrip.
       01 toolStripStatusLabel1 type System.Windows.Forms.ToolStripStatusLabel.
       01 undoToolStripMenuItem type System.Windows.Forms.ToolStripMenuItem.
       01 playObviousCellsToolStripMenuIt type System.Windows.Forms.ToolStripMenuItem.
       01 btnClear type System.Windows.Forms.Button.
       01 btnUndo type System.Windows.Forms.Button.
       01 btnSmartPlay type System.Windows.Forms.Button.
       01 grid1 type CobolDoKu.SudokuGridView.
      
       
       *>> <summary>
       *>> Required method for Designer support - do not modify
       *>> the contents of this method with the code editor.
       *>> </summary>
       method-id InitializeComponent private.
       procedure division.
       set menuStrip1 to new System.Windows.Forms.MenuStrip
       set fileToolStripMenuItem to new System.Windows.Forms.ToolStripMenuItem
       set openPuzzleToolStripMenuItem to new System.Windows.Forms.ToolStripMenuItem
       set savePuzzleToolStripMenuItem to new System.Windows.Forms.ToolStripMenuItem
       set editToolStripMenuItem to new System.Windows.Forms.ToolStripMenuItem
       set templateModeToolStripMenuItem to new System.Windows.Forms.ToolStripMenuItem
       set clearToolStripMenuItem to new System.Windows.Forms.ToolStripMenuItem
       set playObviousCellsToolStripMenuIt to new System.Windows.Forms.ToolStripMenuItem
       set viewToolStripMenuItem to new System.Windows.Forms.ToolStripMenuItem
       set showPossibleValuesToolStripMenu to new System.Windows.Forms.ToolStripMenuItem
       set undoToolStripMenuItem to new System.Windows.Forms.ToolStripMenuItem
       set openFileDialog1 to new System.Windows.Forms.OpenFileDialog
       set saveFileDialog1 to new System.Windows.Forms.SaveFileDialog
       set statusStrip1 to new System.Windows.Forms.StatusStrip
       set toolStripStatusLabel1 to new System.Windows.Forms.ToolStripStatusLabel
       set btnClear to new System.Windows.Forms.Button
       set btnUndo to new System.Windows.Forms.Button
       set btnSmartPlay to new System.Windows.Forms.Button
       set grid1 to new CobolDoKu.SudokuGridView
       invoke menuStrip1::SuspendLayout
       invoke statusStrip1::SuspendLayout
       invoke self::SuspendLayout
      *> 
      *> menuStrip1
      *> 
       invoke menuStrip1::Items::AddRange(fileToolStripMenuItem editToolStripMenuItem viewToolStripMenuItem)
       set menuStrip1::Location to new System.Drawing.Point( 0 0)
       set menuStrip1::Name to "menuStrip1"
       set menuStrip1::Size to new System.Drawing.Size( 472 28)
       set menuStrip1::TabIndex to 2
       set menuStrip1::Text to "menuStrip1"
      *> 
      *> fileToolStripMenuItem
      *> 
       invoke fileToolStripMenuItem::DropDownItems::AddRange(openPuzzleToolStripMenuItem savePuzzleToolStripMenuItem)
       set fileToolStripMenuItem::Name to "fileToolStripMenuItem"
       set fileToolStripMenuItem::Size to new System.Drawing.Size( 44 24)
       set fileToolStripMenuItem::Text to "&File"
      *> 
      *> openPuzzleToolStripMenuItem
      *> 
       set openPuzzleToolStripMenuItem::Name to "openPuzzleToolStripMenuItem"
       set openPuzzleToolStripMenuItem::Size to new System.Drawing.Size( 169 24)
       set openPuzzleToolStripMenuItem::Text to "Open Puzzle..."
       invoke openPuzzleToolStripMenuItem::add_Click(new System.EventHandler(self::openPuzzleToolStripMenuItem_Click))
      *> 
      *> savePuzzleToolStripMenuItem
      *> 
       set savePuzzleToolStripMenuItem::Name to "savePuzzleToolStripMenuItem"
       set savePuzzleToolStripMenuItem::Size to new System.Drawing.Size( 169 24)
       set savePuzzleToolStripMenuItem::Text to "Save Puzzle..."
       invoke savePuzzleToolStripMenuItem::add_Click(new System.EventHandler(self::savePuzzleToolStripMenuItem_Click))
      *> 
      *> editToolStripMenuItem
      *> 
       invoke editToolStripMenuItem::DropDownItems::AddRange(templateModeToolStripMenuItem clearToolStripMenuItem playObviousCellsToolStripMenuIt)
       set editToolStripMenuItem::Name to "editToolStripMenuItem"
       set editToolStripMenuItem::Size to new System.Drawing.Size( 47 24)
       set editToolStripMenuItem::Text to "&Edit"
      *> 
      *> templateModeToolStripMenuItem
      *> 
       set templateModeToolStripMenuItem::CheckOnClick to True
       set templateModeToolStripMenuItem::Name to "templateModeToolStripMenuItem"
       set templateModeToolStripMenuItem::Size to new System.Drawing.Size( 184 24)
       set templateModeToolStripMenuItem::Text to "Template Mode"
       invoke templateModeToolStripMenuItem::add_Click(new System.EventHandler(self::templateModeToolStripMenuItem_Click))
      *> 
      *> clearToolStripMenuItem
      *> 
       set clearToolStripMenuItem::Name to "clearToolStripMenuItem"
       set clearToolStripMenuItem::Size to new System.Drawing.Size( 184 24)
       set clearToolStripMenuItem::Text to "Clear"
       invoke clearToolStripMenuItem::add_Click(new System.EventHandler(self::clearToolStripMenuItem_Click))
      *> 
      *> playObviousCellsToolStripMenuIt
      *> 
       set playObviousCellsToolStripMenuIt::Name to "playObviousCellsToolStripMenuIt"
       set playObviousCellsToolStripMenuIt::Size to new System.Drawing.Size( 184 24)
       set playObviousCellsToolStripMenuIt::Text to "Smart Play"
       invoke playObviousCellsToolStripMenuIt::add_Click(new System.EventHandler(self::playObviousCellsToolStripMenuItem_Click))
      *> 
      *> viewToolStripMenuItem
      *> 
       invoke viewToolStripMenuItem::DropDownItems::AddRange(showPossibleValuesToolStripMenu)
       set viewToolStripMenuItem::Name to "viewToolStripMenuItem"
       set viewToolStripMenuItem::Size to new System.Drawing.Size( 53 24)
       set viewToolStripMenuItem::Text to "&View"
      *> 
      *> showPossibleValuesToolStripMenu
      *> 
       set showPossibleValuesToolStripMenu::CheckOnClick to True
       set showPossibleValuesToolStripMenu::Name to "showPossibleValuesToolStripMenu"
       set showPossibleValuesToolStripMenu::Size to new System.Drawing.Size( 219 24)
       set showPossibleValuesToolStripMenu::Text to "Show Possible Values"
       invoke showPossibleValuesToolStripMenu::add_Click(new System.EventHandler(self::showPossibleValuesToolStripMenu_Click))
      *> 
      *> undoToolStripMenuItem
      *> 
       set undoToolStripMenuItem::Name to "undoToolStripMenuItem"
       set undoToolStripMenuItem::Size to new System.Drawing.Size( 158 22)
       set undoToolStripMenuItem::Text to "Undo"
      *> 
      *> openFileDialog1
      *> 
       set openFileDialog1::DefaultExt to "xml"
       set openFileDialog1::Filter to "XML Files (*.xml)|*.xml"
       set openFileDialog1::Title to "Open Puzzle"
      *> 
      *> saveFileDialog1
      *> 
       set saveFileDialog1::DefaultExt to "xml"
       set saveFileDialog1::Filter to "XML Files (*.xml)|*.xml"
       set saveFileDialog1::Title to "Save Puzzle"
      *> 
      *> statusStrip1
      *> 
       invoke statusStrip1::Items::AddRange(toolStripStatusLabel1)
       set statusStrip1::Location to new System.Drawing.Point( 0 348)
       set statusStrip1::Name to "statusStrip1"
       set statusStrip1::Size to new System.Drawing.Size( 472 22)
       set statusStrip1::TabIndex to 3
       set statusStrip1::Text to "statusStrip1"
       invoke statusStrip1::add_ItemClicked(new System.Windows.Forms.ToolStripItemClickedEventHandler(self::statusStrip1_ItemClicked))
      *> 
      *> toolStripStatusLabel1
      *> 
       set toolStripStatusLabel1::Name to "toolStripStatusLabel1"
       set toolStripStatusLabel1::Size to new System.Drawing.Size( 457 17)
       set toolStripStatusLabel1::Spring to True
      *> 
      *> btnClear
      *> 
       set btnClear::Location to new System.Drawing.Point( 340 38)
       set btnClear::Name to "btnClear"
       set btnClear::Size to new System.Drawing.Size( 100 26)
       set btnClear::TabIndex to 4
       set btnClear::Text to "Clear"
       set btnClear::UseVisualStyleBackColor to True
       invoke btnClear::add_Click(new System.EventHandler(self::btnClear_Click))
      *> 
      *> btnUndo
      *> 
       set btnUndo::Location to new System.Drawing.Point( 340 79)
       set btnUndo::Name to "btnUndo"
       set btnUndo::Size to new System.Drawing.Size( 100 26)
       set btnUndo::TabIndex to 5
       set btnUndo::Text to "Undo"
       set btnUndo::UseVisualStyleBackColor to True
       invoke btnUndo::add_Click(new System.EventHandler(self::btnUndo_Click))
      *> 
      *> btnSmartPlay
      *> 
       set btnSmartPlay::Location to new System.Drawing.Point( 340 128)
       set btnSmartPlay::Name to "btnSmartPlay"
       set btnSmartPlay::Size to new System.Drawing.Size( 100 26)
       set btnSmartPlay::TabIndex to 6
       set btnSmartPlay::Text to "Smart Play"
       set btnSmartPlay::UseVisualStyleBackColor to True
       invoke btnSmartPlay::add_Click(new System.EventHandler(self::btnSmartPlay_Click))
      *> 
      *> grid1
      *> 
       set grid1::BackColor to type System.Drawing.SystemColors::Window
       set grid1::Location to new System.Drawing.Point( 10 38)
       set grid1::Name to "grid1"
       set grid1::SelectCol to 0
       set grid1::SelectRow to 0
       set grid1::ShowHints to False
       set grid1::Size to new System.Drawing.Size( 300 300)
       set grid1::TabIndex to 1
       set grid1::TemplateMode to False
       invoke grid1::add_CellChanged(new CobolDoKu.CellChangeDelegate(self::grid1_CellChanged))
       invoke grid1::add_Click(new System.EventHandler(self::grid1_Click))
      *> 
      *> Form1
      *> 
       set self::ClientSize to new System.Drawing.Size( 472 370)
       invoke self::Controls::Add(btnSmartPlay)
       invoke self::Controls::Add(btnUndo)
       invoke self::Controls::Add(btnClear)
       invoke self::Controls::Add(statusStrip1)
       invoke self::Controls::Add(grid1)
       invoke self::Controls::Add(menuStrip1)
       set self::MainMenuStrip to menuStrip1
       set self::MinimumSize to new System.Drawing.Size( 490 415)
       set self::Name to "Form1"
       set self::Text to "CobolDoKu"
       invoke menuStrip1::ResumeLayout(False)
       invoke menuStrip1::PerformLayout
       invoke statusStrip1::ResumeLayout(False)
       invoke statusStrip1::PerformLayout
       invoke self::ResumeLayout(False)
       invoke self::PerformLayout
       end method.

       *>> <summary>
       *>> Clean up any resources being used.      
       *>> </summary>
       *>> <param name="disposing"></param>
       method-id. Dispose override is protected.
       local-storage section.       
       procedure division using by value disposing as condition-value.
           if disposing then
             if components not = null then
               invoke components::Dispose
             end-if
           end-if.
           invoke super::Dispose(by value disposing).
       end method "Dispose".


       end class.

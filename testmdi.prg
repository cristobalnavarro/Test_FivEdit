//----------------------------------------------------------------------------//
//
// Test implementation MDI enviroment
// Author: Cristobal Navarro
// Date: 28/12/2017
//
// TExplbar.prg
// 
// 
//----------------------------------------------------------------------------//

#include "FiveWin.ch"
#include "splitter.ch"

Static oWndP
Static oWnd
Static oWndCalend
Static oBarMdi
Static oFont
Static oFont1
Static oFont2
Static oExplBar
Static oVSplitL
Static oTitle
Static oPnel2
Static nRow        := 0
Static nCol        := 0
Static nHChild     := 250
Static nWChild     := 400
Static nPosL       := 0
Static nPosVSp     := 360 //331
Static nHSay       := 19
Static nWPanel     := 32
Static lNoPopupH   := .F.
Static lNoPopupV   := .T.
Static cTitPnel    := "TITULO PANEL ( Press Double Click )"
Static cTitWnd     := "TITULO VENTANA"
Static lAdjChild   := .F.

Static oChilds
Static oMnu

//----------------------------------------------------------------------------//

Function Main()

   //EsValidoMail( "gustavo.morenoponce@gmail.com" )
   Main1()
Return nil


Function EsValidoMail( cMail )
local oApi
local cResponse
oApi := CreateObject( "MSXML2.XMLHTTP" )
oApi:Open( "GET", "https://garridodiaz.com/emailvalidator/index.php/?email=" + cMail )
oApi:SetRequestHeader( "Content-Type", "application/json" )
oApi:Send() // cMail )
//Wait( 1 )
SysWait( 1 )
cResponse := oApi:ResponseText()
? cResponse
Return cResponse



Function Main1()

   local oMenu
   local cT
   
   Fw_SetUnicode( .T. )
   
   DEFINE FONT oFont  NAME "Segoe Symbol" SIZE 0, -14 //BOLD
   DEFINE FONT oFont1 NAME "Calibri" SIZE 0, -12 BOLD
   DEFINE FONT oFont2 NAME "Calibri" SIZE 0, -20 NESCAPEMENT 900 BOLD
   //? HB_IS_OF_TYPE( oFont, HB_IT_ARRAY ) //.and. hb_arrayIsObject( oFont )
   //? hb_arrayIsObject( oFont )
   //? hb_FNameMerge( cFilePath( hb_argv( 0 ) ), cFileNoExt( hb_argv( 0 ) ), ".ppp" )
   //? TimeToSec( Time() )
   //cT := DateTime()
   //? Right( TTos( cT ), Len( TTos( cT ) ) - 9 ) 
   //? GETDROPSHADOW()
   //SETDROPSHADOW( 1 )

   DEFINE WINDOW oWnd STYLE WS_POPUP COLORS 0, CLR_HGRAY

   @ 2, 1 SAY oTitle PROMPT cTitWnd OF oWnd ;
      SIZE nPosVSp + 11, nHSay PIXEL FONT oFont CENTER COLOR CLR_BROWN, CLR_WHITE

   DEFINE MSGBAR OF oWnd PROMPT "Sample MDI"
   
   //oWnd:oLeft  := oExplBar
   ACTIVATE WINDOW oWnd MAXIMIZED ;
      ON INIT ( HazExplorerBar(), ;
                HazMdi(), HazSplit(), oExplBar:Show(), nPosL := oWndCalend:nLeft ) ;
      VALID ( SendMessage( oWndCalend:hWnd, WM_CLOSE ), .T. )

   RELEASE FONT oFont
   RELEASE FONT oFont1
   RELEASE FONT oFont2

   //SETDROPSHADOW( 0 )

return nil

//----------------------------------------------------------------------------//

Function HazSplit()

   local oBrush

   DEFINE BRUSH oBrush FILE "..\bitmaps\spiral.bmp"

   @ 24, nPosVSp SPLITTER oVSplitL ;
        VERTICAL ;
        PREVIOUS CONTROLS oTitle, oExplBar ;
        HINDS CONTROLS oWndCalend:oWndClient ;
        LEFT MARGIN 2 ;
        RIGHT MARGIN 2 ;
        SIZE 12, ScreenHeight() - 1 - 23;
        COLOR CLR_GRAY PIXEL ;
        OF oWnd ;
        ON CHANGE ( oWndCalend:SetSize( oWndCalend:nWidth + ( nPosL - ( oVSplitL:nRight + 2 ) ), ;
                    oWnd:nHeight - 26 ), ;
                    oWndCalend:Move( 3, oVSplitL:nRight + 2 ), ;
                    AEVal( oWndCalend:oWndClient:aWnd, ;
                    { | w | w:Move( w:nTop, w:nLeft ), ;
                            w:SetSize( w:nWidth, w:nHeight ) } ), ;
                            nPosL := oVSPlitL:nRight + 2 )
                            //Para ajustar proporcionalmente el ancho de las childs al mover el splitter
                            //w:SetSize( w:nWidth + ( nPosL - ( oVSplitL:nRight + 2 ) ), w:nHeight ) } ), ;
   
   oVSplitL:SetBrush( oBrush )
   RELEASE BRUSH oBrush   

Return nil

//----------------------------------------------------------------------------//

Function HazExplorerBar()

   local aPnels := {}
   local lHide  := .T.
   local nPanel
   local nItem
   local oSay
   local bClick  := { | o | MsgInfo( o:GetText() ) }
   local bClick1 := { | o | MnuButton( , , , o ) }
   Local aGrad   := { { CLR_WHITE, METRO_OLIVE },;
                     { CLR_WHITE, METRO_OLIVE } }
   local oBrush
   Local aGrad1 := { { 0.5, METRO_OLIVE, CLR_HGRAY },;
                     { 0.5, CLR_HGRAY, METRO_OLIVE } }

   DEFINE BRUSH oBrush GRADIENT aGrad1

   oExplBar := TExplorerBar():New( nHSay + 3, 1, nPosVSp - 1, oWnd:nHeight() - 2, oWnd, , , , , , , )
   //oExplBar:lAlignToPanel := .T.
   //oExplBar:nTopColor     := CLR_WHITE
   //oExplBar:nBottomColor  := CLR_WHITE
   oExplBar:nTopColor     := Rgb( 240, 240, 240 )
   oExplBar:nBottomColor  := aGrad[ 1 ][ 2 ]
   oExplBar:Hide()
   AAdd( aPnels, oExplBar:AddPanel( "DATABASES", "D:\Fwh\FwhTeam\BmpsVS_32\CrashDumpFile_32x_24.Bmp", , 40, 0, aGrad, oFont, CLR_WHITE, CLR_WHITE ) )
   WITH OBJECT Atail( aPnels ) //oPanel1
      //:nOffSetX        := 100
      :nClrTextSpecial := CLR_WHITE
      :nClrHover       := Rgb( 0, 0, 0 ) //RGB( 66, 142, 255 )
      :nOffSetY        := 12
      :LoadBitmaps( 1, "D:\Fwh\FwhTeam\BmpsVS_32\CheckOut_16x_32.bmp" )
      :LoadBitmaps( 2, "D:\Fwh\FwhTeam\BmpsVS_32\CheckIn_16x_32.bmp" )
      :nTopMargin      := 1
      :nLeftMargin     := nWPanel + 22
      :nRightMargin    := 10
      :nLeft           := aPnels[ 1 ]:nLeftMargin
      :nRight          := oWnd:nWidth - aPnels[ 1 ]:nRightMargin
      //:AddLink( { || Str( Seconds() ) }, bClick, "D:\Fwh\FwhTeam\BmpsVS_32\DatabaseRun_16x_32.bmp", , METRO_OLIVE, , ) //"Open",
      :AddLink( "Explorer", bClick1, "D:\Fwh\FwhTeam\BmpsVS_32\DatabaseAuditSpecification_16x_32.bmp", , METRO_STEEL, , )
      :AddLink( "Explorer", bClick1, 0xE101, , METRO_OLIVE, , )
      :AddLink( "Structure", bClick, "D:\Fwh\FwhTeam\BmpsVS_32\Databar_16x_32.Bmp", , METRO_OLIVE, , )
      :AddLink( "Tools", bClick, "D:\Fwh\FwhTeam\BmpsVS_32\DatabaseOptions_12882_32.bmp", , METRO_OLIVE, , )
      :AddLink( "Close", bClick1, "D:\Fwh\FwhTeam\BmpsVS_32\DatabaseOffline_16x_32.bmp", , METRO_OLIVE, , )
   END

   WITH OBJECT oExplBar
      AAdd( aPnels, :AddPanel( "TOOLS", "D:\Fwh\FwhTeam\BmpsVS_32\DataMiningStructure_32x_24.bmp", , 40, 0, aGrad, oFont, CLR_WHITE, CLR_WHITE ) )
      AAdd( aPnels, :AddPanel( "EDITOR",   "D:\Fwh\FwhTeam\BmpsVS_32\FrameworkDesignStudio_32x_24.bmp", , 40, 0, aGrad, oFont, CLR_WHITE, CLR_WHITE  ) )
      AAdd( aPnels, :AddPanel( "EXPLORER", "D:\Fwh\FwhTeam\BmpsVS_32\FileDialogReport_32x_24.bmp", , 40, 0, aGrad, oFont, CLR_WHITE, CLR_WHITE  ) )
      AAdd( aPnels, :AddPanel( "EXP./IMPORT", "D:\Fwh\FwhTeam\BmpsVS_32\GetTextFormat_32x_24.Bmp", , 40, 0, aGrad, oFont, CLR_WHITE, CLR_WHITE  ) )
      AAdd( aPnels, :AddPanel( "USERS", "D:\Fwh\FwhTeam\BmpsVS_32\LookupPrincipal_32x_24.bmp", , 40, 0, aGrad, oFont, CLR_WHITE, CLR_WHITE  ) )
      For nPanel := 2 to Len( aPnels )
         WITH OBJECT :aPanels[ nPanel ]
            //:lSpecial        := .T.
            //:nOffSetX        := 60
            :lCollapsed      := .T.
            :LoadBitmaps( 1, "D:\Fwh\FwhTeam\BmpsVS_32\CheckOut_16x_32.bmp" )
            :LoadBitmaps( 2, "D:\Fwh\FwhTeam\BmpsVS_32\CheckIn_16x_32.bmp" )
            :nClrTextSpecial := CLR_WHITE
            :nClrHover       := Rgb( 0, 0, 0 )
            :nTopMargin      := 1
            :nLeftMargin     := nWPanel + 22
            :nRightMargin    := 1
            :nLeft           := :nLeftMargin
            :nRight          := oWnd:nWidth - :nRightMargin
            :nHeight         := :nTitleHeight
         END
         For nItem := nPanel + 1 To Len( :aPanels )
           :aPanels[ nItem ]:nTop -= ( :aPanels[ nPanel ]:nBodyHeight )
         Next
      Next
      :CheckScroll()
   END WITH
   
   //#define CLR_DIALOGS RGB( 123, 140, 223 )
   //oPanel   := TScrollPanel():New( 112, 240, 380, 600, oDlg, .T. )
   //oPanel:SetColor( CLR_WHITE, CLR_DIALOGS )
   WITH OBJECT ( oPnel2 := TPanel():New( 0, 0, 0, nWPanel, oExplBar ) )
      :SetColor( 0, CLR_WHITE ) //METRO_OLIVE )
      //:SetBrush( oBrush )
      :nAlign  := 3
      WndHeight( :hWnd, :nHeight + 2 )
      :bPainted   := { | o | HazSayPnel() }
      :bLDblClick := { | o | lHide := !lHide, ;
                             oVSplitL:SetPosition( if( !lHide, nWPanel + 1, nPosVSp ) ), ;
                             Eval( oVSplitL:bChange ), ;
                             oVSplitL:Adjust(), oWndCalend:Refresh() }
   END WITH

   RELEASE BRUSH oBrush

Return nil

//----------------------------------------------------------------------------//

Function HazMdi()

   local oBrush
   Local aGrad  := { { 0.5, CLR_WHITE, METRO_OLIVE },;
                     { 0.5, METRO_OLIVE, CLR_WHITE } }

   DEFINE BRUSH oBrush GRADIENT aGrad

   DEFINE WINDOW oWndCalend MDI OF oWnd STYLE WS_POPUP ;
      FROM 3, nPosVSp + 12 TO oWnd:nHeight - 26, oWnd:nWidth - 4 ;
      PIXEL COLOR CLR_BLUE, CLR_HGRAY MENU MyMenu() MENUINFO 0 //BRUSH oBrush

   if lNoPopupH 
      nWChild := Int( oWndCalend:nWidth / 5 )
   endif

   ACTIVATE WINDOW oWndCalend ;
      ON INIT ( HazBar() ) ;
      ON RESIZE ( ; //if( !Empty( oVSplitL ), oVSplitL:Adjust(), ), ;
                     WndTop( oWndCalend:oWndClient:hWnd, oBarMdi:nBottom ),;
                     WndLeft( oWndCalend:oWndClient:hWnd, ;
                        if( !Empty( oVSplitL ), oVSplitL:nRight + 1, 0 ) ), ;//nPosVSp + 12 ) ),;
                     WndWidth( oWndCalend:oWndClient:hWnd, oWnd:nWidth - ; //oExplBar:nWidth - 12 ), ;
                        if( !Empty( oVSplitL ), oVSplitL:nRight + 1, nPosVSp + 12 ) ), ;
                     oWndCalend:SetMenu( oWndCalend:oMenu ) ) //, ;

Return nil

//----------------------------------------------------------------------------//

Function HazBar()

   DEFINE BUTTONBAR oBarMdi OF oWndCalend SIZE 104, 64 2015 NOBORDER  HEIGHT 88

   DEFINE BUTTON OF oBarMdi PROMPT "Create" ;
      FILE "D:\Fwh\FwhTeam\BmpsVS_32\CPPHubApplication_32x_24.bmp" ;
      LEFT ACTION ( WindowChild() ) ;
      GROUP LABEL "Child" COLORS CLR_WHITE, METRO_OLIVE

   DEFINE BUTTON OF oBarMdi ;
      FILE "D:\Fwh\FwhTeam\BmpsVS_32\Uninstall_32x_24.bmp" ;
      ACTION ( MsgInfo( oWndCalend:oWndClient:nLeft ) ) ;
      GROUP LABEL "Others Actions" COLORS CLR_WHITE, METRO_OLIVE

   DEFINE BUTTON OF oBarMdi ;
      FILE "D:\Fwh\FwhTeam\BmpsVS_32\UMLModelFile_32x_24.bmp" ;
      ACTION ( oExplBar:aPanels[ 1 ]:aControls[ 1 ]:Refresh() ) //MsgInfo( oWndCalend:ClassName() ) )

   DEFINE BUTTON OF oBarMdi ;
      FILE "D:\Fwh\FwhTeam\BmpsVS_32\TestSuiteStatic_32x_24.bmp" ;
      ACTION ( MsgInfo( oWndCalend:oWndActive:ClassName() ) )

   DEFINE BUTTON OF oBarMdi ;
      FILE "D:\Fwh\FwhTeam\BmpsVS_32\SourceControlSites_32x_24.bmp" ;
      ACTION ( MsgInfo( Len( oWndCalend:oWndClient:aWnd ) ) )

   DEFINE BUTTON OF oBarMdi PROMPT "Exit" ;
      FILE "D:\Fwh\FwhTeam\BmpsVS_32\MappedTracepointDisable_32x_24.bmp" ;
      ACTION ( oWnd:End() ) BTNRIGHT ;
      GROUP LABEL "Salir" COLORS CLR_WHITE, METRO_OLIVE

Return oBarMdi

//----------------------------------------------------------------------------//

Function MyMenu()

   local oMenu

   MENU oMenu FONT oFont 2015 COLORMENU CLR_WHITE, CLR_BROWN
      MENUITEM "Option &1" FILE "D:\Fwh\FwhTeam\BmpsVS_32\PreviousBookmarkFolder_16x_32.bmp"
         MENU
            MENUITEM { || AllTrim( Str( Seconds() ) ) } FILE "D:\Fwh\FwhTeam\BmpsVS_32\SQLLibrary_16x_32.bmp"
            SEPARATOR
            MENUITEM "Item 12" FILE "D:\Fwh\FwhTeam\BmpsVS_32\SlicersHorizontal_16x_32.bmp"
            MENUITEM "Item 13" FILE "D:\Fwh\FwhTeam\BmpsVS_32\SlicersVertical_16x_32.bmp"
            SEPARATOR
            MENUITEM "Item 14" FILE "D:\Fwh\FwhTeam\BmpsVS_32\SkinFile_16x_32.bmp"
            SEPARATOR
            MENUITEM "Item 15" FILE "D:\Fwh\FwhTeam\BmpsVS_32\SiteConnectionURL_32.bmp"
            MENUITEM "&Exit"     ACTION oWnd:End()
         ENDMENU
      MENUITEM "Option &2"  FILE "D:\Fwh\FwhTeam\BmpsVS_32\PhoneNumberViewer_16x_32.bmp"
         MENU
            MENUITEM "Item 21" FILE "D:\Fwh\FwhTeam\BmpsVS_32\RunTests_8790_32.bmp"
            //MENUITEM "Item 22" FILE "D:\Fwh\FwhTeam\BmpsVS_32\ResultstoText_9948_32.bmp"
            //SEPARATOR
            //MENUITEM "Item 23" FILE "D:\Fwh\FwhTeam\BmpsVS_32\ReformatSelection_16x_32.bmp"
            //MENUITEM "Item 24" FILE "D:\Fwh\FwhTeam\BmpsVS_32\PYWeb_16x_32.bmp"
         ENDMENU
      //oMenu:AddMdi( , "D:\Fwh\FwhTeam\BmpsVS_32\FolderBrowserDialogControl_678_32.bmp")
      //oMenu:AddHelp("Test Fivewin MDI Enviroment", "Cristobal Navarro - 2017", , ;
      //              "D:\Fwh\FwhTeam\BmpsVS_32\HelpApplication_16x_32.bmp", , .F. )
      //MENUITEM oChilds PROMPT "Childs"
      //MENU oMnu
      //     SEPARATOR
      //ENDMENU

   ENDMENU

Return oMenu

//----------------------------------------------------------------------------//

Function MnuButton( nR, nC, nF, oParent )

   local oMenu
   local aCoors
   DEFAULT nR   := oParent:nBottom
   DEFAULT nC   := oParent:nRight
   aCoors       := ScreenToClient( oParent:hWnd, { nR, nC } )
   MENU oMenu POPUP FONT oFont 2015 ;
      COLORMENU CLR_WHITE, CLR_BROWN
      MENUITEM "Option &1" FILE "D:\Fwh\FwhTeam\BmpsVS_32\PreviousBookmarkFolder_16x_32.bmp"
         MENU
            MENUITEM { || AllTrim( Str( Seconds() ) ) } FILE "D:\Fwh\FwhTeam\BmpsVS_32\SQLLibrary_16x_32.bmp"
            SEPARATOR
            MENUITEM "Item 12" FILE "D:\Fwh\FwhTeam\BmpsVS_32\SlicersHorizontal_16x_32.bmp"
            MENUITEM "Item 13" FILE "D:\Fwh\FwhTeam\BmpsVS_32\SlicersVertical_16x_32.bmp"
         ENDMENU
      MENUITEM "Option &2"  FILE "D:\Fwh\FwhTeam\BmpsVS_32\PhoneNumberViewer_16x_32.bmp"
         MENU
            MENUITEM "Item 21" FILE "D:\Fwh\FwhTeam\BmpsVS_32\RunTests_8790_32.bmp"
            MENUITEM "Item 22" FILE "D:\Fwh\FwhTeam\BmpsVS_32\ResultstoText_9948_32.bmp"
            SEPARATOR
            MENUITEM "Item 23" FILE "D:\Fwh\FwhTeam\BmpsVS_32\ReformatSelection_16x_32.bmp"
            MENUITEM "Item 24" FILE "D:\Fwh\FwhTeam\BmpsVS_32\PYWeb_16x_32.bmp"
         ENDMENU
   ENDMENU
   ACTIVATE MENU oMenu AT aCoors[ 1 ] + oParent:nHeight, oParent:nRight OF oParent
   //aCoors[ 2 ] + oParent:nWidth OF oParent

Return oMenu

//----------------------------------------------------------------------------//

#define WS_EX_TOOLWINDOW         0x00000080
#define GWL_EXSTYLE                   -20
#define GWL_STYLE                     -16
//#define WS_EX_DLGMODALFRAME      0x00000001
#define WS_EX_LAYERED            0x00080000
#define WS_EX_STATICEDGE         0x00020000
//#define WS_EX_ACCEPTFILES        0x00000010
#define WS_EX_MDICHILD           0x00000040
#define WS_EX_COMPOSITED         0x02000000
#define WS_EX_CLIENTEDGE         0x00000200
#define WS_EX_WINDOWEDGE         0x00000100
#define WS_EX_NOINHERITLAYOUT    0x00100000
#define WS_EX_OVERLAPPEDWINDOW   WS_EX_WINDOWEDGE, WS_EX_CLIENTEDGE

#define SWP_DRAWFRAME            0x0020
#define SWP_FRAMECHANGED         0x0020
#define SWP_NOACTIVATE           0x0010
#define SWP_NOMOVE               0x0002
#define SWP_NOSIZE               0x0001
#define SWP_NOZORDER             0x0004


//----------------------------------------------------------------------------//

function WindowChild()

   local oWndChild
   local oFolder, oSay, oSay1
   local x
   local nPosR  := 0
   local nPosC  := 0
   local oCursor
   local oImage

   //DEFINE CURSOR oCursor WAIT //HAND //WAIT
   DEFINE WINDOW oWndChild MDICHILD OF oWndCalend ;
      FROM nRow + 1 , nCol TO nHChild, nWChild PIXEL ; 
      ; //NOSYSMENU ; //BORDER NONE ; //NOCAPTION ;
      COLOR CLR_WHITE, METRO_OLIVE
   
   //BRUSH oWndCalend:oBrush  // NOCAPTION

   //@ 0, 0 FOLDER oFolder OF oWndChild
   @ 1, 1 XIMAGE oImage SIZE 50, 50 ;
      OF oWndChild SOURCE "ejemplo.png" NOBORDER //aImages[ 2 ][ 2 ] //oBrw:aRow[ 2 ]  //

   //oWndChild:oClient := oFolder
   //oImage:oCursor    := oCursor

   //SetWindowLong( oWndChild:hWnd, -16, "L" )
   //oWndChild:Center( oWndCalend:hWnd )
   //WndCenter( oWndChild:hWnd, oWndCalend:oWndClient:hWnd )

#define WS_EX_NOREDIRECTIONBITMAP  0x00200000

   SetWindowLong( oWndChild:hWnd, GWL_EXSTYLE,;
                  nOr( GetWindowLong( oWndChild:hWnd, GWL_EXSTYLE ), ;
                       WS_EX_TOOLWINDOW, WS_EX_COMPOSITED, WS_EX_NOINHERITLAYOUT ) ) //, ; // , WS_SYSMENU

//                       WS_EX_TOOLWINDOW, WS_EX_COMPOSITED, WS_EX_MDICHILD, WS_EX_WINDOWEDGE, WS_EX_CLIENTEDGE ) ) //, WS_EX_NOINHERITLAYOUT ) ) //, ; // , WS_SYSMENU
   //                  , WS_EX_NOREDIRECTIONBITMAP
   //                  , WS_EX_DLGMODALFRAME
   //                  , WS_EX_WINDOWEDGE, WS_EX_CLIENTEDGE ) )
   //                  , WS_CLIPCHILDREN
   //                  , WS_CLIPSIBLINGS
   //                  , WS_POPUPWINDOW
   //                  , WS_THICKFRAME
   //                  , WS_EX_STATICEDGE
   //                  , WS_EX_MDICHILD

   //


/*
#define CS_NOCLOSE   0x0200
   SetWindowLong( oWndChild:hWnd, -16, ;
                  nOr( GetWindowLong( oWndChild:hWnd, GWL_STYLE ), CS_GLOBALCLASS ) )
*/
                  //    , WS_CHILDWINDOW ) )
                  //    , WS_THICKFRAME ) )
                  //    , WS_SYSMENU ) )
                  //    , WS_POPUPWINDOW ) )
                  //    , WS_OVERLAPPEDWINDOW ) )
                  //    , WS_OVERLAPPED ) )
                  //    , WS_DLGFRAME ) )
                  //    , WS_BORDER ) )
   //                   , CS_OWNDC ) )
   //                   , CS_PARENTDC ) )
   //                   , CS_NOCLOSE ) )
   //                   , CS_GLOBALCLASS ) )

   //SetWindowLong( oWndChild:hWnd, GWL_STYLE, ;
   //               nOr( GetWindowLong( oWndChild:hWnd, GWL_STYLE ), WS_MINIMIZEBOX, WS_MAXIMIZEBOX ) )

   //SetWindowPos( oWndChild:hWnd, NIL, 0, 0, 0, 0, nOr( SWP_NOMOVE, SWP_NOSIZE, SWP_NOZORDER, SWP_FRAMECHANGED ) )  // SWP_NOACTIVATE, 

   ACTIVATE WINDOW oWndChild ;
      ON INIT ( SetWindowPos( oWndChild:hWnd, NIL, 0, 0, 0, 0, nOr( SWP_NOMOVE, SWP_NOSIZE, SWP_NOZORDER, SWP_FRAMECHANGED ) ), ;  //SWP_NOACTIVATE, 
                oWndChild:cToolTip := oWndChild:cCaption, ;
                oWndChild:SetSize(), ;
                AddChildPrompt() ) ;
      ON MOVE ( oWndChild:CoorsUpdate(), ;
                if( oWndChild:nLeft < 1, oWndChild:Move( oWndChild:nTop, 0 ), ), ;
                if( oWndChild:nTop  < 2, ( oWndChild:Move( 1, oWndChild:nLeft ), oBarMdi:Refresh() ), ) )

return oWndChild

//----------------------------------------------------------------------------//

Function HazSayPnel()

   oPnel2:Say( Int( oPnel2:nHeight / 2 ) - Int( Len( cTitPnel ) ), 1, ;
               cTitPnel, METRO_OLIVE, , oFont2, .T., .T. )  //CLR_WHITE

Return nil

//----------------------------------------------------------------------------//

Function AddChildPrompt()

   local oMnu

   if Len( oWndCalend:oWndClient:aWnd ) = 1
      //MENUITEM "Primera" OF oMnu
      //oChilds:aMenuItems := {}
      //MENU oMnu OF oChilds
      //ENDMENU
      //MenuAddItem( "Primera", , , , {|oMenuItem| oWndCalend:oWndClient:aWnd[ 1 ]:SetFocus() },;
      //       , , oMnu, , , ,;
      //       , , , , , , .F., , , , , , , , , , , ;
      //       , ,,,,, , , , , , , , , , , , , )
      CreaMenuChilds()

   endif


Return nil

//----------------------------------------------------------------------------//

Function CreaMenuChilds()

      //? Len( oWndCalend:oMenu:aMenuItems )
      //oChilds := MenuAddItem( "Childs", , , , { |oMenuItem| oMnu },;
      //       , , oWndCalend:oMenu, , , ,;
      //       , , , , , , .F., , , , , , , , , , , ;
      //       , ,,,,, , , , , , , , , , , , , )

      MENUITEM oChilds PROMPT "Childs" OF oWndCalend:oMenu
      MENU oMnu
         MENUITEM "Primera"
      ENDMENU
      //? Len( oWndCalend:oMenu:aMenuItems )
Return oChilds

//----------------------------------------------------------------------------//

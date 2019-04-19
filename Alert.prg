// FiveWin Clipper Alert replacement

#include "FiveWin.ch"

//-----------------------------------------------------------------//

function Main()

   local nOption

   nOption = Alert( "take an option",;
                    { "&One", "&Two", "T&hree" },;
                    "Please, select" )

   MsgInfo( nOption )

return nil

//-----------------------------------------------------------------//

procedure AppSys  // XBase++ requirement

return

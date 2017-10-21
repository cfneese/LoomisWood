#pragma rtGlobals = 1			// Use modern global access method.
#pragma IgorVersion = 5.02
#pragma Version = 2.01

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Welcome to the Loomis-Wood Igor Add-In.
//
// To use the Loomis-Wood Igor Add-In:
//
//
//		**********		Do either A or B:		**********
//
// 1A.	Copy this file to the "User Procedures" subfolder of the IGOR program folder.
//		The path for the "User Procedures" folder is usually something like:
//			"C:\Program Files\WaveMetrics\Igor Pro Folder\User Procedures"
//
// 2A.	Open the procedure window of your IGOR experiment.  (Press Ctrl-M)
//		Add the line #include "LoomisWood" to the top of the procedure window
// 		This will create a "Loomis-Wood" menu and make availible all of the prodecures
//		associated with this Add-In.
//
//		**********		OR		**********
//
// 1B.	If you want the Loois-Wood IGOR Add-In to be availible automatically,
//		then create a Shortcut to this procedure file (LoomisWood.ipf) in the
//		"Igor Procedures" subfolder of the IGOR program folder.
//		The path for the "Igor Procedures" folder is usually something like:
//			"C:\Program Files\WaveMetrics\Igor Pro Folder\Igor Procedures"
//
// Changes since Version 1.00:
//
// Version 2.00
// 1.  No longer dependant on SetWindowExt XOP.
// 2.  Currently does not respond to mouse wheel or mouse double click events, because of above change.
//
// Version 2.01
// 1.  Colors are no longer based on the Integer2Color function and the Rainbow color table, but a RGB color wave M_Colors in the Loomis-wood Folder.
// 2.  The Control Bar in Loomis-Wood Plot is now a sub-window.
// 3.  Added zoom
// 4.  Assignments are now databased by two text waves:  Peak_Series and Series_Data.
//      This change eliminates the need for MAX_DUP_ASSIGN and allows the same line to be assigned multiple times without wasting memory.
//      This change also improves the performance of many operations, since assignment info is availible by peak or by series, instead of just by peak.
// 5.  Improved Error Handling of FitSeries.  Changed output of FitSeries to string, instead of simply printing results to history.
// 6.  Implemented an Undo Last Fit Command...  
// 7.  Made sure all Make commands specify precision explicitly, since some installations may default to single precision instead of double precision.

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Global constants
//ROOT_FOLDER and BASE_FOLDER must NOT end with a ":".
//ROOT_FOLDER and BASE_FOLDER should be full paths.
//ROOT_FOLDER must be a subfolder of root:
//BASE_FOLDER must be identical to ROOT_FOLDER, or a subfolder of ROOT_FOLDER
static strconstant ROOT_FOLDER = "root:LoomisWood"
static strconstant BASE_FOLDER = "root:LoomisWood"

static constant FIVEMAX_PEAKS_PER_PLOT = 10000
static constant MAX_QN = 8
static constant MAX_FIT_ORDER = 7
//static constant MAX_DUP_ASSIGN = 8
static constant MAX_M = 10000
//static constant MAX_IT = 100 
//static constant M_ACC = 0.001

static constant TOP_BAR_HEIGHT = 60
//static constant LEFT_BAR_HEIGHT = 0
//static constant BOTTOM_BAR_HEIGHT = 0
//static constant RIGHT_BAR_HEIGHT = 0

// Igor Event Codes
static constant EC_Activate = 0
static constant EC_Deactivate = 1
static constant EC_Kill = 2
static constant EC_MouseDown = 3
static constant EC_MouseMoved = 4
static constant EC_MouseUp = 5
static constant EC_Resize = 6
static constant EC_CursorMoved = 7
static constant EC_Modified = 8
static constant EC_EnableMenu = 9
static constant EC_Menu = 10
static constant EC_Keyboard = 11

 //
// Virtual Keys, Standard Set
// Modifed from winuser.h in the Windows API
// Changed 07/06/2004 to reflect new Igor SetWindow hook

//The following don't occur as normal keyup and keydown events
//Static Constant VK_LBUTTON	=  0x01	//Left Mouse Button
//Static Constant VK_RBUTTON	=  0x02	//Right Mouse Button
//Static Constant VK_CANCEL	=  0x03	//Ctrl-Break
//Static Constant VK_MBUTTON	=  0x04 	//Middle Mouse Button

Static Constant VK_BACK = 0x08	//Backspace
Static Constant VK_TAB =  0x09

Static Constant VK_CLEAR =  0x0C	//Numeric keypad 5 with Num Lock OFF
Static Constant VK_RETURN =  0x0D

//Static Constant VK_SHIFT = 0x10
//Static Constant VK_CONTROL	=  0x11
//Static Constant VK_MENU =  0x12	//Alt
//Static Constant VK_PAUSE =  0x13
//Static Constant VK_CAPITAL	=  0x14	//Caps Lock

//Static Constant VK_KANA =  0x15
//Static Constant VK_HANGUL	=  0x15
//Static Constant VK_JUNJA =  0x17
//Static Constant VK_FINAL =  0x18
//Static Constant VK_HANJA =  0x19
//Static Constant VK_KANJI =  0x19

Static Constant VK_ESCAPE =  0x1B

//Static Constant VK_CONVERT =  0x1C
//Static Constant VK_NONCONVERT =  0x1D
//Static Constant VK_ACCEPT =  0x1E
//Static Constant VK_MODECHANGE =  0x1F

Static Constant VK_SPACE =  0x20
Static Constant VK_PRIOR =  0x0B	//Page Up
Static Constant VK_NEXT = 0x0C	//Page Down
Static Constant VK_END =  0x04
Static Constant VK_HOME =  0x01
Static Constant VK_LEFT =  0x1C
Static Constant VK_UP =  0x1E
Static Constant VK_RIGHT =  0x1D
Static Constant VK_DOWN =  0x1F

//Static Constant VK_SELECT =  0x29
//Static Constant VK_PRINT =  0x2A
//Static Constant VK_EXECUTE	=  0x2B
//Static Constant VK_SNAPSHOT =  0x2C	//Print Screen
//Static Constant VK_INSERT =  0x2D
Static Constant VK_DELETE =  0x7F
//Static Constant VK_HELP = 0x2F

Static Constant VK_0 =  0x30
Static Constant VK_1 =  0x31
Static Constant VK_2 =  0x32
Static Constant VK_3 = 0x33
Static Constant VK_4 =  0x34
Static Constant VK_5 = 0x35
Static Constant VK_6 = 0x36
Static Constant VK_7 = 0x37
Static Constant VK_8 = 0x38
Static Constant VK_9 = 0x39

Static Constant VK_A = 0x61
Static Constant VK_B = 0x62
Static Constant VK_C = 0x63
Static Constant VK_D = 0x64
Static Constant VK_E = 0x65
Static Constant VK_F = 0x66
Static Constant VK_G = 0x67
Static Constant VK_H = 0x68
Static Constant VK_I = 0x69
Static Constant VK_J = 0x6A
Static Constant VK_K = 0x6B
Static Constant VK_L = 0x6C
Static Constant VK_M = 0x6D
Static Constant VK_N = 0x6E
Static Constant VK_O = 0x6F
Static Constant VK_P = 0x70
Static Constant VK_Q = 0x71
Static Constant VK_R = 0x72
Static Constant VK_S = 0x73
Static Constant VK_T = 0x74
Static Constant VK_U = 0x75
Static Constant VK_V = 0x76
Static Constant VK_W = 0x77
Static Constant VK_X = 0x78
Static Constant VK_Y = 0x79
Static Constant VK_Z = 0x7A

//Static Constant VK_LWIN = 0x5B
//Static Constant VK_RWIN = 0x5C
//Static Constant VK_APPS = 0x5D

//Static Constant VK_NUMPAD0 = 0x60
//Static Constant VK_NUMPAD1 = 0x61
//Static Constant VK_NUMPAD2 = 0x62
//Static Constant VK_NUMPAD3 = 0x63
//Static Constant VK_NUMPAD4 = 0x64
//Static Constant VK_NUMPAD5 = 0x65
//Static Constant VK_NUMPAD6 = 0x66
//Static Constant VK_NUMPAD7 = 0x67
//Static Constant VK_NUMPAD8 = 0x68
//Static Constant VK_NUMPAD9 = 0x69
Static Constant VK_MULTIPLY = 0x2A
Static Constant VK_ADD = 0x2B
Static Constant VK_SEPARATOR = 0x2E
Static Constant VK_SUBTRACT = 0x2D
Static Constant VK_DECIMAL = 0x6E
Static Constant VK_DIVIDE = 0x6F
Static Constant VK_F1 = 0x70
Static Constant VK_F2 = 0x71
Static Constant VK_F3 = 0x72
Static Constant VK_F4 = 0x73
Static Constant VK_F5 = 0x74
Static Constant VK_F6 = 0x75
Static Constant VK_F7 = 0x76
Static Constant VK_F8 = 0x77
Static Constant VK_F9 = 0x78
Static Constant VK_F10 = 0x79
Static Constant VK_F11 = 0x7A
Static Constant VK_F12 = 0x7B
//Static Constant VK_F13 = 0x7C
//Static Constant VK_F14 = 0x7D
//Static Constant VK_F15 = 0x7E
//Static Constant VK_F16 = 0x7F
//Static Constant VK_F17 = 0x80
//Static Constant VK_F18 = 0x81
//Static Constant VK_F19 = 0x82
//Static Constant VK_F20 = 0x83
//Static Constant VK_F21 = 0x84
//Static Constant VK_F22 = 0x85
//Static Constant VK_F23 = 0x86
//Static Constant VK_F24 = 0x87

Static Constant VK_NUMLOCK = 0x90
Static Constant VK_SCROLL = 0x91	//Scroll Lock


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// String Table (Makes translation/corrections easier)
// NOTE: There are also strings in the Menu "Loomis-Wood" command  below
static strconstant LW_TITLE = "Loomis-Wood"
static strconstant LW_STRING1 = "Name of New Loomis Wood Folder:  "
static strconstant LW_STRING2 = "Wave containing peak frequencies:"
static strconstant LW_STRING3 = "Wave containing peak intensities:"
static strconstant LW_STRING4 = "Wave containing peak widths:"
static strconstant LW_STRING5 = "Intensity for all peaks:"
static strconstant LW_STRING6 = "Width for all peaks:"
static strconstant LW_STRING7 = "\" is not an availible name.  Do you wish to use \""
static strconstant LW_STRING8 = "\" instead?"
static strconstant LW_STRING9 = "Loomis Wood Folder to Delete:"
static strconstant LW_STRING10 = "Series Name: (cannot contain \";\")"
static strconstant LW_STRING11 = "Series Color:"
static strconstant LW_STRING12 = "Select a Series:"
static strconstant LW_STRING13 = "Series to delete:"
static strconstant LW_STRING14="the Shift:"
static strconstant LW_STRING15="Maximum m:"
static strconstant LW_STRING16="Minimum m:"
static strconstant LW_STRING17 = "Loomis-Wood Folder:"
static strconstant LW_STRING18 = "Name of New Plot Folder:"
static strconstant LW_STRING19 = "The waves, \""
static strconstant LW_STRING20 = "\", have different dimensions.  If you choose to continue, Loomis-Wood will use truncated copies of all three waves.  The original waves will remain unchanged.  Do you wish to continue?"
static strconstant LW_STRING21 = "\", and \""

static strconstant LW_HISTORY1="\tThe Loomis-Wood folder \""
static strconstant LW_HISTORY2="\" has been deleted."
static strconstant LW_HISTORY3="\" has been created."

// COLOR_LIST replaced by ColorNames wave version 2.01
// static strconstant COLOR_LIST = "Red;Orange;Yellow;Green;Blue;Violet;Cyan"
// static strconstant COLOR_LIST = "Red;Yellow;Lime;Aqua;Blue;Fuscia;Maroon;Olive;Green;Teal;Navy;Purple;Black;Grey"

static strconstant LW_ERROR1 = "\tLoomis-Wood Error: \""
static strconstant LW_ERROR2 = "\" does not exist."
static strconstant LW_ERROR3 = "\tLoomis-Wood Error:  The active graph is not a Loomis-Wood plot."
static strconstant LW_ERROR4 = "\tLoomis-Wood Error:  There are no peaks predicted by the current band constants.  Please edit the band constants."
static strconstant LW_ERROR5 = "\tLoomis-Wood Error:  The band constants are invalid.  Please edit the band constants."
static strconstant LW_ERROR6 = "\tLoomis-Wood Error:  The series requested does not exist."
static strconstant LW_ERROR7 = "\tLoomis-Wood Error:  The order of the series to be fit is less than 1."
static strconstant LW_ERROR8 = "\tLoomis-Wood Error:  An error occured while fitting the current series."
static strconstant LW_ERROR9 = "\tLoomis-Wood Error:  A backup coefficient wave does not exist."
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Loomis-Wood menu and related functions:
menu "&Loomis-Wood", dynamic
// This builds the Loomis-Wood munu
// NOTE:  FUNCTIONS AND VARIABLES REFERENCED IN THIS PROCEDURE CANNOT BE STATIC!
// Thus, all of the strings for this menu  are literals, not static strconstants.
	help = {OnLWmenuBuild()+"Welcome to Loomis-Wood!"}

	"Create a &New Loomis-Wood Folder...", NewLoomisWoodFolder()
	help = {"Create a new Loomis-Wood folder."}

	"Create a New Loomis-Wood &Plot...", MakeLoomisWoodPlot("","")
	help = {"Make a Loomis-Wood plot.  You must have already created a Loomis-Wood folder."}

	"&Delete a Loomis-Wood Folder...", DeleteLoomisWoodFolder("")
	help = {"Delete an existing Loomis-Wood folder."}

	submenu LWDynamicMenuItem()+ "Modify &Series"
	help = {"These commands modify the series in the current plot.", "This command is only availible for Loomis-Wood plots."}
		LWDynamicMenuItem()+ "Start a &New Series.../F2", AddSeries()
		help = {"Start a new series.", "This command is only availible for Loomis-Wood plots."}

		LWDynamicMenuItem()+ "&Select a Series.../F3", SelectSeries()
		help = {"Change the current series.", "This command is only availible for Loomis-Wood plots."}

		LWDynamicMenuItem()+ "&Delete a Series.../F4", DeleteSeries()
		help = {"Delete a series.", "This command is only availible for Loomis-Wood plots."}

		LWDynamicMenuItem()+ "&Fit Current Series/F5", Print FitSeries(GetCurrentSeriesNumber())
		help = {"Fit the current series.", "This command is only availible for Loomis-Wood plots."}

		LWDynamicMenuItem()+ "&Undo Last Fit/SF5", UndoFit()
		help = {"Revert to previous fit.", "This command is only availible for Loomis-Wood plots."}

		LWDynamicMenuItem()+ "&M-Shift Current Series/F6", ShiftSeries(GetCurrentSeriesNumber(),0,1)
		help = {"M-shift the current series.", "This command is only availible for Loomis-Wood plots."}

		LWDynamicMenuItem()+ "&View Current Series/F7", ViewSeries(GetCurrentSeriesNumber())
		help = {"View the assignment table for the current series.", "This command is only availible for Loomis-Wood plots."}

		LWDynamicMenuItem()+ "Edit Series &Info.../F8", EditSeriesInfo()
		help = {"Change the name, color, order, etc. of all assigned series.", "This command is only availible for Loomis-Wood plots."}

	end //submenu
	LWDynamicMenuItem()+ "Extract &Assignments.../F9", ExtractAssignments()
	help = {"Create a table of assignments.", "This command is only availible for Loomis-Wood plots."}

	LWDynamicMenuItem()+ "Change &M-axis scaling.../F11", ChangeRange(0,0)
	help = {"Change the M-axis scaling of the current Loomis-Wood plot.", "This command is only availible for Loomis-Wood plots."}

	LWDynamicMenuItem()+ "Edit &Band Constants.../F12", EditBandConstants()
	help = {"View/Edit the Band Constants for the current Loomis-wood plot.", "This command is only availible for Loomis-Wood plots."}

	LWDynamicMenuItem()+ "Edit Colors", EditColors()
	help = {"View/Edit the Colors used for the current Loomis-Wood folder.", "This command is only availible for Loomis-Wood plots."}

end //menu "Loomis-Wood"

function/S OnLWmenuBuild()
// DO NOT DECLARE AS STATIC!
// Any commands in this function will be executed whenever the LoomisWood menu is built.
// This is a good place for global initializations.
	string saveDF = GetDataFolder(1)
	SetDataFolder root:
	NewDataFolder/O $ROOT_FOLDER
	NewDataFolder/O $BASE_FOLDER
	SetDataFolder saveDF
	return ""
end //function/S OnLWmenuBuild

function/S LWDynamicMenuItem()
// DO NOT DECLARE AS STATIC!
// Several commands on the Loomis-Wood menu should only be availible if the top window is a Loomis-Wood plot.
// By prepending a "(" to a menu item, it is greyed out.
	string theParen
	if (isTopWinLWPlot(-1))
		theParen = ""
	else
		theParen = "("
	endif
	return theParen 
end //function/S LWDynamicMenuItem
                    
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Utility functions:
static function BinarySearch2(w, y)
	wave w
	variable y
	
	variable p =BinarySearch(w,y)
	if (p==-2)
		p = numpnts(w)-1
	elseif (p < 0)
		p = -1
	endif
	
	return p
end

static function/S Real1DWaveList(arg1,arg2,arg3)
// This function is just like WaveList(arg1,arg2,arg3), except that
// it only returns Real 1D waves.
	string arg1, arg2, arg3
	string startList, endList, theWave
	variable index
	
	startList = WaveList(arg1, arg2, arg3)
	endList = ""
	index = 0
	do
		// Get the next wave name.
		theWave = StringFromList(index, startList, arg2)
		if (strlen(theWave) == 0)
			break // Ran out of waves.
		endif
		if ((WaveDims($theWave)==1) %& (WaveType($theWave)!=0) %& !(WaveType($theWave)%&1) )
			theWave += arg2
			endList += theWave
		endif
		index += 1
	while (1) // Loop until break.

	return endList
end //static function/S Real1DWaveList

static function/S FolderList(sourceFolderStr)
// Returns a list of all folders in sourceFolderStr.
	string sourceFolderStr
	string theResult = ""
	string objName
	variable index
	index = CountObjects(sourceFolderStr,4)-1
	if (index == -1)
		return ""
	endif
	do
		objName = GetIndexedObjName(sourceFolderstr, 4, index)
		if (strlen(objName) > 0)
			theResult+=objName+";"
		endif
		index -= 1
	while (index >= 0)
	return theResult
end //static function/S FolderList

function/S TextWave2List(theTextWave)
// DO NOT DECLARE AS STATIC!
// Converts a 1D text wave into a ';' separated list
	wave/T theTextWave
	string Result=""
	variable index

	index = 1
	for (index = 1; index < numpnts(theTextWave); index += 1)
		Result += theTextWave(index)+";"
	endfor
	
	return Result
end

static function/S StandardBandLabels(order)
// These are the labels that go along with StandardBand2Poly
	variable order
	switch (order)
	case 0:
		return "nu0"
	case 1:
		return "B''eff"
	case 2:
		return "delta B''eff"	
	case 3:
		return "D''eff"
	case 4:
		return "delta D''eff"	
	case 5:
		return "H''eff"
	case 6:
		return "delta H''eff"	
	default:
		return ""
	endswitch
end

static function StandardBand2Poly(row, column, deltaJ)
// Calculates a matrix element for the matrix that is used to convert Band Constant parameters to polynomial coefficients
// The "Standard" Band Constant parameters are nu(0), B''eff, deltaB, D''eff, deltaD, H''eff, and deltaH.
	Variable row, column, deltaJ
	
	Variable theN = Ceil(column / 2)
	Variable Odd = mod(column,2)
	Variable theResult, index
	
	if (row > 2 * theN)
		return 0
	endif

	if (DeltaJ == 0)
		// This code is necessary b/c 0^0 evaluates to NaN not 1!
		if ((Odd) %| (row < theN))
			return 0
		elseif (theN == 0)
			return 1
		else
			return binomial(theN,2*theN-row)*(2*(mod(row,2))-1)
		endif
	endif
	
	if ((Odd) %& (row >= theN))
		theResult = binomial(theN,2*theN-row)*(2*(mod(row,2))-1)
	else
		theResult = 0
	endif
	
	index = max(row,theN)
	do
		theResult += (1-2*(mod(index,2)))*(deltaJ^(index-row))*(binomial(theN,2*theN-index))*(binomial(index,row))
		index += 1
	while(index <= 2*theN)
	
	if ((theN > 0) %& !mod(theN,2))
		// Even order terms are negative by definition, except for the band-center
		theResult *= -1
	endif

	return theResult
end //static function StandardBand2Poly

//static function Integer2Rainbow(theInt)
//// This function converts an integer from 0-6 to a number between 0-99 that corresponds to the Rainbow color table.
//	variable theInt
//	switch (theInt)
//	case 0:
//		return 67		//Cyan
//	case 1:
//		return 00		//Red
//	case 2:
//		return 12		//Orange
//	case 3:
//		return 21		//Yellow
//	case 4:
//		return 40		//Green
//	case 5:
//		return 90		//Blue
//	case 6:
//		return 99		//Violet
//	default:
//		return 67		//Cyan
//	endswitch
//end //function Integer2Rainbow

static function poly2(coeff, order, theX)
// Same as built-in Function poly(), except that order is given explicitly.
// It is nice to be able to use order < (numpnts(coeff) - 1).
	wave coeff
	variable order, theX
	variable theResult = coeff[order]
	variable index
	for (index = order - 1 ; index >= 0 ; index -= 1)
		theResult = theResult* theX + coeff[index]
	endfor	
	return theResult
end //static function poly2

static function/C poly3(coeff, order, theX)
// Same as poly2(), except that the derivative is also calculated, and returned as the imag part of a complex result.
	wave coeff
	variable order, theX
	variable eval = coeff[order] * theX + coeff[order-1]
	variable diff = coeff[order]
	variable index
	for (index = order -2 ; index >= 0 ; index -= 1)
		diff = eval + diff * theX
		eval = coeff[index] + eval * theX
	endfor	
	return cmplx(eval,diff)
end //static function poly3

static function/C bound_poly(coeff, order, theX)
// Finds the limits of monotonicity for the polynomial contained in coeff around the value theX.
// Returns a complex number whose real part is the lower limit and whose imaginary part is the upper limit.
	wave coeff
	variable order, theX
	variable/C theRes
	
	for ( order = min(round(order), numpnts(coeff) - 1) ; order > 0 ; order -=1 ) 
		if (coeff[order] != 0)
			break
		endif
	endfor

	if (order<= 0)
		return cmplx(NaN, NaN)
	endif
	 
	string SaveDF = GetDataFolder(1)
	NewDataFolder/O/S root:Packages
	NewDataFolder/O/S root:Packages:bound_poly

	Make/D/O/N=(order) thePoly
	thePoly = coeff[p+1]*(p+1)
	FindRoots /P=thePoly
	WAVE/C W_polyRoots
	for ( order = numpnts(W_polyRoots) ; order >= 0 ; order -=1 ) 
		if (abs((imag(W_polyRoots[order])/real(W_polyRoots[order]))) > 1e-14)
			DeletePoints order, 1, W_polyRoots
		endif
	endfor
	order = numpnts(W_polyRoots)+2
	Redimension/R/N=(order) W_polyRoots
	WAVE RealRoots=W_polyRoots
	RealRoots[order-1] = INF
	RealRoots[order-2] = -INF
	Sort RealRoots RealRoots
	order = BinarySearch(RealRoots, theX)
	theRes = cmplx(RealRoots[order],RealRoots[order+1])
	SetDataFolder SaveDF
	KillDataFolder root:Packages:bound_poly
	return theRes
end //static function/c bound_poly

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Misc Loomis-Wood functions:
static function isTopWinLWPlot(theWinType)
// This function tests to see if the top window is a Loomis-Wood plot.
// If the top window is a Loomis-Wood plot, it will contain "LoomisWood=ver" in its note.
// Use theWinType = 1 if only the top GRAPH needs to be a Loomis-Wood plot
// Use theWinType = -1 if the overall top WINDOW needs to be a Loomis-Wood plot
	variable theWinType
	variable theVersion
	string TopWinName = WinName(0,theWinType)

	if (!cmpstr(TopWinName,""))	//This is necessary b/c this function may be called when there are no active windows.
		return 0
	endif

	GetWindow $TopWinName, note
	theVersion = NumberByKey("LoomisWood",S_Value,"=",",")
	if (theVersion > 0)
		return 1
	else
		return 0
	endif
end //static function isTopWinLWPlot

static function VerifyInputWaveDims(Peak_Frequencies,Peak_Intensities,Peak_Widths)
// Checks to make sure that all peak-listing related waves have the same length.
	String Peak_Frequencies,Peak_Intensities,Peak_Widths
	Variable theResult = 0
	
	If (cmpstr(Peak_Intensities,"_constant_"))
		theResult +=(numpnts($Peak_Frequencies)!=numpnts($Peak_Intensities))		
	EndIf

	If (cmpstr(Peak_Widths,"_constant_"))
		theResult += (numpnts($Peak_Frequencies)!=numpnts($Peak_Widths))		
	EndIf

	Return theResult
end //static function VerifyInputWaveDims

static function GetNumPeaks(Peak_Frequencies,Peak_Intensities,Peak_Widths)
// Used to determine the number of peaks when some of the peak-listing related waves have extra points
	String Peak_Frequencies,Peak_Intensities,Peak_Widths
	Variable theResult = numpnts($Peak_Frequencies)
	If (cmpstr(Peak_Intensities,"_constant_"))
		theResult = min(theResult,numpnts($Peak_Intensities))		
	EndIf
	If (cmpstr(Peak_Widths,"_constant_"))
		theResult = min(theResult,numpnts($Peak_Widths))
	EndIf
	return theResult
end //static Function GetNumPeaks

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Main Loomis-Wood inteface functions:
Function NewLoomisWoodFolder()
	// Save current folder name
	String SaveDF = GetDataFolder(1)
	
	// Get name of a new SourceFolder from user
	String SourceFolder = GetNewLWDataFolder()
	if (cmpstr(SourceFolder,"")==0)
		Return 0
	endif
	
	// Create SourceFolder and copy peakfinder waves to it.
	if (CopyWavesToSourceFolder(SaveDF, SourceFolder))
		SourceFolder += ":"
		SetDataFolder SourceFolder

		// These are the persistant data created by CopyWavesToSourceFolder().
		WAVE Peak_Frequency = Peak_Frequency
		WAVE Peak_Intensity = Peak_Intensity
		WAVE Peak_Width = Peak_Width
		NVAR NumPeaks = NumPeaks
	
		// New 2/18/05
		Make/O/T/N=14 ColorNames = {"Teal","Red","Yellow","Lime","Blue","Fuchsia","Maroon","Olive","Green","Aqua","Navy","Purple","Black","Grey"}
		Make/O/D/N=(14,3) M_Colors
		M_Colors[0][0]= {0       , 65535, 65535, 0       , 0       , 65535, 32768, 32768, 0       , 0       , 0       , 32768, 0, 32768}
		M_Colors[0][1]= {32768, 0       , 65535, 65535, 0       , 0       , 0       , 32768, 32768, 65535, 0       , 0       , 0, 32768}
  		M_Colors[0][2]= {32768, 0       , 0       , 0       , 65535, 65535, 0       , 0       , 0       , 65535, 32768, 32768, 0, 32768}

		// Create the remaining persistant data.
		//Make/I/N=(NumPeaks) Peak_Shape
		Make/T/N=(NumPeaks) Peak_Series
		//Make/W/N=(NumPeaks,MAX_DUP_ASSIGN) Peak_Series
		//Make/I/N=(NumPeaks,MAX_DUP_ASSIGN) Peak_Assignment

		Make/D/N=(MAX_FIT_ORDER,MAX_FIT_ORDER) Band2Poly
		Band2Poly = StandardBand2Poly(p,q,1)
		Make/T/N=(MAX_FIT_ORDER) BandCoeffLabels
		BandCoeffLabels = StandardBandLabels(p)
		
		Duplicate/O Band2Poly, Poly2Band
		MatrixInverse/O Poly2Band
		
		//Make/D/N=(MAX_FIT_ORDER,1) TempB
		//MatrixGaussJ Band2Poly, TempB
		//Rename M_Inverse, Poly2Band
		//KillWaves/Z TempB, M_X
				
		Make/T/N=1 Series_Name, Series_Data 
		Make/T/N=(1,MAX_QN) Series_QN
		Make/W/N=1 Series_Color, Series_Shape, Series_Order
		Series_Name[0] = "Unassigned"
		Variable/G NumSeries = 0

		Variable/G minWidth, maxWidth, minIntensity, maxIntensity
		WaveStats/Q Peak_Width
		minWidth = V_min
		maxWidth = V_max
		WaveStats/Q Peak_intensity
		minIntensity = V_min
		maxIntensity = V_max
		Variable index

		// Create an initial display
		MakeLoomisWoodPlot(SourceFolder, "Plot0")
		SetDataFolder SaveDF
		Return 1
	else
		Return 0
	endif
End //Function NewLoomisWoodFolder

static function GetPeakfinderWaves(Peak_Frequency, Peak_Intensity, Peak_Width)
// DIALOG
	string &Peak_Frequency, &Peak_Intensity, &Peak_Width

	string Peak_F = Peak_Frequency
	string Peak_I = Peak_Intensity
	string Peak_W = Peak_Width

	Prompt Peak_F, LW_STRING2, popup Real1DWaveList("*", ";", "")
	Prompt Peak_I, LW_STRING3, popup "_constant_;" + Real1DWaveList("*", ";", "")
	Prompt Peak_W, LW_STRING4, popup "_constant_;" + Real1DWaveList("*", ";", "")
	DoPrompt LW_TITLE, Peak_F, Peak_I, Peak_W
	
	Peak_Frequency = GetDataFolder(1)+Peak_F

	if (cmpstr(Peak_I,"_constant_"))
		Peak_Intensity= GetDataFolder(1)+Peak_I
	else
		Peak_Intensity = Peak_I
	endif

	if (cmpstr(Peak_W,"_constant_"))
		Peak_Width= GetDataFolder(1)+Peak_W		
	else
		Peak_Width = Peak_W
	endif

	return V_Flag

end //static function GetPeakfinderWaves

static function GetConstantIntensity(Constant_Intensity)
// DIALOG
	variable Constant_Intensity //= 1

	Prompt Constant_Intensity, LW_STRING5
	DoPrompt LW_TITLE, Constant_Intensity 
	
	if (V_Flag)
		return 0
	endif

	return Constant_Intensity
end //static function GetConstantIntensity

static function GetConstantWidth(Constant_Width)
// DIALOG
	variable Constant_Width //= 0.001
	Prompt Constant_Width, LW_STRING6
	DoPrompt LW_TITLE, Constant_Width 

	if (V_Flag)
		return 0
	endif

	return Constant_Width
end //static function GetConstantWidth

static function/S GetNewLWDataFolder()
// DIALOG
	String SourceFolder
	//Save current folder name
	String SaveDF = GetDataFolder(1)

	//Ask for New SourceFolder.
	Prompt SourceFolder, LW_STRING1
	DoPrompt LW_TITLE, SourceFolder
	If (V_Flag)
		Return ""
	EndIf

	//Switch to LoomisWood folder.
	SetDataFolder $BASE_FOLDER

	//Verify SourceFolder.
	If (CheckName(SourceFolder,11))
		Do
			DoAlert 2, "\""+ SourceFolder + LW_STRING7+ UniqueName(CleanupName(SourceFolder,1),11,0) + LW_STRING8
			switch (V_Flag)
			case 1:
				// The user clicked "Yes", so change the name.
				SourceFolder=UniqueName(CleanupName(SourceFolder,1),11,0)
				break
			case 2:
				// The user clicked "No", so try again.
				DoPrompt LW_TITLE, SourceFolder
				If (V_Flag)
					Return ""
				EndIf
				break
			default:
				// The user clicked "Cancel" so abort.
				SetDataFolder SaveDF
				Return ""
			endswitch
		While(CheckName(SourceFolder,11))
	EndIf
	SourceFolder = BASE_FOLDER +":"+ SourceFolder
	
	//Switch back to original folder.
	SetDataFolder SaveDF
	Return SourceFolder
end //static function/S GetNewLWDataFolder

static function CopyWavesToSourceFolder(SourceDF, LWDF)
	String SourceDF, LWDF
	String SaveDF = GetDataFolder(1)

	String Peak_Frequencies = ""
	String Peak_Intensities = ""
	String Peak_Widths = ""
	
	Variable Constant_Width
	Variable Constant_Intensity

	SetDataFolder SourceDF
	//Ask for waves from peakfinder.
	If (GetPeakfinderWaves(Peak_Frequencies,Peak_Intensities,Peak_Widths))
		Return 0
	EndIf

	If (VerifyInputWaveDims(Peak_Frequencies,Peak_Intensities,Peak_Widths))
		DoAlert 1, LW_STRING19+Peak_Frequencies+"\", \""+Peak_Intensities+LW_STRING21+Peak_Widths+LW_STRING20
		If (V_Flag==2)
			// The user clicked "No", so abort.
			SetDataFolder SourceDF
			Return 0
		EndIf
	EndIf

	If (!cmpstr(Peak_Intensities,"_constant_"))
		Constant_Intensity = GetConstantIntensity(1)
		If (!Constant_Intensity)
			Return 0
		EndIf
	EndIf
	If (!cmpstr(Peak_Widths,"_constant_"))
		Constant_Width = GetConstantWidth(.001)
		If (!Constant_Width)
			Return 0
		EndIf
	EndIf
	
	//Create SourceFolder, if it doesn't already exist
	NewDataFolder/O/S $LWDF

	Variable/G NumPeaks = GetNumPeaks(Peak_Frequencies,Peak_Intensities,Peak_Widths)
	Duplicate/R=[0,NumPeaks-1] $Peak_Frequencies, Peak_Frequency
	
	If (cmpstr(Peak_Intensities,"_constant_"))
		Duplicate/R=[0,NumPeaks-1] $Peak_Intensities, Peak_Intensity
	Else
		Duplicate Peak_Frequency, Peak_Intensity
		Peak_Intensity = Constant_Intensity
	EndIf
	
	If (cmpstr(Peak_Widths,"_constant_"))
		Duplicate/R=[0,NumPeaks-1] $Peak_Widths,Peak_Width
	Else
		Duplicate Peak_Frequency,Peak_Width
		Peak_Width = Constant_Width
	EndIf

	Sort Peak_Frequency,Peak_Frequency,Peak_Intensity,Peak_Width
	SetDataFolder SaveDF
	
	Return 1
end //static function CopyWavesToSourceFolder

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function DeleteLoomisWoodFolder(SourceFolder)
// OPTIONAL DIALOG
	string SourceFolder

	string PlotFolder
	variable index
	
	if (cmpstr(SourceFolder,""))
		if (ValidateSourceFolder(SourceFolder))
			// SourceFolder invalid
			Beep
			Print LW_ERROR1 + SourceFolder + LW_ERROR2
			return 0
		endif
	else
		//Prompt for SourceFolder
		Prompt SourceFolder, LW_STRING9, popup FolderList(BASE_FOLDER)
		DoPrompt LW_TITLE, SourceFolder
		if (V_flag)
			return 0
		endif
		SourceFolder = BASE_FOLDER + ":" + SourceFolder + ":"
	endif
	
	//First, remove all dependencies in plot folders
	for(index = 1 ; index <= CountObjects(SourceFolder,4) ; index += 1)
		PlotFolder = SourceFolder+GetIndexedObjName(SourceFolder,4,index-1)+":"
		SetFormula $(PlotFolder+"BandCoeffUpdate"), ""
		SetFormula $(PlotFolder+"TriangleUpdate"), ""
		SetFormula $(PlotFolder+"SeriesOrder"), ""
		//KillVariables/Z $(PlotFolder+"BandCoeffUpdate"),$(PlotFolder+"TriangleUpdate")
	endfor
	// Second, remove all dependencies in source folder
	// Finally, kill the folder
	KillDataFolder $SourceFolder
	
	Beep	
	Print LW_HISTORY1 + SourceFolder + LW_HISTORY2
end //function DeleteLoomisWoodFolder

function MakeLoomisWoodPlot(SourceFolder, PlotFolder)
// OPTIONAL DIALOG
	String SourceFolder, PlotFolder
	
	if (cmpstr(SourceFolder,"") || cmpstr(PlotFolder,""))
		if (ValidateSourceFolder(SourceFolder))
			// SourceFolder invalid
			Beep
			Print LW_ERROR1 + SourceFolder + LW_ERROR2
			return 0
		endif
	else
		//Prompt for SourceFolder and PlotFolder
		Prompt SourceFolder, LW_STRING17, popup FolderList(BASE_FOLDER)
		Prompt PlotFolder, LW_STRING18
		DoPrompt LW_TITLE, SourceFolder, PlotFolder
		if (V_flag)
			return 0
		endif
		SourceFolder = BASE_FOLDER + ":" + SourceFolder + ":"
	endif
	
	String temp
	String SaveDF=GetDataFolder(1)
	
	SetDataFolder SourceFolder
	WAVE Peak_Frequency
	WAVE Peak_Width
	WAVE/T Series_Name
	NVAR NumPeaks
		
	//TODO: Validate PlotFolder
	NewDataFolder/O/S $PlotFolder
	PlotFolder = SourceFolder + PlotFolder + ":"
	
	// Create persistant data
	Make/O/D/N=(NumPeaks) Peak_LWm
	Make/O/D/N=(NumPeaks) Peak_delta_frequency
	Make/O/D/N=(FIVEMAX_PEAKS_PER_PLOT) Triangle_X, Triangle_Yup, Triangle_Ydown
	Make/O/U/W/N=(FIVEMAX_PEAKS_PER_PLOT,3) Triangle_Color
	//Make/O/W/N=(FIVEMAX_PEAKS_PER_PLOT) Triangle_Color
	Make/O/D/N=(MAX_FIT_ORDER) BandCoeff, PolyCoeff
	Make/O/D/N=(2) LWCursorX = NaN, LWCursorYup = NaN, LWCursorYdown = NaN

	Triangle_X = NaN
	Triangle_Yup = NaN
	Triangle_Ydown = NaN
	Triangle_Color = NaN
	Variable/G lastTriangle

	Variable/G Zoom=1
	Variable/G BandCoeffUpdate, TriangleUpdate
	Variable/G StartP, EndP
	Variable/G lwCursor_p, lwCursor_m, lwCursor_frequency, lwCursor_intensity, lwCursor_width, lwCursor_delta_m, lwCursor_delta_frequency
	String/G lwCursor_assignments
	Variable/G startM = -10.5, endM = 10.5
	Variable/G CurrentSeries = 1
	Variable/G SeriesOrder
	SetFormula SeriesOrder, "DoSeriesOrderUpdate("+SourceFolder+"Series_Order,"+PlotFolder+"CurrentSeries)"

	// Initialize persistant data.
	BandCoeff[0] = mean(Peak_Frequency,0,NumPeaks-1)
	BandCoeff[1] = 100*mean(Peak_Width,0,NumPeaks-1)

	temp = "DoBandCoeffUpdate("+PlotFolder+"BandCoeff)"
	SetFormula BandCoeffUpdate, temp
	//temp = "DoTriangleUpdate("+PlotFolder+"Peak_LWm,"+SourceFolder+"Peak_Series,"+SourceFolder+"Peak_Shape,"+SourceFolder+"Series_Color,"+SourceFolder+"Series_Shape,"+PlotFolder+"StartM,"+PlotFolder+"EndM,"+PlotFolder+"Zoom)"
	temp = "DoTriangleUpdate("+PlotFolder+"Peak_LWm,"+SourceFolder+"Peak_Series,"+SourceFolder+"Series_Color,"+SourceFolder+"Series_Shape,"+PlotFolder+"StartM,"+PlotFolder+"EndM,"+PlotFolder+"Zoom)"
	SetFormula TriangleUpdate, temp

	// Draw the Graph
	Display/K=1/W=(3,0,762,400) LWCursorYup, LWCursorYdown vs LWCursorX
	AppendToGraph Triangle_Yup, Triangle_Ydown vs Triangle_X

	// Setup the axes
	SetAxis/R left 10,-11
	SetAxis/A/N=1/E=2 bottom
	ModifyGraph standoff=0
	ModifyGraph manTick(left)={0.51,1,0,0},manMinor(left)={1,0}
	ModifyGraph btLen(left)=0.1
	ModifyGraph tlOffset(left)=5
	ModifyGraph stLen(left)=5
	ModifyGraph minor(bottom)=1,lowTrip(bottom)=1e-06;DelayUpdate
	ModifyGraph sep(bottom)=25
	
	// Setup the traces
	ModifyGraph mode(LWCursorYup)=7,mode(Triangle_Yup)=7
	ModifyGraph toMode(LWCursorYup)=1,toMode(Triangle_Yup)=1
	ModifyGraph hBarNegFill(LWCursorYup)=2,hBarNegFill(Triangle_Yup)=2
	ModifyGraph hbFill=2
	ModifyGraph rgb(LWCursorYup)=(0,0,0),rgb(LWCursorYdown)=(0,0,0)
	ModifyGraph zColor(Triangle_Yup)={Triangle_Color,*,*,directRGB}
	ModifyGraph zColor(Triangle_Ydown)={Triangle_Color,*,*,directRGB}

	// Setup the hook function
	SetWindow kwTopWin,note="LoomisWood=1.0,SourceFolder="+SourceFolder+",PlotFolder="+PlotFolder+",",hook(LW)=LWHookFunction
	//Execute/Z "SetWindowExt kwTopWin"

	// Move the cursor to approximately the center of the plot
	lwCursor_p = Round(0.5*(StartP+EndP))
	MoveCursor(lwCursor_p)	

	RenameWindow #,LWbase
	// Setup the control bar
	ControlBar TOP_BAR_HEIGHT
	NewPanel/FG=(FL,FT,GR,GT)/HOST=# 		// New
	RenameWindow #,PTop	// New

	PopupMenu CurrentSeriesPopup,pos={2,32},size={280,21},proc=CurrentSeriesPopupMenuControl,title="Current Series"
	PopupMenu CurrentSeriesPopup,mode=1,bodyWidth= 200
	PopupMenu popup_assignments,pos={2,8},size={280,21},proc=CurrentSeriesPopupMenuControl,title="Assignments"
	PopupMenu popup_assignments,mode=1,bodyWidth= 200
	ValDisplay display_frequency,pos={292,8},size={160,18},title="frequency",fSize=12
	ValDisplay display_frequency,format="%13.6f",limits={0,0,0},barmisc={0,1000}
	ValDisplay display_delta_frequency,pos={452,8},size={175,18},title="delta frequency",fSize=12
	ValDisplay display_delta_frequency,format="%13.6f",limits={0,0,0},barmisc={0,1000}
	ValDisplay display_m,pos={362,32},size={70,18},title="m",fSize=12,format="%d"
	ValDisplay display_m,limits={0,0,0},barmisc={0,1000}
	ValDisplay display_delta_m,pos={437,32},size={110,18},title="delta m",fSize=12,format="%5.3f"
	ValDisplay display_delta_m,limits={0,0,0},barmisc={0,1000}
	ValDisplay display_intensity,pos={552,32},size={110,18},title="intensity"
	ValDisplay display_intensity,fSize=12,format="%5.3f"
	ValDisplay display_intensity,limits={0,0,0},barmisc={0,1000}
	ValDisplay display_width,pos={632,8},size={110,18},title="width",fSize=12
	ValDisplay display_width,format="%8.6f",limits={0,0,0},barmisc={0,1000}
	ValDisplay display_p,pos={672,32},size={70,18},title="p",fSize=12,format="%d"
	ValDisplay display_p,limits={0,0,0},barmisc={0,1000}
	SetVariable order_setvar,pos={287,32},size={65,21},title="Order",format="%d"
	SetVariable order_setvar,limits={1,6,1}, proc=OrderSetVarProc
	SetVariable zoom_setvar,pos={750,32},size={79,21},title="Zoom",format="%d"
	SetVariable zoom_setvar,limits={1,INF,1}

	Execute/Z "SetVariable zoom_setvar, value="+PlotFolder+"Zoom" 
	Execute/Z "SetVariable order_setvar, value="+PlotFolder+"SeriesOrder" 
	Execute/Z "PopupMenu CurrentSeriesPopup value=TextWave2List("+SourceFolder+"Series_Name)+\"_Create_New_Series_;\""
	Execute/Z "PopupMenu popup_assignments value="+PlotFolder+"lwCursor_assignments"
	Execute/Z "ValDisplay display_p,value="+PlotFolder+"lwCursor_p"
	Execute/Z "ValDisplay display_m,value="+PlotFolder+"lwCursor_m"
	Execute/Z "ValDisplay display_frequency,value="+PlotFolder+"lwCursor_frequency"
	Execute/Z "ValDisplay display_intensity,value="+PlotFolder+"lwCursor_intensity"
	Execute/Z "ValDisplay display_width,value="+PlotFolder+"lwCursor_width"
	Execute/Z "ValDisplay display_delta_m,value="+PlotFolder+"lwCursor_delta_m"
	Execute/Z "ValDisplay display_delta_frequency,value="+PlotFolder+"lwCursor_delta_frequency"

	SetWindow kwTopWin,note="LoomisWood=1.0,SourceFolder="+SourceFolder+",PlotFolder="+PlotFolder+","
	SetActiveSubwindow ##	// New

	SetDataFolder SaveDF
end //function MakeLoomisWoodPlot

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Data updating functions
function DoBandCoeffUpdate(BandCoeff)
// DO NOT DECLARE AS STATIC!
// This function is called via a dependancy whenever BandCoeff is changed
// This function is responsible for calculating Peak_LWm, PolyCoeff, minM, maxM, minP, maxP
	wave BandCoeff

	variable start_time = ticks

	string PlotFolder = GetWavesDataFolder(BandCoeff,1)
	string SaveDF = GetDataFolder(1)
	SetDataFolder PlotFolder
	WAVE PolyCoeff
	WAVE Peak_LWm
	WAVE Peak_delta_frequency
	variable/G minM, maxM, minP, maxP
	SetDataFolder ::
	WAVE Peak_Frequency
	WAVE Band2Poly
	NVAR NumPeaks
	SetDataFolder SaveDF

	variable/C limits

	variable theF, theF2, theM, theP
	variable Order, FatminM, FatmaxM, minF, maxF, slope

	// Update PolyCoeff.
	MatrixMultiply Band2Poly, BandCoeff
	WAVE M_product = M_product
	PolyCoeff = M_product
	KillWaves/Z M_product
	
	// Analyze PolyCoeff.
	WaveStats/Q PolyCoeff
	if (V_numINFs || V_numNaNs)
		// If PolyCoeff contains INFs or NaNs, things will go crazy:
		Beep
		print LW_ERROR4
		return 0
	endif
		
	Order = numpnts(PolyCoeff)
	do
		Order -= 1
	while ((PolyCoeff[Order] == 0) && (Order > 0))
	if (Order <= 0)
		Beep
		print LW_ERROR4
		return 0
	endif

	limits = bound_poly(PolyCoeff, Order, 0.0)
	minM = ceil(max(-MAX_M, real(limits)))
	maxM = floor(min( MAX_M, imag(limits))	)
	FatminM = poly2(PolyCoeff, Order, minM) 		
	FatmaxM = poly2(PolyCoeff, Order, maxM)
	minF = min(FatminM, FatmaxM)
	maxF = max(FatminM, FatmaxM)
	minP = BinarySearch(Peak_Frequency, minF)
	maxP = BinarySearch(Peak_Frequency, maxF)

	do	// This is a do-while(0) loop, allowing the break statement to be used like a goto.
		if ((minP == -2) || (maxP == -1))
			// There are no peaks in the range of the polynomial
			Beep
			Print LW_ERROR4
			Peak_LWm  = NaN
			break
		endif
		if (minP == -1)
			// The range of the polynomial begins below the frequency of the first peak.
			minP = 0
		else
			// The range of the polynomial begins above the frequency of the first peak.
			// Set Peak_LWm of those peaks below the range of the polynomial to -Inf
			Peak_LWm[0, minP - 1] = -Inf
		endif
		if (maxP == -2)
			// The range of the polynomial ends above the frequency of the first peak.
			maxP = NumPeaks
		else
			// The range of the polynomial ends below the frequency of the last peak.
			// Set Peak_LWm of those peaks below the range of the polynomial to +Inf
			Peak_LWm[maxP + 1, NumPeaks - 1] = Inf
		endif
		
		theM = minM	
		theF = poly2(PolyCoeff, order, theM)
		theF2 = poly2(PolyCoeff, order, theM + 0.5)

		// For negative slope, run theP backwards
		slope = sign(FatmaxM - FatminM)
		for (theP = (slope > 0 ? minP : maxP) ; ((minP <= theP) && (theP <= maxP))  ; theP += slope)
			if (theF2 < Peak_Frequency[theP] )
				do
					theM += 1
					theF2 = poly2(PolyCoeff, order, theM + 0.5)
				while (theF2 < Peak_Frequency[theP] )
				theF = poly2(PolyCoeff, order, theM)
			endif
			Peak_LWm[theP] = theM
			Peak_delta_frequency[theP] = Peak_Frequency[theP] - theF
		endfor		
	while(0)

	// This update time should be under 120 ticks (2 sec) for good user interaction
	//printf "BandCoeff update took %d ticks.\r" ticks - start_time
	return (ticks - start_time)
end

function DoSeriesOrderUpdate(Series_Order, CurrentSeries)
// DO NOT DECLARE AS STATIC!
	wave Series_Order
	variable CurrentSeries	
	return Series_Order[CurrentSeries]
end

function DoTriangleUpdate(Peak_LWm, Peak_Series, Series_Color, Series_Shape, StartM, EndM, Zoom)
// This procedure recalculates Triangle_X, Triangle_Yup, Triangle_Ydown, and Triangle_Color, StartP, EndP, StartFrequency, and EndFrequency
// whenever Peak_LWm, Peak_Series, Peak_Shape, Series_Color, Series_Shape, StartM, or EndM  change.
// DO NOT DECLARE AS STATIC!
	Wave Peak_LWm
	Wave/T Peak_Series
	Wave Series_Color, Series_Shape
	Variable startM, endM, Zoom

	Variable start_time = ticks

	String SaveDF = GetDataFolder(1)
	SetDataFolder GetWavesDataFolder(Peak_LWm,1)
	WAVE M_Colors = ::M_Colors
	WAVE Peak_Intensity = ::Peak_Intensity
	WAVE Peak_width = ::Peak_Width
	WAVE PolyCoeff
	WAVE Peak_delta_frequency
	WAVE Triangle_X
	WAVE Triangle_Yup
	WAVE Triangle_Ydown
	WAVE Triangle_Color

	Variable/G startP = BinarySearch2(Peak_LWm, startM) + 1
	Variable/G endP = min(BinarySearch2(Peak_LWm, endM), StartP + 0.2*FIVEMAX_PEAKS_PER_PLOT - 1)
	Variable/G startFrequency = poly(PolyCoeff,startM)
	Variable/G endFrequency = poly(PolyCoeff,endM)
	NVAR lastTriangle
	SetDataFolder ::
	NVAR minWidth, maxWidth, minIntensity, maxIntensity
	SetDataFolder SaveDF
	
	Variable base, center, color, height, fiveindex, shape, width, scale_width,  scale_height, WidthMin, index
	Variable total_height, clip_width
	Variable colorR, colorB, colorG
	Variable series
		
	scale_width = (maxWidth- minWidth > 0) ? 0.045 * PolyCoeff[1] / (maxWidth - minWidth) : 0
	WidthMin = 0.005 * PolyCoeff[1]
	
	scale_height = (maxIntensity-minIntensity > 0) ? 0.80 / (maxIntensity - minIntensity) : 0
	scale_height *= Zoom
	
	for (index = startP ; index <= endP ; index += 1)
		fiveindex = 5*(index-StartP)
		base = Peak_LWm[index]
		center = Peak_delta_frequency[index]
		total_height = (Peak_Intensity[index] - minIntensity) *scale_height + 0.1
		height = min(total_height, 0.90)  // New Version 2.01
		width =  (Peak_width[index] - minWidth)*scale_width + WidthMin
		clip_width = (1-height/total_height)*width
		
		series = str2num(StringFromList(0,Peak_Series[index],";"))
		if (numtype(series))
			series = 0
		endif
		
		color = Series_Color[series]
		colorR = M_Colors[color][0]
		colorG = M_Colors[color][1]
		colorB = M_Colors[color][2]
		shape = Series_Shape[series]!=0
		
		Triangle_X[fiveindex] = center - width
		Triangle_Yup[fiveindex] = base
		Triangle_Ydown[fiveindex] = base
		Triangle_Color[fiveindex] = {{colorR},{colorG},{colorB}}

		fiveindex += 1
		Triangle_X[fiveindex] = center - clip_width
		Triangle_Yup[fiveindex] = base-height
		Triangle_Ydown[fiveindex] = base-(1-shape)*height
		Triangle_Color[fiveindex] = {{colorR},{colorG},{colorB}}

		fiveindex += 1
		Triangle_X[fiveindex] = center + clip_width
		Triangle_Yup[fiveindex] = base-height
		Triangle_Ydown[fiveindex] = base-(1-shape)*height
		Triangle_Color[fiveindex] = {{colorR},{colorG},{colorB}}

		fiveindex += 1
		Triangle_X[fiveindex] = center + width
		Triangle_Yup[fiveindex] = base
		Triangle_Ydown[fiveindex] = base
		Triangle_Color[fiveindex] = {{colorR},{colorG},{colorB}}

	endfor
	fiveindex += 2
	Triangle_X[fiveindex,lastTriangle] = NaN
	//Triangle_Yup[fiveindex,lastTriangle] = NaN
	//Triangle_Ydown[fiveindex,lastTriangle] = NaN
	//Triangle_Color[fiveindex,lastTriangle] = NaN
	lastTriangle = fiveindex + 2

	// This update time should be under 3 ticks (0.05 sec) for good user interaction
	//printf "Triangle update took %d ms.\r" ticks - start_time
	return ticks - start_time
end //function DoTriangleUpdate

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Loomis-Wood plot hook function:
function LWHookFunction(s)
	STRUCT WMWinHookStruct &s
	
	if ((ticks - s.ticks) > 10)
		//Ignore events that are more than 2 ticks stale. 
		return 1
	endif
	
	Variable theKey, theP

	//do not handle Events that occur in the control bar:
	if (s.mouseLoc.v < 0 || s.mouseLoc.h < 0) //TOP_BAR_HEIGHT
		return 0
	endif

	switch(s.eventcode)
		case EC_Keyboard:
			switch(s.keycode)
			case VK_RETURN:
				AssignPeak(CursorPosition(),GetCurrentSeriesNumber(),CursorM(),1)
				VMoveCursor(1)
				return 1 
			case VK_DELETE:
				UnAssignPeak(CursorPosition(),7)
				UnAssignPeak(CursorPosition(),6)
				UnAssignPeak(CursorPosition(),5)
				UnAssignPeak(CursorPosition(),4)
				UnAssignPeak(CursorPosition(),3)
				UnAssignPeak(CursorPosition(),2)
				UnAssignPeak(CursorPosition(),1)
				UnAssignPeak(CursorPosition(),0)
				VMoveCursor(1)
				return 1 
			case VK_PRIOR:
				VerticalScroll(-LinesPerFrame())
				return 1
			case VK_NEXT:
				VerticalScroll(LinesPerFrame())
				return 1
			case VK_LEFT:
				HMoveCursor(-1)
				return 1 
			case VK_UP:
				VMoveCursor(-1)
				return 1
			case VK_RIGHT:
				HMoveCursor(1)
				return 1 
			case VK_DOWN:
				VMoveCursor(1)
				return 1
			case 0x41:
			case 0x61:
			//case VK_A:
				//Prevent Ctrl-A
				return 1			
//			case VK_F2:
//				AddSeries()
//				return 1	
//			case VK_F3:
//				SelectSeries()
//				return 1
//			case VK_F4:
//				DeleteSeries()
//				//String PlotFolder = StringByKey("PlotFolder",S_Value,"=",",")
//				//NVAR CurrentSeries = $(PlotFolder+"CurrentSeries")
//				//DeleteSeries(CurrentSeries)
//				return 1	
//			case VK_F5:
//				GetWindow kwTopWin, note
//				String PlotFolder = StringByKey("PlotFolder",S_Value,"=",",")
//				NVAR CurrentSeries = $(PlotFolder+"CurrentSeries")
//				FitSeries(CurrentSeries)
//				return 1
//			case VK_F6:
//				GetWindow kwTopWin, note
//				PlotFolder = StringByKey("PlotFolder",S_Value,"=",",")
//				NVAR CurrentSeries = $(PlotFolder+"CurrentSeries")
//				ShiftSeries(CurrentSeries,0,1)
//				return 1
//			case VK_F7:
//				GetWindow kwTopWin, note
//				PlotFolder = StringByKey("PlotFolder",S_Value,"=",",")
//				NVAR CurrentSeries = $(PlotFolder+"CurrentSeries")
//				ViewSeries(CurrentSeries)
//				return 1
//			case VK_F8:
//				EditSeriesInfo()
//				return 1
//			case VK_F9:
//				ExtractAssignments()
//				return 1
//			case VK_F11:
//				ChangeRange(0, 0)
//				return 1
//			case VK_F12:
//				EditBandConstants()
//				return 1	
			default:
				//Print theKey
				return 0
			endswitch
		case EC_MouseDown:
			SetActiveSubwindow LWbase
			theP = HitTest(s)
			if (theP >= 0)
				MoveCursor(theP)
 			endif
 			return 1
		//case "mousedblclk":
		//	theP = HitTest(InfoStr)
		//	if (theP >= 0)
		//		AssignPeak(theP,GetCurrentSeriesNumber(),CursorM(), -1)
 		//	endif			
		//	return 1
		case EC_MouseUp:
			theP = HitTest(s)
			if ((theP >= 0) || (theP == -9))
				return 1
 			endif
 			break
		//case "mousewheel":
		//	VerticalScroll( sign(NumberByKey("DELTA",InfoStr)) )
		//	return 1
 		//case EC_Kill
 		//	return SWXKillDialog(StringByKey("WINDOW",InfoStr))			
		default:
			return 0
	endswitch //(Event)

End //function LWHookFunction


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//// Loomis-Wood plot hook function:
//function LWHookFunctionOld(InfoStr)
//// This is the event handler for a Loomis-Wood plot window.
//	String InfoStr
//	if ((ticks - NumberByKey("TICKS", InfoStr)) > 2)
//		//Ignore events that are more than 2 ticks stale. 
//		return 1
//	endif
//	String Event = StringByKey("EVENT",InfoStr)
//	
//		//The events in IGOR 4.00 and above are: 
//		//		activate
//		//		deactivate
//		//		kill
//		//		mousedown		-> handled by SetWindowExt
//		//		mouseup		-> handled by SetWindowExt
//		//		mousemoved
//		//		resize
//		//The events provided by SetWindowExt are: 
//		//		mousedown
//		//		mouseup
//		//		mousedblclk
//		//		mmousedown
//		//		mmouseup
//		//		mmousedblclk
//		//		mmousedown
//		//		rmouseup
//		//		rmousedblclk
//		//		rmousemoved
//		//		mousewheel
//		//		keyup
//		//		keydown
//		//		close
//
//	Variable theKey, theP
//
//	//do not handle Events that occur in the control bar:
//	//if (NumberByKey("MOUSEY",InfoStr) < TOP_BAR_HEIGHT)
//	//	return 0
//	//endif
//
//	strswitch(Event)
//		case "keydown":
//			theKey = NumberByKey("KEY",InfoStr)
//			switch(theKey)
//			case VK_RETURN:
//				AssignPeak(CursorPosition(),GetCurrentSeriesNumber(),CursorM(),-1)
//				VMoveCursor(1)
//				return 1 
//			case VK_DELETE:
//				UnAssignPeak(CursorPosition(),7)
//				UnAssignPeak(CursorPosition(),6)
//				UnAssignPeak(CursorPosition(),5)
//				UnAssignPeak(CursorPosition(),4)
//				UnAssignPeak(CursorPosition(),3)
//				UnAssignPeak(CursorPosition(),2)
//				UnAssignPeak(CursorPosition(),1)
//				UnAssignPeak(CursorPosition(),0)
//				VMoveCursor(1)
//				return 1 
//			case VK_PRIOR:
//				VerticalScroll(-LinesPerFrame())
//				return 1
//			case VK_NEXT:
//				VerticalScroll(LinesPerFrame())
//				return 1
//			case VK_LEFT:
//				HMoveCursor(-1)
//				return 1 
//			case VK_UP:
//				VMoveCursor(-1)
//				return 1
//			case VK_RIGHT:
//				HMoveCursor(1)
//				return 1 
//			case VK_DOWN:
//				VMoveCursor(1)
//				return 1
//			case VK_A:
//				//Prevent Ctrl-A
//				return 1			
//			case VK_F2:
//				AddSeries()
//				return 1	
//			case VK_F3:
//				SelectSeries()
//				return 1
//			case VK_F4:
//				DeleteSeries()
//				//String PlotFolder = StringByKey("PlotFolder",S_Value,"=",",")
//				//NVAR CurrentSeries = $(PlotFolder+"CurrentSeries")
//				//DeleteSeries(CurrentSeries)
//				return 1	
//			case VK_F5:
//				GetWindow kwTopWin, note
//				String PlotFolder = StringByKey("PlotFolder",S_Value,"=",",")
//				NVAR CurrentSeries = $(PlotFolder+"CurrentSeries")
//				FitSeries(CurrentSeries)
//				return 1
//			case VK_F6:
//				GetWindow kwTopWin, note
//				PlotFolder = StringByKey("PlotFolder",S_Value,"=",",")
//				NVAR CurrentSeries = $(PlotFolder+"CurrentSeries")
//				ShiftSeries(CurrentSeries,0,1)
//				return 1
//			case VK_F7:
//				GetWindow kwTopWin, note
//				PlotFolder = StringByKey("PlotFolder",S_Value,"=",",")
//				NVAR CurrentSeries = $(PlotFolder+"CurrentSeries")
//				ViewSeries(CurrentSeries)
//				return 1
//			case VK_F8:
//				EditSeriesInfo()
//				return 1
//			case VK_F9:
//				ExtractAssignments()
//				return 1
//			case VK_F11:
//				ChangeRange(0, 0)
//				return 1
//			case VK_F12:
//				EditBandConstants()
//				return 1	
//			default:
//				//Print theKey
//				return 0
//			endswitch
//		case "mousedown":
//			theP = HitTestOld(InfoStr)
//			if (theP >= 0)
//				MoveCursor(theP)
// 			endif
// 			return 1
//		case "mousedblclk":
//			theP = HitTestOld(InfoStr)
//			if (theP >= 0)
//				AssignPeak(theP,GetCurrentSeriesNumber(),CursorM(), -1)
// 			endif			
//			return 1
//		case "mouseup":
//			theP = HitTestOld(InfoStr)
//			if ((theP >= 0) || (theP == -9))
//				return 1
// 			endif
// 			break
//		case "mousewheel":
//			VerticalScroll( sign(NumberByKey("DELTA",InfoStr)) )
//			return 1
// 		case "kill":
// 			return 0 //SWXKillDialog(StringByKey("WINDOW",InfoStr))			
//		default:
//			return 0
//	endswitch //(Event)
//
//End //function LWHookFunction

//static function SWXKillDialog(WinStr)
////This portion of the hook function will make sure that SetWindowExt kwTopWin is added to the recreation menu.
////However, if Display, Edit, NewPanel, or NewLayout have /K=0, the result will be dual DoRecreationDialogs.
////Because procedure windows cannot be edited while functions or macros are running, it is necessary to invoke  SetProcedureText via Execute/P.
////There is no way to prevent the SetProcedureText command from showing in the History window.
//	string WinStr
//		switch (DoRecreationDialog(WinStr))
//		case 0:	//Cancel
//			Return 2
//		case 1:	//Save
//		case 2:	//Replace
//			SVAR/Z S_FnName
//			if (cmpstr(S_FnName,WinStr))
//				DoWindow/F $WinStr
//				DoWindow/C $S_FnName
//			endif
//			string/G S_SWX_RecreationMacroText = SWXRecreation(S_FnName)
//			Execute/P/Z "SetProcedureText(\""+S_FnName+"\",S_SWX_RecreationMacroText,255)"
//			return 1
//		case 3:	//No Save
//			return 0
//		endswitch
//end //static function SWXKillDialog
//
//static function/S SWXRecreation(WinName)
//	string WinName
//	string theMacro = WinRecreation(WinName,0)
//	variable insert = StrSearch(theMacro,"\rEndMacro\r",0)
//	if (insert < 0)
//		Return ""
//	else
//		Return (theMacro[0,insert-1]+"\r\tSetWindowExt kwTopWin"+theMacro[insert,strlen(theMacro)])
//	endif
//end //static function/S SWXRecreation

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Loomis-Wood plot event handlers
static Function HitTest(s)
// Returns -8 through -1 if user clicks outside the plot area.
// Returns -9 or peak number if user clicks inside the plot area.
	STRUCT WMWinHookStruct &s

	Variable theResult = 0
	
	Variable xpixel, ypixel, theX, theY

	String theTrace

	xpixel = s.mouseLoc.h
	ypixel = s.mouseLoc.v //- TOP_BAR_HEIGHT
	theX = AxisValfromPixel("","bottom",xpixel)
	theY = AxisValfromPixel("","left",ypixel)
	GetAxis/Q left
	theResult = (theY > max(V_min,V_max))+2*(theY < min(V_min,V_max))
	GetAxis/Q bottom
	theResult += 3*(theX > max(V_min,V_max))+6*(theX < min(V_min,V_max))
	
	If (theResult)
		return -theResult
	EndIf

	theTrace = StringByKey("TRACE",TraceFromPixel(xpixel, ypixel,"PREF:Triangle_Yup;"))
	return NearestPeak(theX, theY - 0.2)	// New 2.01
	
	StrSwitch(theTrace)	// string switch
		case "Triangle_Yup":
		case "Triangle_Ydown":
		case "LWCursorYup":
		case "LWCursorYdown":
			return NearestPeak(theX, theY - 0.2)
		default:
	EndSwitch

	return -9
End //Static Function HitTest

//static Function HitTestOld(InfoStr)
//// Returns -8 through -1 if user clicks outside the plot area.
//// Returns -9 or peak number if user clicks inside the plot area.
//	String InfoStr
//
//	Variable theResult = 0
//	
//	Variable xpixel, ypixel, theX, theY
//
//	String theTrace
//
//	xpixel = NumberByKey("MOUSEX",InfoStr)
//	ypixel = NumberByKey("MOUSEY",InfoStr) - TOP_BAR_HEIGHT
//	theX = AxisValfromPixel("","bottom",xpixel)
//	theY = AxisValfromPixel("","left",ypixel)
//	GetAxis/Q left
//	theResult = (theY > max(V_min,V_max))+2*(theY < min(V_min,V_max))
//	GetAxis/Q bottom
//	theResult += 3*(theX > max(V_min,V_max))+6*(theX < min(V_min,V_max))
//	
//	If (theResult)
//		return -theResult
//	EndIf
//
//	theTrace = StringByKey("TRACE",TraceFromPixel(xpixel, ypixel,"PREF:Triangle_Yup;"))
//	StrSwitch(theTrace)	// string switch
//		case "Triangle_Yup":
//		case "Triangle_Ydown":
//		case "LWCursorYup":
//		case "LWCursorYdown":
//			return NearestPeak(theX, theY - 0.2)
//		default:
//	EndSwitch
//
//	return -9
//End //Static Function HitTest

static function NearestPeak(theX, theY)
// Finds the peak nearest a set of cartesian coordinates in a Loomis-Wood plot.
	variable theX, theY
	
	variable theM, minP, maxP

	GetWindow kwTopWin, note
	string PlotFolder = StringByKey("PlotFolder",S_Value,"=",",")
	WAVE Peak_LWm = $(PlotFolder+"Peak_LWm")
	WAVE Peak_delta_frequency = $(PlotFolder+"Peak_delta_frequency")
	GetAxis/Q bottom

	theM = ceil(theY)
	maxP = BinarySearch(Peak_LWm, theM)
	minP = maxP

	minP += 1
	do
		minP -= 1
	while (Peak_LWm[minP-1] == theM && minP > 0)

	maxP -= 1
	do
		maxP += 1
	while (Peak_LWm[maxP+1] == theM && maxP < numpnts(Peak_LWm))

	if (minP == maxP)
		return minP
	endif

	FindLevel /P/Q/R=[minP,maxP] Peak_delta_frequency, theX
	if (V_flag)
		return (theX < 0) ? minP : maxP
	endif
	
	return round(V_levelX)
	
end //static function NearestPeak

static Function VerticalScroll(Amount)
// Scrolls a Loomis-wood plot vertically
	Variable Amount

	Variable Delta
	String PlotFolder
	
	GetAxis/Q left
	Delta = Amount+.5

	GetWindow kwTopWin, note
	PlotFolder = StringByKey("PlotFolder",S_Value,"=",",")
	NVAR startM = $(PlotFolder+"startM")
	NVAR endM = $(PlotFolder+"endM")

	StartM = min(V_min,V_max) + Delta
	EndM = max(V_min,V_max) + Delta

	SetAxis/R left (floor(EndM)),(floor(StartM))
End //Static Function VerticalScroll

static Function LinesPerFrame()
	GetAxis/Q left
	Return abs(V_min-V_max)
End //Static Function LinesPerFrame

static function MoveCursor(theP)
// Moves the cursor on a Loomis-Wood plot.
	Variable theP
	if (numtype(theP))
		// theP is -INF, INF, or NaN, so do nothing.
		return 0
	endif

	String PlotFolder, SourceFolder
	Variable temp

	GetWindow kwTopWin, note
	PlotFolder = StringByKey("PlotFolder",S_Value,"=",",")
	SourceFolder = StringByKey("SourceFolder",S_Value,"=",",")
	NVAR maxP = $(PlotFolder+"maxP")
	NVAR minP = $(PlotFolder+"minP")

	if ((theP > max(maxP,minP)) || (theP < min(maxP,minP)))
		//Trying to move out of bounds, so do nothing
		return 0
	endif

	NVAR NumPeaks = $(SourceFolder+"NumPeaks")
	NVAR StartP = $(PlotFolder+"StartP")
	NVAR EndP = $(PlotFolder+"EndP")
	
	NVAR lwCursor_p = $(PlotFolder+"lwCursor_p")
	NVAR lwCursor_m = $(PlotFolder+"lwCursor_m")
	NVAR lwCursor_frequency = $(PlotFolder+"lwCursor_frequency")
	NVAR lwCursor_intensity = $(PlotFolder+"lwCursor_intensity")
	NVAR lwCursor_width = $(PlotFolder+"lwCursor_width")
	NVAR lwCursor_delta_m = $(PlotFolder+"lwCursor_delta_m")
	NVAR lwCursor_delta_frequency = $(PlotFolder+"lwCursor_delta_frequency")
	SVAR lwCursor_assignments= $(PlotFolder+"lwCursor_assignments")

	WAVE Peak_Frequency = $(Sourcefolder+"Peak_Frequency")
	WAVE Peak_Intensity = $(Sourcefolder+"Peak_Intensity")
	WAVE Peak_Width = $(Sourcefolder+"Peak_Width")
	WAVE/T Peak_Series = $(Sourcefolder+"Peak_Series")
	WAVE/T Series_Data = $(Sourcefolder+"Series_Data")
	WAVE/T Series_Name = $(Sourcefolder+"Series_Name")

	WAVE Triangle_X = $(PlotFolder+"Triangle_X")
	WAVE Triangle_Yup = $(PlotFolder+"Triangle_Yup")
	WAVE LWCursorYup = $(PlotFolder+"LWCursorYup")
	WAVE LWCursorYdown = $(PlotFolder+"LWCursorYdown")
	WAVE LWCursorX = $(PlotFolder+"LWCursorX")
	WAVE Peak_LWm = $(PlotFolder+"Peak_LWm")
	WAVE PolyCoeff = $(PlotFolder+"PolyCoeff")

	theP = limit(theP, 0, NumPeaks - 1)
	if (theP < StartP)
		VerticalScroll(round(Peak_LWm[theP])-round(Peak_LWm[StartP]))
		DoUpdate
		MoveCursor(theP)
		return 0
	elseif (theP > EndP)
		VerticalScroll(round(Peak_LWm[theP])-round(Peak_LWm[EndP]))
		DoUpdate
		MoveCursor(theP)
		return 0
	endif
	
	lwCursor_p = theP
	lwCursor_frequency = Peak_Frequency[theP]
	lwCursor_intensity = Peak_Intensity[theP]
	lwCursor_width = Peak_Width[theP]
	
 	temp = 5*(lwCursor_p-StartP)
	LWCursorX[0] = Triangle_X[temp]
	LWCursorX[1] = Triangle_X[temp+3]
	LWCursorYdown = Triangle_Yup[temp]
	LWCursorYup = Triangle_Yup[temp]-0.8
	
	lwCursor_m = Triangle_Yup[temp]
	lwCursor_delta_m = Triangle_X[temp+1]
	lwCursor_delta_frequency = lwCursor_frequency - poly(PolyCoeff, lwCursor_m)

	Variable i, series, nseries
	String m
	nseries = ItemsInList(Peak_Series[theP])
	if (nseries <= 0)
		lwCursor_assignments = "Unassigned"
	else
		lwCursor_assignments = ""
		for (i = 0 ; i < nseries ; i += 1)
			series = str2num(StringFromList(i,Peak_Series[theP]))
			m = StringByKey(num2str(theP), Series_Data[series])
			m = StringFromList(0,m,",")
			lwCursor_assignments += Series_Name[series]+" "+m+";"
		endfor
	endif
	PopupMenu popup_assignments,mode=1

End //Static Function MoveCursor

static Function CursorPosition()
	String PlotFolder
	GetWindow kwTopWin, note
	PlotFolder = StringByKey("PlotFolder",S_Value,"=",",")
	NVAR lwCursor_p = $(PlotFolder+"lwCursor_p")
	Return lwCursor_p
End //Static Function CursorPosition

static function CursorM()
	GetWindow kwTopWin, note
	String PlotFolder = StringByKey("PlotFolder",S_Value,"=",",")
	WAVE Peak_LWm = $(PlotFolder+"Peak_LWm")
	return round(Peak_LWm[CursorPosition()])
end

static function VMoveCursor(Amount)
	Variable Amount

	String PlotFolder
	Variable temp

	GetWindow kwTopWin, note
	PlotFolder = StringByKey("PlotFolder",S_Value,"=",",")
	NVAR lwCursor_p = $(PlotFolder+"lwCursor_p")
	NVAR StartP = $(PlotFolder+"StartP")
	WAVE Triangle_X = $(PlotFolder+"Triangle_X")
	WAVE Triangle_Yup = $(PlotFolder+"Triangle_Yup")
	
 	temp = 5*(lwCursor_p-StartP)
	temp = NearestPeak(Triangle_X[temp+1], Triangle_Yup[temp]+ Amount)
	if (temp == CursorPosition())
		MoveCursor(temp+Amount)
	else
		MoveCursor(temp)
	endif

End //Static Function VMoveCursor

static Function HMoveCursor(Amount)
	Variable Amount
	MoveCursor(CursorPosition() + Amount)
End //Static Function HMoveCursor

function ChangeRange(theMin, theMax)		//F11
// OPTIONAL DIALOG
// Changes the left axis scaling of a Loomis-Wood plot.
	variable theMin, theMax

	if (!isTopWinLWPlot(1))
		Beep
		Print LW_ERROR3
		return 0
	endif

	GetWindow kwTopWin, note
	String PlotFolder = StringByKey("PlotFolder",S_Value,"=",",")
	NVAR StartM = $(PlotFolder+"StartM")
	NVAR EndM = $(PlotFolder+"EndM")

	if ((theMin==0) && (theMax==0))
		do
			theMax = ceil(StartM)
			theMin = floor(EndM)
			Prompt theMax, LW_STRING15
			Prompt theMin, LW_STRING16
			DoPrompt LW_TITLE, theMax, theMin

			if (V_flag)
				return 0
			endif
		while ((theMin==0) && (theMax==0))
	endif

	StartM = min(theMin,theMax) - 1 
	EndM = max(theMin,theMax)

	SetAxis/R left EndM, StartM
	EndM -= 0.5
	StartM += 0.5
end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Series related functions
function SelectSeries()
// NON-OPTIONAL DIALOG
	if (!isTopWinLWPlot(1))
		Beep
		Print LW_ERROR3
		return 0
	endif

	GetWindow kwTopWin, note
	String SourceFolder = StringByKey("SourceFolder",S_Value,"=",",")
	WAVE/T Series_Name = $(SourceFolder+"Series_Name")

	variable theSeries
	prompt theSeries, LW_STRING12, popup TextWave2List(Series_Name)+"_Create_New_Series_;"
	doprompt LW_TITLE, theSeries
	if (V_Flag)
		return 0
	endif
	
	CurrentSeriesPopupMenuControl("SelectSeries Function",theSeries,"")
end function

static function ChangeCurrentSeries(theSeries)
	Variable theSeries

	GetWindow kwTopWin, note
	String SourceFolder = StringByKey("SourceFolder",S_Value,"=",",")
	String PlotFolder = StringByKey("PlotFolder",S_Value,"=",",")
	
	NVAR NumSeries = $(SourceFolder+"NumSeries")
	NVAR CurrentSeries = $(PlotFolder+"CurrentSeries")

	if ((theSeries > 0) && (theSeries <= NumSeries))
		CurrentSeries = theSeries
		PopupMenu CurrentSeriesPopup, mode=theSeries
	else
		//Out of Range -- Do nothing
	endif
end

function DeleteSeries()
	if (!isTopWinLWPlot(1))
		Beep
		Print LW_ERROR3
		return 0
	endif

	string saveDF = GetDataFolder(1)
	GetWindow kwTopWin, note
	SetDataFolder StringByKey("SourceFolder",S_Value,"=",",")
	
	NVAR NumSeries
	WAVE/T Series_Name, Series_Data, Series_QN
	WAVE Series_Color, Series_Shape, Series_Order
	WAVE/T Peak_Series
	
	SetDataFolder saveDF
	
	variable theSeries
	prompt theSeries, LW_STRING13, popup TextWave2List(Series_Name)
	doprompt LW_TITLE, theSeries
	if (V_Flag)
		return 0
	endif

	Variable i, npnts, point
	npnts = ItemsInList(Series_Data[theSeries])
	string item
	for (i=0 ; i<npnts ; i+=1)
		item = StringFromList(i,Series_Data[theSeries],";")
		point = str2num(StringFromList(0,item,":"))
		Peak_Series[point] = RemoveFromList(num2str(theSeries),Peak_Series[point],";")
	endfor
	
	Variable series
	npnts=numpnts(Peak_Series)
	for (point=0 ; point<npnts; point+=1)
		if (ItemsInList(Peak_Series[point])>0)
			item = ""
			for (i=0 ; i<ItemsInList(Peak_Series[point]) ; i+=1)
				series = str2num(StringFromList(i,Peak_Series[point],";"))
				series -= series > theSeries ? 1 : 0
				item += num2str(series)+";"
			endfor
			Peak_Series[point] = item
		endif
	endfor


	DeletePoints theSeries, 1, Series_Name, Series_Data, Series_Color, Series_Shape, Series_Order, Series_QN
	NumSeries -= 1
end

function AddSeries()
	if (!isTopWinLWPlot(1))
		Beep
		Print LW_ERROR3
		return 0
	endif

	string saveDF = GetDataFolder(1)
	GetWindow kwTopWin, note
	SetDataFolder StringByKey("SourceFolder",S_Value,"=",",")
	
	NVAR NumSeries
	WAVE/T Series_Name, Series_Data, Series_QN 
	WAVE/T ColorNames
	WAVE Series_Color, Series_Shape, Series_Order
	SetDataFolder saveDF
			
	string SeriesName
	variable SeriesColor = Mod(NumSeries,6)+1
	Prompt SeriesName, LW_STRING10
	Prompt SeriesColor, LW_STRING11, popup, TextWave2List(ColorNames) //COLOR_LIST

	do		// Dialog repeats if SeriesName contains a ";", or is of length 0
		DoPrompt LW_TITLE, SeriesName, SeriesColor
		if (V_Flag)
			// User Canceled -- Do Nothing
			return 1
		endif
	while ((strsearch(SeriesName,";",0)!=-1) || (strlen(SeriesName) < 1))

	NumSeries += 1
	Redimension/N=(NumSeries+1) Series_Name, Series_Data, Series_Color, Series_Shape, Series_Order
	Redimension/N=(NumSeries+1,-1) Series_QN
	Series_Name[NumSeries] = SeriesName
	Series_Data[NumSeries] = ""
	Series_Color[NumSeries] = SeriesColor
	Series_Shape[NumSeries] = -1
	Series_Order[NumSeries] = 1
end

function GetCurrentSeriesNumber()
// DO NOT MAKE STATIC
	if (!isTopWinLWPlot(1))
		Beep
		Print LW_ERROR3
		return 0
	endif

	GetWindow kwTopWin, note
	String SourceFolder = StringByKey("SourceFolder",S_Value,"=",",")
	String PlotFolder = StringByKey("PlotFolder",S_Value,"=",",")
	NVAR CurrentSeries = $(PlotFolder+"CurrentSeries")
	NVAR NumSeries = $(SourceFolder+"NumSeries")
	if ((CurrentSeries > NumSeries) || (CurrentSeries < 1))
		// A valid series is not currently selected
		if (NumSeries == 0)
			// There are no series yet		
			AddSeries()
		else
			//Need to select a series
			SelectSeries()
		endif
		DoUpdate	// Must force update here to make the popup display correctly
					// after the call to ChangeCurrentSeries()
		ChangeCurrentSeries(CurrentSeries)
	endif
	return CurrentSeries
end

static function AssignPeak(theP, theSeries, theM, theShape)
	Variable theP, theSeries, theM, theShape
	Variable theA
	Variable otherP
	
	string saveDF = GetDataFolder(1)
	GetWindow kwTopWin, note
	SetDataFolder  StringByKey("SourceFolder",S_Value,"=",",")
	WAVE/T Peak_Series, Series_Data
	SetDataFolder saveDF
	
	Series_Data[theSeries] = ReplaceStringByKey( num2str(theP) , Series_Data[theSeries] , num2str(theM)+","+num2str(theShape) )
	if ( !(FindListItem(num2str(theSeries) , Peak_Series[theP]) >= 0) )
		Peak_Series[theP] += num2str(theSeries) + ";"
	endif
End //Static Function AssignPeak

static Function UnAssignPeak(theP, theSeries)
	Variable theP, theSeries
	
	GetWindow kwTopWin, note
	String SourceFolder = StringByKey("SourceFolder",S_Value,"=",",")
	
	WAVE/T Peak_Series = $(SourceFolder+"Peak_Series")
	WAVE/T Series_Data = $(SourceFolder+"Series_Data")

	Series_Data[theSeries] = RemoveByKey( num2str(theP) , Series_Data[theSeries] )
	Peak_Series[theP] = RemoveFromList( num2str(theSeries), Peak_Series[theP] )
End //Static Function UnAssignPeak

function/S UndoFit()
	if (!isTopWinLWPlot(1))
		Beep
		return LW_ERROR3
	endif

	string saveDF=GetDataFolder(1)
	GetWindow kwTopWin, note
	SetDataFolder StringByKey("PlotFolder",S_Value,"=",",")
	WAVE BandCoeff
	WAVE LastCoeff
	SetDataFolder saveDF
	
	if (WaveExists(LastCoeff))
		BandCoeff = LastCoeff
	else
		return LW_ERROR9
	endif
	
	return ""
	
end

function/S FitSeries(theSeries)
// Fits theSeries to a polynomial.
// TODO: Needs an optional dialog for theSeries < 0
// TODO: Needs error handling
	variable theSeries

	string message, total_message=""

	if (!isTopWinLWPlot(1))
		Beep
		return LW_ERROR3
	endif
	
	if (theSeries <0 || numtype(theSeries))
		Beep
		return LW_ERROR6
	endif

	variable order

	string saveDF=GetDataFolder(1)
	GetWindow kwTopWin, note
	SetDataFolder StringByKey("PlotFolder",S_Value,"=",",")
	WAVE BandCoeff
	Duplicate/O BandCoeff, LastCoeff

	SetDataFolder StringByKey("SourceFolder",S_Value,"=",",")
	WAVE Series_Order, Poly2Band
	WAVE/T BandCoeffLabels, Series_Name
	
	if (theSeries >= numpnts(Series_Order))
		Beep
		SetDataFolder saveDF 
		return LW_ERROR6
	endif
	
	FetchSeries(theSeries)
	SetDataFolder SeriesFit
	WAVE Series_Frequency, Series_M, Series_Select
	Duplicate/O Series_Frequency, Series_Residual
	
	Variable V_FitOptions = 4	// Suppress Dialog
	Variable V_FitError = 0
	order = Series_Order[theSeries] + 1
	if (order > 2)
		CurveFit/Q/M=2/N poly order, Series_Frequency /X=Series_M /M=Series_Select /R=Series_Residual /A=0 
	elseif (order == 2)
		K2 = 0
		CurveFit/Q/M=2/N/H="001" poly 3, Series_Frequency /X=Series_M /M=Series_Select /R=Series_Residual /A=0 
	else
		Beep
		SetDataFolder saveDF 
		return LW_ERROR7
	endif

	if (V_FitError)
		Beep
		total_message = LW_ERROR8
	else
		WAVE W_coef , W_sigma, M_Covar
	
		Redimension /N=(MAX_FIT_ORDER) W_coef
		Redimension /N=(MAX_FIT_ORDER) W_sigma
		Redimension /N=(MAX_FIT_ORDER, MAX_FIT_ORDER) M_covar
		M_covar *= (p<order) && (q<order)
		
		MatrixMultiply Poly2Band, W_coef
		WAVE M_product = M_product
		BandCoeff = M_product
	
		MatrixMultiply Poly2Band, M_covar
		M_covar = M_product
		MatrixMultiply M_covar, Poly2Band/T
		M_covar = M_product
		W_sigma = sqrt(M_covar[p][p])
	
		Duplicate/O M_covar M_correl
		M_correl = ((p<order) && (q<order)) ? M_covar[p][q]/(W_sigma[p]*W_sigma[q]) :  0
		
		variable index, index2
		string strDigit
		sprintf total_message, "\tFit of series %s, order %d, %d lines.\r", Series_Name[theSeries], order -1, V_npnts
		sprintf message, "\t%16s = %14.4G\r" "S. E.", sqrt(V_chisq/(V_npnts - order))
		total_message += message
		for (index = 0 ; index < order ; index += 1)
			strDigit = num2str(2+floor(log(abs(BandCoeff[index])))-floor(log(abs(W_sigma[index]))))
			sprintf message, "\t%16s = %#14."+strDigit+"G ± %#5.2G", BandCoeffLabels[index], BandCoeff[index], W_sigma[index]
			total_message += message
			for (index2 = 0 ; index2 < index ; index2 += 1)
				sprintf message, "\t\t%6.3f", M_correl[index][index2]
				total_message += message
			endfor
			sprintf message, "\r"
			total_message += message
		endfor	
		Variable/G ChiSq=V_ChiSq, nPnts=V_nPnts
		
		KillWaves/Z W_ParamConfidenceInterval, M_Product
	endif
	SetDataFolder saveDF
	return total_message
end

static function FetchSeries(theSeries)
//FetchSeries creates the global waves Series_M, Series_Frequency, Series_Select, Series_Intensity, and Series_Width
	variable theSeries

	string saveDF = GetDataFolder(1)
	GetWindow kwTopWin, note

	SetDataFolder StringByKey("PlotFolder",S_Value,"=",",")
	WAVE Peak_delta_frequency

	SetDataFolder StringByKey("SourceFolder",S_Value,"=",",")
	WAVE Peak_Frequency, Peak_Intensity, Peak_Width
	WAVE/T Peak_Series, Series_Data

	NewDataFolder/O/S SeriesFit
	Variable npnts = ItemsInList(Series_Data[theSeries])

	Make/D/O/N=(npnts) Series_M, Series_Frequency, Series_Residual, Series_Select, Series_Intensity, Series_Width
	SetDataFolder SaveDF 

	Variable i, pnt
	String data
	for (i = 0 ; i < npnts ; i += 1)
		data = StringFromList(i,Series_Data[theSeries])
		pnt = str2num(StringFromList(0,data,":"))
		data = StringFromList(1,data,":")

		Series_M[i] = str2num(StringFromList(0,data,","))
		Series_Select[i] = str2num(StringFromList(1,data,","))

		Series_Frequency[i] = Peak_Frequency[pnt]
		Series_Residual[i] = Peak_delta_Frequency[pnt]
		Series_Intensity[i] = Peak_Intensity[pnt]
		Series_Width[i] = Peak_Width[pnt]
	endfor
	
	Sort Series_M, Series_Frequency, Series_Residual, Series_Select, Series_Intensity, Series_Width, Series_M
end

Function ViewSeries(theSeries)		//F7
	Variable theSeries
	if (!isTopWinLWPlot(1))
		Beep
		Print LW_ERROR3
		return 0
	endif

	FetchSeries(theSeries)
	
	string saveDF = getDataFolder(1)
	GetWindow kwTopWin, note
	SetDataFolder StringByKey("SourceFolder",S_Value,"=",",")
	SetDataFolder SeriesFit
	WAVE Series_M, Series_Frequency, Series_Residual, Series_Select, Series_Intensity, Series_Width

	Edit/K=1/W=(3,0,338.25,404)  Series_M, Series_Frequency, Series_Residual, Series_Select, Series_Intensity, Series_Width
	Execute/Z "ModifyTable width(Point)=18,width(Series_M)=24,title(Series_M)=\"M\",format(Series_Frequency)=3"
	Execute/Z "ModifyTable digits(Series_Frequency)=6,width(Series_Frequency)=68,title(Series_Frequency)=\"Frequency\""
	Execute/Z "ModifyTable format(Series_Residual)=3,digits(Series_Residual)=6,width(Series_Residual)=62"
	Execute/Z "ModifyTable title(Series_Residual)=\"Residual\",width(Series_Select)=42,title(Series_Select)=\"Select\""
	Execute/Z "ModifyTable format(Series_Intensity)=3,width(Series_Intensity)=59,title(Series_Intensity)=\"Intensity\""
	Execute/Z "ModifyTable format(Series_Width)=3,digits(Series_Width)=6,width(Series_Width)=51"
	Execute/Z "ModifyTable title(Series_Width)=\"Width\""

	SetDataFolder saveDF
End Function

Function EditSeriesInfo()
	if (!isTopWinLWPlot(1))
		Beep
		Print LW_ERROR3
		return 0
	endif
	
	string saveDF = getDataFolder(1)
	GetWindow kwTopWin, note
	SetDataFolder StringByKey("SourceFolder",S_Value,"=",",")
	WAVE/T Series_Name, Series_QN
	WAVE Series_Shape, Series_Color, Series_Order

	Edit/W=(3,37.25,681,416)/K=1 Series_Name,Series_Color,Series_Shape,Series_Order,Series_QN
	Execute/Z "ModifyTable width(Point)=36,width(Series_Name)=56,title(Series_Name)=\"Name\",width(Series_Color)=32"
	Execute/Z "ModifyTable title(Series_Color)=\"Color\",width(Series_Shape)=32,title(Series_Shape)=\"Shape\""
	Execute/Z "ModifyTable width(Series_Order)=32,title(Series_Order)=\"Order\",width(Series_QN)=54"
	Execute/Z "ModifyTable title(Series_QN)=\"Sel. Rules\""
	
	SetDataFolder saveDF
End Function

function ShiftSeries(theSeries, theShift, autoFixConstants)
// OPTIONAL DIALOG
// M-Shifts a series.
	Variable theSeries, theShift, autoFixConstants

	if (!isTopWinLWPlot(1))
		Beep
		Print LW_ERROR3
		return 0
	endif

	if (!theShift)
		// If theShift is zero, prompt for a new value
		Prompt theShift, LW_STRING14
		DoPrompt LW_TITLE, theShift
		if (V_flag)
			return 0
		endif
	endif
	
	GetWindow kwTopWin, note
	String SourceFolder = StringByKey("SourceFolder",S_Value,"=",",")
	//String PlotFolder = StringByKey("SourceFolder",S_Value,"=",",")
	
	WAVE/T Series_Data = $(SourceFolder + "Series_Data")
	Variable npnts = ItemsInList(Series_Data[theSeries])

	Variable i, pnt, m, shape
	String data, new_data=""
	for (i = 0 ; i < npnts ; i += 1)
		data = StringFromList(i,Series_Data[theSeries])
		pnt = str2num(StringFromList(0,data,":"))
		data = StringFromList(1,data,":")
		m = str2num(StringFromList(0,data,",")) + theShift
		shape = str2num(StringFromList(1,data,","))
		new_data += num2str(pnt)+":"+num2str(m)+","+num2str(shape)+";"
	endfor
	
	Series_Data[theSeries] = new_data
			
	if (autoFixConstants)
		ShiftConstants(-theShift)
	endif
end

function ShiftConstants(theShift)
// OPTIONAL DIALOG
// This function M-Shifts BandCoeff
	variable theShift

	if (!isTopWinLWPlot(1))
		Beep
		Print LW_ERROR3
		return 0
	endif

	if (!theShift)
		// If theShift is zero, prompt for a new value
		Prompt theShift, LW_STRING14
		DoPrompt LW_TITLE, theShift
		if (V_flag)
			return 0
		endif
	endif
	
	GetWindow kwTopWin, note
	string SourceFolder = StringByKey("SourceFolder",S_Value,"=",",")
	string PlotFolder = StringByKey("PlotFolder",S_Value,"=",",")
	WAVE PolyCoeff = $(PlotFolder + "PolyCoeff")
	WAVE BandCoeff = $(PlotFolder + "BandCoeff")
	WAVE Poly2Band = $(SourceFolder + "Poly2Band")

	Make/D/O/N=(MAX_FIT_ORDER,MAX_FIT_ORDER) M_Temp
	M_Temp = ((p+q) <= 6)*binomial(p+q,p)*PolyCoeff[p+q]
	Make/D/O/N=(MAX_FIT_ORDER) V_Temp
	V_Temp[0] = 1
	V_Temp[1,6] = V_Temp[p-1]*theShift
	MatrixMultiply M_Temp, V_Temp
	WAVE M_Product
	PolyCoeff = M_Product[p][0]
	MatrixMultiply Poly2Band, PolyCoeff
	BandCoeff = M_Product[p][0]
	KillWaves M_Product, V_Temp, M_Temp

	VerticalScroll(-theShift)
	DoUpdate
	MoveCursor(CursorPosition())
end

function EditBandConstants()		//F12
// NON-OPTIONAL DIALOG
	if (!isTopWinLWPlot(1))
		Beep
		Print LW_ERROR3
		return 0
	endif
	
	string saveDF = GetDataFolder(1)
	GetWindow kwTopWin, note
	SetDataFolder StringByKey("PlotFolder",S_Value,"=",",")
	WAVE BandCoeff
	SetDataFolder StringByKey("SourceFolder",S_Value,"=",",")
	WAVE/T BandCoeffLabels
	SetDataFolder saveDF
	
	variable const0 = BandCoeff[0]
	variable const1 = BandCoeff[1]
	variable const2 = BandCoeff[2]
	variable const3 = BandCoeff[3]
	variable const4 = BandCoeff[4]
	variable const5 = BandCoeff[5]
	variable const6 = BandCoeff[6]
	Prompt const0, BandCoeffLabels[0]
	Prompt const1, BandCoeffLabels[1]
	Prompt const2, BandCoeffLabels[2]
	Prompt const3, BandCoeffLabels[3]
	Prompt const4, BandCoeffLabels[4]
	Prompt const5, BandCoeffLabels[5]
	Prompt const6, BandCoeffLabels[6]
	DoPrompt LW_TITLE, const0, const4, const1, const5, const2, const6, const3
	if (V_flag)
		return 0
	endif
	BandCoeff[0] = const0
	BandCoeff[1] = const1
	BandCoeff[2] = const2
	BandCoeff[3] = const3
	BandCoeff[4] = const4
	BandCoeff[5] = const5
	BandCoeff[6] = const6
end function

function EditColors()
	if (!isTopWinLWPlot(1))
		Beep
		Print LW_ERROR3
		return 0
	endif
	
	string saveDF = GetDataFolder(1)
	GetWindow kwTopWin, note
	SetDataFolder StringByKey("SourceFolder",S_Value,"=",",")
	WAVE/T ColorNames
	WAVE M_Colors
	SetDataFolder saveDF
	Edit/K=1 ColorNames, M_Colors
end

static function ValidateSourceFolder (SourceFolder)
// Makes sure that the SourceFolder string is valid.
// Changes SourceFolder to be an absolute reference.
// Returns 1 if SourceFolder is invalid, 0 if SorceFolder is valid.
 	string &SourceFolder

	variable theRes = 0
	string saveDF = GetDataFolder(1)
		
	// SourceFolder may be relative to BASE_FOLDER, absolute, or invalid
	string temp = SourceFolder + "::"
	if (DataFolderExists(SourceFolder) && DataFolderExists(temp))
		//If FolderA exists, the Source MAY be absolute
		SetDataFolder SourceFolder
		SetDataFolder ::
		if (cmpstr(GetDataFolder(1),BASE_FOLDER+":"))
			// invalid or relative
		else 
			// SourceFolder is absolute so make it relative
			SetDataFolder SourceFolder
			SourceFolder = GetDataFolder(0)
		endif
	endif

	// Now, SourceFolder is relative to BASE_FOLDER or invalid
	temp = BASE_FOLDER + ":" + SourceFolder
	if (!DataFolderExists(temp))
		theRes = 1
	else
		SetDataFolder temp
		// Now, SourceFolder is validated and absolute
		SourceFolder=GetDataFolder(1)
	endif
	
	SetDataFolder saveDF
	return theRes
 end
 
 function OrderSetVarProc(ctrlName,varNum,varStr,varName) : SetVariableControl
	string ctrlName
	variable varNum
	string varStr
	string varName

	GetWindow kwTopWin, note
	string SourceFolder = StringByKey("SourceFolder",S_Value,"=",",")
	string PlotFolder = StringByKey("PlotFolder",S_Value,"=",",")
	
	WAVE Series_Order = $(SourceFolder+"Series_Order")
	NVAR CurrentSeries = $(PlotFolder+"CurrentSeries")
	
	Series_Order[CurrentSeries] = varNum
end

function CurrentSeriesPopupMenuControl(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	
	String SourceFolder, PlotFolder

	GetWindow kwTopWin, note
	SourceFolder = StringByKey("SourceFolder",S_Value,"=",",")
	
	NVAR NumSeries = $(SourceFolder+"NumSeries")
	
	if (popNum > NumSeries)
		if(AddSeries())
			//User canceled AddSeries:
			PlotFolder = StringByKey("PlotFolder",S_Value,"=",",")
			NVAR CurrentSeries = $(PlotFolder+"CurrentSeries")
			popNum = CurrentSeries
		endif
		DoUpdate	// Must force update here to make the popup display correctly
					// after the call to ChangeCurrentSeries()
	endif
	ChangeCurrentSeries(popNum)
end

function ExtractAssignments()
	if (!isTopWinLWPlot(1))
		Beep
		Print LW_ERROR3
		return 0
	endif
	
	string saveDF = GetDataFolder(1)
	GetWindow kwTopWin, note
	SetDataFolder StringByKey("SourceFolder",S_Value,"=",",")

	WAVE Peak_Frequency, Peak_Intensity, Peak_Width
	WAVE/T Peak_Series
	WAVE Series_Shape, Series_Color, Series_Order
	WAVE/T Series_Data, Series_QN
	NVAR NumPeaks, NumSeries
	
	NewDataFolder/O/S Assignments
	variable NumAssignments = 0
	variable index1
	for (index1 = 0 ; index1 < NumPeaks ; index1 += 1)
		NumAssignments += ItemsInList(Peak_Series[index1])
	endfor
	
	Make/O/D/N=(NumAssignments) Frequency, Intensity, Width
	Make/O/W/N=(NumAssignments) Series, theM, Select
	Make/O/I/N=(NumAssignments) theP

	//variable MaxQN
	//for (index1 = 0 ; index1 < MAX_QN ; index1 += 1)
	//	if (!cmpstr(Series_QN[0][index1],""))
	//		break
	//	endif
	//	Series_QN[0][index1] = CleanupName(Series_QN[0][index1], 0)
	//	Make/O/W/N=(NumAssignments) $(Series_QN[0][index1])
	//endfor
	//MaxQN = index1
	//string theString = ""

	variable m, nseries, index2, ser, assignment=0
	string data
	for (index1 = 0 ; index1 < NumPeaks ; index1 += 1)
		nseries = ItemsInList(Peak_Series[index1])
		for (index2 = 0 ; index2 < nseries ; index2 += 1)
			Frequency[assignment] = Peak_Frequency[index1]
			Intensity[assignment] = Peak_Intensity[index1]
			Width[assignment] = Peak_Width[index1]

			ser = str2num(StringFromList(index2,Peak_Series[index1]))
			data = StringByKey(num2str(index1),Series_Data[ser])
			M = str2num(StringFromList(0,data,","))

			Select[assignment] = str2num(StringFromList(1,data,","))
			theM[assignment] = M
			Series[assignment] = ser

			theP[assignment] = index1
				


//			theString = "["+num2str(A)+"] = "
//			for (index3 = 0 ; index3 < MaxQN ; index3 += 1)
//				Execute/Z Series_QN[0][index3] + theString + Series_QN[S][index3]
//			endfor
//
			assignment += 1
		endfor
	endfor
	
	Edit/K=1/W=(5,5,700,400) Frequency, Intensity, Width,Series, theM, theP, Select
	// for (index3 = 0 ; index3 < MaxQN ; index3 += 1)
	// 	AppendToTable $Series_QN[0][index3]
	// endfor
	Execute/Z "ModifyTable width = 35"
	Execute/Z "ModifyTable width(Frequency)=80,format(Frequency)=3,digits(Frequency)=6"
	Execute/Z "ModifyTable width(Point)=30,width(Intensity)=60,format(Intensity)=3"
	Execute/Z "ModifyTable width(Width)=60,format(Width)=3,digits(Width)=6,width(Series)=50"

	SetDataFolder saveDF
end function

function Assign_Peaklist(Replace)
	Variable Replace
	if (!isTopWinLWPlot(1))
		Beep
		Print LW_ERROR3
		return 0
	endif
	
	string saveDF = GetDataFolder(1)
	GetWindow kwTopWin, note
	SetDataFolder StringByKey("SourceFolder",S_Value,"=",",")

	WAVE Peak_Shape, Peak_Series, Peak_Assignment
		
	SetDataFolder Assignments
	NVAR NumAssignments
	WAVE Series, theM, Select, theP
	if (Replace)
		Peak_Series = 0
		Peak_Assignment = 0
		Peak_Shape = 0
	endif

	Select += 2*(Select<0)
	variable index
	for( index = 0 ; index < NumAssignments ; index += 1)
		AssignPeak(theP[index], Series[index], theM[index], Select[index])
	endfor
	SetDataFolder saveDF
end function
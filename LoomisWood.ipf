#pragma rtGlobals = 1			// Use modern global access method.
#pragma IgorVersion = 5.02
#pragma Version = 2.06

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
// 1.  Colors are no longer based on the Integer2Color function and the Rainbow color table, but a RGB color wave Colors in the Loomis-wood Folder.
// 2.  The Control Bar in Loomis-Wood Plot is now a sub-window.
// 3.  Added zoom
// 4.  Assignments are now databased by two text waves:  Line_Series and Series_Data.
//      This change eliminates the need for MAX_DUP_ASSIGN and allows the same line to be assigned multiple times without wasting memory.
//      This change also improves the performance of many operations, since assignment info is availible by peak or by series, instead of just by peak.
// 5.  Improved Error Handling of FitSeries.  Changed output of FitSeries to string, instead of simply printing results to history.
// 6.  Implemented an Undo Last Fit Command...  
// 7.  Made sure all Make commands specify precision explicitly, since some installations may default to single precision instead of double precision.

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Global constants
static strconstant BASE_FOLDER = "root:LW"

static constant FIVEMAX_PEAKS_PER_PLOT = 10000
static constant MAX_FIT_ORDER = 7
static constant MAX_M = 10000

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
static strconstant LW_STRING22 = "Frequency Tolerence"
static strconstant LW_STRING23 = "Assignment function"

static strconstant LW_HISTORY1="\tThe Loomis-Wood folder \""
static strconstant LW_HISTORY2="\" has been deleted."
static strconstant LW_HISTORY3="\" has been created."

// COLOR_LIST replaced by ColorNames wave version 2.01
// static strconstant COLOR_LIST = "Red;Orange;Yellow;Green;Blue;Violet;Cyan"
// static strconstant COLOR_LIST = "Red;Yellow;Lime;Aqua;Blue;Fuscia;Maroon;Olive;Green;Teal;Navy;Purple;Black;Grey"

static strconstant LW_ERROR1 = "\tLoomis-Wood Error: \""
static strconstant LW_ERROR2 = "\" does not exist."
static strconstant LW_ERROR3 = "\tLoomis-Wood Error:  The active graph is not a Loomis-Wood plot.\r"
static strconstant LW_ERROR4 = "\tLoomis-Wood Error:  There are no peaks predicted by the current band constants.  Please edit the band constants.\r"
static strconstant LW_ERROR5 = "\tLoomis-Wood Error:  The band constants are invalid.  Please edit the band constants.\r"
static strconstant LW_ERROR6 = "\tLoomis-Wood Error:  The series requested does not exist.\r"
static strconstant LW_ERROR7 = "\tLoomis-Wood Error:  The order of the series to be fit is less than 1.\r"
static strconstant LW_ERROR8 = "\tLoomis-Wood Error:  An error occured while fitting the current series.\r"
static strconstant LW_ERROR9 = "\tLoomis-Wood Error:  A backup coefficient wave does not exist.\r"
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Loomis-Wood menu and related functions:
menu "&Loomis-Wood", dynamic
// This builds the Loomis-Wood munu
// NOTE:  FUNCTIONS AND VARIABLES REFERENCED IN THIS PROCEDURE CANNOT BE STATIC!
// Thus, all of the strings for this menu  are literals, not static strconstants.
	help = {OnLWmenuBuild()+"Welcome to Loomis-Wood!"}

	submenu "&Data Sets"

		"Create a &New Loomis-Wood Data Set...", NewLWDataSet()
		help = {"Create a new Loomis-Wood folder."}

		"&Delete a Loomis-Wood Data Set...", DeleteLWDataSet("")
		help = {"Delete an existing Loomis-Wood folder."}

		"-"
		help = {"", ""}

		LWDynamicMenuItem()+ "View Line List...", ViewLineList()
		help = {"View the line list for the curent data set", "This command is only availible for Loomis-Wood plots."}

		LWDynamicMenuItem()+ "View Series List.../F8", ViewSeriesList()
		help = {"View/Edit the name, color, order, etc. of all assigned series.", "This command is only availible for Loomis-Wood plots."}

		LWDynamicMenuItem()+ "Extract &Assignments.../F9", ExtractAssignments("")
		help = {"Create a table of assignments.", "This command is only availible for Loomis-Wood plots."}
		
		"-"
		help = {"", ""}

		LWDynamicMenuItem()+ "Update Line List...", UpdateLinesFolder(NaN)
		help = {"Update line list to reflect added or deleted lines.", "This command is only availible for Loomis-Wood plots."}

		LWDynamicMenuItem()+ "Synchronize Lines To Series", SynchronizeLines2Series()
		help = {"Synchronize series data with assignments.  This is necessary after manually editing the line list.", "This command is only availible for Loomis-Wood plots."}

		LWDynamicMenuItem()+ "Synchronize Series To Lines", SynchronizeSeries2Lines()
		help = {"Synchronize assignments with series data.  This is necessary after manually editing series table.", "This command is only availible for Loomis-Wood plots."}

		"-"
		help = {"", ""}

		LWDynamicMenuItem()+ "Edit Colors", EditColors()
		help = {"View/Edit the Colors used for the current Loomis-Wood folder.", "This command is only availible for Loomis-Wood plots."}
	end //submenu
	
	submenu "&Plots"
		"&Create a New Loomis-Wood Plot...", NewLWPlot("","")
		help = {"Make a Loomis-Wood plot.  You must have already created a Loomis-Wood folder."}
		
		"(&Delete a Loomis-Wood Plot...", 
		help = {"Make a Loomis-Wood plot.  You must have already created a Loomis-Wood folder."}		

		LWDynamicMenuItem()+ "Change &M-axis scaling.../F11", ChangeRange(0,0)
		help = {"Change the M-axis scaling of the current Loomis-Wood plot.", "This command is only availible for Loomis-Wood plots."}

		LWDynamicMenuItem()+ "Edit &Band Constants.../F12", EditBandConstants()
		help = {"View/Edit the Band Constants for the current Loomis-wood plot.", "This command is only availible for Loomis-Wood plots."}

	end

	submenu LWDynamicMenuItem()+ "&Series"
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

		LWDynamicMenuItem()+ "&M-Shift Current Series.../F6", ShiftSeries(GetCurrentSeriesNumber(),0,1)
		help = {"M-shift the current series.", "This command is only availible for Loomis-Wood plots."}

		LWDynamicMenuItem()+ "&View Current Series/F7", ViewSeries(GetCurrentSeriesNumber())
		help = {"View the assignment table for the current series.", "This command is only availible for Loomis-Wood plots."}

		"-"
		help = {"", ""}

		LWDynamicMenuItem()+ "View Series List.../F8", ViewSeriesList()
		help = {"View/Edit the name, color, order, etc. of all assigned series.", "This command is only availible for Loomis-Wood plots."}
	end //submenu
end //menu "Loomis-Wood"

function/S OnLWmenuBuild()
// DO NOT DECLARE AS STATIC!
// Any commands in this function will be executed whenever the LoomisWood menu is built.
// This is a good place for global initializations.
	string saveDF = GetDataFolder(1)
	SetDataFolder root:
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

function/S DimLabels2List(w, dim)
	wave w
	variable dim
	variable i
	
	string result = ""
	for(i = 0 ; i<Dimsize(w,dim) ; i += 1)
		result += GetDimLabel(w, dim, i)
		result += ";"
	endfor
	
	return result
end

function/S List2DimLabels(w, dim, list)
	wave w
	variable dim
	string list

	variable i
	for(i = 0 ; i<Dimsize(w,dim) ; i += 1)
		SetDimLabel dim, i, $StringFromList(i,list), w
	endfor
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

static function poly2(coeff, order, theX)
// Same as built-in function poly(), except that order is given explicitly.
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

static function GetFolders(theWinType, DataSet, PlotFolder)
	variable theWinType
	string &DataSet, &PlotFolder
// This function tests to see if the top window is a Loomis-Wood plot.
// If the top window is a Loomis-Wood plot, it will contain "LoomisWood=ver" in its note.
// Use theWinType = 1 if only the top GRAPH needs to be a Loomis-Wood plot
// Use theWinType = -1 if the overall top WINDOW needs to be a Loomis-Wood plot
	DataSet = ""
	PlotFolder = ""

	string TopWinName = WinName(0,theWinType)
	if (!cmpstr(TopWinName,""))	//This is necessary b/c this function may be called when there are no active windows.
		Beep
		Print LW_ERROR3
		return 0
	endif

	GetWindow $TopWinName, note
	variable theVersion = NumberByKey("LoomisWood",S_Value,"=",",")

	if (theVersion > 0)
		DataSet = StringByKey("DataSet",S_Value,"=",",")
		PlotFolder = StringByKey("PlotFolder",S_Value,"=",",")
		return 1
	else
		Beep
		Print LW_ERROR3
		return 0
	endif
end

static function VerifyInputWaveDims(Line_Frequencies, Line_Intensities, Line_Widths)
// Checks to make sure that all peak-listing related waves have the same length.
	String Line_Frequencies,Line_Intensities,Line_Widths
	Variable theResult = 0
	
	If (cmpstr(Line_Intensities,"_constant_"))
		theResult +=(numpnts($Line_Frequencies)!=numpnts($Line_Intensities))		
	EndIf

	If (cmpstr(Line_Widths,"_constant_"))
		theResult += (numpnts($Line_Frequencies)!=numpnts($Line_Widths))		
	EndIf

	Return theResult
end //static function VerifyInputWaveDims

static function GetNumLines(Line_Frequencies,Line_Intensities,Line_Widths)
// Used to determine the number of lines when some of the peak-listing related waves have extra points
	String Line_Frequencies,Line_Intensities,Line_Widths
	Variable theResult = numpnts($Line_Frequencies)
	If (cmpstr(Line_Intensities,"_constant_"))
		theResult = min(theResult,numpnts($Line_Intensities))		
	EndIf
	If (cmpstr(Line_Widths,"_constant_"))
		theResult = min(theResult,numpnts($Line_Widths))
	EndIf
	return theResult
end //static function GetNumPeaks

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Main Loomis-Wood inteface functions:
function NewLWDataSet()
	// Save current folder name
	String SaveDF = GetDataFolder(1)
	
	// Get name of a new Data Set Folder from user
	String DataSet = GetNewLWDataFolder()
	if (cmpstr(DataSet,"")==0)
		Return 0
	endif
	
	// Create DataSet and copy peakfinder waves to it.
	if (NewLinesFolder(SaveDF, DataSet))
		DataSet += ":"
		SetDataFolder DataSet
	
		// New 2/18/05
		Make/O/D/N=(14,3) Colors
		Colors[0][0]= {0       , 65535, 65535, 0       , 0       , 65535, 32768, 32768, 0       , 0       , 0       , 32768, 0, 32768}
		Colors[0][1]= {32768, 0       , 65535, 65535, 0       , 0       , 0       , 32768, 32768, 65535, 0       , 0       , 0, 32768}
  		Colors[0][2]= {32768, 0       , 0       , 0       , 65535, 65535, 0       , 0       , 0       , 65535, 32768, 32768, 0, 32768}
		List2DimLabels(Colors,0,"Teal;Red;Yellow;Lime;Blue;Fuchsia;Maroon;Olive;Green;Aqua;Navy;Purple;Black;Grey")
		List2DimLabels(Colors,1,"Red;Blue;Green")

		Make/D/N=(MAX_FIT_ORDER,MAX_FIT_ORDER) Band2Poly
		Band2Poly = StandardBand2Poly(p,q,1)
		Make/T/N=(MAX_FIT_ORDER) BandCoeffLabels
		BandCoeffLabels = StandardBandLabels(p)
		
		Duplicate/O Band2Poly, Poly2Band
		MatrixInverse/O Poly2Band
						
		NewSeriesFolder(DataSet)
		
		// Create an initial display
		NewLWPlot(DataSet, "Plot0")
		SetDataFolder SaveDF
		Return 1
	else
		Return 0
	endif
End //function NewLWDataSet

static function GetPeakfinderWaves(Line_Frequency, Line_Intensity, Line_Width)
// DIALOG
	string &Line_Frequency, &Line_Intensity, &Line_Width

	string Line_F = "" //Line_Frequency
	if (exists(Line_Frequency)==1)
		Line_F = NameOfWave($Line_Frequency)
	endif

	string Line_I = "" //Line_Intensity
	if (exists(Line_Intensity)==1)
		Line_I = NameOfWave($Line_Intensity)
	endif

	string Line_W = "" //Line_Width
	if (exists(Line_Width)==1)
		Line_W = NameOfWave($Line_Width)
	endif

	Prompt Line_F, LW_STRING2, popup Real1DWaveList("*", ";", "")
	Prompt Line_I, LW_STRING3, popup "_constant_;" + Real1DWaveList("*", ";", "")
	Prompt Line_W, LW_STRING4, popup "_constant_;" + Real1DWaveList("*", ";", "")
	DoPrompt LW_TITLE, Line_F, Line_I, Line_W
	
	Line_Frequency = GetDataFolder(1)+Line_F

	if (cmpstr(Line_I,"_constant_"))
		Line_Intensity= GetDataFolder(1)+Line_I
	else
		Line_Intensity = Line_I
	endif

	if (cmpstr(Line_W,"_constant_"))
		Line_Width= GetDataFolder(1)+Line_W		
	else
		Line_Width = Line_W
	endif

	return V_Flag

end //static function GetPeakfinderWaves

static function/S GetNewLWDataFolder()
// DIALOG
	String DataSet
	//Save current folder name
	String SaveDF = GetDataFolder(1)

	//Ask for New DataSet.
	Prompt DataSet, LW_STRING1
	DoPrompt LW_TITLE, DataSet
	If (V_Flag)
		Return ""
	EndIf

	//Switch to LoomisWood folder.
	SetDataFolder $BASE_FOLDER

	//Verify DataSet.
	If (CheckName(DataSet,11))
		Do
			DoAlert 2, "\""+ DataSet + LW_STRING7+ UniqueName(CleanupName(DataSet,1),11,0) + LW_STRING8
			switch (V_Flag)
			case 1:
				// The user clicked "Yes", so change the name.
				DataSet=UniqueName(CleanupName(DataSet,1),11,0)
				break
			case 2:
				// The user clicked "No", so try again.
				DoPrompt LW_TITLE, DataSet
				If (V_Flag)
					Return ""
				EndIf
				break
			default:
				// The user clicked "Cancel" so abort.
				SetDataFolder SaveDF
				Return ""
			endswitch
		While(CheckName(DataSet,11))
	EndIf
	DataSet = BASE_FOLDER +":"+ DataSet
	
	//Switch back to original folder.
	SetDataFolder SaveDF
	Return DataSet
end //static function/S GetNewLWDataFolder

static function NewLinesFolder(SourceDF, LWDF)
	String SourceDF, LWDF
	String SaveDF = GetDataFolder(1)

	String Frequencies = ""
	String Intensities = ""
	String Widths = ""
	
	Variable Constant_Width
	Variable Constant_Intensity

	SetDataFolder SourceDF
	//Ask for waves from peakfinder.
	If (GetPeakfinderWaves(Frequencies, Intensities, Widths))
		Return 0
	EndIf

	If (VerifyInputWaveDims(Frequencies, Intensities, Widths))
		DoAlert 1, LW_STRING19+Frequencies+"\", \""+Intensities+LW_STRING21+Widths+LW_STRING20
		If (V_Flag==2)
			// The user clicked "No", so abort.
			SetDataFolder SourceDF
			Return 0
		EndIf
	EndIf
	
	//Create DataSet, if it doesn't already exist
	NewDataFolder/O/S $LWDF
	NewDataFolder/O/S Lines

	Variable NumLines = GetNumLines(Frequencies, Intensities, Widths)

	Duplicate/O/R=[0,NumLines-1] $Frequencies, Frequency
	String/G ::Frequency_Source = Frequencies

	If (cmpstr(Intensities,"_constant_"))
		Duplicate/O/R=[0,NumLines-1] $Intensities, Intensity
		String/G ::Intensity_Source = Intensities
	Else
		Make/O/N=(numpnts(Frequency)), Intensity = 1
	EndIf
	
	If (cmpstr(Widths,"_constant_"))
		Duplicate/O/R=[0,NumLines-1] $Widths, Width
		String/G ::Width_Source = Widths
	Else
		Make/O/N=(numpnts(Frequency)), Width = NaN
	EndIf

//	Duplicate/R=[0,NumLines-1] $Frequencies, Frequency
//	
//	If (cmpstr(Intensities,"_constant_"))
//		Duplicate/R=[0,NumLines-1] $Intensities, Intensity
//	Else
//		Make/O/N=(numpnts(Frequency)), Intensity = 1
//	EndIf
//	
//	If (cmpstr(Widths,"_constant_"))
//		Duplicate/R=[0,NumLines-1] $Widths, Width
//	Else
//		Make/O/N=(numpnts(Frequency)), Width = NaN
//	EndIf

	Sort Frequency, Frequency, Intensity, Width
	
	Wavestats/Q  Intensity
	Variable/G minIntensity = V_min
	Variable/G maxIntensity = V_max

	Wavestats/Q  Width
	Variable/G minWidth = V_min
	Variable/G maxWidth = V_max

	Variable/G Count = numpnts(Frequency)
	Make/T/N=(Count) Assignments

	SetDataFolder SaveDF
	
	Return 1
end //static function CopyWavesToSourceFolder

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function DeleteLWDataSet(DataSet)
// OPTIONAL DIALOG
	string DataSet

	string PlotFolder
	variable index
	
	if (cmpstr(DataSet,""))
		if (ValidateSourceFolder(DataSet))
			// DataSet invalid
			Beep
			Print LW_ERROR1 + DataSet + LW_ERROR2
			return 0
		endif
	else
		//Prompt for DataSet
		String DataSetFolders = FolderList(BASE_FOLDER)
		if (ItemsInList(DataSetFolders)>0)
			Prompt DataSet, LW_STRING9, popup DataSetFolders
			DoPrompt LW_TITLE, DataSet
			if (V_flag)
				return 0
			endif
			DataSet = BASE_FOLDER + ":" + DataSet + ":"
		else
			return 0
		endif
	endif
	
	String PlotsFolder = DataSet + "Plots:"
	//First, remove all dependencies in plot folders
	for(index = 1 ; index <= CountObjects(PlotsFolder,4) ; index += 1)
		PlotFolder = PlotsFolder+GetIndexedObjName(PlotsFolder,4,index-1)+":"
		DeleteLWPlotFolder(PlotFolder)
		//SetFormula $(PlotFolder+"BandCoeffUpdate"), ""
		//SetFormula $(PlotFolder+"TriangleUpdate"), ""
		//SetFormula $(PlotFolder+"SeriesOrder"), ""
	endfor
	// Then, kill the folder
	KillDataFolder $DataSet
	
	Beep	
	Print LW_HISTORY1 + DataSet + LW_HISTORY2
end //function DeleteLWDataSet

function DeleteLWPlotFolder(PlotFolder)
// OPTIONAL DIALOG
	string PlotFolder

	string saveDF = GetDataFolder(1)
	SetDataFolder PlotFolder
	//First, remove all dependencies in plot folders
	SetFormula $("BandCoeffUpdate"), ""
	SetFormula $("TriangleUpdate"), ""
	SetFormula $("SeriesOrder"), ""
	SetDataFolder saveDF
	// Then, kill the folder
	KillDataFolder $PlotFolder
end

function NewLWPlot(DataSet, PlotFolder)
// OPTIONAL DIALOG
	String DataSet, PlotFolder
	
	if (cmpstr(DataSet,"") || cmpstr(PlotFolder,""))
		if (ValidateSourceFolder(DataSet))
			// DataSet invalid
			Beep
			Print LW_ERROR1 + DataSet + LW_ERROR2
			return 0
		endif
	else
		//Prompt for DataSet and PlotFolder
		Prompt DataSet, LW_STRING17, popup FolderList(BASE_FOLDER)
		Prompt PlotFolder, LW_STRING18
		DoPrompt LW_TITLE, DataSet, PlotFolder
		if (V_flag)
			return 0
		endif
		DataSet = BASE_FOLDER + ":" + DataSet + ":"
	endif
	
	String temp
	String SaveDF=GetDataFolder(1)
	
	SetDataFolder DataSet
	Struct LinesStruct lines
	GetLinesStruct(DataSet, lines)

	Struct SeriesStruct series
	GetSeriesStruct(DataSet, series)

	//TODO: Validate PlotFolder
	NewDataFolder/O/S Plots
	NewDataFolder/O/S $PlotFolder
	PlotFolder = GetDatafolder(1)
	
	// Create persistant data
	Make/O/D/N=(lines.Count) Line_LWm
	Make/O/D/N=(lines.Count) Line_DF
	Make/O/D/N=(FIVEMAX_PEAKS_PER_PLOT) Triangle_X, Triangle_Yup, Triangle_Ydown
	Make/O/U/W/N=(FIVEMAX_PEAKS_PER_PLOT,3) Triangle_Color
	Make/O/D/N=(MAX_FIT_ORDER) BandCoeff, PolyCoeff
	Make/O/D/N=(2) LWCursorX = NaN, LWCursorYup = NaN, LWCursorYdown = NaN
	Make/O/T/N=(1,6) AssignmentListText
	Make/O/I/N=(1,6) AssignmentListSel

	Triangle_X = NaN
	Triangle_Yup = NaN
	Triangle_Ydown = NaN
	Triangle_Color = NaN
	Variable/G lastTriangle

	Variable/G Zoom=1
	Variable/G BandCoeffUpdate, TriangleUpdate
	Variable/G StartP, EndP
	Variable/G lwCursor_p, lwCursor_m, lwCursor_Nu, lwCursor_I, lwCursor_W, lwCursor_dM, lwCursor_dNu
	//String/G lwCursor_assignments
	Variable/G startM = -10.5, endM = 10.5
	Variable/G CurrentSeries = 1
	Variable/G SeriesOrder

	// Initialize persistant data.
	BandCoeff[0] = mean(lines.Frequency,0,lines.Count-1)
	BandCoeff[1] = abs(10*(lines.Frequency[0]-lines.Frequency[inf])/lines.Count)

	String Title
	sprintf Title, "LWA: %s, %s", StringFromList(ItemsInList(DataSet,":")-1,DataSet,":"), StringFromList(ItemsInList(PlotFolder,":")-1,PlotFolder,":")
	// Draw the Graph
	Display/K=1/W=(3,0,762,400) LWCursorYup, LWCursorYdown vs LWCursorX As Title
	AppendToGraph Triangle_Yup, Triangle_Ydown vs Triangle_X

	// Setup the axes
	SetAxis/R left 10,-11
	SetAxis/A/N=0/E=2 bottom
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
	SetWindow kwTopWin,hook(LW)=LWHookFunction
	SetWindow kwTopWin,note="LoomisWood=2.0,DataSet="+DataSet+",PlotFolder="+PlotFolder+","

	// Setup the control bar
	ControlBar/T 60
	NewPanel/FG=(GL,FT,GR,GT)/HOST=# 		// New
	RenameWindow #, PTop	// New
	ModifyPanel frameStyle=0

	//PopupMenu popup_assignments, size={280,22}, proc=CurrentSeriesPopupMenuControl,title="Assignments"
	//PopupMenu popup_assignments, mode=1, bodyWidth= 200
	//Execute/Z "PopupMenu popup_assignments value="+PlotFolder+"lwCursor_assignments"

	PopupMenu CurrentSeriesPopup, pos={2,38}, size={280,22}, proc=CurrentSeriesPopupMenuControl,title="Current Series"
	PopupMenu CurrentSeriesPopup, mode=1, bodyWidth= 200
	Execute/Z "PopupMenu CurrentSeriesPopup value=TextWave2List("+DataSet+"Series:Name)+\"_Create_New_Series_;\""

	SetVariable order_setvar, pos={292,41}, size={80,16},title="Order", format="%d"
	SetVariable order_setvar, limits={1,6,1}, proc=OrderSetVarProc
	SetVariable order_setvar, value=SeriesOrder, bodyWidth= 40

	SetVariable zoom_setvar, pos={382,41}, size={80,16}, title="Zoom", format="%d"
	SetVariable zoom_setvar, limits={1,INF,1}
	SetVariable zoom_setvar, value=Zoom

//	SetWindow kwTopWin,note="LoomisWood=2.0,DataSet="+DataSet+",PlotFolder="+PlotFolder+","
//	SetActiveSubwindow ##	// New
//
//	ControlBar/B 60
//	NewPanel/FG=(GL,GB,GR,FB)/HOST=# 
//	RenameWindow #, PBottom
//	ModifyPanel frameStyle=0

	SetVariable display_p, pos={2,1}, size={70,18}, title="P", fSize=12, format="%d" //, bodyWidth=150
	SetVariable display_frequency, size={140,18}, title="Nu", fSize=12, format="%13.6f"
	SetVariable display_delta_frequency, size={100,18}, title="dNu", fSize=12, format="%13.6f"
	SetVariable display_width, pos={2,20}, size={100,18}, title="W", fSize=12, format="%8.6f"
	SetVariable display_intensity, size={70,18},title="I", fSize=12, format="%5.3f"
	SetVariable display_m, size={70,18}, title="M", fSize=12, format="%d"
	SetVariable display_delta_m, size={80,18}, title="dM", fSize=12, format="%5.3f"

	SetVariable display_p, value=lwCursor_p, limits={-inf,inf,0}, noedit=1
	SetVariable display_frequency, value=lwCursor_Nu, limits={-inf,inf,0}, noedit=1
	SetVariable display_delta_frequency, value=lwCursor_dNu, limits={-inf,inf,0}, noedit=1
	SetVariable display_intensity, value=lwCursor_I, limits={-inf,inf,0}, noedit=1
	SetVariable display_width, value=lwCursor_W, limits={-inf,inf,0}, noedit=1
	SetVariable display_m, value=lwCursor_m, limits={-inf,inf,0}, noedit=1
	SetVariable display_delta_m, value=lwCursor_dM, limits={-inf,inf,0}, noedit=1

	GetWindow #, wSize
	variable width=max(V_right - V_left - 472, 100)
	variable height=max(V_bottom - V_top - 4, 40)
	variable name_size = max(50,(width-120)/2)

	ListBox list0, pos={470,2}, size={width,height}, proc=ListBoxProc
	ListBox list0, listWave=AssignmentListText
	ListBox list0, selWave=AssignmentListSel,mode= 5
	ListBox list0, widths={name_size,25,25,25,25,name_size}, userColumnResize= 1

	//Button button0 title="Toggle",proc=ShowLeft
	SetWindow #,note="LoomisWood=2.0,DataSet="+DataSet+",PlotFolder="+PlotFolder+","
	SetActiveSubwindow ##

//	ControlBar/L 300
//	NewPanel/FG=(FL,GT,GL,GB)/HOST=# 
//	RenameWindow #,PLeft
//	ModifyPanel frameStyle=0
//
//	SetVariable display_p, size={200,18}, title="P", fSize=12, format="%d", bodyWidth=150
//	SetVariable display_frequency, size={200,18}, title="Nu", fSize=12, format="%13.6f", bodyWidth=150
//	SetVariable display_delta_frequency, size={200,18}, title="dNu", fSize=12, format="%13.6f", bodyWidth=150
//	SetVariable display_width, size={200,18}, title="W", fSize=12, format="%8.6f", bodyWidth=150
//	SetVariable display_intensity, size={200,18},title="I", fSize=12, format="%5.3f", bodyWidth=150
//	SetVariable display_m, size={200,18}, title="M", fSize=12, format="%d", bodyWidth=150
//	SetVariable display_delta_m, size={200,18}, title="dM", fSize=12, format="%5.3f", bodyWidth=150
//
//	SetVariable display_p, value=lwCursor_p, limits={-inf,inf,0}, noedit=1
//	SetVariable display_frequency, value=lwCursor_Nu, limits={-inf,inf,0}, noedit=1
//	SetVariable display_delta_frequency, value=lwCursor_dNu, limits={-inf,inf,0}, noedit=1
//	SetVariable display_intensity, value=lwCursor_I, limits={-inf,inf,0}, noedit=1
//	SetVariable display_width, value=lwCursor_W, limits={-inf,inf,0}, noedit=1
//	SetVariable display_m, value=lwCursor_m, limits={-inf,inf,0}, noedit=1
//	SetVariable display_delta_m, value=lwCursor_dM, limits={-inf,inf,0}, noedit=1
//
//	ListBox list0,size={300,100}, proc=ListBoxProc
//	ListBox list0, listWave=AssignmentListText
//	ListBox list0, selWave=AssignmentListSel,mode= 5
//	ListBox list0, widths={120,25,25,25,25,120}, userColumnResize= 1
//
//	Button button0 title="Toggle",proc=ShowBottom
//
//	SetWindow kwTopWin,note="LoomisWood=2.0,DataSet="+DataSet+",PlotFolder="+PlotFolder+","
//	SetActiveSubwindow ##
//	// Hide Left Panel
//	MoveSubwindow/W=#PLeft fguide=(GR, GT, FR, GB)
//	ControlBar/L 0

	SetFormula SeriesOrder, "DoSeriesOrderUpdate("+DataSet+"Series:Order,"+PlotFolder+"CurrentSeries)"
	temp = "DoBandCoeffUpdate("+PlotFolder+"BandCoeff)"
	SetFormula BandCoeffUpdate, temp
	temp = "DoTriangleUpdate("+PlotFolder+"Line_LWm,"+DataSet+"Lines:Assignments,"+DataSet+"Series:Color,"+DataSet+"Series:Shape,"+PlotFolder+"StartM,"+PlotFolder+"EndM,"+PlotFolder+"Zoom)"
	SetFormula TriangleUpdate, temp

	// Move the cursor to approximately the center of the plot
	lwCursor_p = Round(0.5*(StartP+EndP))
	MoveCursor(lwCursor_p)	

	SetDataFolder SaveDF
end //function NewLWPlot

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Data updating functions
function DoBandCoeffUpdate(BandCoeff)
// DO NOT DECLARE AS STATIC!
// This function is called via a dependancy whenever BandCoeff is changed
// This function is responsible for calculating Line_LWm, PolyCoeff, minM, maxM, minP, maxP
	wave BandCoeff

	variable start_time = ticks

	string PlotFolder = GetWavesDataFolder(BandCoeff,1)
	string SaveDF = GetDataFolder(1)
	SetDataFolder PlotFolder
	Make/O/D/N=201 CombX, CombY = 1, CombM
	SetScale/I x, -100, 100, "M", CombX, CombY, CombM
	CombM = x
	WAVE PolyCoeff
	WAVE Line_LWm
	WAVE Line_DF
	variable/G minM, maxM, minP, maxP
	SetDataFolder :::
	WAVE Line_Frequency = :Lines:Frequency
	WAVE Band2Poly
	Variable NumLines = numpnts(Line_Frequency)
	SetDataFolder SaveDF

	variable/C limits

	variable theF, theF2, theM, theP
	variable Order, FatminM, FatmaxM, minF, maxF, slope

	if(numpnts(LW_M) != NumLines)
		Redimension/N=(NumLines) Line_LWm, Line_DF
	endif

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
	minP = BinarySearch(Line_Frequency, minF)
	maxP = BinarySearch(Line_Frequency, maxF)

	do	// This is a do-while(0) loop, allowing the break statement to be used like a goto.
		if ((minP == -2) || (maxP == -1))
			// There are no peaks in the range of the polynomial
			Beep
			Print LW_ERROR4
			Line_LWm  = NaN
			break
		endif
		if (minP == -1)
			// The range of the polynomial begins below the frequency of the first peak.
			minP = 0
		else
			// The range of the polynomial begins above the frequency of the first peak.
			// Set Line_LWm of those peaks below the range of the polynomial to -Inf
			Line_LWm[0, minP - 1] = -Inf
		endif
		if (maxP == -2)
			// The range of the polynomial ends above the frequency of the first peak.
			maxP = NumLines
		else
			// The range of the polynomial ends below the frequency of the last peak.
			// Set Line_LWm of those peaks below the range of the polynomial to +Inf
			Line_LWm[maxP + 1, NumLines - 1] = Inf
		endif
		
		theM = minM	
		theF = poly2(PolyCoeff, order, theM)
		theF2 = poly2(PolyCoeff, order, theM + 0.5)
		CombX = poly2(PolyCoeff, order, x)

		// For negative slope, run theP backwards
		slope = sign(FatmaxM - FatminM)
		for (theP = (slope > 0 ? minP : maxP) ; ((minP <= theP) && (theP <= maxP))  ; theP += slope)
			if (theF2 < Line_Frequency[theP] )
				do
					theM += 1
					theF2 = poly2(PolyCoeff, order, theM + 0.5)
				while (theF2 < Line_Frequency[theP] )
				theF = poly2(PolyCoeff, order, theM)
			endif
			Line_LWm[theP] = theM
			Line_DF[theP] = Line_Frequency[theP] - theF
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

function DoTriangleUpdate(LWm, Assignments, Series_Color, Series_Shape, StartM, EndM, Zoom)
// This procedure recalculates Triangle_X, Triangle_Yup, Triangle_Ydown, and Triangle_Color, StartP, EndP, StartFrequency, and EndFrequency
// whenever LWm, Assignments, Line_Shape, Series_Color, Series_Shape, StartM, or EndM  change.
// DO NOT DECLARE AS STATIC!
	Wave LWm
	Wave/T Assignments
	Wave Series_Color, Series_Shape
	Variable startM, endM, Zoom

	Variable start_time = ticks

	String SaveDF = GetDataFolder(1)
	SetDataFolder GetWavesDataFolder(Assignments,1)
	SetDataFolder ::
	String DataSet = GetDataFolder(1)
	WAVE Colors
	
	Struct LinesStruct lines
	GetLinesStruct(DataSet, lines)

	SetDataFolder GetWavesDataFolder(LWm,1)
	WAVE PolyCoeff
	WAVE Line_DF
	WAVE Triangle_X
	WAVE Triangle_Yup
	WAVE Triangle_Ydown
	WAVE Triangle_Color

	Variable/G startP = BinarySearch2(LWm, startM) + 1
	Variable/G endP = min(BinarySearch2(LWm, endM), StartP + 0.2*FIVEMAX_PEAKS_PER_PLOT - 1)
	Variable/G startFrequency = poly(PolyCoeff,startM)
	Variable/G endFrequency = poly(PolyCoeff,endM)
	NVAR lastTriangle
	NVAR lwCursor_p

	SetDataFolder SaveDF
	
	Variable base, center, color, height, fiveindex, shape, width, scale_width,  scale_height, WidthMin, index
	Variable total_height, clip_width
	Variable colorR, colorB, colorG
	Variable series_num
		
	scale_width = (lines.maxWidth-lines.minWidth > 0) ? 0.045 * PolyCoeff[1] / (lines.maxWidth - lines.minWidth) : 0
	WidthMin = 0.005 * PolyCoeff[1]
	
	//scale_height = (lines.maxIntensity-lines.minIntensity > 0) ? 0.80 / (lines.maxIntensity - lines.minIntensity) : 0
	scale_height = (lines.maxIntensity-lines.minIntensity > 0) ? 0.90 / lines.maxIntensity : 0
	scale_height *= Zoom
	
	for (index = startP ; index <= endP ; index += 1)
		fiveindex = 5*(index-StartP)
		base = LWm[index]
		center = Line_DF[index]
		//total_height = (lines.Intensity[index] - lines.minIntensity) *scale_height + 0.1
		total_height = lines.Intensity[index]*scale_height
		height = min(total_height, 0.90)  // New Version 2.01
		width =  (lines.width[index] -lines.minWidth)*scale_width + WidthMin
		width = numtype(width) ? WidthMin : width
		clip_width = (1-height/total_height)*width
		
		series_num = str2num(StringFromList(0,Assignments[index],";"))
		if (numtype(series_num))
			series_num = 0
		endif
		
		color = Series_Color[series_num]
		colorR = Colors[color][0]
		colorG = Colors[color][1]
		colorB = Colors[color][2]
		shape = Series_Shape[series_num]!=0
		
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
	UpdateCursor()
	
	// This update time should be under 3 ticks (0.05 sec) for good user interaction
	//printf "Triangle update took %d ms.\r" ticks - start_time
	return ticks - start_time
end //function DoTriangleUpdate

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Loomis-Wood plot hook function:
function LWHookFunction(s)
	STRUCT WMWinHookStruct &s
	
//	if ((ticks - s.ticks) > 10)
//		//Ignore events that are more than 2 ticks stale. 
//		return 1
//	endif
	
	Variable theKey, theP

	//do not handle Events that occur in the control bar:
	//if (s.mouseLoc.v < 0 || s.mouseLoc.h < 0)
	//	return 0
	//endif

	switch(s.eventcode)
		case EC_Keyboard:
			switch(s.keycode)
			case VK_RETURN:
				AssignLine(CursorPosition(),GetCurrentSeriesNumber(),CursorM(),1,1,1,"")
				VMoveCursor(1)
				return 1 
			case VK_DELETE:
				UnAssignLine(CursorPosition(),GetCurrentSeriesNumber())
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
			case 0x4B:
			case 0x6B:
				// "K" or "k"
				STRUCT AssignmentStruct assigned_line
				if (ReadAssignment(CursorPosition(), GetCurrentSeriesNumber(), assigned_line))
					assigned_line.LW = !assigned_line.LW
					AssignLine2(assigned_line)
				endif
				return 1
			case 0x4C:
			case 0x6C:
				// "L" or "l"
				if (ReadAssignment(CursorPosition(), GetCurrentSeriesNumber(), assigned_line))
					assigned_line.LS = !assigned_line.LS
					AssignLine2(assigned_line)
				endif
				return 1
			case 0x55:
			case 0x75:
				// "U" or "u"
				if (ReadAssignment(CursorPosition(), GetCurrentSeriesNumber(), assigned_line))
					assigned_line.US = !assigned_line.US
					AssignLine2(assigned_line)
				endif
				return 1
			//case 0x41:
			//case 0x61:
			//	//Prevent Ctrl-A (Autoscale)
			//	return 1			
			case VK_BACK:
			case VK_END:
			case VK_HOME:
			default:
				//print s.keycode
				return 0
			endswitch
		case EC_MouseDown:
			//do not handle mouse events that occur outside the graph area
			if (s.mouseLoc.v < 0 || s.mouseLoc.h < 0) //TOP_BAR_HEIGHT
				return 0
			else
				//SetActiveSubwindow LWbase
				theP = HitTest(s)
				if (theP >= 0)
					MoveCursor(theP)
	 			endif
	 		endif
 			return 1
		//case "mousedblclk":
		//	theP = HitTest(InfoStr)
		//	if (theP >= 0)
		//		AssignLine(theP,GetCurrentSeriesNumber(),CursorM(), -1)
 		//	endif			
		//	return 1
		case EC_MouseUp:
			//do not handle Events that occur that occur outside the graph area
			if (s.mouseLoc.v < 0 || s.mouseLoc.h < 0) //TOP_BAR_HEIGHT
				return 0
			else
				theP = HitTest(s)
				if ((theP >= 0) || (theP == -9))
					return 1
 				endif
 			endif
 			break
		//case "mousewheel":
		//	VerticalScroll( sign(NumberByKey("DELTA",InfoStr)) )
		//	return 1
		case EC_Resize: //Resize
			SetActiveSubwindow $WinName(0,1)
			SetActiveSubwindow #pTop
			GetWindow #, wSize
			variable width=max(V_right - V_left - 704, 100)
			variable height=max(V_bottom - V_top - 4,40)
			variable name_size = max(50,(width-120)/2)
			ListBox list0 size={width,height}
			ListBox list0 widths={name_size,25,25,25,25,name_size}
			SetActiveSubwindow ##
			break
		default:
			return 0
			
	endswitch //(Event)

End //function LWHookFunction

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Loomis-Wood plot event handlers
static function HitTest(s)
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
End //Static function HitTest

static function NearestPeak(theX, theY)
// Finds the peak nearest a set of cartesian coordinates in a Loomis-Wood plot.
	variable theX, theY
	
	variable theM, minP, maxP

	String DataSet, PlotFolder
	if (!GetFolders(1,DataSet, PlotFolder))
		return 0
	endif

	WAVE Line_LWm = $(PlotFolder+"Line_LWm")
	WAVE Line_DF = $(PlotFolder+"Line_DF")
	GetAxis/Q bottom

	theM = ceil(theY)
	maxP = BinarySearch(Line_LWm, theM)
	minP = maxP

	minP += 1
	do
		minP -= 1
	while (Line_LWm[minP-1] == theM && minP > 0)

	maxP -= 1
	do
		maxP += 1
	while (Line_LWm[maxP+1] == theM && maxP < numpnts(Line_LWm))

	if (minP == maxP)
		return minP
	endif

	FindLevel /P/Q/R=[minP,maxP] Line_DF, theX
	if (V_flag)
		return (theX < 0) ? minP : maxP
	endif
	
	return round(V_levelX)
	
end //static function NearestPeak

static function VerticalScroll(Amount)
// Scrolls a Loomis-wood plot vertically
	Variable Amount

	Variable Delta
	
	GetAxis/Q left
	Delta = Amount+.5

	String DataSet, PlotFolder
	if (!GetFolders(1,DataSet, PlotFolder))
		return 0
	endif

	NVAR startM = $(PlotFolder+"startM")
	NVAR endM = $(PlotFolder+"endM")

	StartM = min(V_min,V_max) + Delta
	EndM = max(V_min,V_max) + Delta

	SetAxis/R left (floor(EndM)),(floor(StartM))
End //Static function VerticalScroll

static function LinesPerFrame()
	GetAxis/Q left
	Return abs(V_min-V_max)
End //Static function LinesPerFrame

static function AssignmentString2ListBoxWaves(str, seriesNames, tw, sw)
	string str
	wave/T tw, seriesNames
	wave sw
	
	variable numAssignments = ItemsInList(str)
	Redimension/N=(numAssignments,6) tw, sw
	if (numAssignments > 0)
		SetDimLabel 1, 0, Series, tw
		SetDimLabel 1, 1, M, tw
		SetDimLabel 1, 2, LW, tw
		SetDimLabel 1, 3, US, tw
		SetDimLabel 1, 4, LS, tw
		SetDimLabel 1, 5, Notes, tw
		
		sw = 2*(q!=0)
		tw[][0] = StringFromList(0,StringFromList(p,str,";"),":")
		tw[][1,5] = StringFromList(q-1,StringByKey(tw[p][0],str),",")
		tw[][0] = seriesNames[str2num(tw[p][0])]
		sw[][2,4] = str2num(tw[p][q])!=0 ? 16+32 : 32 
	endif
End

static function UpdateCursor()
	Variable temp

	String DataSet, PlotFolder
	if (!GetFolders(1,DataSet, PlotFolder))
		return 0
	endif

	NVAR StartP = $(PlotFolder+"StartP")

	NVAR lwCursor_p = $(PlotFolder+"lwCursor_p")
	NVAR lwCursor_m = $(PlotFolder+"lwCursor_m")
	NVAR lwCursor_Nu = $(PlotFolder+"lwCursor_Nu")
	NVAR lwCursor_I = $(PlotFolder+"lwCursor_I")
	NVAR lwCursor_W = $(PlotFolder+"lwCursor_W")
	NVAR lwCursor_dM = $(PlotFolder+"lwCursor_dM")
	NVAR lwCursor_dNu = $(PlotFolder+"lwCursor_dNu")

	Struct LinesStruct lines
	GetLinesStruct(DataSet, lines)

	Struct SeriesStruct series
	GetSeriesStruct(DataSet, series)

	WAVE Triangle_X = $(PlotFolder+"Triangle_X")
	WAVE Triangle_Yup = $(PlotFolder+"Triangle_Yup")
	WAVE LWCursorYup = $(PlotFolder+"LWCursorYup")
	WAVE LWCursorYdown = $(PlotFolder+"LWCursorYdown")
	WAVE LWCursorX = $(PlotFolder+"LWCursorX")
	WAVE Line_LWm = $(PlotFolder+"Line_LWm")
	WAVE PolyCoeff = $(PlotFolder+"PolyCoeff")
	WAVE/T AssignmentListText = $(PlotFolder+"AssignmentListText")
	WAVE AssignmentListSel = $(PlotFolder+"AssignmentListSel")
	
	lwCursor_Nu = lines.Frequency[lwCursor_p]
	lwCursor_I = lines.Intensity[lwCursor_p]
	lwCursor_W = lines.Width[lwCursor_p]
	
 	temp = 5*(lwCursor_p-StartP)
	LWCursorX[0] = Triangle_X[temp]
	LWCursorX[1] = Triangle_X[temp+3]
	LWCursorYdown = Triangle_Yup[temp]
	LWCursorYup = Triangle_Yup[temp]-0.8
	
	lwCursor_m = Triangle_Yup[temp]
	lwCursor_dM = Triangle_X[temp+1]
	lwCursor_dNu = lwCursor_Nu - poly(PolyCoeff, lwCursor_m)

	AssignmentString2ListBoxWaves(lines.Assignments[lwCursor_p], series.Name, AssignmentListText, AssignmentListSel)
end

static function MoveCursor(theP)
// Moves the cursor on a Loomis-Wood plot.
	Variable theP
	if (numtype(theP))
		// theP is -INF, INF, or NaN, so do nothing.
		return 0
	endif

	Variable temp

	String DataSet, PlotFolder
	if (!GetFolders(1,DataSet, PlotFolder))
		return 0
	endif

	NVAR maxP = $(PlotFolder+"maxP")
	NVAR minP = $(PlotFolder+"minP")

	if ((theP > max(maxP,minP)) || (theP < min(maxP,minP)))
		//Trying to move out of bounds, so do nothing
		return 0
	endif

	NVAR StartP = $(PlotFolder+"StartP")
	NVAR EndP = $(PlotFolder+"EndP")
	
	NVAR lwCursor_p = $(PlotFolder+"lwCursor_p")
//	NVAR lwCursor_m = $(PlotFolder+"lwCursor_m")
//	NVAR lwCursor_Nu = $(PlotFolder+"lwCursor_Nu")
//	NVAR lwCursor_I = $(PlotFolder+"lwCursor_I")
//	NVAR lwCursor_W = $(PlotFolder+"lwCursor_W")
//	NVAR lwCursor_dM = $(PlotFolder+"lwCursor_dM")
//	NVAR lwCursor_dNu = $(PlotFolder+"lwCursor_dNu")
	//SVAR lwCursor_assignments= $(PlotFolder+"lwCursor_assignments")

	Struct LinesStruct lines
	GetLinesStruct(DataSet, lines)

	Struct SeriesStruct series
	GetSeriesStruct(DataSet, series)

//	WAVE Triangle_X = $(PlotFolder+"Triangle_X")
//	WAVE Triangle_Yup = $(PlotFolder+"Triangle_Yup")
//	WAVE LWCursorYup = $(PlotFolder+"LWCursorYup")
//	WAVE LWCursorYdown = $(PlotFolder+"LWCursorYdown")
//	WAVE LWCursorX = $(PlotFolder+"LWCursorX")
	WAVE Line_LWm = $(PlotFolder+"Line_LWm")
//	WAVE PolyCoeff = $(PlotFolder+"PolyCoeff")
//	WAVE/T AssignmentListText = $(PlotFolder+"AssignmentListText")
//	WAVE AssignmentListSel = $(PlotFolder+"AssignmentListSel")

	theP = limit(theP, 0, lines.Count - 1)
	if (theP < StartP)
		VerticalScroll(round(Line_LWm[theP])-round(Line_LWm[StartP]))
		DoUpdate
		MoveCursor(theP)
		return 0
	elseif (theP > EndP)
		VerticalScroll(round(Line_LWm[theP])-round(Line_LWm[EndP]))
		DoUpdate
		MoveCursor(theP)
		return 0
	endif
	
	lwCursor_p = theP
//	lwCursor_Nu = lines.Frequency[theP]
//	lwCursor_I = lines.Intensity[theP]
//	lwCursor_W = lines.Width[theP]
//	
// 	temp = 5*(lwCursor_p-StartP)
//	LWCursorX[0] = Triangle_X[temp]
//	LWCursorX[1] = Triangle_X[temp+3]
//	LWCursorYdown = Triangle_Yup[temp]
//	LWCursorYup = Triangle_Yup[temp]-0.8
//	
//	lwCursor_m = Triangle_Yup[temp]
//	lwCursor_dM = Triangle_X[temp+1]
//	lwCursor_dNu = lwCursor_Nu - poly(PolyCoeff, lwCursor_m)
//
//
//	AssignmentString2ListBoxWaves(lines.Assignments[theP], series.Name, AssignmentListText, AssignmentListSel)

	UpdateCursor()
End //Static function MoveCursor

static function CursorPosition()
	String DataSet, PlotFolder
	if (!GetFolders(1,DataSet, PlotFolder))
		return 0
	endif
	NVAR lwCursor_p = $(PlotFolder+"lwCursor_p")
	Return lwCursor_p
End //Static function CursorPosition

static function CursorM()
	String DataSet, PlotFolder
	if (!GetFolders(1,DataSet, PlotFolder))
		return 0
	endif
	WAVE Line_LWm = $(PlotFolder+"Line_LWm")
	return round(Line_LWm[CursorPosition()])
end

static function VMoveCursor(Amount)
	Variable Amount

	Variable temp

	String DataSet, PlotFolder
	if (!GetFolders(1,DataSet, PlotFolder))
		return 0
	endif
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
End //Static function VMoveCursor

static function HMoveCursor(Amount)
	Variable Amount
	MoveCursor(CursorPosition() + Amount)
End //Static function HMoveCursor

function ChangeRange(theMin, theMax)		//F11
// OPTIONAL DIALOG
// Changes the left axis scaling of a Loomis-Wood plot.
	variable theMin, theMax

	String DataSet, PlotFolder
	if (!GetFolders(1,DataSet, PlotFolder))
		return 0
	endif

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
	String DataSet, PlotFolder
	if (!GetFolders(1,DataSet, PlotFolder))
		return 0
	endif

	Struct SeriesStruct series
	GetSeriesStruct(DataSet, series)

	variable theSeries
	prompt theSeries, LW_STRING12, popup TextWave2List(Series.Name)+"_Create_New_Series_;"
	doprompt LW_TITLE, theSeries
	if (V_Flag)
		return 0
	endif
	
	CurrentSeriesPopupMenuControl("SelectSeries function",theSeries,"")
end function

static function ChangeCurrentSeries(theSeries)
	Variable theSeries

	String DataSet, PlotFolder
	if (!GetFolders(1,DataSet, PlotFolder))
		return 0
	endif
	Struct SeriesStruct series
	GetSeriesStruct(DataSet, series)
	
	NVAR CurrentSeries = $(PlotFolder+"CurrentSeries")

	if ((theSeries > 0) && (theSeries <= series.Count))
		CurrentSeries = theSeries
		PopupMenu CurrentSeriesPopup, mode=theSeries
	else
		//Out of Range -- Do nothing
	endif
end

function DeleteSeries()
// NON-OPTIONAL DIALOG
	String DataSet, PlotFolder
	if (!GetFolders(1,DataSet, PlotFolder))
		return 0
	endif

	Struct LinesStruct lines
	GetLinesStruct(DataSet, lines)

	Struct SeriesStruct series
	GetSeriesStruct(DataSet, series)
	
	variable theSeries
	prompt theSeries, LW_STRING13, popup TextWave2List(series.Name)
	doprompt LW_TITLE, theSeries
	if (V_Flag)
		return 0
	endif

	Variable i, npnts, point
	npnts = ItemsInList(series.Data[theSeries])
	string item
	for (i=0 ; i<npnts ; i+=1)
		item = StringFromList(i,series.Data[theSeries],";")
		point = str2num(StringFromList(0,item,":"))
		lines.Assignments[point] = RemoveByKey(num2str(theSeries),lines.Assignments[point])
	endfor
	
	Variable series_num
	//npnts=numpnts(Line_Series)
	for (point=0 ; point<lines.Count; point+=1)
		for (i=0 ; i<ItemsInList(lines.Assignments[point]) ; i+=1)
			series_num = str2num( StringFromList(0, StringFromList(i,lines.Assignments[point],";"), ":" ) )
			if (series_num > theSeries)
				STRUCT AssignmentStruct assigned_line
				if (ReadAssignment(point, series_num, assigned_line))
					assigned_line.LW = !assigned_line.LW
					UnAssignLine(point, series_num)
					assigned_line.series -= 1
					AssignLine2(assigned_line)
				endif
			endif
		endfor
	endfor

	DeletePoints theSeries, 1, series.Name, series.Data, series.Color, series.Shape, series.Order
end

function AddSeries()
// NON-OPTIONAL DIALOG
	String DataSet, PlotFolder
	if (!GetFolders(1,DataSet, PlotFolder))
		return 0
	endif

	string saveDF = GetDataFolder(1)
	SetDataFolder DataSet
	WAVE Colors
	SetDataFolder saveDF

	Struct SeriesStruct series
	GetSeriesStruct(DataSet, series)
			
	string SeriesName
	variable SeriesColor = Mod(series.Count+1,DimSize(Colors,0)-1)+1
	Prompt SeriesName, LW_STRING10
	Prompt SeriesColor, LW_STRING11, popup, DimLabels2List(Colors,0) //COLOR_LIST
	do		// Dialog repeats if SeriesName contains a ";", or is of length 0
		DoPrompt LW_TITLE, SeriesName, SeriesColor
		if (V_Flag)
			// User Canceled -- Do Nothing
			return 1
		endif
	while ((strsearch(SeriesName,";",0)!=-1) || (strlen(SeriesName) < 1))

	SeriesColor -= 1
	series.Count += 1
	Redimension/N=(series.Count+1) series.Name, series.Data, series.Color, series.Shape, series.Order
	series.Name[series.Count] = SeriesName
	series.Data[series.Count] = ""
	series.Color[series.Count] = SeriesColor
	series.Shape[series.Count] = 1
	series.Order[series.Count] = 1
end

function GetCurrentSeriesNumber()
// DO NOT MAKE STATIC
	String DataSet, PlotFolder
	if (!GetFolders(1,DataSet, PlotFolder))
		return 0
	endif
	NVAR CurrentSeries = $(PlotFolder+"CurrentSeries")

	Struct SeriesStruct series
	GetSeriesStruct(DataSet, series)

	if ((CurrentSeries > series.Count) || (CurrentSeries < 1))
		// A valid series is not currently selected
		if (series.Count == 0)
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

static function ReadAssignment(theP, theSeries, s)
	variable theP, theSeries
	STRUCT AssignmentStruct &s

	String DataSet, PlotFolder
	if (!GetFolders(1,DataSet, PlotFolder))
		return 0
	endif

	Struct LinesStruct lines
	GetLinesStruct(DataSet, lines)

	Struct SeriesStruct series
	GetSeriesStruct(DataSet, series)
	
	string data = StringByKey( num2str(theSeries) , lines.assignments[theP] )
	if (CmpStr(data,"")!=0)
		s.Point = theP
		s.Series = theSeries
		s.M = Str2Num(StringFromList(0,data,","))
		s.LW = Str2Num(StringFromList(1,data,","))
		s.US = Str2Num(StringFromList(2,data,","))
		s.LS = Str2Num(StringFromList(3,data,","))
		s.Notes = StringFromList(4,data,",")
		return 1
	else
		s.Point = NaN
		s.Series = NaN
		s.M = NaN
		s.LW = NaN
		s.US = NaN
		s.LS = NaN
		s.Notes = ""
		return 0
	endif
end

static function AssignLine2(s)
	STRUCT AssignmentStruct &s
	return AssignLine(s.Point, s.Series, s.M, s.LW, s.US, s.LS, s.Notes)
end	

static function AssignLine(theP, theSeries, theM, LWmask, USmask, LSmask, Notes)
	Variable theP, theSeries, theM, LWmask, USmask, LSmask
	String Notes
	Variable theA
	Variable otherP
	
	String DataSet, PlotFolder
	if (!GetFolders(1,DataSet, PlotFolder))
		return 0
	endif

	Struct LinesStruct lines
	GetLinesStruct(DataSet, lines)

	Struct SeriesStruct series
	GetSeriesStruct(DataSet, series)
	
	string data //= num2str(theM)+","+num2str(LWmask)+","+num2str(USmask)+","+num2str(GSmask)+"," + Notes
	sprintf data, "%d,%d,%d,%d,%s", theM,  LWmask, USmask, LSmask, Notes
	
	series.Data[theSeries] = ReplaceStringByKey( num2str(theP) , series.Data[theSeries] , data )
	lines.Assignments[theP] = ReplaceStringByKey( num2str(theSeries) , lines.Assignments[theP] , data )

	return 1
End //Static function AssignLine

static function UnAssignLine(theP, theSeries)
	Variable theP, theSeries
	
	String DataSet, PlotFolder
	if (!GetFolders(1,DataSet, PlotFolder))
		return 0
	endif
	
	Struct LinesStruct lines
	GetLinesStruct(DataSet, lines)

	Struct SeriesStruct series
	GetSeriesStruct(DataSet, series)

	series.data[theSeries] = RemoveByKey( num2str(theP) , series.data[theSeries] )
	lines.Assignments[theP] = RemoveByKey( num2str(theSeries), lines.Assignments[theP] )
	lines.Assignments[theP] = RemoveByKey( "NaN", lines.Assignments[theP] )
	
	return 1
End //Static function UnAssignLine

function/S UndoFit()
	String DataSet, PlotFolder
	if (!GetFolders(1,DataSet, PlotFolder))
		return ""
	endif

	string saveDF=GetDataFolder(1)
	SetDataFolder PlotFolder
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
	variable theSeries

	string message, total_message=""

	String DataSet, PlotFolder
	if (!GetFolders(1,DataSet, PlotFolder))
		return ""
	endif
	
	if (theSeries < 0 || numtype(theSeries))
		Beep
		return LW_ERROR6
	endif

	variable order

	string saveDF=GetDataFolder(1)

	SetDataFolder PlotFolder
	WAVE BandCoeff
	Duplicate/O BandCoeff, LastCoeff

	SetDataFolder DataSet
	WAVE Poly2Band
	WAVE/T BandCoeffLabels

	Struct SeriesStruct series
	GetSeriesStruct(DataSet, series)

	if (theSeries > series.Count)
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
	order = series.Order[theSeries] + 1
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
		string series_name = series.Name[theSeries]
		sprintf total_message, "\tFit of series %s, order %d, %d lines fit, %d lines assigned.\r", series_name, order -1, V_npnts, numpnts(Series_Frequency)
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
	String DataSet, PlotFolder
	if (!GetFolders(1,DataSet, PlotFolder))
		return 0
	endif

	Struct LinesStruct lines
	GetLinesStruct(DataSet, lines)

	Struct SeriesStruct series
	GetSeriesStruct(DataSet, series)

	SetDataFolder PlotFolder
	WAVE Line_DF

	SetDataFolder DataSet
	NewDataFolder/O/S SeriesFit
	Variable npnts = ItemsInList(series.Data[theSeries])

	Make/D/O/N=(npnts) Series_M, Series_Frequency, Series_Residual, Series_Select, Series_Intensity, Series_Width
	SetDataFolder SaveDF 

	Variable i, pnt
	String data
	for (i = 0 ; i < npnts ; i += 1)
		data = StringFromList(i, series.Data[theSeries])
		pnt = str2num(StringFromList(0,data,":"))
		data = StringFromList(1,data,":")

		Series_M[i] = str2num(StringFromList(0,data,","))
		Series_Select[i] = str2num(StringFromList(1,data,","))

		Series_Frequency[i] = lines.Frequency[pnt]
		Series_Residual[i] = Line_DF[pnt]
		Series_Intensity[i] = lines.Intensity[pnt]
		Series_Width[i] = lines.Width[pnt]
	endfor
	
	Sort Series_M, Series_Frequency, Series_Residual, Series_Select, Series_Intensity, Series_Width, Series_M
end

function ViewSeries(theSeries)		//F7
	Variable theSeries
	String DataSet, PlotFolder
	if (!GetFolders(1,DataSet, PlotFolder))
		return 0
	endif

	FetchSeries(theSeries)
	
	string saveDF = getDataFolder(1)

	Struct SeriesStruct series
	GetSeriesStruct(DataSet, series)

	SetDataFolder DataSet
	SetDataFolder SeriesFit
	WAVE Series_M, Series_Frequency, Series_Residual, Series_Select, Series_Intensity, Series_Width

	String Title = series.Name[theSeries]
	sprintf Title, "LWA: %s, \"%s\"", StringFromList(ItemsInList(DataSet,":")-1,DataSet,":"), Title

	Edit/K=1/W=(3,0,338.25,404)  Series_M, Series_Frequency, Series_Residual, Series_Select, Series_Intensity, Series_Width As Title[0,39]
	ModifyTable width(Point)=18,width(Series_M)=24,title(Series_M)="M",format(Series_Frequency)=3
	ModifyTable digits(Series_Frequency)=6,width(Series_Frequency)=68,title(Series_Frequency)="Frequency"
	ModifyTable format(Series_Residual)=3,digits(Series_Residual)=6,width(Series_Residual)=62
	ModifyTable title(Series_Residual)="Residual",width(Series_Select)=42,title(Series_Select)="Select"
	ModifyTable format(Series_Intensity)=3,width(Series_Intensity)=59,title(Series_Intensity)="Intensity"
	ModifyTable format(Series_Width)=3,digits(Series_Width)=6,width(Series_Width)=51
	ModifyTable title(Series_Width)="Width"

	SetDataFolder saveDF
End function

function ViewSeriesList()
	String DataSet, PlotFolder
	if (!GetFolders(1,DataSet, PlotFolder))
		return 0
	endif

	Struct SeriesStruct series
	GetSeriesStruct(DataSet, series)

	String Title
	sprintf Title, "LWA: %s, Series List", StringFromList(ItemsInList(DataSet,":")-1,DataSet,":")

	Edit/K=1 series.Name,series.Color,series.Shape,series.Order, series.Data as Title
	ModifyTable width(Point)=36,width(series.Name)=160,title(series.Name)="Name"
	ModifyTable width(series.Color)=32,title(series.Color)="Color"
	ModifyTable width(series.Shape)=32, title(series.Shape)="Shape"
	ModifyTable width(series.Order)=32,title(series.Order)="Order"
	ModifyTable width(series.Data)=200,title(series.Data)="Data"
End function

function ShiftSeries(theSeries, theShift, autoFixConstants)
// OPTIONAL DIALOG
// M-Shifts a series.
	Variable theSeries, theShift, autoFixConstants

	String DataSet, PlotFolder
	if (!GetFolders(1,DataSet, PlotFolder))
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
	
	Struct SeriesStruct series
	GetSeriesStruct(DataSet, series)
	
	Variable npnts = ItemsInList(series.Data[theSeries])
	Struct AssignmentStruct assignment
	
	Variable i, pnt, m, shape
	String data
	for (i = 0 ; i < npnts ; i += 1)
		data = StringFromList(i,series.Data[theSeries])
		pnt = str2num(StringFromList(0,data,":"))
		ReadAssignment(pnt, theSeries, assignment)
		assignment.m += theShift
		AssignLine2(assignment)
	endfor
				
	if (autoFixConstants)
		ShiftConstants(-theShift)
	endif
end

function ShiftConstants(theShift)
// OPTIONAL DIALOG
// This function M-Shifts BandCoeff
	variable theShift

	String DataSet, PlotFolder
	if (!GetFolders(1,DataSet, PlotFolder))
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
	
	WAVE PolyCoeff = $(PlotFolder + "PolyCoeff")
	WAVE BandCoeff = $(PlotFolder + "BandCoeff")
	WAVE Poly2Band = $(DataSet + "Poly2Band")

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
	String DataSet, PlotFolder
	if (!GetFolders(1,DataSet, PlotFolder))
		return 0
	endif
	
	string saveDF = GetDataFolder(1)
	SetDataFolder PlotFolder
	WAVE BandCoeff
	SetDataFolder DataSet
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
	String DataSet, PlotFolder
	if (!GetFolders(1,DataSet, PlotFolder))
		return 0
	endif
	
	string saveDF = GetDataFolder(1)
	SetDataFolder DataSet
	WAVE Colors
	SetDataFolder saveDF
	String Title
	sprintf Title, "LWA: %s, Colors", StringFromList(ItemsInList(DataSet,":")-1,DataSet,":")

	Edit/K=1 Colors.ld As Title
end

static function ValidateSourceFolder (DataSet)
// Makes sure that the DataSet string is valid.
// Changes DataSet to be an absolute reference.
// Returns 1 if DataSet is invalid, 0 if DataSet is valid.
 	string &DataSet

	variable theRes = 0
	string saveDF = GetDataFolder(1)
		
	// DataSet may be relative to BASE_FOLDER, absolute, or invalid
	string temp = DataSet + "::"
	if (DataFolderExists(DataSet) && DataFolderExists(temp))
		//If FolderA exists, the Source MAY be absolute
		SetDataFolder DataSet
		SetDataFolder ::
		if (cmpstr(GetDataFolder(1),BASE_FOLDER+":"))
			// invalid or relative
		else 
			// DataSet is absolute so make it relative
			SetDataFolder DataSet
			DataSet = GetDataFolder(0)
		endif
	endif

	// Now, DataSet is relative to BASE_FOLDER or invalid
	temp = BASE_FOLDER + ":" + DataSet
	if (!DataFolderExists(temp))
		theRes = 1
	else
		SetDataFolder temp
		// Now, DataSet is validated and absolute
		DataSet=GetDataFolder(1)
	endif
	
	SetDataFolder saveDF
	return theRes
 end
 
 function OrderSetVarProc(ctrlName,varNum,varStr,varName) : SetVariableControl
	string ctrlName
	variable varNum
	string varStr
	string varName

	String DataSet, PlotFolder
	if (!GetFolders(1,DataSet, PlotFolder))
		return 0
	endif
	
	Struct SeriesStruct series
	GetSeriesStruct(DataSet, series)

	NVAR CurrentSeries = $(PlotFolder+"CurrentSeries")
	
	series.Order[CurrentSeries] = varNum
end

function CurrentSeriesPopupMenuControl(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	
	String DataSet, PlotFolder
	if (!GetFolders(1,DataSet, PlotFolder))
		return 0
	endif
	
	Struct SeriesStruct series
	GetSeriesStruct(DataSet, series)
	
	if (popNum > series.Count)
		if(AddSeries())
			//User canceled AddSeries:
			NVAR CurrentSeries = $(PlotFolder+"CurrentSeries")
			popNum = CurrentSeries
		endif
		DoUpdate	// Must force update here to make the popup display correctly
					// after the call to ChangeCurrentSeries()
	endif
	ChangeCurrentSeries(popNum)
end

function ExtractAssignments(functionName)
	string functionName
	
	String DataSet, PlotFolder
	if (!GetFolders(1,DataSet, PlotFolder))
		return 0
	endif
	
	if (!TestLWLabelProto(functionName))
		Prompt functionName, LW_STRING23, popup "_none_;" + LWLabelList()
		DoPrompt LW_TITLE, functionName
		
		if (V_Flag)
			// Cancel 
			return 0
		endif
	endif
	variable useFunction = cmpstr(functionName, "_none_")

	Struct LinesStruct lines
	GetLinesStruct(DataSet, lines)

	Struct SeriesStruct series
	GetSeriesStruct(DataSet, series)

	string saveDF=GetDataFolder(1)
	SetDataFolder DataSet
	NewDataFolder/O/S Assignments
	variable NumAssignments = 0
	variable index1
	for (index1 = 0 ; index1 < lines.Count ; index1 += 1)
		NumAssignments += ItemsInList(lines.Assignments[index1])
	endfor
	
	Make/O/D/N=(NumAssignments) Frequency, Intensity, Width
	Make/O/W/N=(NumAssignments) SeriesIndex, theM, Select, US, GS
	Make/O/I/N=(NumAssignments) theP
	Make/O/T/N=(NumAssignments) Assignment

	variable m, nseries, index2, ser, Asgn=0
	string data
	for (index1 = 0 ; index1 < lines.Count ; index1 += 1)
		nseries = ItemsInList(lines.Assignments[index1])
		for (index2 = 0 ; index2 < nseries ; index2 += 1)
			Frequency[Asgn] =lines.Frequency[index1]
			Intensity[Asgn] = lines.Intensity[index1]
			Width[Asgn] = lines.Width[index1]

			ser = str2num(StringFromList(index2, lines.Assignments[index1]))
			data = StringByKey(num2str(index1), series.Data[ser])
			M = str2num(StringFromList(0,data,","))

			Select[Asgn] = str2num(StringFromList(1,data,","))
			US[Asgn] = str2num(StringFromList(2,data,","))
			GS[Asgn] = str2num(StringFromList(3,data,","))
			theM[Asgn] = M
			SeriesIndex[Asgn] = ser

			theP[Asgn] = index1
			
			Asgn += 1
		endfor
	endfor

	if (useFunction)
		FUNCREF   LWLabelProto f=$functionName
		Assignment = f(series.name[SeriesIndex[p]] ,theM[p])
	else
		Assignment = ""
	endif
	
	String Title
	sprintf Title, "LWA: %s, Assignments", StringFromList(ItemsInList(DataSet,":")-1,DataSet,":")

	Edit/K=1/W=(5,5,700,400) Assignment, US, GS, Frequency, Intensity, Width,SeriesIndex, theM, theP, Select As Title
	ModifyTable width = 35
	ModifyTable width(Assignment)=200
	ModifyTable width(Frequency)=80,format(Frequency)=3,digits(Frequency)=6
	ModifyTable width(Point)=30,width(Intensity)=60,format(Intensity)=3
	ModifyTable width(Width)=60,format(Width)=3,digits(Width)=6,width(SeriesIndex)=50

	SetDataFolder saveDF
end function

structure SeriesStruct
	WAVE/T Name
	WAVE Color
	WAVE Shape
	WAVE Order
	WAVE/T Data
	NVAR Count
EndStructure

static function GetSeriesStruct(DataSet, s)
	String DataSet
	Struct SeriesStruct &s

	String saveDF = GetDataFolder(1)
	SetDataFolder DataSet
	SetDataFolder Series

	WAVE/T s.Name = Name
	WAVE s.Color = Color
	WAVE s.Shape = Shape
	WAVE s.Order = Order
	WAVE/T s.Data = Data
	NVAR s.Count = Count
	s.Count = numPnts(s.Name)-1
	SetDataFolder saveDF
End

structure LinesStruct
	WAVE Frequency
	WAVE Intensity
	WAVE Width
	WAVE/T Assignments
	NVAR maxIntensity
	NVAR minIntensity
	NVAR maxWidth
	NVAR minWidth
	NVAR Count
EndStructure

static function GetLinesStruct(DataSet, s)
	String DataSet
	Struct LinesStruct &s

	String saveDF = GetDataFolder(1)
	SetDataFolder DataSet
	SetDataFolder Lines

	WAVE s.Frequency = Frequency
	WAVE s.Intensity = Intensity
	WAVE s.Width = Width
	WAVE/T s.Assignments = Assignments

	NVAR s.Count = Count
	NVAR s.maxIntensity = maxIntensity
	NVAR s.minIntensity = minIntensity
	NVAR s.maxWidth = maxWidth
	NVAR s.minWidth = minWidth

	SetDataFolder saveDF
End

static function GetLinesStruct2(LinesFolder, s)
// This function is only used when dealing with a copy or backup of the main lines folder
	String LinesFolder
	Struct LinesStruct &s

	String saveDF = GetDataFolder(1)
	SetDataFolder LinesFolder

	WAVE s.Frequency = Frequency
	WAVE s.Intensity = Intensity
	WAVE s.Width = Width
	WAVE/T s.Assignments = Assignments

	NVAR s.Count = Count
	NVAR s.maxIntensity = maxIntensity
	NVAR s.minIntensity = minIntensity
	NVAR s.maxWidth = maxWidth
	NVAR s.minWidth = minWidth

	SetDataFolder saveDF
End

structure AssignmentStruct
	Variable Point
	Variable Series
	Variable M
	Variable LW
	Variable US
	Variable LS
	String Notes
EndStructure

function/S LWLabelProto(name, m)
	string name
	variable m
	return "invalid"
End

static function TestLWLabelProto(name)
	String name
	FUNCREF   LWLabelProto f=$name

	return cmpstr("invalid",f("",0))!=0
End

static function NewSeriesFolder(DataSet)
	String DataSet
	
	String saveDF = GetDataFolder(1)
	SetDataFolder DataSet
	NewDataFolder/O/S Series
	
	Make/T/N=1 Name="Unassigned"
	Make/W/N=1 Shape, Color, Order=1
	Make/T/N=1 Data
	Variable/G Count = 0
	
	SetDataFolder saveDF
end

function/S LWLabelList()
	string List=FunctionList("*", ";", "KIND:6,NPARAMS:2,VALTYPE:4" )
	string FinalList=""
	string Name
	variable i, size = ItemsInList(List)
	for (i = 0 ; i < size ; i += 1)
		Name = StringFromList(i,List)
		if (TestLWLabelProto(Name))
			FinalList += Name + ";"
		endif
	endfor
	return FinalList
End

function ListBoxProc(LB_Struct) : ListBoxControl
	STRUCT WMListboxAction &LB_Struct
	//1=mouse down, 2=up, 3=dbl click, 4=cell select with mouse or keys
	//5=cell select with shift key, 6=begin edit, 7=end

	if ((LB_Struct.eventCode==1 && LB_Struct.col>=2 && LB_Struct.col <= 4) || LB_Struct.eventCode==7)
		String DataSet, PlotFolder
		if (GetFolders(1,DataSet, PlotFolder))
			WAVE/T AssignmentListText = $(PlotFolder+"AssignmentListText")
			WAVE AssignmentListSel = $(PlotFolder+"AssignmentListSel")

			Struct LinesStruct lines
			GetLinesStruct(DataSet, lines)
			
			Variable Point = CursorPosition()
			Variable Series = str2num(StringFromList(0,StringFromList(LB_Struct.row,lines.Assignments[Point],";"),":"))
			Variable M = str2num(AssignmentListText[LB_Struct.row][1])
			Variable LW = (AssignmentListSel[LB_Struct.row][2] & 0x10)!=0
			Variable US = (AssignmentListSel[LB_Struct.row][3] & 0x10)!=0
			Variable LS = (AssignmentListSel[LB_Struct.row][4] & 0x10)!=0
			String Notes = AssignmentListText[LB_Struct.row][5]
			
			if (numType(M)==0)
				AssignLine(Point, Series, M, LW, US, LS, Notes)
			else
				UpdateCursor()
			endif
			SetActiveSubwindow $WinName(0,1)
		endif
	endif
	return 0
End

function FitAll()
	String DataSet, PlotFolder
	if (!GetFolders(1,DataSet, PlotFolder))
		return 0
	endif

	Struct SeriesStruct series
	GetSeriesStruct(DataSet, series)

	DoWindow LWresults
	if (V_Flag)
		Notebook LWresults selection={StartOfFile,EndOfFile}
	else
		NewNotebook/F=0/N=LWresults
	endif

	Variable i
	for (i=1 ; i<= series.Count ; i +=1)
		Notebook LWresults text=FitSeries(i)+"\r\r"
	endfor
End

function SynchronizeSeries2Lines()
	String DataSet, PlotFolder
	if (!GetFolders(1,DataSet, PlotFolder))
		return 0
	endif

	Struct SeriesStruct series
	GetSeriesStruct(DataSet, series)

	Struct LinesStruct lines
	GetLinesStruct(DataSet, lines)

	series.Data = ""
	Variable i, j, jmax, series_num
	String item
	for(i = 0 ; i <= lines.Count ; i+=1)
		jmax = ItemsInList(lines.assignments[i])
		for(j = 0 ; j < jmax ; j+=1)
			item = StringFromList(j,lines.assignments[i])
			series_num = Str2Num(StringFromList(0,item,":"))
			item = StringFromList(1,item,":")
			series.Data[series_num] += Num2Str(i)+":"+item+";"
		endfor
	endfor
End

function SynchronizeLines2Series()
	String DataSet, PlotFolder
	if (!GetFolders(1,DataSet, PlotFolder))
		return 0
	endif

	Struct SeriesStruct series
	GetSeriesStruct(DataSet, series)

	Struct LinesStruct lines
	GetLinesStruct(DataSet, lines)

	lines.assignments = ""
	Variable i, j, jmax, point
	String item
	for(i = 1 ; i <= series.Count ; i+=1)
		jmax = ItemsInList(series.data[i])
		for(j = 0 ; j < jmax ; j+=1)
			item = StringFromList(j,series.data[i])
			point = Str2Num(StringFromList(0,item,":"))
			item = StringFromList(1,item,":")
			lines.assignments[point] += Num2Str(i)+":"+item+";"
		endfor
	endfor
End

function UpdateLinesFolder(FreqTol)
	Variable FreqTol
	String LWDF, PlotFolder
	//String SourceDF = GetDataFolder(1)
	if (!GetFolders(1,LWDF, PlotFolder))
		return 0
	endif

	String SaveDF = GetDataFolder(1)

	SetDataFolder LWDF
	String Frequencies = StrVarOrDefault("Frequency_Source", "")
	String Intensities = StrVarOrDefault("Intensity_Source", "")
	String Widths = StrVarOrDefault("Width_Source", "")
	SetDataFolder SaveDF
	
	Variable Constant_Width
	Variable Constant_Intensity

	//SetDataFolder SourceDF
	//Ask for waves from peakfinder.
	If (GetPeakfinderWaves(Frequencies, Intensities, Widths))
		Return 0
	EndIf
	//SetDataFolder LWDF
	//String/G Frequency_Source = Frequencies
	//String/G Intensity_Source =  Intensities
	//String/G Width_Source = Widths
	//SetDataFolder SaveDF

	If (VerifyInputWaveDims(Frequencies, Intensities, Widths))
		DoAlert 1, LW_STRING19+Frequencies+"\", \""+Intensities+LW_STRING21+Widths+LW_STRING20
		If (V_Flag==2)
			// The user clicked "No", so abort.
			SetDataFolder SourceDF
			Return 0
		EndIf
	EndIf
	
	SetDataFolder LWDF
	NewDataFolder/O LinesBak
	KillDataFolder LinesBak
	DuplicateDataFolder Lines, LinesBak

	If (FreqTol < 0 || numType(FreqTol) != 0)
		FreqTol = 0.001
		Prompt FreqTol, LW_STRING22
		DoPrompt LW_TITLE, FreqTol
	EndIf
	
	Struct LinesStruct LinesBak
	GetLinesStruct2(LWDF+"LinesBak" ,LinesBak)

	SetDataFolder Lines

	Variable NumLines = GetNumLines(Frequencies, Intensities, Widths)

	Duplicate/O/R=[0,NumLines-1] $Frequencies, Frequency
	String/G ::Frequency_Source = Frequencies

	If (cmpstr(Intensities,"_constant_"))
		Duplicate/O/R=[0,NumLines-1] $Intensities, Intensity
		String/G ::Intensity_Source = Intensities
	Else
		Make/O/N=(numpnts(Frequency)), Intensity = 1
	EndIf
	
	If (cmpstr(Widths,"_constant_"))
		Duplicate/O/R=[0,NumLines-1] $Widths, Width
		String/G ::Width_Source = Widths
	Else
		Make/O/N=(numpnts(Frequency)), Width = NaN
	EndIf

	Sort Frequency, Frequency, Intensity, Width
	
	Wavestats/Q  Intensity
	Variable/G minIntensity = V_min
	Variable/G maxIntensity = V_max

	Wavestats/Q  Width
	Variable/G minWidth = V_min
	Variable/G maxWidth = V_max

	Variable/G Count = numpnts(Frequency)
	Make/O/T/N=(Count) Assignments = ""

	Variable i, j
	for (i=0 ; i<LinesBak.Count ; i+= 1)
		if (strlen(LinesBak.Assignments[i]) > 0)
			j = Round(BinarySearchInterp(Frequency, LinesBak.Frequency[i]))
			if (j >= 0  && abs(Frequency[j] - LinesBak.Frequency[i]) < FreqTol)
				Assignments[j] = LinesBak.Assignments[i]
			else
				printf "Line # %d, %f, %f not matched.\r", i, 0+LinesBak.Frequency[i], 0+LinesBak.Intensity[i]
			endif
		endif
	endfor

	SetDataFolder SaveDF
	
	SynchronizeSeries2Lines()
	Return 1
end //static function CopyWavesToSourceFolder

function ViewLineList()
	String DataSet, PlotFolder
	if (!GetFolders(1,DataSet, PlotFolder))
		return 0
	endif

	Struct LinesStruct lines
	GetLinesStruct(DataSet, lines)

	String Title
	sprintf Title, "LWA: %s, Line List", StringFromList(ItemsInList(DataSet,":")-1,DataSet,":")

	Edit/K=1 lines.Frequency,lines.Intensity, lines.Width, lines.Assignments as Title
	ModifyTable width(Point)=35, format=3, digits=4, format(Point)=0
	
End function

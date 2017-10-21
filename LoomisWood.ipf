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
// 1.  Colors are no longer based on the Integer2Color function and the Rainbow color table, but a RGB color wave M_Colors in the Loomis-wood Folder.
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

	submenu "&Data Sets"

		"Create a &New Loomis-Wood Data Set...", NewLWDataSet()
		help = {"Create a new Loomis-Wood folder."}

		"&Delete a Loomis-Wood Data Set...", DeleteLWDataSet("")
		help = {"Delete an existing Loomis-Wood folder."}

		"-"
		help = {"", ""}

		LWDynamicMenuItem()+ "(View Line List...", 
		help = {"View the line list for the curent data set", "This command is only availible for Loomis-Wood plots."}

		LWDynamicMenuItem()+ "View Series List.../F8", ViewSeriesList()
		help = {"View/Edit the name, color, order, etc. of all assigned series.", "This command is only availible for Loomis-Wood plots."}

		LWDynamicMenuItem()+ "Extract &Assignments.../F9", ExtractAssignments()
		help = {"Create a table of assignments.", "This command is only availible for Loomis-Wood plots."}
		
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

static function VerifyInputWaveDims(Line_Frequencies,Line_Intensities,Line_Widths)
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
end //static Function GetNumPeaks

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Main Loomis-Wood inteface functions:
Function NewLWDataSet()
	// Save current folder name
	String SaveDF = GetDataFolder(1)
	
	// Get name of a new Data Set Folder from user
	String DataSet = GetNewLWDataFolder()
	if (cmpstr(DataSet,"")==0)
		Return 0
	endif
	
	// Create DataSet and copy peakfinder waves to it.
	if (CopyWavesToDataSetFolder(SaveDF, DataSet))
		DataSet += ":"
		SetDataFolder DataSet

//		// These are the persistant data created by CopyWavesToSourceFolder().
//		SetDatafolder Lines
//		WAVE Line_Frequency = Frequency
//		WAVE Line_Intensity = Intensity
//		WAVE Line_Width = Width
//
//		Wavestats/Q  Line_Intensity
//		Variable/G minIntensity = V_min
//		Variable/G maxIntensity = V_max
//
//		Wavestats/Q  Line_Width
//		Variable/G minWidth = V_min
//		Variable/G maxWidth = V_max
//
//		Variable NumLines = numpnts(Line_Frequency)
//		// Create the remaining persistant data.
//		Make/T/N=(NumLines) :Lines:Assignments
//		SetDatafolder ::
	
		// New 2/18/05
		Make/O/T/N=14 ColorNames = {"Teal","Red","Yellow","Lime","Blue","Fuchsia","Maroon","Olive","Green","Aqua","Navy","Purple","Black","Grey"}
		Make/O/D/N=(14,3) M_Colors
		M_Colors[0][0]= {0       , 65535, 65535, 0       , 0       , 65535, 32768, 32768, 0       , 0       , 0       , 32768, 0, 32768}
		M_Colors[0][1]= {32768, 0       , 65535, 65535, 0       , 0       , 0       , 32768, 32768, 65535, 0       , 0       , 0, 32768}
  		M_Colors[0][2]= {32768, 0       , 0       , 0       , 65535, 65535, 0       , 0       , 0       , 65535, 32768, 32768, 0, 32768}


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
End //Function NewLWDataSet

static function GetPeakfinderWaves(Line_Frequency, Line_Intensity, Line_Width)
// DIALOG
	string &Line_Frequency, &Line_Intensity, &Line_Width

	string Line_F = Line_Frequency
	string Line_I = Line_Intensity
	string Line_W = Line_Width

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

//static function GetConstantIntensity(Constant_Intensity)
//// DIALOG
//	variable Constant_Intensity //= 1
//
//	Prompt Constant_Intensity, LW_STRING5
//	DoPrompt LW_TITLE, Constant_Intensity 
//	
//	if (V_Flag)
//		return 0
//	endif
//
//	return Constant_Intensity
//end //static function GetConstantIntensity

//static function GetConstantWidth(Constant_Width)
//// DIALOG
//	variable Constant_Width //= 0.001
//	Prompt Constant_Width, LW_STRING6
//	DoPrompt LW_TITLE, Constant_Width 
//
//	if (V_Flag)
//		return 0
//	endif
//
//	return Constant_Width
//end //static function GetConstantWidth

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

static function CopyWavesToDataSetFolder(SourceDF, LWDF)
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

	//If (!cmpstr(Line_Intensities,"_constant_"))
	//	Constant_Intensity = GetConstantIntensity(1)
	//	If (!Constant_Intensity)
	//		Return 0
	//	EndIf
	//EndIf
	//If (!cmpstr(Line_Widths,"_constant_"))
	//	Constant_Width = GetConstantWidth(.001)
	//	If (!Constant_Width)
	//		Return 0
	//	EndIf
	//EndIf
	
	//Create DataSet, if it doesn't already exist
	NewDataFolder/O/S $LWDF
	NewDataFolder/O/S Lines

	Variable NumLines = GetNumLines(Frequencies, Intensities, Widths)
	Duplicate/R=[0,NumLines-1] $Frequencies, Frequency
	
	If (cmpstr(Intensities,"_constant_"))
		Duplicate/R=[0,NumLines-1] $Intensities, Intensity
	Else
		Make/O/N=(numpnts(Frequency)), Intensity = 1
	EndIf
	
	If (cmpstr(Widths,"_constant_"))
		Duplicate/R=[0,NumLines-1] $Widths, Width
	Else
		Make/O/N=(numpnts(Frequency)), Width = 1
	EndIf

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
		Prompt DataSet, LW_STRING9, popup FolderList(BASE_FOLDER)
		DoPrompt LW_TITLE, DataSet
		if (V_flag)
			return 0
		endif
		DataSet = BASE_FOLDER + ":" + DataSet + ":"
	endif
	
	String PlotsFolder = DataSet + "Plots:"
	//First, remove all dependencies in plot folders
	for(index = 1 ; index <= CountObjects(PlotsFolder,4) ; index += 1)
		PlotFolder = PlotsFolder+GetIndexedObjName(PlotsFolder,4,index-1)+":"
		SetFormula $(PlotFolder+"BandCoeffUpdate"), ""
		SetFormula $(PlotFolder+"TriangleUpdate"), ""
		SetFormula $(PlotFolder+"SeriesOrder"), ""
	endfor
	// Then, kill the folder
	KillDataFolder $DataSet
	
	Beep	
	Print LW_HISTORY1 + DataSet + LW_HISTORY2
end //function DeleteLWDataSet

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

	//Struct SeriesStruct series
	//GetSeriesStruct(DataSet, series)
			
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
	SetFormula SeriesOrder, "DoSeriesOrderUpdate("+DataSet+"Series:Order,"+PlotFolder+"CurrentSeries)"

	// Initialize persistant data.
	BandCoeff[0] = mean(lines.Frequency,0,lines.Count-1)
	BandCoeff[1] = 100*mean(lines.Frequency,0,lines.Count-1)

	temp = "DoBandCoeffUpdate("+PlotFolder+"BandCoeff)"
	SetFormula BandCoeffUpdate, temp
	temp = "DoTriangleUpdate("+PlotFolder+"Line_LWm,"+DataSet+"Lines:Assignments,"+DataSet+"Series:Color,"+DataSet+"Series:Shape,"+PlotFolder+"StartM,"+PlotFolder+"EndM,"+PlotFolder+"Zoom)"
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
	SetWindow kwTopWin,hook(LW)=LWHookFunction
	SetWindow kwTopWin,note="LoomisWood=2.0,DataSet="+DataSet+",PlotFolder="+PlotFolder+","

	// Setup the control bar
	ControlBar 60
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
	Execute/Z "PopupMenu CurrentSeriesPopup value=TextWave2List("+DataSet+"Series:Name)+\"_Create_New_Series_;\""
	Execute/Z "PopupMenu popup_assignments value="+PlotFolder+"lwCursor_assignments"
	Execute/Z "ValDisplay display_p,value="+PlotFolder+"lwCursor_p"
	Execute/Z "ValDisplay display_m,value="+PlotFolder+"lwCursor_m"
	Execute/Z "ValDisplay display_frequency,value="+PlotFolder+"lwCursor_frequency"
	Execute/Z "ValDisplay display_intensity,value="+PlotFolder+"lwCursor_intensity"
	Execute/Z "ValDisplay display_width,value="+PlotFolder+"lwCursor_width"
	Execute/Z "ValDisplay display_delta_m,value="+PlotFolder+"lwCursor_delta_m"
	Execute/Z "ValDisplay display_delta_frequency,value="+PlotFolder+"lwCursor_delta_frequency"

	SetWindow kwTopWin,note="LoomisWood=2.0,DataSet="+DataSet+",PlotFolder="+PlotFolder+","
	SetActiveSubwindow ##	// New

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

function DoTriangleUpdate(Line_LWm, Line_Series, Series_Color, Series_Shape, StartM, EndM, Zoom)
// This procedure recalculates Triangle_X, Triangle_Yup, Triangle_Ydown, and Triangle_Color, StartP, EndP, StartFrequency, and EndFrequency
// whenever Line_LWm, Line_Series, Line_Shape, Series_Color, Series_Shape, StartM, or EndM  change.
// DO NOT DECLARE AS STATIC!
	Wave Line_LWm
	Wave/T Line_Series
	Wave Series_Color, Series_Shape
	Variable startM, endM, Zoom

	Variable start_time = ticks

	String SaveDF = GetDataFolder(1)
	SetDataFolder GetWavesDataFolder(Line_Series,1)
	WAVE M_Colors = ::M_Colors
	WAVE Line_Intensity = Intensity
	WAVE Line_Width = Width
	NVAR minWidth, maxWidth, minIntensity, maxIntensity

	SetDataFolder GetWavesDataFolder(Line_LWm,1)
	WAVE PolyCoeff
	WAVE Line_DF
	WAVE Triangle_X
	WAVE Triangle_Yup
	WAVE Triangle_Ydown
	WAVE Triangle_Color

	Variable/G startP = BinarySearch2(Line_LWm, startM) + 1
	Variable/G endP = min(BinarySearch2(Line_LWm, endM), StartP + 0.2*FIVEMAX_PEAKS_PER_PLOT - 1)
	Variable/G startFrequency = poly(PolyCoeff,startM)
	Variable/G endFrequency = poly(PolyCoeff,endM)
	NVAR lastTriangle
	SetDataFolder ::
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
		base = Line_LWm[index]
		center = Line_DF[index]
		total_height = (Line_Intensity[index] - minIntensity) *scale_height + 0.1
		height = min(total_height, 0.90)  // New Version 2.01
		width =  (Line_width[index] - minWidth)*scale_width + WidthMin
		clip_width = (1-height/total_height)*width
		
		series = str2num(StringFromList(0,Line_Series[index],";"))
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
	//if (s.mouseLoc.v < 0 || s.mouseLoc.h < 0)
	//	return 0
	//endif

	switch(s.eventcode)
		case EC_Keyboard:
			switch(s.keycode)
			case VK_RETURN:
				AssignPeak(CursorPosition(),GetCurrentSeriesNumber(),CursorM(),1)
				VMoveCursor(1)
				return 1 
			case VK_DELETE:
				UnAssignPeak(CursorPosition(),GetCurrentSeriesNumber())
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
				//Prevent Ctrl-A (Autoscale)
				return 1			
			default:
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
		//		AssignPeak(theP,GetCurrentSeriesNumber(),CursorM(), -1)
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
		default:
			return 0
	endswitch //(Event)

End //function LWHookFunction

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

static function NearestPeak(theX, theY)
// Finds the peak nearest a set of cartesian coordinates in a Loomis-Wood plot.
	variable theX, theY
	
	variable theM, minP, maxP

	GetWindow kwTopWin, note
	string PlotFolder = StringByKey("PlotFolder",S_Value,"=",",")
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

	String PlotFolder, DataSet
	Variable temp

	GetWindow kwTopWin, note
	PlotFolder = StringByKey("PlotFolder",S_Value,"=",",")
	DataSet = StringByKey("DataSet",S_Value,"=",",")
	NVAR maxP = $(PlotFolder+"maxP")
	NVAR minP = $(PlotFolder+"minP")

	if ((theP > max(maxP,minP)) || (theP < min(maxP,minP)))
		//Trying to move out of bounds, so do nothing
		return 0
	endif

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

	SetDataFolder DataSet
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
	lwCursor_frequency = lines.Frequency[theP]
	lwCursor_intensity = lines.Intensity[theP]
	lwCursor_width = lines.Width[theP]
	
 	temp = 5*(lwCursor_p-StartP)
	LWCursorX[0] = Triangle_X[temp]
	LWCursorX[1] = Triangle_X[temp+3]
	LWCursorYdown = Triangle_Yup[temp]
	LWCursorYup = Triangle_Yup[temp]-0.8
	
	lwCursor_m = Triangle_Yup[temp]
	lwCursor_delta_m = Triangle_X[temp+1]
	lwCursor_delta_frequency = lwCursor_frequency - poly(PolyCoeff, lwCursor_m)

	Variable i, series_num, nassignments
	String m
	nassignments = ItemsInList(lines.Assignments[theP])
	if (nassignments <= 0)
		lwCursor_assignments = "Unassigned"
	else
		lwCursor_assignments = ""
		for (i = 0 ; i < nassignments ; i += 1)
			series_num = str2num(StringFromList(i,lines.Assignments[theP]))
			m = StringByKey(num2str(theP), series.Data[series_num])
			m = StringFromList(0,m,",")
			lwCursor_assignments += series.Name[series_num]+" "+m+";"
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
	WAVE Line_LWm = $(PlotFolder+"Line_LWm")
	return round(Line_LWm[CursorPosition()])
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
	String DataSet = StringByKey("DataSet",S_Value,"=",",")
	Struct SeriesStruct series
	GetSeriesStruct(DataSet, series)

	variable theSeries
	prompt theSeries, LW_STRING12, popup TextWave2List(Series.Name)+"_Create_New_Series_;"
	doprompt LW_TITLE, theSeries
	if (V_Flag)
		return 0
	endif
	
	CurrentSeriesPopupMenuControl("SelectSeries Function",theSeries,"")
end function

static function ChangeCurrentSeries(theSeries)
	Variable theSeries

	GetWindow kwTopWin, note
	String DataSet = StringByKey("DataSet",S_Value,"=",",")
	String PlotFolder = StringByKey("PlotFolder",S_Value,"=",",")
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
	if (!isTopWinLWPlot(1))
		Beep
		Print LW_ERROR3
		return 0
	endif

	GetWindow kwTopWin, note
	String DataSet = StringByKey("DataSet",S_Value,"=",",")
	//String PlotFolder = StringByKey("PlotFolder",S_Value,"=",",")

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
		lines.Assignments[point] = RemoveFromList(num2str(theSeries),lines.Assignments[point],";")
	endfor
	
	Variable series_num
	//npnts=numpnts(Line_Series)
	for (point=0 ; point<lines.Count; point+=1)
		if (ItemsInList(lines.Assignments[point])>0)
			item = ""
			for (i=0 ; i<ItemsInList(lines.Assignments[point]) ; i+=1)
				series_num = str2num(StringFromList(i,lines.Assignments[point],";"))
				series_num -= series_num > theSeries ? 1 : 0
				item += num2str(series_num)+";"
			endfor
			lines.Assignments[point] = item
		endif
	endfor

	DeletePoints theSeries, 1, series.Name, series.Data, series.Color, series.Shape, series.Order
end

function AddSeries()
	if (!isTopWinLWPlot(1))
		Beep
		Print LW_ERROR3
		return 0
	endif

	string saveDF = GetDataFolder(1)
	GetWindow kwTopWin, note
	SetDataFolder StringByKey("DataSet",S_Value,"=",",")
	WAVE/T ColorNames

	SetDataFolder Series
	WAVE/T Series_Name = Name
	WAVE/T Series_Data = Data
	WAVE Series_Color = Color
	WAVE Series_Shape = shape
	WAVE Series_Order = Order
	Variable NumSeries = numpnts(Series_Name) - 1
	SetDataFolder saveDF
			
	string SeriesName
	// HERE HERE
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
	String DataSet = StringByKey("DataSet",S_Value,"=",",")
	String PlotFolder = StringByKey("PlotFolder",S_Value,"=",",")
	NVAR CurrentSeries = $(PlotFolder+"CurrentSeries")
	Variable NumSeries = numPnts($(DataSet+"Series:Name")) -1
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
	SetDataFolder  StringByKey("DataSet",S_Value,"=",",")
	WAVE/T Line_Series = :Lines:Assignments
	WAVE/T Series_Data = :Series:Data
	SetDataFolder saveDF
	
	Series_Data[theSeries] = ReplaceStringByKey( num2str(theP) , Series_Data[theSeries] , num2str(theM)+","+num2str(theShape) )
	if ( !(FindListItem(num2str(theSeries) , Line_Series[theP]) >= 0) )
		Line_Series[theP] += num2str(theSeries) + ";"
	endif
End //Static Function AssignPeak

static Function UnAssignPeak(theP, theSeries)
	Variable theP, theSeries
	
	GetWindow kwTopWin, note
	String DataSet = StringByKey("DataSet",S_Value,"=",",")
	
	Struct LinesStruct lines
	GetLinesStruct(DataSet, lines)

	Struct SeriesStruct series
	GetSeriesStruct(DataSet, series)

	series.data[theSeries] = RemoveByKey( num2str(theP) , series.data[theSeries] )
	lines.Assignments[theP] = RemoveFromList( num2str(theSeries), lines.Assignments[theP] )
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

	SetDataFolder StringByKey("DataSet",S_Value,"=",",")
	WAVE Poly2Band
	WAVE/T BandCoeffLabels
	SetDataFolder Series
	WAVE Series_Order = Order
	WAVE/T Series_Name = Name
	if (theSeries >= numpnts(Series_Order))
		Beep
		SetDataFolder saveDF 
		return LW_ERROR6
	endif
	
	FetchSeries(theSeries)
	SetDataFolder ::SeriesFit
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
	WAVE Line_DF

	SetDataFolder StringByKey("DataSet",S_Value,"=",",")
	SetDataFolder Lines
	WAVE Line_Frequency = Frequency
	WAVE Line_Intensity = Intensity
	WAVE Line_Width = Width
	WAVE/T Line_Series = Assignments
	SetDataFolder ::Series
	WAVE/T Series_Data = Data

	NewDataFolder/O/S ::SeriesFit
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

		Series_Frequency[i] = Line_Frequency[pnt]
		Series_Residual[i] = Line_DF[pnt]
		Series_Intensity[i] = Line_Intensity[pnt]
		Series_Width[i] = Line_Width[pnt]
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
	SetDataFolder StringByKey("DataSet",S_Value,"=",",")
	SetDataFolder SeriesFit
	WAVE Series_M, Series_Frequency, Series_Residual, Series_Select, Series_Intensity, Series_Width

	Edit/K=1/W=(3,0,338.25,404)  Series_M, Series_Frequency, Series_Residual, Series_Select, Series_Intensity, Series_Width
	ModifyTable width(Point)=18,width(Series_M)=24,title(Series_M)="M",format(Series_Frequency)=3
	ModifyTable digits(Series_Frequency)=6,width(Series_Frequency)=68,title(Series_Frequency)="Frequency"
	ModifyTable format(Series_Residual)=3,digits(Series_Residual)=6,width(Series_Residual)=62
	ModifyTable title(Series_Residual)="Residual",width(Series_Select)=42,title(Series_Select)="Select"
	ModifyTable format(Series_Intensity)=3,width(Series_Intensity)=59,title(Series_Intensity)="Intensity"
	ModifyTable format(Series_Width)=3,digits(Series_Width)=6,width(Series_Width)=51
	ModifyTable title(Series_Width)="Width"

	SetDataFolder saveDF
End Function

Function ViewSeriesList()
	if (!isTopWinLWPlot(1))
		Beep
		Print LW_ERROR3
		return 0
	endif
	
	string saveDF = getDataFolder(1)
	GetWindow kwTopWin, note
	SetDataFolder StringByKey("DataSet",S_Value,"=",",")

	SetDataFolder Series
	WAVE/T Series_Name = Name
	//WAVE/T Series_Data = Data
	WAVE Series_Color = Color
	WAVE Series_Shape = shape
	WAVE Series_Order = Order

	Edit/W=(3,37.25,681,416)/K=1 Series_Name,Series_Color,Series_Shape,Series_Order
	ModifyTable width(Point)=36,width(Series_Name)=56,title(Series_Name)="Name",width(Series_Color)=32
	ModifyTable title(Series_Color)="Color", width(Series_Shape)=32, title(Series_Shape)="Shape"
	ModifyTable width(Series_Order)=32,title(Series_Order)="Order"
	
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
	String DataSet = StringByKey("DataSet",S_Value,"=",",")
	//String PlotFolder = StringByKey("DataSet",S_Value,"=",",")
	
	WAVE/T Series_Data = $(DataSet + "Series:Data")
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
	string DataSet = StringByKey("DataSet",S_Value,"=",",")
	string PlotFolder = StringByKey("PlotFolder",S_Value,"=",",")
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
	if (!isTopWinLWPlot(1))
		Beep
		Print LW_ERROR3
		return 0
	endif
	
	string saveDF = GetDataFolder(1)
	GetWindow kwTopWin, note
	SetDataFolder StringByKey("PlotFolder",S_Value,"=",",")
	WAVE BandCoeff
	SetDataFolder StringByKey("DataSet",S_Value,"=",",")
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
	SetDataFolder StringByKey("DataSet",S_Value,"=",",")
	WAVE/T ColorNames
	WAVE M_Colors
	SetDataFolder saveDF
	Edit/K=1 ColorNames, M_Colors
end

static function ValidateSourceFolder (DataSet)
// Makes sure that the DataSet string is valid.
// Changes DataSet to be an absolute reference.
// Returns 1 if DataSet is invalid, 0 if SorceFolder is valid.
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

	GetWindow kwTopWin, note
	string DataSet = StringByKey("DataSet",S_Value,"=",",")
	string PlotFolder = StringByKey("PlotFolder",S_Value,"=",",")
	
	WAVE Series_Order = $(DataSet+"Series:Order")
	NVAR CurrentSeries = $(PlotFolder+"CurrentSeries")
	
	Series_Order[CurrentSeries] = varNum
end

function CurrentSeriesPopupMenuControl(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	
	String DataSet, PlotFolder

	GetWindow kwTopWin, note
	DataSet = StringByKey("DataSet",S_Value,"=",",")
	
	Variable NumSeries = numPnts($(DataSet+"Series:Name")) - 1
	
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
	SetDataFolder StringByKey("DataSet",S_Value,"=",",")

	SetDataFolder Lines
	WAVE Line_Frequency = Frequency
	WAVE Line_Intensity = Intensity
	WAVE Line_Width = Width
	WAVE/T Line_Series = Series

	SetDataFolder ::Series	
	WAVE Series_Shape = Shape
	WAVE Series_Color = Color
	WAVE Series_Order = Order
	WAVE/T Series_Data = Data
	Variable NumPeaks=numPnts(Line_Frequency)
	Variable NumSeries=numPnts(Series_Shape) - 1
	
	NewDataFolder/O/S Assignments
	variable NumAssignments = 0
	variable index1
	for (index1 = 0 ; index1 < NumPeaks ; index1 += 1)
		NumAssignments += ItemsInList(Line_Series[index1])
	endfor
	
	Make/O/D/N=(NumAssignments) Frequency, Intensity, Width
	Make/O/W/N=(NumAssignments) Series, theM, Select
	Make/O/I/N=(NumAssignments) theP

	variable m, nseries, index2, ser, assignment=0
	string data
	for (index1 = 0 ; index1 < NumPeaks ; index1 += 1)
		nseries = ItemsInList(Line_Series[index1])
		for (index2 = 0 ; index2 < nseries ; index2 += 1)
			Frequency[assignment] = Line_Frequency[index1]
			Intensity[assignment] = Line_Intensity[index1]
			Width[assignment] = Line_Width[index1]

			ser = str2num(StringFromList(index2,Line_Series[index1]))
			data = StringByKey(num2str(index1),Series_Data[ser])
			M = str2num(StringFromList(0,data,","))

			Select[assignment] = str2num(StringFromList(1,data,","))
			theM[assignment] = M
			Series[assignment] = ser

			theP[assignment] = index1
			assignment += 1
		endfor
	endfor
	
	Edit/K=1/W=(5,5,700,400) Frequency, Intensity, Width,Series, theM, theP, Select
	ModifyTable width = 35
	ModifyTable width(Frequency)=80,format(Frequency)=3,digits(Frequency)=6
	ModifyTable width(Point)=30,width(Intensity)=60,format(Intensity)=3
	ModifyTable width(Width)=60,format(Width)=3,digits(Width)=6,width(Series)=50

	SetDataFolder saveDF
end function

Structure SeriesStruct
	WAVE/T Name
	WAVE Color
	WAVE Shape
	WAVE Order
	WAVE/T Data
	NVAR Count
EndStructure

Function GetSeriesStruct(DataSet, s)
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

Structure LinesStruct
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

Function GetLinesStruct(DataSet, s)
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
	SetDataFolder saveDF
End

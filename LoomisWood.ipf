// Copyright (c) 2017 Christopher F. Neese
//
// THIS SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#pragma rtGlobals = 1			// Use modern global access method.
#pragma IgorVersion = 5.02
#pragma Version = 3.00
#pragma ModuleName = LWA

// Changes 3.00:
// Rewrote the calculation of triangles to eliminate the need for regions.
//		This is a major change:
//		There is now a frequency span for each row set by StarDeltaNu and EndDeltaNu in the plot folder.
//		Limiting the frequency span is useful as a full 2B span may be too wide to produce a meaningful plot.
//		ChangeRange now sets a vertical (M) and a horizontal (DeltaNu) range.
//		A line can now appear at multiple values of M.
//		The mapping of Nu to (dNu, M) is no longer bijective, so it is difficult to center the graph on a specific point.
//		As a result the cursor can "get lost" while panning and zooming, and a lot of panning may be necessary after 
//		updating the fit model.
// Rewrote the code to use DFREFs instead of Strings where possible.
// Added RetrieveOrCreateTable() so that tables are initialized and named in a standard way.
// GetLwInfo() replaces GetFolders for retrieving data from the Window note.
// Added mouse wheel support.
// Added shift-cursor key support for panning.  PgDn and PgUp still pan vertically.
// Added horizontal panning.
// Removed superfluous dM display
//
// Added Rule, LineColor, and Model to Series Table
//
// ToDo List:
//		Replace window note retrieved with GetWindow with custom user data retrieved with GetUserData()
//		More structures for manipulating the plot folder.
//		Modify color support to use color index wave instead of RGB color wave.  Add alpha channel to colors.
//		Improve cursor movement on zoom/pan/jump 

// Igor 7 Bugs:
// Bug 1: (Reported to WM)
//     Setting a window note on tables prints 
//  BUG: WMDisposePtr: Attempt to dispose invalid pointer.
//  	Stack Trace:
//  		Stack trace is not available
//  when the table is killed
//
// Bug 2: (Reported to WM)
//		The original dependency formula for SeriesOrder causes the Set Variable control to unbind from SeriesOrder. 


// Changes 2.10:
// AddSeries lengthens LegendName and LegendShape
// Added EditFitFunc(), FlipConstants(), and FlipSeries()
// Added limit checks to support latest Igor 6.3
// Changed to #pragma rtGlobals = 3; fixed associated compiler errors
// Changed MoveCursor() to move to beginning or end if theP is out of bounds
// Removed bug in MoveCursor() that shifted plot by infinity. 

// Changes 2.09:
// Shifted triangles by 0.5, so that left axis ticks no longer require an offset.
//  Changes made are in DoTriangleUpdate(), UpdateCursor(), NearestPeak(), NewLWPlot(), VMoveCursor()
//  and ChangeRange()
// Added ChangeMinc(i) function
// Added LegendName and LegendShape to Series structure
// Added Triangle_Color2 for the outline of a triangle
// Textbox now moves below other controls if window becomes too narrow 

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

/// Global constants
static strconstant BASE_FOLDER = "root:LW"

static constant FIVEMAX_PEAKS_PER_PLOT = 500000
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
static constant EC_MouseWheel = 22

Static Constant VK_BACK = 0x08	//Backspace
Static Constant VK_TAB = 0x09
Static Constant VK_RETURN = 0x0D
Static Constant VK_ESCAPE = 0x1B
Static Constant VK_SPACE = 0x20
Static Constant VK_PGUP = 0x0B	//Page Up
Static Constant VK_PGDN = 0x0C	//Page Down
Static Constant VK_END = 0x04
Static Constant VK_HOME = 0x01
Static Constant VK_LEFT = 0x1C
Static Constant VK_UP = 0x1E
Static Constant VK_RIGHT = 0x1D
Static Constant VK_DOWN = 0x1F
Static Constant VK_DELETE = 0x7F

/// String Table (Makes translation/corrections easier)
// NOTE: There are also strings in the Menu "Loomis-Wood" command  below
static strconstant LW_TITLE = "Loomis-Wood"
static strconstant LW_ABOUT = "Loomis-Wood Add-In Version 2\rMay 2005\rChristopher F. Neese\rhttp://fermi.uchicago.edu/freeware/LoomisWood.shtml"
static strconstant LW_STRING1 = "Name of New Loomis Wood Folder:  "
static strconstant LW_STRING2 = "Wave containing peak frequencies:"
static strconstant LW_STRING3 = "Wave containing peak intensities:"
static strconstant LW_STRING4 = "Wave containing peak widths:"
//static strconstant LW_STRING5 = "Intensity for all peaks:"
//static strconstant LW_STRING6 = "Width for all peaks:"
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
static strconstant LW_STRING24 = "Line # %d, %f, %f not matched.\r"
static strconstant LW_STRING25 = "Please select a region:"
static strconstant LW_STRING26 = "Increment for m axis:"

static strconstant LW_HISTORY1="\tThe Loomis-Wood folder \""
static strconstant LW_HISTORY2="\" has been deleted."
static strconstant LW_HISTORY3="\" has been created."

static strconstant LW_ERROR1 = "\tLoomis-Wood Error: \""
static strconstant LW_ERROR2 = "\" does not exist."
static strconstant LW_ERROR3 = "\tLoomis-Wood Error:  The active graph is not a Loomis-Wood plot.\r"
static strconstant LW_ERROR4 = "\tLoomis-Wood Error:  There are no peaks predicted by the current band constants.  Please edit the band constants.\r"
static strconstant LW_ERROR5 = "\tLoomis-Wood Error:  The band constants are invalid.  Please edit the band constants.\r"
static strconstant LW_ERROR6 = "\tLoomis-Wood Error:  The series requested does not exist.\r"
static strconstant LW_ERROR7 = "\tLoomis-Wood Error:  The order of the series to be fit is less than 1.\r"
static strconstant LW_ERROR8 = "\tLoomis-Wood Error:  An error occured while fitting the current series.\r"
static strconstant LW_ERROR9 = "\tLoomis-Wood Error:  A backup coefficient wave does not exist.\r"

static strconstant FIT_RES = "\tFit of series %s, order %d, %d lines fit, %d lines assigned.\r"

/// Loomis-Wood menu and related functions:
menu "&Loomis-Wood", dynamic
// This builds the Loomis-Wood munu
// NOTE:  FUNCTIONS AND VARIABLES REFERENCED IN THIS PROCEDURE CANNOT BE STATIC!
// Thus, all of the strings for this menu are literals, not static strconstants.
// If functions are static, they must be prefixed with LWA#
	help = {LWA#OnLWmenuBuild()+"Welcome to Loomis-Wood!"}

	submenu "&Data Sets"

		"Create a &New Loomis-Wood Data Set...", NewLWDataSet()
		help = {"Create a new Loomis-Wood folder."}

		"&Delete a Loomis-Wood Data Set...", DeleteLWDataSet($"")
		help = {"Delete an existing Loomis-Wood folder."}

		"-"
		help = {"", ""}

		LWA#LWDynamicMenuItem(3)+ "View Line List...", ViewLineList()
		help = {"View the line list for the curent data set", "This command is only availible for Loomis-Wood plots."}

		LWA#LWDynamicMenuItem(3)+ "View Series List.../F8", ViewSeriesList()
		help = {"View/Edit the name, color, order, etc. of all assigned series.", "This command is only availible for Loomis-Wood plots."}

		LWA#LWDynamicMenuItem(3)+ "Extract &Assignments.../F9", ExtractAssignments("")
		help = {"Create a table of assignments.", "This command is only availible for Loomis-Wood plots."}
		
		LWA#LWDynamicMenuItem(3)+ "&Fit All Series.../SF9", FitAll()
		help = {"Fit All series in the data set and create a report.", "This command is only availible for Loomis-Wood plots."}
		"-"
		help = {"", ""}

		LWA#LWDynamicMenuItem(3)+ "Update Line List...", UpdateLinesFolder(NaN)
		help = {"Update line list to reflect added or deleted lines.", "This command is only availible for Loomis-Wood plots."}

		LWA#LWDynamicMenuItem(3)+ "Synchronize Lines To Series", SynchronizeLines2Series()
		help = {"Synchronize series data with assignments.  This is necessary after manually editing the line list.", "This command is only availible for Loomis-Wood plots."}

		LWA#LWDynamicMenuItem(3)+ "Synchronize Series To Lines", SynchronizeSeries2Lines()
		help = {"Synchronize assignments with series data.  This is necessary after manually editing series table.", "This command is only availible for Loomis-Wood plots."}

		"-"
		help = {"", ""}

		LWA#LWDynamicMenuItem(3)+ "Edit Colors", EditColors()
		help = {"View/Edit the Colors used for the current Loomis-Wood folder.", "This command is only availible for Loomis-Wood plots."}

		LWA#LWDynamicMenuItem(-1)+ "Edit &Fit Function...", EditFitFunc()
		help = {"View/Edit the Fit Functions for the current Loomis-Wood folder.", "This command is only availible for Loomis-Wood plots."}

	end
	
	submenu "&Plots"
		"&Create a New Loomis-Wood Plot...", NewLWPlot($"","")
		help = {"Make a Loomis-Wood plot.  You must have already created a Loomis-Wood folder."}
		
		//"(&Delete a Loomis-Wood Plot...", 
		//help = {"Make a Loomis-Wood plot.  You must have already created a Loomis-Wood folder."}		

		LWA#LWDynamicMenuItem(-1)+ "Change &M-axis scaling.../F11", ChangeRange(0,0,0,0)
		help = {"Change the M-axis scaling of the current Loomis-Wood plot.", "This command is only availible for Loomis-Wood plots."}

		LWA#LWDynamicMenuItem(-1)+ "Edit &Band Constants.../F12", EditBandConstants()
		help = {"View/Edit the Band Constants for the current Loomis-wood plot.", "This command is only availible for Loomis-Wood plots."}

		LWA#LWDynamicMenuItem(-1)+ "\\M0Show/Hide Cursor", ShowHideCursor()
		help = {"Toggle visability of cursor for the current Loomis-wood plot.", "This command is only availible for Loomis-Wood plots."}
	end

	submenu LWA#LWDynamicMenuItem(-1)+ "&Series"
	help = {"These commands modify the series in the current plot.", "This command is only availible for Loomis-Wood plots."}
		LWA#LWDynamicMenuItem(-1)+ "Start a &New Series.../F2", AddSeries()
		help = {"Start a new series.", "This command is only availible for Loomis-Wood plots."}

		LWA#LWDynamicMenuItem(-1)+ "&Select a Series.../F3", SelectSeries()
		help = {"Change the current series.", "This command is only availible for Loomis-Wood plots."}

		LWA#LWDynamicMenuItem(-1)+ "&Delete a Series.../F4", DeleteSeries()
		help = {"Delete a series.", "This command is only availible for Loomis-Wood plots."}

		LWA#LWDynamicMenuItem(-1)+ "&Fit Current Series/F5", Print FitSeries(GetCurrentSeriesNumber())
		help = {"Fit the current series.", "This command is only availible for Loomis-Wood plots."}

		LWA#LWDynamicMenuItem(-1)+ "&Undo Last Fit/SF5", UndoFit()
		help = {"Revert to previous fit.", "This command is only availible for Loomis-Wood plots."}

		LWA#LWDynamicMenuItem(-1)+ "&M-Shift Current Series.../F6", ShiftSeries(GetCurrentSeriesNumber(),0,1)
		help = {"M-shift the current series.", "This command is only availible for Loomis-Wood plots."}

		LWA#LWDynamicMenuItem(-1)+ "&M-Flip Current Series.../SF6", FlipSeries(GetCurrentSeriesNumber(),1)
		help = {"M-flip the current series.", "This command is only availible for Loomis-Wood plots."}

		LWA#LWDynamicMenuItem(-1)+ "&View Current Series/F7", ViewSeries(GetCurrentSeriesNumber())
		help = {"View the assignment table for the current series.", "This command is only availible for Loomis-Wood plots."}

		"-"
		help = {"", ""}

		LWA#LWDynamicMenuItem(3)+ "View Series List...", ViewSeriesList()
		help = {"View/Edit the name, color, order, etc. of all assigned series.", "This command is only availible for Loomis-Wood plots."}
	end
	
	"About Loomis-Wood Add-In...", LWA#About()
end

/// Menu support functions:
static function/S OnLWmenuBuild()
// Any commands in this function will be executed whenever the LoomisWood menu is built.
// This is a good place for global initializations.
	DFREF saveDF = GetDataFolderDFR()
	SetDataFolder root:
	NewDataFolder/O $BASE_FOLDER
	SetDataFolder saveDF
	return ""
end

static function/S LWDynamicMenuItem(theWinType)
	Variable theWinType
// Several commands on the Loomis-Wood menu should only be availible if the top window is a Loomis-Wood plot.
// By prepending a "(" to a menu item, it is greyed out.
	string theParen
	if (isTopWinLWPlot(theWinType))
		theParen = ""
	else
		theParen = "("
	endif
	return theParen 
end

static function About()
	DoAlert 0, LW_ABOUT
end
                    
/// Utility functions:
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
end

static function/S FolderList(sourceFolderStr)
// Returns a list of all folders in sourceFolderStr.
	DFREF sourceFolderStr
	string theResult = ""
	string objName
	variable index
	index = CountObjectsDFR(sourceFolderStr,4)-1
	if (index == -1)
		return ""
	endif
	do
		objName = GetIndexedObjNameDFR(sourceFolderstr, 4, index)
		if (strlen(objName) > 0)
			theResult+=objName+";"
		endif
		index -= 1
	while (index >= 0)
	return theResult
end

static function/S TextWave2List(theTextWave)
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

static function/S DimLabels2List(w, dim)
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

static function/S List2DimLabels(w, dim, list)
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
end

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
end

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
	 
	DFREF SaveDF = GetDataFolderDFR()
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
end

static function FindPolyExtrema(coeff, order)
// Finds the extrema of a polynomial
	wave coeff
	variable order
	
	for ( order = min(round(order), numpnts(coeff) - 1) ; order > 0 ; order -=1 ) 
		if (coeff[order] != 0)
			break
		endif
	endfor

	if (order<= 0)
		Make/N=0/D W_Extrema
		return NaN
	endif
	 
	DFREF SaveDF = GetDataFolderDFR()
	NewDataFolder/O/S root:Packages
	NewDataFolder/O/S root:Packages:bound_poly

	Make/D/O/N=(order) thePoly
	thePoly = coeff[p+1]*(p+1)
	FindRoots /P=thePoly
	WAVE/C W_polyRoots
	Variable a, b
	for ( order = numpnts(W_polyRoots)-1 ; order >= 0 ; order -=1 ) 
		a = real(W_polyRoots[order])
		b = imag(W_polyRoots[order])
		if (abs(b/a) > 1e-14)
			DeletePoints order, 1, W_polyRoots
		endif
	endfor
	order = numpnts(W_polyRoots)
	SetDataFolder SaveDF
	Make/O/D/N=(numpnts(W_polyRoots)) W_Extrema
	if (numpnts(W_polyRoots)>0)
		W_Extrema = real(W_polyRoots)
		Sort W_Extrema W_Extrema
	endif
	KillDataFolder root:Packages:bound_poly
end

static function inv_poly(coeff, order, theY, Xmin, Xmax)
// Finds the limits of monotonicity for the polynomial contained in coeff around the value theX.
// Returns a complex number whose real part is the lower limit and whose imaginary part is the upper limit.
	wave coeff
	variable order, theY, Xmax, Xmin
	variable theRes = NaN
	
	for ( order = min(round(order), numpnts(coeff) - 1) ; order > 0 ; order -=1 ) 
		if (coeff[order] != 0)
			break
		endif
	endfor

	if (order<= 0)
		return NaN
	endif
	 
	DFREF SaveDF = GetDataFolderDFR()
	NewDataFolder/O/S root:Packages
	NewDataFolder/O/S root:Packages:inv_poly

	Make/D/O/N=(order+1) thePoly = coeff[p]
	thePoly[0] -= theY

	FindRoots /P=thePoly
	WAVE/C W_polyRoots
	Variable a, b
	for ( order = numpnts(W_polyRoots)-1 ; order >= 0 ; order -=1 ) 
		a = real(W_polyRoots[order])
		b = imag(W_polyRoots[order])
		if ((abs(b/a) < 1e-14) && (a > Xmin) && (a < Xmax))
			theRes = a
		endif
	endfor
	SetDataFolder SaveDF
	KillDataFolder root:Packages:inv_poly
	return theRes
end

static function CompareFunctions(n1, n2)
	string n1, n2

	string f1, f2
	
	//if (!cmpstr(n1,n2))
	//	return 0
	//endif
	f1 = FunctionInfo(n1)
	f2 = FunctionInfo(n2)
	
	f1 = RemoveByKey("NAME", f1)
	f1 = RemoveByKey("TYPE", f1)
	f1 = RemoveByKey("PROCWIN", f1)
	f1 = RemoveByKey("MODULE", f1)
	f1 = RemoveByKey("INDEPENDENTMODULE", f1)
	f1 = RemoveByKey("SPECIAL", f1)
	f1 = RemoveByKey("SUBTYPE", f1)
	f1 = RemoveByKey("PROCLINE", f1)
	f1 = RemoveByKey("VISIBLE", f1)
	f1 = RemoveByKey("XOP", f1)

	f2 = RemoveByKey("NAME", f2)
	f2 = RemoveByKey("TYPE", f2)
	f2 = RemoveByKey("PROCWIN", f2)
	f2 = RemoveByKey("MODULE", f2)
	f2 = RemoveByKey("INDEPENDENTMODULE", f2)
	f2 = RemoveByKey("SPECIAL", f2)
	f2 = RemoveByKey("SUBTYPE", f2)
	f2 = RemoveByKey("PROCLINE", f2)
	f2 = RemoveByKey("VISIBLE", f2)
	f2 = RemoveByKey("XOP", f2)
	
	return !cmpstr(f1,f2)
end

static function/S FunctionList2(fname)
	string fname
	string List=FunctionList("*", ";", "" )
	string FinalList=""
	string Name
	variable i, size = ItemsInList(List)
	for (i = 0 ; i < size ; i += 1)
		Name = StringFromList(i,List)
		if (CompareFunctions(fname, Name))
			FinalList += Name + ";"
		endif
	endfor
	return FinalList
end

/// Misc Loomis-Wood functions:
static function isTopWinLWPlot(theWinType)
// This function tests to see if the top window is a Loomis-Wood plot. (or an associated Table)
// If the top window is a Loomis-Wood plot, it will contain "LoomisWood=ver" in its note.
// Use theWinType = 1 if only the top GRAPH needs to be a Loomis-Wood plot
// Use theWinType = 3 if the top GRAPH or TABLE needs to be a Loomis-Wood plot or associated Table
// Use theWinType = -1 if the overall top WINDOW needs to be a Loomis-Wood plot
// Use theWindType = -3 if the overall top WINDOW needs to be a Loomis-Wood plot or associated Table
	variable theWinType
	variable theVersion
	string TopWinName = WinName(0, theWinType < 0 ? -1 : theWinType)

	if (!cmpstr(TopWinName,""))	//This is necessary b/c this function may be called when there are no active windows.
		return 0
	endif
	
	if (theWinType < 0)
		if (cmpstr(TopWinName, WinName(0, -theWinType)))
			// Topmost window is wrong type
			return 0
		endif
	endif

	GetWindow $TopWinName, note
	theVersion = NumberByKey("LoomisWood",S_Value,"=",",")
	if (theVersion > 0)
		return 1
	else
		return 0
	endif
end

static function/S GetPlotList()
	string output = ""
	
	DFREF base = $BASE_FOLDER
	string DataSetFolders = FolderList(base)
	variable i
	for (i = 0 ; i < ItemsInList(DataSetFolders) ; i+= 1)
		string DataSetName =  StringFromList(i,DataSetFolders)
		DFREF dataset = base:$DataSetName
		DFREF plots = dataset:plots
		string PlotFolders = FolderList(plots)

		variable j
		for (j = 0 ; j < ItemsInList(PlotFolders) ; j+= 1)
			DFREF plot = plots:$StringFromList(j,PlotFolders)
			output += GetDataFolder(1,plot)
		endfor
	endfor
	
	return output
end

/// Main Loomis-Wood inteface functions:
function NewLWDataSet()
	// Save current folder name
	DFREF SaveDF = GetDataFolderDFR()
	
	// Get name of a new Data Set Folder from user
	DFREF DataSet = GetNewLWDataFolder()
	if (DataFolderRefStatus(DataSet)!=1)
		Return 0
	endif
	
	// Create DataSet and copy peakfinder waves to it.
	if (NewLinesFolder(saveDF, DataSet))
	
		NewSeriesFolder(DataSet)
		FinishDataFolder(DataSet)
		Return 1
	else
		Return 0
	endif
end

static function/DF GetNewLWDataFolder()
// DIALOG
	String DataSet
	//Save current folder name
	DFREF SaveDF = GetDataFolderDFR()

	//Ask for New DataSet.
	Prompt DataSet, LW_STRING1
	DoPrompt LW_TITLE, DataSet
	If (V_Flag)
		Return $""
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
					Return $""
				EndIf
				break
			default:
				// The user clicked "Cancel" so abort.
				SetDataFolder SaveDF
				Return $""
			endswitch
		While(CheckName(DataSet,11))
	EndIf
	DataSet = BASE_FOLDER +":"+ DataSet
	
	//Switch back to original folder.
	NewDataFolder $DataSet
	SetDataFolder SaveDF
	Return $DataSet
end

static function isDataSetDFR(dfref dfr)
	DFREF current = GetDataFolderDFR()
	SetDataFolder dfr
	SetDataFolder ::
	DFREF parent = GetDataFolderDFR()
	SetDataFolder current

	return !DataFolderRefsEqual(parent, $(BASE_FOLDER))	
end

function FinishDataFolder(DataSet)
	DFREF DataSet

	DFREF SaveDF = GetDataFolderDFR()
	SetDataFolder DataSet
	// New 2/18/05
	Make/O/D/N=(14,3) Colors
	Colors[0][0]= {0       , 65535, 65535, 0       , 0       , 65535, 32768, 32768, 0       , 0       , 0       , 32768, 0, 32768}
	Colors[0][1]= {32768, 0       , 65535, 65535, 0       , 0       , 0       , 32768, 32768, 65535, 0       , 0       , 0, 32768}
	Colors[0][2]= {32768, 0       , 0       , 0       , 65535, 65535, 0       , 0       , 0       , 65535, 32768, 32768, 0, 32768}
	List2DimLabels(Colors,0,"Teal;Red;Yellow;Lime;Blue;Fuchsia;Maroon;Olive;Green;Aqua;Navy;Purple;Black;Grey")
	List2DimLabels(Colors,1,"Red;Blue;Green")

	Make/O/D/N=(MAX_FIT_ORDER,MAX_FIT_ORDER) Band2Poly
	Band2Poly = StandardBand2Poly(p,q,1)
	Make/O/T/N=(MAX_FIT_ORDER) BandCoeffLabels
	BandCoeffLabels = StandardBandLabels(p)
	
	//Duplicate/O Band2Poly, Poly2Band
	//MatrixInverse/O Poly2Band
	MatrixOp/O Poly2Band = Inv(Band2Poly)				
	
	// Create an initial display
	NewLWPlot(DataSet, "Plot0")
	SynchronizeSeries2Lines()
	SetDataFolder SaveDF	
End

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
	
	string df = GetDataFolder(1)
	Line_Frequency = df+Line_F

	if (cmpstr(Line_I,"_constant_"))
		Line_Intensity= df+Line_I
	else
		Line_Intensity = Line_I
	endif

	if (cmpstr(Line_W,"_constant_"))
		Line_Width= df+Line_W		
	else
		Line_Width = Line_W
	endif

	return V_Flag
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
end

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
end

static function NewLinesFolder(SourceDF, LWDF)
	DFREF SourceDF
	DFREF LWDF
	DFREF SaveDF = GetDataFolderDFR()

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
	
	SetDataFolder LWDF

	//Create DataSet, if it doesn't already exist
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

	Sort {Frequency}, Frequency, Intensity, Width
	
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
end

static function NewSeriesFolder(DataSet)
	DFREF DataSet
	
	DFREF SaveDF = GetDataFolderDFR()
	SetDataFolder DataSet
	NewDataFolder/O/S Series
	
	Make/T/N=1 Name="Unassigned"
	Make/I/N=1 Shape
	Make/I/N=1 Model, Color, Order
	Make/T/N=1 Data
	Variable/G Count = 0
	
	Make/T/N=1 LegendText=""
	Make/I/N=1 LegendShape

	Make/T/N=1 Rule=""
	Make/I/N=1 Model, LineColor
	
	
	SetDataFolder saveDF
end

//function DeleteLWDataSet_Old(DataSet)
//// OPTIONAL DIALOG
//	string DataSet
//
//	string PlotFolder
//	variable index
//	
//	if (cmpstr(DataSet,""))
//		if (ValidateSourceFolder(DataSet))
//			// DataSet invalid
//			Beep
//			Print LW_ERROR1 + DataSet + LW_ERROR2
//			return 0
//		endif
//	else
//		//Prompt for DataSet
//		String DataSetFolders = FolderList(BASE_FOLDER)
//		if (ItemsInList(DataSetFolders)>0)
//			Prompt DataSet, LW_STRING9, popup DataSetFolders
//			DoPrompt LW_TITLE, DataSet
//			if (V_flag)
//				return 0
//			endif
//			DataSet = BASE_FOLDER + ":" + DataSet + ":"
//		else
//			return 0
//		endif
//	endif
//end
	
function/DF GetDataSetDialog(msg)
	string msg
	
	//Prompt for DataSet
	String DataSetFolders = FolderList(BASE_FOLDER)
	String DataSetName
	if (ItemsInList(DataSetFolders)>0)
		Prompt DataSetName, msg, popup DataSetFolders
		DoPrompt LW_TITLE, DataSetName
		if (V_flag==0)
			DFREF dfr = $(BASE_FOLDER + ":" + DataSetName + ":")
			return dfr
		endif
	endif	
end	
	
function DeleteLWDataSet(DataSetDFR)
// OPTIONAL DIALOG
	DFREF DataSetDFR

	if (!DataFolderRefStatus(DataSetDFR))
		//Prompt for DataSet
		DFREF DataSetDFR = GetDataSetDialog(LW_STRING9)
		if (DataFolderRefStatus(DataSetDFR)!=1)
			return 0
		endif	
	endif

	if (isDataSetDFR(DataSetDFR))
		// DataSet invalid
		Beep
		Print LW_ERROR1 + GetDataFolder(1,DataSetDFR) + LW_ERROR2
		return 0
	endif

	DFREF plots = DataSetDFR:Plots
	//First, remove all dependencies in plot folders
	int index
	for(index = 1 ; index <= CountObjectsDFR(plots,4) ; index += 1)
		DFREF plot = plots:$GetIndexedObjNameDFR(plots,4,index-1)
		DeleteLWPlotFolder(plot)
	endfor

	string name = GetDataFolder(1,DataSetDFR)

	// Then, kill the folder
	KillDataFolder DataSetDFR
	
	Beep	
	Print LW_HISTORY1 + name + LW_HISTORY2
end

function DeleteLWPlotFolder(PlotFolder)
// OPTIONAL DIALOG
	DFREF PlotFolder

	DFREF saveDF = GetDataFolderDFR()
	SetDataFolder PlotFolder
	//First, remove all dependencies in plot folders
	SetFormula $("BandCoeffUpdate"), ""
	SetFormula $("TriangleUpdate"), ""
	SetFormula $("DataUpdate"), ""
	SetFormula $("SeriesNameUpdate"), ""
	SetFormula $("SeriesOrder"), ""
	SetDataFolder saveDF
	
	string cmd = "KillDataFolder "+GetDataFolder(1,plotFolder)
	print cmd
	// Then, kill the folder
	Execute/P/Q/Z cmd
end

function ViewLineList()
	Struct LwInfo info
	if (!GetLwInfo(1, info))
		return 0
	endif

	Struct LinesStruct lines
	GetLinesStruct(info.data, lines)

	if (RetrieveOrCreateTable(info, "_LL", "Line List"))
		AppendToTable lines.Frequency,lines.Intensity, lines.Width, lines.Assignments
		ModifyTable width(Point)=35, format=3, digits=4, format(Point)=0
	endif
end

function EditColors()
	Struct LwInfo info
	if (!GetLwInfo(1, info))
		return 0
	endif
	
	WAVE/SDFR=info.data Colors

	if (RetrieveOrCreateTable(info, "_CT", "Colors"))
		AppendToTable Colors.ld
	endif	
end
 
function NewLWPlot(DataSet, PlotFolderName)
// OPTIONAL DIALOG
	DFREF DataSet
	String PlotFolderName
	String DataSetName = GetDataFolder(1,DataSet)
	
	if (DataFolderRefStatus(DataSet)==1)
		if (isDataSetDFR(DataSet))
			// DataSet invalid
			Beep
			Print LW_ERROR1 + GetDataFolder(1, DataSet) + LW_ERROR2
			return 0
		endif
	else
		//Prompt for DataSet and PlotFolder
		Prompt DataSetName, LW_STRING17, popup FolderList($BASE_FOLDER)
		Prompt PlotFolderName, LW_STRING18
		DoPrompt LW_TITLE, DataSetName, PlotFolderName
		if (V_flag)
			return 0
		endif
		
		DataSetName = BASE_FOLDER + ":" + DataSetName + ":"
		DFREF DataSet = $DataSetName
	endif
	
	DFREF SaveDF = GetDataFolderDFR()
	
	SetDataFolder DataSet
		
	Struct LinesStruct lines
	GetLinesStruct(dataDFR, lines)

	Struct SeriesStruct series
	GetSeriesStruct(dataDFR, series)

//	//TODO: Validate PlotFolder
	NewDataFolder/O/S Plots
	NewDataFolder/O/S $PlotFolderName
	DFREF PlotFolder = GetDatafolderDFR()
	PlotFolderName = GetDataFolder(1,PlotFolder)
	
	Make/O/D/N=2001 CombX, CombY = 1, CombM
	SetScale/I x, -1000, 1000, "M", CombX, CombY, CombM
	CombM = x
	Variable/G startDeltaNu = -50, endDeltaNu = 50
	
	Variable/G DataUpdate
	string temp = "DoDataUpdate(CombX, StartM, EndM, StartDeltaNu, EndDeltaNu)"
	SetFormula DataUpdate, temp
	
	// Create persistant data
	Make/O/D/N=(FIVEMAX_PEAKS_PER_PLOT) Triangle_X, Triangle_Yup, Triangle_Ydown
	Make/O/U/W/N=(FIVEMAX_PEAKS_PER_PLOT,3) Triangle_Color, Triangle_Color2
	Make/O/D/N=(MAX_FIT_ORDER) BandCoeff, PolyCoeff
	Make/O/D/N=(2) LWCursorX = NaN, LWCursorYup = NaN, LWCursorYdown = NaN
	Make/O/T/N=(1,6) AssignmentListText
	Make/O/I/N=(1,6) AssignmentListSel

	Triangle_X = NaN
	Triangle_Yup = NaN
	Triangle_Ydown = NaN
	Triangle_Color = NaN
	Triangle_Color2 = NaN
	Variable/G lastTriangle

	Variable/G Zoom=1
	Variable/G lwCursor_p, lwCursor_m, lwCursor_Nu, lwCursor_I, lwCursor_W, lwCursor_dNu
	Variable/G lwCursor_pnt, lwCursor_hide
	
	//String/G lwCursor_assignments
	Variable/G startM = -10, endM = 10 // 01/17/07 Changed

	Variable/G CurrentSeries = 1

	// Initialize persistant data.
	BandCoeff[0] = mean(lines.Frequency,0,lines.Count-1)
	BandCoeff[1] = abs(10*(lines.Frequency[0]-lines.Frequency[inf])/lines.Count)

	Variable/G SeriesOrder
	temp = "DoSeriesOrderUpdate("+DataSetName+"Series:Order,"+PlotFolderName+"CurrentSeries)"
	temp = DataSetName+"Series:Order["+PlotFolderName+"CurrentSeries]"
	SetFormula SeriesOrder, temp

	Variable/G SeriesNameUpdate
	temp = "DoSeriesNameUpdate("+DataSetName+"Series:Name,"+PlotFolderName+"CurrentSeries)"
	SetFormula SeriesNameUpdate, temp

	Variable/G BandCoeffUpdate
	temp = "DoBandCoeffUpdate("+PlotFolderName+"BandCoeff)"
	SetFormula BandCoeffUpdate, temp

	Variable/G TriangleUpdate
	temp =	 "DoTriangleUpdate(DataP, DataDeltaNu, DataM,"+DataSetName+"Lines:Assignments,"+DataSetName+"Series:Color,"+DataSetName+"Series:Shape, Zoom)"
	SetFormula TriangleUpdate, temp

	String Title
	sprintf Title, "LWA: %s, %s", GetDataFolder(1,DataSet), GetDataFolder(1,PlotFolder)
	// Draw the Graph
	Display/K=1/W=(3,0,762,400) LWCursorYup, LWCursorYdown vs LWCursorX As Title
	AppendToGraph Triangle_Yup, Triangle_Ydown, Triangle_Yup vs Triangle_X
	// New 01/17/07 First Copy is outline, second is fill

	// Setup the axes
	SetAxis/R left  EndM + 0.5, StartM -0.5
	SetAxis/A/E=0 bottom
	ModifyGraph standoff(left)=0 // Changed 01/17/07
	ModifyGraph manTick(left)={0,1,0,0}, manMinor(left)={1,2}  // Changed 01/17/07
	ModifyGraph btLen(left)=0.1, stLen(left)=5, ftLen(left)=0.1 // Changed 01/17/07
	ModifyGraph tlOffset(left)=5
	ModifyGraph minor(bottom)=1,lowTrip(bottom)=1e-06;DelayUpdate
	ModifyGraph sep(bottom)=10 // Changed 01/17/07
	ModifyGraph axThick=0.5	// added 01/17/07
	
	// Setup the traces
	ModifyGraph mode(LWCursorYup)=7,mode(Triangle_Yup)=7
	ModifyGraph toMode(LWCursorYup)=1,toMode(Triangle_Yup)=1
	ModifyGraph hBarNegFill(LWCursorYup)=2,hBarNegFill(Triangle_Yup)=2
	ModifyGraph hbFill=2
	ModifyGraph rgb(LWCursorYup)=(0,0,0),rgb(LWCursorYdown)=(0,0,0)
	ModifyGraph zColor(Triangle_Yup)={Triangle_Color,*,*,directRGB}
	ModifyGraph zColor(Triangle_Ydown)={Triangle_Color2,*,*,directRGB}
	ModifyGraph zColor(Triangle_Yup#1)={Triangle_Color2,*,*,directRGB}
	ModifyGraph lsize=0.5	// added 01/17/07	 

	// Setup the hook function
	SetWindow kwTopWin,hook(LW)=LWHookFunction
	SetWindow kwTopWin,note="LoomisWood=2.0,DataSet="+DataSetName+",PlotFolder="+PlotFolderName+","

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
	Execute/Z "PopupMenu CurrentSeriesPopup value=LWA#TextWave2List("+DataSetName+"Series:Name)+\"_Create_New_Series_;\""

	SetVariable order_setvar, pos={292,41}, size={80,16},title="Order", format="%d"
	SetVariable order_setvar, limits={1,6,1}, proc=OrderSetVarProc
	SetVariable order_setvar, value=SeriesOrder, bodyWidth= 40

	SetVariable zoom_setvar, pos={382,41}, size={80,16}, title="Zoom", format="%d"
	SetVariable zoom_setvar, limits={1,INF,1}
	SetVariable zoom_setvar, value=Zoom

	SetVariable display_p, pos={2,1}, size={70,18}, title="P", fSize=12, format="%d" //, bodyWidth=150
	SetVariable display_frequency, size={140,18}, title="Nu", fSize=12, format="%13.6f"
	SetVariable display_delta_frequency, size={100,18}, title="dNu", fSize=12, format="%13.6f"
	SetVariable display_width, pos={2,20}, size={100,18}, title="W", fSize=12, format="%8.6f"
	SetVariable display_intensity, size={70,18},title="I", fSize=12, format="%5.3f"
	SetVariable display_m, size={70,18}, title="M", fSize=12, format="%d"

	SetVariable display_p, value=lwCursor_p, limits={-inf,inf,0}, noedit=1
	SetVariable display_frequency, value=lwCursor_Nu, limits={-inf,inf,0}, noedit=1
	SetVariable display_delta_frequency, value=lwCursor_dNu, limits={-inf,inf,0}, noedit=1
	SetVariable display_intensity, value=lwCursor_I, limits={-inf,inf,0}, noedit=1
	SetVariable display_width, value=lwCursor_W, limits={-inf,inf,0}, noedit=1
	SetVariable display_m, value=lwCursor_m, limits={-inf,inf,0}, noedit=1

	GetWindow #, wSize
	variable width=max(V_right - V_left - 472, 100)
	variable height=max(V_bottom - V_top - 4, 40)
	variable name_size = max(50,(width-120)/2)

	ListBox list0, pos={470,2}, size={width,height}, proc=ListBoxProc
	ListBox list0, listWave=AssignmentListText
	ListBox list0, selWave=AssignmentListSel,mode= 5
	ListBox list0, widths={name_size,25,25,25,25,name_size}, userColumnResize= 1

	SetWindow #,note="LoomisWood=2.0,DataSet="+DataSetName+",PlotFolder="+PlotFolderName+","
	SetActiveSubwindow ##

	// Move the cursor to approximately the center of the plot
//	lwCursor_p = Round(0.5*(StartP+EndP))
//	MoveCursor(lwCursor_p)	

	SetDataFolder SaveDF
end

/// Data dependency functions:
function DoBandCoeffUpdate(BandCoeff)
// DO NOT DECLARE AS STATIC!
// This function is called via a dependancy whenever BandCoeff is changed
// This function is responsible for calculating Line_LWm, Line_DF, PolyCoeff, minM, maxM, minP, maxP
	wave BandCoeff
	
	variable start_time = ticks

	string PlotFolder = GetWavesDataFolder(BandCoeff,1)
	DFREF SaveDF = GetDataFolderDFR()
	SetDataFolder PlotFolder
	WAVE PolyCoeff
	SetDataFolder :::
	WAVE Line_Frequency = :Lines:Frequency
	WAVE Band2Poly
	SetDataFolder PlotFolder

	variable order
	
	MatrixOp/O PolyCoeff = Band2Poly x BandCoeff

	// Analyze PolyCoeff.
	WaveStats/Q PolyCoeff
	if (V_numINFs || V_numNaNs)
		// If PolyCoeff contains INFs or NaNs, things will go crazy:
		Beep
		print "1111", LW_ERROR4
		SetDataFolder SaveDF
		return 0
	endif
		
	order = numpnts(PolyCoeff)
	do
		order -= 1
	while ((PolyCoeff[order] == 0) && (order > 0))
	if (order <= 0)
		Beep
		print "2222", LW_ERROR4 
		SetDataFolder SaveDF
		return 0
	endif

	Make/O/D/N=2001 CombX, CombY = 1, CombM
	SetScale/I x, -1000, 1000, "M", CombX, CombY, CombM
	CombM = x
	CombX = poly2(PolyCoeff, order, x)

	SetDataFolder SaveDF

	// This update time should be under 120 ticks (2 sec) for good user interaction
	//printf "BandCoeff update took %d ticks.\r" ticks - start_time
	return (ticks - start_time)
end

function DoSeriesOrderUpdate(Series_Order, CurrentSeries)
// DO NOT DECLARE AS STATIC!
	wave Series_Order
	variable CurrentSeries
	
	variable npnts = numpnts(Series_Order)
	if (npnts<= 0)
		return 0
	else
		CurrentSeries = limit(Currentseries,0,npnts-1)
	endif 
	
	variable res=Series_Order[CurrentSeries]
	print "Here", res
	return res
end  

function DoSeriesNameUpdate(Series_Name, CurrentSeries)
// DO NOT DECLARE AS STATIC!
	wave/T Series_Name
	variable CurrentSeries

	ControlInfo CurrentSeriesPopup
	
	if (V_flag)
		PopupMenu CurrentSeriesPopup, mode=CurrentSeries	
	endif
end

function DoDataUpdate(comb, StartM, EndM, StartDeltaNu, EndDeltaNu)
// This procedure recalculates 
// DO NOT DECLARE AS STATIC!
	Wave comb
	Variable startM, EndM, StartDeltaNu, EndDeltaNu

	Variable start_time = StopMSTimer(-2)

	DFREF SaveDF = GetDataFolderDFR()
	DFREF PlotFolder = GetWavesDataFolderDFR(comb)
	SetDataFolder PlotFolder
	SetDataFolder :::
	DFREF dataDFR = GetDataFolderDFR()
	
	Struct LinesStruct lines
	GetLinesStruct(dataDFR, lines)

	variable nrows = abs(endM - startM + 1)

	SetDataFolder PlotFolder
	Make/O/D/N=(nrows) RowStart, RowStop
	SetScale/I x, StartM, EndM, "", RowStart, RowStop  

	RowStart = BinarySearch2(lines.Frequency, comb(startM+p)+StartDeltaNu ) + 1
	RowStop = BinarySearch2(lines.Frequency, comb(startM+p)+EndDeltaNu )

	Make/FREE/D/N=(nrows) temp = RowStop - RowStart + 1
	

	variable theM, row, p1, p2, n2, rowNu
	variable nlines = sum(temp)
	Make/O/D/N=(nlines) DataP, DataM, DataDeltaNu
	
	for(row=0 ; row < nrows ; row += 1)
		theM = StartM + row
		n2 = temp[row]
		p2 = p1 + n2 - 1
		rowNu = comb(startM+row)
		
		DataP[p1, p2] = RowStart[row] + p - p1	
		DataM[p1, p2] = theM
		DataDeltaNu[p1, p2] = lines.Frequency[DataP[p]] - rowNu
		
		p1 += n2
	endfor

	SetDataFolder SaveDF

	// This update time should be under 3 ticks (0.05 sec) for good user interaction
	//printf "Data update took %d ms.\r" ticks - start_time
	return (StopMSTimer(-2) - start_time)*1e-6
end

//Function CheckM(StartM, EndM, minM, maxM)
//	variable &startM, &EndM, minM, maxM
//	
//	// First check to make sure that StartM and EndM make sense
//	// This code will prevent scrolling beyond the first or last peak
//	if (StartM > EndM)
//		// This should only happen if the user manually edits StartM or EndM
//		// instead of using ChangeRange()
//		K0 = EndM
//		EndM = StartM
//		StartM = K0
//		ChangeRange(StartM, EndM)
//	endif
//	StartM = ceil(StartM)
//	EndM = floor(EndM)
//
//	if ( abs(endM-startM) > abs(maxM-minM) )
//		// Region is smaller than Range"
//		if ( ! (min(endM,startM) < maxM && maxM < max(endM,startM)) && (min(endM,startM) < minM && minM < max(endM,startM))  )
//			//Print "Centering Range within Region"
//			K0 = 0.5*(endM-startM)
//			startM = round(0.5*(maxM+minM)) + K0
//			endM = round(0.5*(maxM+minM)) - K0
//			ChangeRange(startM,endM)
//			//SetDataFolder SaveDF
//			//return 0
//		endif
//	else
//		K0 = abs(endM-startM)
//		if (endM > maxM)
//			//Print "Moving To End of Region"
//			endM = maxM
//			startM = maxM - K0
//			ChangeRange(startM,endM)
//			//SetDataFolder SaveDF
//			//return 0
//		elseif (startM < minM)
//			//Print "Moving To Beginning of Region"
//			startM = minM
//			endM = minM + K0
//			ChangeRange(startM,endM)
//			//SetDataFolder SaveDF
//			//return 0
//		endif
//	endif
//End

function DoTriangleUpdate(DataP, DataX, DataM, Assignments, Series_Color, Series_Shape, Zoom)
// This procedure recalculates Triangle_X, Triangle_Yup, Triangle_Ydown, and Triangle_Color, StartP, EndP, StartFrequency, and EndFrequency
// whenever LWm, Assignments, Line_Shape, Series_Color, Series_Shape, StartM, or EndM  change.
// DO NOT DECLARE AS STATIC!
	WAVE DataP, DataX, DataM
	Wave/T Assignments
	Wave Series_Color, Series_Shape
	Variable Zoom

	Variable start_time = StopMSTimer(-2)

	DFREF SaveDF = GetDataFolderDFR()
	SetDataFolder GetWavesDataFolderDFR(Assignments)
	SetDataFolder ::
	String DataSet = GetDataFolder(1)
	WAVE Colors
	DFREF data =$DataSet

	Struct LinesStruct lines
	GetLinesStruct(data, lines)

	DFREF PlotFolder = GetWavesDataFolderDFR(DataP)
	cd PlotFolder

	WAVE PolyCoeff
	WAVE Line_DF
	WAVE Triangle_X
	WAVE Triangle_Yup
	WAVE Triangle_Ydown
	WAVE Triangle_Color
	WAVE Triangle_Color2
	
	If (!WaveExists(Triangle_Color2))
		Duplicate/O Triangle_Color, Triangle_Color2
	endif
	If (DimSize(Colors,1)!=6)
		Redimension/N=(-1,6) Colors
		Colors[][3,5]=Colors[p][q-3]
	EndIf

	NVAR lastTriangle

//	NVAR minM
//	NVAR maxM
//	CheckM(StartM, EndM, minM, maxM)

	Variable/G ZoomW
	ZoomW = (numtype(ZoomW) || ZoomW <= 0) ? 1 : ZoomW
	Variable/G MinInt
	
	SetDataFolder SaveDF
	
	// Now, calculate the Triangles
	Variable base, center, color, height, fiveindex, shape, width, scale_width,  scale_height, WidthMin, index
	Variable total_height, clip_width
	Variable colorR, colorB, colorG
	Variable colorR2, colorB2, colorG2
	Variable series_num
		
	scale_width = 2*ZoomW
 	WidthMin = 0.25

	scale_height = (lines.maxIntensity-lines.minIntensity > 0) ? 0.90 / max(lines.maxIntensity, lines.minIntensity) : 1
	scale_height *= Zoom
	
	variable nlines = numpnts(DataP) 
	variable line
	
	for (line = 0 ; line <= nlines ; line += 1)
		fiveindex = 5*line
		index = DataP[line]
		
		series_num = str2num(StringFromList(0,Assignments[index],";"))
		if (numtype(series_num))
			series_num = 0
		endif
		shape = Series_Shape[series_num]
		shape = abs(lines.Intensity [index]) > minInt ?Series_Shape[series_num] : -1

		base = DataM[line] + 0.5  // 1/17/07 + 0.5 is new
		center = DataX[line]

		//total_height = (lines.Intensity[index] - lines.minIntensity) *scale_height + 0.1
		total_height = lines.Intensity[index]*scale_height
		base -= total_height < 0

		height = shape<0 ? NaN : sign(total_height)*min(abs(total_height), 0.90)  // New Version 2.01
		width =  lines.width[index]//*scale_width//(lines.width[index] -lines.minWidth)*scale_width + WidthMin
		width = numtype(width) ? WidthMin : width
		width *= scale_width
		clip_width = (1-height/total_height)*width	
		
		color = Series_Color[series_num]
		colorR = Colors[color][0]
		colorG = Colors[color][1]
		colorB = Colors[color][2]
		colorR2 = Colors[color][3]
		colorG2 = Colors[color][4]
		colorB2 = Colors[color][5]
		shape = shape!=0
		
		Triangle_X[fiveindex] = center - width
		Triangle_Yup[fiveindex] = base
		Triangle_Ydown[fiveindex] = base
		Triangle_Color[fiveindex] = {{colorR},{colorG},{colorB}}
		Triangle_Color2[fiveindex] = {{colorR2},{colorG2},{colorB2}}

		fiveindex += 1
		Triangle_X[fiveindex] = center - clip_width
		Triangle_Yup[fiveindex] = base-height
		Triangle_Ydown[fiveindex] = base-(1-shape)*height
		Triangle_Color[fiveindex] = {{colorR},{colorG},{colorB}}
		Triangle_Color2[fiveindex] = {{colorR2},{colorG2},{colorB2}}

		fiveindex += 1
		Triangle_X[fiveindex] = center + clip_width
		Triangle_Yup[fiveindex] = base-height
		Triangle_Ydown[fiveindex] = base-(1-shape)*height
		Triangle_Color[fiveindex] = {{colorR},{colorG},{colorB}}
		Triangle_Color2[fiveindex] = {{colorR2},{colorG2},{colorB2}}

		fiveindex += 1
		Triangle_X[fiveindex] = center + width
		Triangle_Yup[fiveindex] = base
		Triangle_Ydown[fiveindex] = base
		Triangle_Color[fiveindex] = {{colorR},{colorG},{colorB}}
		Triangle_Color2[fiveindex] = {{colorR2},{colorG2},{colorB2}}

	endfor
	fiveindex += 2
	Triangle_X[fiveindex,lastTriangle] = NaN
	//Triangle_Yup[fiveindex,lastTriangle] = NaN
	//Triangle_Ydown[fiveindex,lastTriangle] = NaN
	//Triangle_Color[fiveindex,lastTriangle] = NaN
	lastTriangle = fiveindex + 2
	if (isTopWinLWPlot(1))
		UpdateCursor()
	endif

	// This update time should be under 3 ticks (0.05 sec) for good user interaction
	//printf "Triangle update took %d ms.\r" ticks - start_time
	return (StopMSTimer(-2) - start_time)*1e-6
end

/// Loomis-Wood plot hook functions:
function LWHookFunction(s)
	STRUCT WMWinHookStruct &s
	
//	if ((ticks - s.ticks) > 10)
//		//Ignore events that are more than 2 ticks stale. 
//		return 1
//	endif
	
	Variable theKey, theP
	String DataSet, PlotFolder

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
			case VK_PGUP:
				VerticalScroll(-LinesPerFrame())
				return 1
			case VK_PGDN:
				VerticalScroll(LinesPerFrame())
				return 1
			case VK_LEFT:
				if (s.eventMod & 0x02)	// Shift
					HorizontalScroll(-0.2)
				else
					HMoveCursor(-1)
				endif
				return 1 
			case VK_UP:
				if (s.eventMod & 0x02)	// Shift
					VerticalScroll(-floor(0.2*LinesPerFrame()))
				else
					VMoveCursor(-1)
				endif
				return 1
			case VK_RIGHT:
				if (s.eventMod & 0x02)	// Shift
					HorizontalScroll(0.2)
				else
					HMoveCursor(1)
				endif
				return 1 
			case VK_DOWN:
				if (s.eventMod & 0x02)	// Shift
					VerticalScroll(floor(0.2*LinesPerFrame()))
				else
					VMoveCursor(1)
				endif
				return 1
			case 0x48:
			case 0x68:
				print s.keycode, s.eventMod
				ShowHideCursor()
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
		case EC_MouseWheel:
			VerticalScroll(s.wheelDy)
			HorizontalScroll(0.005*s.wheelDx)
			return 1
		case EC_MouseDown:
			//do not handle mouse events that occur outside the graph area
			if (s.mouseLoc.v < 0 || s.mouseLoc.h < 0) //TOP_BAR_HEIGHT
				return 0
			else
				SetActiveSubwindow $WinName(0,1)  // 01/17/07
				theP = HitTest(s)
				if (theP >= 0)
					UpdateCursor(theP=theP)
					return 1
	 			endif
	 		endif
 			return 0
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
		case EC_Resize: //Resize
			SetActiveSubwindow $WinName(0,1)
			SetActiveSubwindow #pTop
			GetWindow #, wSize
 			variable width=V_right - V_left - 474 //474 was 704
			variable height=V_bottom - V_top - 4
			if (height < 56)
				ControlBar/T 60
				height = 56
			endif
			if (width < 200)
				width += 466
				height -= 60
				if (height < 40)
					ControlBar/T 102
					height = 40
				endif
				ListBox list0, pos={4,60}
			else
				ControlInfo list0
				if (V_left < 470)
					height = max(56, height - 56)
					ControlBar/T height + 4
					ListBox list0, pos={470, 2}	
				endif
			endif
			variable name_size = max(50,(width-120)/2)
			ListBox list0 size={width,height}
			ListBox list0 widths={name_size,25,25,25,25,name_size}
			SetActiveSubwindow ##
			break
		case EC_Activate:
			Struct LwInfo info
			if (!GetLwInfo(1, info))
				return 0
			endif
			ControlInfo CurrentSeriesPopup
			NVAR/SDFR=info.plot CurrentSeries
			if (V_flag)
				PopupMenu CurrentSeriesPopup, mode=CurrentSeries	
			endif
			break
		case EC_Kill:
			OnKill()
			break
		default:
			return 0		
	endswitch
end

static function OnKill()
	Struct LwInfo info
	if (!GetLwInfo(1, info))
		return 0
	endif
	DeleteLWPlotFolder(info.plot)
end


function CurrentSeriesPopupMenuControl(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	
	Struct LwInfo info
	if (!GetLwInfo(1, info))
		return 0
	endif

	Struct SeriesStruct series
	GetSeriesStruct(info.data, series)
	
	if (popNum > series.Count)
		if(AddSeries())
			//User canceled AddSeries:
			NVAR/SDFR=info.plot CurrentSeries
			popNum = CurrentSeries
		endif
		DoUpdate	// Must force update here to make the popup display correctly
					// after the call to ChangeCurrentSeries()
	endif
	ChangeCurrentSeries(popNum)
end

function ListBoxProc(LB_Struct) : ListBoxControl
	STRUCT WMListboxAction &LB_Struct
	//1=mouse down, 2=up, 3=dbl click, 4=cell select with mouse or keys
	//5=cell select with shift key, 6=begin edit, 7=end

	if ((LB_Struct.eventCode==1 && LB_Struct.col>=2 && LB_Struct.col <= 4) || LB_Struct.eventCode==7)
		Struct LwInfo info
		if (!GetLwInfo(1, info))
			return 0
		endif

		WAVE/SDFR=info.plot/T AssignmentListText
		WAVE/SDFR=info.plot AssignmentListSel

		Struct LinesStruct lines
		GetLinesStruct(info.data, lines)
			
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
	return 0
end

/// Loomis-Wood plot event handlers:
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
	return NearestPeak(theX, theY)	// New 2.01
	
	StrSwitch(theTrace)	// string switch
		case "Triangle_Yup":
		case "Triangle_Ydown":
		case "LWCursorYup":
		case "LWCursorYdown":
			return NearestPeak(theX, theY)
		default:
	EndSwitch

	return -9
end

static function NearestPeak(theX, theY)
// Finds the peak nearest a set of cartesian coordinates in a Loomis-Wood plot.
	variable theX, theY
	
	Struct LwInfo info
	if (!GetLwInfo(1, info))
		return 0
	endif

	WAVE/SDFR=info.plot DataM
	WAVE/SDFR=info.plot DataDeltaNu
	WAVE/SDFR=info.plot DataP
	GetAxis/Q bottom

	Duplicate/FREE DataM, DataMfrac
	variable range = abs(V_max - V_min)
	DataMfrac += DataDeltaNu / range
	
	variable pnt = round(BinarySearchInterp(DataMfrac,round(theY)+theX/range))
	
	return pnt
end

static function VerticalScroll(Amount)
// Scrolls a Loomis-wood plot vertically
	Variable Amount

	Struct LwInfo info
	if (!GetLwInfo(1, info))
		return 0
	endif

	NVAR/SDFR=info.plot startM
	NVAR/SDFR=info.plot endM

	startM += Amount
	endM += Amount

	SetAxis/R left  EndM + 0.5, StartM -0.5
end

static function HorizontalScroll(Amount)
// Scrolls a Loomis-wood plot vertically
	Variable Amount

	Struct LwInfo info
	if (!GetLwInfo(1, info))
		return 0
	endif

	NVAR/SDFR=info.plot startDeltaNu
	NVAR/SDFR=info.plot endDeltaNu

	variable range = (endDeltaNu - startDeltaNu)*Amount


	startDeltaNu += range
	endDeltaNu += range
end

static function LinesPerFrame()
	Struct LwInfo info
	if (!GetLwInfo(1, info))
		return 0
	endif

	NVAR/SDFR=info.plot startM
	NVAR/SDFR=info.plot endM
	
	return abs(endM-startM)+1
end

function ShowHideCursor()
	String DataSet, PlotFolder

	Struct LwInfo info
	if (!GetLwInfo(1, info))
		return 0
	endif
	
	NVAR/SDFR=info.plot lwCursor_hide
	lwCursor_hide = !lwCursor_hide

	UpdateCursor()
end

static function UpdateCursor([theP])
	variable theP

	Variable temp

	Struct LwInfo info
	if (!GetLwInfo(1, info))
		return 0
	endif

	DFREF PlotDFR = info.plot
	
	NVAR/SDFR=PlotDFR lwCursor_pnt
	NVAR/SDFR=PlotDFR lwCursor_p 
	NVAR/SDFR=PlotDFR lwCursor_m
	NVAR/SDFR=PlotDFR lwCursor_Nu
	NVAR/SDFR=PlotDFR lwCursor_I
	NVAR/SDFR=PlotDFR lwCursor_W
	NVAR/SDFR=PlotDFR lwCursor_dNu
	NVAR/SDFR=PlotDFR lwCursor_hide
	
	Struct LinesStruct lines
	GetLinesStruct(info.data, lines)

	Struct SeriesStruct series
	GetSeriesStruct(info.data, series)

	WAVE/SDFR=PlotDFR Triangle_X
	WAVE/SDFR=PlotDFR Triangle_Yup
	WAVE/SDFR=PlotDFR LWCursorYup
	WAVE/SDFR=PlotDFR LWCursorYdown
	WAVE/SDFR=PlotDFR LWCursorX
	WAVE/SDFR=PlotDFR/T AssignmentListText
	WAVE/SDFR=PlotDFR AssignmentListSel
	
	WAVE/SDFR=PlotDFR DataP
	WAVE/SDFR=PlotDFR DataM
	WAVE/SDFR=PlotDFR DataDeltaNu
	
	if (!ParamIsDefault(theP))
		lwCursor_pnt = theP
	endif

	lwCursor_p = DataP[lwCursor_pnt]
	lwCursor_m = DataM[lwCursor_pnt]
	lwCursor_dNu = DataDeltaNu[lwCursor_pnt]
	
	lwCursor_Nu = lines.Frequency[lwCursor_p]
	lwCursor_I = lines.Intensity[lwCursor_p]
	lwCursor_W = lines.Width[lwCursor_p]
	
 	temp = limit(5*lwCursor_pnt,0,numpnts(Triangle_X)-4)
	LWCursorX[0] = Triangle_X[temp]
	LWCursorX[1] = Triangle_X[temp+3]
	LWCursorYdown = lwCursor_hide ? NaN : Triangle_Yup[temp]
	LWCursorYup = lwCursor_hide ? NaN : Triangle_Yup[temp]-0.8*sign(lwCursor_I)
	
	AssignmentString2ListBoxWaves(lines.Assignments[lwCursor_p], series.Name, AssignmentListText, AssignmentListSel)
end

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
end

//static function MoveCursor(theP)
//// Moves the cursor on a Loomis-Wood plot.
//	Variable theP
//	if (numtype(theP)==-2)
//		// theP is -INF, INF, or NaN, so do nothing.
//		return 0
//	endif
//
//	Variable temp
//
//	Struct LwInfo info
//	if (!GetLwInfo(1, info))
//		return 0
//	endif
//	string PlotFolder = GetDataFolder(1,info.plot)
//
//
//	NVAR maxP = $(PlotFolder+"maxP")
//	NVAR minP = $(PlotFolder+"minP")
//	NVAR lwCursor_p = $(PlotFolder+"lwCursor_p")
//	NVAR StartP = $(PlotFolder+"StartP")
//	NVAR EndP = $(PlotFolder+"EndP")
//
//	NVAR maxM = $(PlotFolder+"maxM")
//	NVAR minM = $(PlotFolder+"minM")
//	NVAR StartM = $(PlotFolder+"StartM")
//	NVAR EndM = $(PlotFolder+"EndM")
//
//	theP = limit(theP,min(maxP,minP),max(maxP,minP))
////	if ((theP > max(maxP,minP)) || (theP < min(maxP,minP)))
////		//Trying to move out of bounds
////		if (lwCursor_p > max(maxP,minP))
////			// Cursor is already out of bounds, so bring it back
////			theP = max(maxP,minP)
////		elseif (lwCursor_p < min(maxP,minP))
////			// Cursor is already out of bounds, so bring it back
////			theP = min(maxP,minP)
////		else
////			//Trying to move out of bounds, so do nothing
////			//Printf "Trying to move cursor out of bounds.  theP=%d; maxP=%d; minP=%d\r", theP, maxP, minP
////			return 0
////		endif
////	endif
//
//	Struct LinesStruct lines
//	GetLinesStruct(info.data, lines)
//
//	Struct SeriesStruct series
//	GetSeriesStruct(info.data, series)
//
//	WAVE Line_LWm = $(PlotFolder+"Line_LWm")
//
//	variable shift = 0 
//	if (theP < StartP)
//		shift = round(Line_LWm[theP])-StartM//round(Line_LWm[StartP])
//	elseif (theP > EndP)
//		shift = round(Line_LWm[theP])-EndM//-round(Line_LWm[EndP])
//	endif
//	
//	if (numtype(shift)!=0)
//		WaveStats/Q Line_LWm
//		NVAR startM = $(PlotFolder+"startM")
//		NVAR endM = $(PlotFolder+"endM")
//
//		printf "Trying to shift plot illegally.  shift=%d\r", shift
//	elseif (shift)
//		VerticalScroll(shift)
//		DoUpdate
//	endif
//	lwCursor_p = theP
//
//	UpdateCursor()
//end

static function CursorPosition()
	Struct LwInfo info
	if (!GetLwInfo(1, info))
		return 0
	endif

	NVAR/SDFR=info.plot lwCursor_p
	Return lwCursor_p
end

static function CursorM()
	Struct LwInfo info
	if (!GetLwInfo(1, info))
		return 0
	endif

	NVAR/SDFR=info.plot lwCursor_m
	Return lwCursor_m
end

static function VMoveCursor(Amount)
	Variable Amount

	Struct LwInfo info
	if (!GetLwInfo(1, info))
		return 0
	endif
	
	NVAR/SDFR=info.plot lwCursor_pnt
	NVAR/SDFR=info.plot lwCursor_dNu
	NVAR/SDFR=info.plot lwCursor_m
	
	Variable pnt = NearestPeak(lwCursor_dNu, lwCursor_m + Amount)
	lwCursor_pnt = pnt
	UpdateCursor()
	
end

static function HMoveCursor(Amount)
	Variable Amount
	
	Struct LwInfo info
	if (!GetLwInfo(1, info))
		return 0
	endif
	
	NVAR/SDFR=info.plot lwCursor_pnt

	lwCursor_pnt += Amount
	UpdateCursor()
end

function ChangeRange(theMin, theMax, left, right)	// F11
// OPTIONAL DIALOG
// Changes the left axis scaling of a Loomis-Wood plot.
	variable theMin, theMax, left, right

	Struct LwInfo info
	if (!GetLwInfo(1, info))
		return 0
	endif

	NVAR/SDFR=info.plot StartM
	NVAR/SDFR=info.plot EndM
	NVAR/SDFR=info.plot StartDeltaNu
	NVAR/SDFR=info.plot EndDeltaNu

	if ((theMin==0) && (theMax==0))
		do
			theMax = ceil(StartM)
			theMin = floor(EndM)
			left = StartDeltaNu
			right = EndDeltaNu
			Prompt theMax, LW_STRING15
			Prompt theMin, LW_STRING16
			Prompt left, "Left Delta Nu"
			Prompt right, "Right Delta Nu"

			DoPrompt LW_TITLE, theMax, theMin, left, right

			if (V_flag)
				return 0
			endif
		while ((theMin==0) && (theMax==0))
	endif

	StartDeltaNu = left
	EndDeltaNu = right
	StartM = min(theMin,theMax) 
	EndM = max(theMin,theMax)

	SetAxis/R left EndM + 0.5, StartM - 0.5	
end

function ChangeMinc(i)	// F11
// OPTIONAL DIALOG
// Changes the left axis scaling of a Loomis-Wood plot.
	variable i
	i = round(i)
	
	if (i<=0)
		do
			i = 1
			Prompt i, LW_STRING26
			DoPrompt LW_TITLE, i
			i = round(i)
			if (V_flag)
				return 0
			endif
		while ( i<=0 )
	endif

	ModifyGraph manTick(left)={0,i,0,0}, manMinor(left)={2*i-1,2}  // Changed 01/17/07
end

/// Series related functions:
function AddSeries()	// F2
// NON-OPTIONAL DIALOG
	Struct LwInfo info
	if (!GetLwInfo(1, info))
		return 0
	endif

	DFREF SaveDF = GetDataFolderDFR()
	WAVE/SDFR=info.data Colors

	Struct SeriesStruct series
	GetSeriesStruct(info.data, series)
			
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
	Redimension/N=(series.Count+1) series.Name, series.Data, series.Color, series.Shape, series.Order, series.LegendText, series.LegendShape
	Redimension/N=(series.Count+1) series.Rule, series.LineColor, series.Model
	series.Name[series.Count] = SeriesName
	series.LegendText[series.Count] = SeriesName
	series.Data[series.Count] = ""
	series.Color[series.Count] = SeriesColor
	series.Shape[series.Count] = 1
	series.LegendShape[series.Count] = 1
	series.Order[series.Count] = 1

	series.LineColor[series.Count] = SeriesColor
end

function SelectSeries()	// F3
// NON-OPTIONAL DIALOG
	Struct LwInfo info
	if (!GetLwInfo(1, info))
		return 0
	endif

	Struct SeriesStruct series
	GetSeriesStruct(info.data, series)

	variable theSeries
	prompt theSeries, LW_STRING12, popup TextWave2List(Series.Name)+"_Create_New_Series_;"
	doprompt LW_TITLE, theSeries
	if (V_Flag)
		return 0
	endif
	
	CurrentSeriesPopupMenuControl("SelectSeries function",theSeries,"")
end

static function ChangeCurrentSeries(theSeries)
	Variable theSeries

	Struct LwInfo info
	if (!GetLwInfo(1, info))
		return 0
	endif

	Struct SeriesStruct series
	GetSeriesStruct(info.data, series)
	
	NVAR/SDFR=info.plot CurrentSeries

	if ((theSeries > 0) && (theSeries <= series.Count))
		CurrentSeries = theSeries
	else
		Beep
		//Out of Range -- Do nothing
	endif
end

function DeleteSeries()	// F4
// NON-OPTIONAL DIALOG
	Struct LwInfo info
	if (!GetLwInfo(1, info))
		return 0
	endif
	
	Struct LinesStruct lines
	GetLinesStruct(info.data, lines)

	Struct SeriesStruct series
	GetSeriesStruct(info.data, series)
	
	variable theSeries
	prompt theSeries, LW_STRING13, popup TextWave2List(series.Name)
	doprompt LW_TITLE, theSeries
	if (V_Flag)
		return 0
	endif

//	Variable i, npnts, point
//	npnts = ItemsInList(series.Data[theSeries])
//	string item
//	for (i=0 ; i<npnts ; i+=1)
//		item = StringFromList(i,series.Data[theSeries],";")
//		point = str2num(StringFromList(0,item,":"))
//		lines.Assignments[point] = RemoveByKey(num2istr(theSeries),lines.Assignments[point])
//	endfor
//	
//	Variable series_num
//	//npnts=numpnts(Line_Series)
//	for (point=0 ; point<lines.Count; point+=1)
//		for (i=0 ; i<ItemsInList(lines.Assignments[point]) ; i+=1)
//			series_num = str2num( StringFromList(0, StringFromList(i,lines.Assignments[point],";"), ":" ) )
//			if (series_num > theSeries)
//				STRUCT AssignmentStruct assigned_line
//				if (ReadAssignment(point, series_num, assigned_line))
//					assigned_line.LW = !assigned_line.LW
//					UnAssignLine(point, series_num)
//					assigned_line.series -= 1
//					AssignLine2(assigned_line)
//				endif
//			endif
//		endfor
//	endfor

	DeletePoints theSeries, 1, series.Name, series.Data, series.Color, series.Shape, series.Order, series.LegendText, series.LegendShape
	DeletePoints theSeries, 1, series.Rule, series.LineColor, series.Model
	series.Count = numpnts(series.Name) - 1
	SynchronizeLines2Series()
	
	// Now cycle through all plots and adjust CurrentSeries as needed
	DFREF dataset = info.data
	DFREF plots = dataset:plots
	
	string plotsList = FolderList(plots)
	variable numPlots = ItemsInList(plotsList)
	DFREF thePlot
	variable i
	for (i=0 ; i<numPlots ; i+= 1)
		thePlot = plots:$StringFromList(i, plotsList)
		NVAR/SDFR=thePlot CurrentSeries
		if (theSeries == CurrentSeries)
			CurrentSeries = series.Count + 1
		elseif (CurrentSeries > theSeries)
			CurrentSeries -= 1
		endif
		if (CurrentSeries < 1 || CurrentSeries > series.Count)
			CurrentSeries = series.Count + 1
		endif
	endfor
end

function GetCurrentSeriesNumber()
// DO NOT MAKE STATIC
	Struct LwInfo info
	if (!GetLwInfo(1, info))
		return 0
	endif

	NVAR/SDFR=info.plot CurrentSeries

	Struct SeriesStruct series
	GetSeriesStruct(info.data, series)

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

function/S FitSeries(theSeries)	// F5
// Fits theSeries to a polynomial.
	variable theSeries

	string total_message=""

	Struct LwInfo info
	if (!GetLwInfo(1, info))
		return ""
	endif

	if (theSeries < 0 || numtype(theSeries))
		Beep
		return LW_ERROR6
	endif

	variable order

	DFREF SaveDF = GetDataFolderDFR()

	SetDataFolder info.plot
	WAVE BandCoeff
	Duplicate/O BandCoeff, LastCoeff

	SetDataFolder info.data
	WAVE Poly2Band
	WAVE/T BandCoeffLabels

	Struct SeriesStruct series
	GetSeriesStruct(info.data, series)

	if (theSeries > series.Count)
		Beep
		SetDataFolder saveDF 
		return LW_ERROR6
	endif
	
	STRUCT SeriesFitStruct s
	FetchSeries(theSeries, s)
	SetDataFolder SeriesFit
	
	Variable V_FitOptions = 4	// Suppress Dialog
	Variable V_FitError = 0
	
	s.Mask = (s.Mask != 0)

	order = series.Order[theSeries] + 1
	if (order > 2)
		k0=0;k2=0;k4=0;k6=0
		string hold_str ="0000000"
		//string hold_str = "1010101"
		CurveFit/Q/M=2/N/H=(hold_str) poly order, s.Frequency /X=s.theM /M=s.Mask /R=s.Residual /A=0 
	elseif (order == 2)
		K2 = 0
		CurveFit/Q/M=2/N/H="001" poly 3, s.Frequency /X=s.theM /M=s.Mask /R=s.Residual /A=0 
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
		
		MatrixOp/O BandCoeff = Poly2Band x W_Coef
		//MatrixMultiply Poly2Band, W_coef
		//WAVE M_product = M_product
		//BandCoeff = M_product
	
		MatrixOp/O M_Covar = Poly2Band x M_Covar x Poly2Band^t
		//MatrixMultiply Poly2Band, M_covar
		//M_covar = M_product
		//MatrixMultiply M_covar, Poly2Band/T
		//M_covar = M_product
		W_sigma = sqrt(M_covar[p][p])
	
		Duplicate/O M_covar M_correl
		M_correl = ((p<order) && (q<order)) ? M_covar[p][q]/(W_sigma[p]*W_sigma[q]) :  0
		
		WAVE s.W_Coef = BandCoeff
		WAVE s.W_Sigma = W_Sigma
		WAVE s.M_Covar = M_Covar
		WAVE s.M_Correl = M_Correl


//		string message, total_message=""
//		variable index, index2
//		string strDigit
//		string series_name = series.Name[theSeries]
//		sprintf total_message, FIT_RES, series_name, order -1, V_npnts, numpnts(s.Frequency)
//		sprintf message, "\t%16s = %14.4G\r" "S. E.", sqrt(V_chisq/(V_npnts - order))
//		total_message += message
//		for (index = 0 ; index < order ; index += 1)
//			strDigit = num2istr(2+floor(log(abs(BandCoeff[index])))-floor(log(abs(W_sigma[index]))))
//			sprintf message, "\t%16s = %#14."+strDigit+"G ? %#5.2G", BandCoeffLabels[index], BandCoeff[index], W_sigma[index]
//			total_message += message
//			for (index2 = 0 ; index2 < index ; index2 += 1)
//				sprintf message, "\t\t%6.3f", M_correl[index][index2]
//				total_message += message
//			endfor
//			sprintf message, "\r"
//			total_message += message
//		endfor	
		Variable/G ChiSq=V_ChiSq, nPnts=V_nPnts, V_Order = Order - 1
		String/G S_Name = series.Name[theSeries]
		NVAR s.ChiSq = Chisq
		NVAR s.nPnts = nPnts
		NVAR s.Order = V_Order
		SVAR s.Name = s_Name
		total_message = GetFitRes(s)
		KillWaves/Z W_ParamConfidenceInterval, M_Product
	endif
	SetDataFolder saveDF
	return total_message
end

function/S GetFitRes(s)
	STRUCT SeriesFitStruct &s
	
	string message, total_message=""
	variable index, index2
	string strDigit
	string series_name = s.Name
	sprintf total_message, FIT_RES, series_name, s.Order, s.npnts, numpnts(s.Frequency)
	sprintf message, "\t%16s = %14.4G\r" "S. E.", sqrt(s.ChiSq/(s.nPnts - s.Order - 1))
	total_message += message
	for (index = 0 ; index <= s.order ; index += 1)
		strDigit = num2istr(2+floor(log(abs(s.W_Coef[index])))-floor(log(abs(s.W_sigma[index]))))
		sprintf message, "\t%16s = %#14."+strDigit+"G ? %#5.2G", ""+s.Labels[index], 0+s.W_Coef[index], 0+s.W_sigma[index]
		total_message += message
		for (index2 = 0 ; index2 < index ; index2 += 1)
			sprintf message, "\t\t%6.3f", 0+s.M_correl[index][index2]
			total_message += message
		endfor
		sprintf message, "\r"
		total_message += message
	endfor
	
	return total_message	
end

function FitAll()
	Struct LwInfo info
	if (!GetLwInfo(1, info))
		return 0
	endif

	Struct SeriesStruct series
	GetSeriesStruct(info.data, series)

	DoWindow/F LWresults
	if (V_Flag)
		Notebook LWresults selection={StartOfFile,EndOfFile}
	else
		NewNotebook/F=0/N=LWresults
		Notebook LWResults font="Courier New"
	endif

	DFREF SaveDF = GetDataFolderDFR()
	SetDataFolder info.data
	SetDataFolder Series
	Make/O/D/N=(series.Count+1, MAX_FIT_ORDER) BandCoeffTable = NaN
	SetDataFolder info.plot
	WAVE BandCoeff
	SetDataFolder SaveDF
	
	Variable i
	for (i=1 ; i<= series.Count ; i +=1)
		Notebook LWresults text=FitSeries(i)+"\r\r"
		BandCoeffTable[i][] = BandCoeff[q]
	endfor
end

function/S UndoFit()	// Shift-F5
	Struct LwInfo info
	if (!GetLwInfo(1, info))
		return ""
	endif

	DFREF SaveDF = GetDataFolderDFR()
	SetDataFolder info.plot
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

static function FetchSeries(theSeries, s)
//FetchSeries creates the SeriesFit folder and fills the structure s.
	variable theSeries
	STRUCT SeriesFitStruct &s
	DFREF saveDF = GetDataFolderDFR()
	Struct LwInfo info
	if (!GetLwInfo(1, info))
		return 0
	endif

	Struct LinesStruct lines
	GetLinesStruct(info.data, lines)

	Struct SeriesStruct series
	GetSeriesStruct(info.data, series)

	SetDataFolder info.plot
	WAVE CombX

	SetDataFolder info.data
	WAVE/T s.Labels =  BandCoeffLabels
	NewDataFolder/O/S SeriesFit
	Variable npnts = ItemsInList(series.Data[theSeries])

	Make/D/O/N=(npnts) theM, Frequency, Residual, Mask, Intensity, Width
	WAVE s.theM = theM
	WAVE s.Frequency = Frequency
	WAVE s.Residual = Residual
	WAVE s.Mask = Mask
	WAVE s.Intensity = Intensity
	WAVE s.Width = Width
	SetDataFolder SaveDF 

	Variable i, pnt
	String data
	for (i = 0 ; i < npnts ; i += 1)
		data = StringFromList(i, series.Data[theSeries])
		pnt = str2num(StringFromList(0,data,":"))
		data = StringFromList(1,data,":")

		theM[i] = str2num(StringFromList(0,data,","))
		Mask[i] = str2num(StringFromList(1,data,","))

		Frequency[i] = lines.Frequency[pnt]
		Residual[i] = Frequency[i] - CombX(theM[i])
		Intensity[i] = lines.Intensity[pnt]
		Width[i] = lines.Width[pnt]
	endfor
	
	// Rename the Current Series Table if necessary
	String Title = series.Name[theSeries]
	String DataSetName = GetDataFolder(0,info.data)
	sprintf Title, "LWA: %s, \"%s\"", DataSetName, Title
	String WindowName = DataSetName + "_CS"
	DoWindow/T $WindowName, Title

	Sort theM, Frequency, Residual, Mask, Intensity,Width, theM
end

function ShiftSeries(theSeries, theShift, autoFixConstants)	// F6
// OPTIONAL DIALOG
// M-Shifts a series.
	Variable theSeries, theShift, autoFixConstants

	Struct LwInfo info
	if (!GetLwInfo(1, info))
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
	GetSeriesStruct(info.data, series)
	
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

function FlipSeries(theSeries, autoFixConstants)	// Shift-F6
	Variable theSeries, autoFixConstants

	Struct LwInfo info
	if (!GetLwInfo(1, info))
		return 0
	endif

	Struct SeriesStruct series
	GetSeriesStruct(info.data, series)
	
	Variable npnts = ItemsInList(series.Data[theSeries])
	Struct AssignmentStruct assignment
	
	Variable i, pnt, m, shape
	String data
	for (i = 0 ; i < npnts ; i += 1)
		data = StringFromList(i,series.Data[theSeries])
		pnt = str2num(StringFromList(0,data,":"))
		ReadAssignment(pnt, theSeries, assignment)
		assignment.m *= -1
		AssignLine2(assignment)
	endfor
				
	if (autoFixConstants)
		FlipConstants()
	endif
end


static function ShiftConstants(theShift)
// OPTIONAL DIALOG
// This function M-Shifts BandCoeff
	variable theShift

	Struct LwInfo info
	if (!GetLwInfo(1, info))
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
	
	WAVE/SDFR=info.plot PolyCoeff
	WAVE/SDFR=info.plot BandCoeff
	WAVE/SDFR=info.data Poly2Band

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
	//MoveCursor(CursorPosition())
end

static function FlipConstants()
	variable theShift

	Struct LwInfo info
	if (!GetLwInfo(1, info))
		return 0
	endif
	
	WAVE/SDFR=info.plot PolyCoeff
	WAVE/SDFR=info.plot BandCoeff
	WAVE/SDFR=info.data Poly2Band

	PolyCoeff[1,;2] *= -1

	MatrixMultiply Poly2Band, PolyCoeff
	WAVE M_Product
	BandCoeff = M_Product[p][0]
	KillWaves M_Product

	DoUpdate
end


function ViewSeries(theSeries)	// F7
	Variable theSeries

	Struct LwInfo info
	if (!GetLwInfo(1, info))
		return 0
	endif

	STRUCT SeriesFitStruct s
	FetchSeries(theSeries, s)
	
	DFREF saveDF = GetDataFolderDFR()

	Struct SeriesStruct series
	GetSeriesStruct(info.data, series)

	SetDataFolder info.data
	SetDataFolder SeriesFit

	if (RetrieveOrCreateTable(info, "_CS", series.Name[theSeries]))
		MoveWindow 3,0,338.25,404
		AppendToTable s.theM, s.Frequency, s.Residual, s.Mask, s.Intensity, s.Width
		ModifyTable showParts=254

		ModifyTable width(Point)=18,width(s.theM)=24,title(s.theM)="M",format(s.Frequency)=3
		ModifyTable digits(s.Frequency)=6,width(s.Frequency)=68,title(s.Frequency)="Frequency"
		ModifyTable format(s.Residual)=3,digits(s.Residual)=6,width(s.Residual)=62
		ModifyTable title(s.Residual)="Residual",width(s.Mask)=42,title(s.Mask)="Mask"
		ModifyTable format(s.Intensity)=3,width(s.Intensity)=59,title(s.Intensity)="Intensity"
		ModifyTable format(s.Width)=3,digits(s.Width)=6,width(s.Width)=51
		ModifyTable title(s.Width)="Width" 
	endif	
	
	SetDataFolder saveDF
end

function ViewSeriesList()	// F8
	Struct LwInfo info
	if (!GetLwInfo(1, info))
		return 0
	endif

	if (RetrieveOrCreateTable(info, "_SL", "Series List"))
		Struct SeriesStruct series
		GetSeriesStruct(info.data, series)

		MoveWindow 5.25,42.5,1000,236
		AppendToTable series.Name, series.Rule, series.Model, series.Color, series.LineColor, series.Shape,series.Order, series.LegendShape, series.LegendText, series.Data
		ModifyTable showParts=254

		ModifyTable font(series.Name)="Fixedsys"
		ModifyTable width(Point)=36,width(series.Name)=210,title(series.Name)="Name"
		ModifyTable width(series.Rule)=210,width(series.LineColor)=32,width(series.Model)=32
		ModifyTable width(series.Color)=32,title(series.Color)="Color"
		ModifyTable width(series.Shape)=32, title(series.Shape)="Shape"
		ModifyTable width(series.Order)=32,title(series.Order)="Order"
		ModifyTable width(series.LegendText)=210,title(series.LegendText)="Legend Text",title(series.LineColor)="Line Color"
		ModifyTable width(series.LegendShape)=31,title(series.LegendShape)="Legend Shape"
		ModifyTable width(series.Data)=200,title(series.Data)="Data"
	endif	
end

function EditFitFunc()
// NON-OPTIONAL DIALOG
	Struct LwInfo info
	if (!GetLwInfo(1, info))
		return 0
	endif

	if (RetrieveOrCreateTable(info, "_FF", "Fit Function"))
	
		WAVE/SDFR=info.data Band2Poly, Poly2Band
		WAVE/SDFR=info.data/T BandCoeffLabels
	
		AppendToTable BandCoeffLabels, Band2Poly, Poly2Band
	endif
End

function EditBandConstants()	// F12
// NON-OPTIONAL DIALOG
	Struct LwInfo info
	if (!GetLwInfo(1, info))
		return 0
	endif
	
	WAVE/SDFR=info.plot BandCoeff
	WAVE/T/SDFR=info.data BandCoeffLabels
	
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

	DFREF saveDF = GetDataFolderDFR()
	SetDataFolder info.plot
	Duplicate/O BandCoeff, LastCoeff
	SetDataFolder saveDF

	BandCoeff[0] = const0
	BandCoeff[1] = const1
	BandCoeff[2] = const2
	BandCoeff[3] = const3
	BandCoeff[4] = const4
	BandCoeff[5] = const5
	BandCoeff[6] = const6
end
 
/// Assignment related functions:
structure AssignmentStruct
	Variable Point
	Variable Series
	Variable M
	Variable LW
	Variable US
	Variable LS
	String Notes
EndStructure

static function ReadAssignment(theP, theSeries, s)
	variable theP, theSeries
	STRUCT AssignmentStruct &s

	Struct LwInfo info
	if (!GetLwInfo(1, info))
		return 0
	endif

	Struct LinesStruct lines
	GetLinesStruct(info.data, lines)

	Struct SeriesStruct series
	GetSeriesStruct(info.data, series)
	
	string data = StringByKey( num2istr(theSeries) , lines.assignments[theP] )
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
	
	Struct LwInfo info
	if (!GetLwInfo(1, info))
		return 0
	endif

	Struct LinesStruct lines
	GetLinesStruct(info.data, lines)

	Struct SeriesStruct series
	GetSeriesStruct(info.data, series)
	
	string data
	sprintf data, "%d,%d,%d,%d,%s", theM,  LWmask, USmask, LSmask, Notes
	
	series.Data[theSeries] = ReplaceStringByKey( num2istr(theP) , series.Data[theSeries] , data )
	lines.Assignments[theP] = ReplaceStringByKey( num2istr(theSeries) , lines.Assignments[theP] , data )

	return 1
end

static function UnAssignLine(theP, theSeries)
	Variable theP, theSeries
	
	Struct LwInfo info
	if (!GetLwInfo(1, info))
		return 0
	endif
	
	Struct LinesStruct lines
	GetLinesStruct(info.data, lines)

	Struct SeriesStruct series
	GetSeriesStruct(info.data, series)

	series.data[theSeries] = RemoveByKey( num2istr(theP) , series.data[theSeries] )
	lines.Assignments[theP] = RemoveByKey( num2istr(theSeries), lines.Assignments[theP] )
	lines.Assignments[theP] = RemoveByKey( "NaN", lines.Assignments[theP] )
	
	return 1
end

function ExtractAssignments(functionName)	// F9
	string functionName
	
	Struct LwInfo info
	if (!GetLwInfo(1, info))
		return 0
	endif
	
	Struct LinesStruct lines
	GetLinesStruct(info.data, lines)

	Struct SeriesStruct series
	GetSeriesStruct(info.data, series)

	DFREF saveDF = GetDataFolderDFR()
	SetDataFolder info.data

	SVAR S_AssignmentFunction
	if (!SVAR_Exists(S_AssignmentFunction))
		String/G S_AssignmentFunction=""
	endif	

	WAVE Colors
	NewDataFolder/O/S Assignments
	variable NumAssignments = 0
	variable index1
	for (index1 = 0 ; index1 < lines.Count ; index1 += 1)
		NumAssignments += ItemsInList(lines.Assignments[index1])
	endfor
	
	Make/O/D/N=(NumAssignments) Frequency, Intensity, Width
	Make/O/W/N=(NumAssignments) SeriesIndex, theM, LWmask, USmask, LSmask
	Make/O/I/N=(NumAssignments) theP
	Make/O/T/N=(NumAssignments) Assignment, Notes, SeriesName

	Make/O/N=(NumAssignments, 3) Color

	Struct AssignmentListStruct assignments
	WAVE/T assignments.Assignment = Assignment
	WAVE/T assignments.Notes = Notes
	WAVE assignments.Frequency = Frequency
	WAVE assignments.LSmask = LSmask
	WAVE assignments.Intensity = Intensity
	WAVE assignments.LWmask = LWmask
	WAVE assignments.SeriesIndex = SeriesIndex
	WAVE assignments.theM = theM
	WAVE assignments.theP = theP
	WAVE assignments.USmask = USmask
	WAVE assignments.Width = Width

	variable m, nseries, index2, ser, Asgn=0
	string data
	for (index1 = 0 ; index1 < lines.Count ; index1 += 1)
		nseries = ItemsInList(lines.Assignments[index1])
		for (index2 = 0 ; index2 < nseries ; index2 += 1)
			Frequency[Asgn] =lines.Frequency[index1]
			Intensity[Asgn] = lines.Intensity[index1]
			Width[Asgn] = lines.Width[index1]

			ser = str2num(StringFromList(index2, lines.Assignments[index1]))
			data = StringByKey(num2istr(index1), series.Data[ser])
			M = str2num(StringFromList(0,data,","))

			LWmask[Asgn] = str2num(StringFromList(1,data,","))
			USmask[Asgn] = str2num(StringFromList(2,data,","))
			LSmask[Asgn] = str2num(StringFromList(3,data,","))
			Notes[Asgn] = StringFromList(4,data,",")
			theM[Asgn] = M
			SeriesIndex[Asgn] = ser
			SeriesName[Asgn] = series.name[ser]

			Color[asgn][] = Colors[series.color[ser]][q]

			theP[Asgn] = index1
			
			Asgn += 1
		endfor
	endfor

	if (!CompareFunctions("LWLabelProto", functionName))
		if (CompareFunctions("LWLabelProto", S_AssignmentFunction))
			functionName = S_AssignmentFunction
		endif
		Prompt functionName, LW_STRING23, popup "_none_;" + FunctionList2("LWLabelProto")
		DoPrompt LW_TITLE, functionName
		
		if (V_Flag)
			// Cancel 
			return 0
		endif
	endif
	
	variable skipTable = 0
	variable useFunction = cmpstr(functionName, "_none_")
	if (useFunction)
		S_AssignmentFunction = functionName
		FUNCREF   LWLabelProto f=$functionName
		skipTable = f(assignments, series)
		skipTable = numType(skipTable) ? 0 : skipTable
		//Assignment = f(series.name[SeriesIndex[p]] ,theM[p])		
	else
		S_AssignmentFunction = ""
		//Assignment = ""
	endif
	
	if (!skipTable)
		if (RetrieveOrCreateTable(info, "_AL", "Assignments"))
			AppendToTable Assignment, USmask, LSmask, Frequency, Intensity, Width,SeriesIndex, theM, theP, LWmask
			MoveWindow 5,5,700,400
			ModifyTable width = 35
			ModifyTable width(Assignment)=200
			ModifyTable width(Frequency)=80,format(Frequency)=3,digits(Frequency)=6
			ModifyTable width(Point)=30,width(Intensity)=60,format(Intensity)=3
			ModifyTable width(Width)=60,format(Width)=3,digits(Width)=6,width(SeriesIndex)=50
		endif
	endif
	SetDataFolder saveDF
end

function RetrieveOrCreateTable(info, key, title2)
	Struct LwInfo &info
	string key
	string title2

	String DataSetName = GetDataFolder(0,info.data)
	String WindowName = DataSetName + key

	String Title
	sprintf Title, "LWA: %s, %s", DataSetName, title2
		
	DoWindow/F $WindowName
	if (!V_Flag)
		Edit/K=1 As Title
		DoWindow/C $WindowName

		String DataSet = GetDataFolder(1, info.data)
		String PlotFolder = GetDataFolder(1, info.plot)
		String NoteText = "LoomisWood=2.0,DataSet="+DataSet+",PlotFolder="+PlotFolder+","
		SetWindow kwTopWin,note=NoteText
		return 1
	endif

	DoWindow/T $WindowName, Title
	return 0
end

//function/S LWLabelProto(name, m)
//	string name
//	variable m
//	return "invalid"
//end

//static function TestLWLabelProto(name)
//	String name
//	FUNCREF   LWLabelProto f=$name
//
//	return cmpstr("invalid",f("",0))!=0
//end

function LWLabelProto(a, s)
	STRUCT AssignmentListStruct &a
	STRUCT SeriesStruct &s
end

/// Structures:
structure SeriesStruct
	WAVE/T Name
	WAVE Color
	WAVE Shape
	WAVE Order
	WAVE/T Data
	NVAR Count
	WAVE/T LegendText
	WAVE LegendShape
	WAVE/T Rule
	WAVE Model
	WAVE LineColor
EndStructure

static function GetSeriesStruct(dataDFR, s, [flag])
	DFREF dataDFR
	Struct SeriesStruct &s
	Variable flag	// If flag is nozero, DataSet is actually the path to the Series Folder, not the DataSet folder

	DFREF saveDF = GetDataFolderDFR()
	SetDataFolder dataDFR
	if (!flag)
		SetDataFolder Series
	endif
			
	WAVE/T s.Name
	WAVE s.Color
	WAVE s.Shape
	WAVE s.Order
	WAVE/T s.Data
	NVAR s.Count
	s.Count = numPnts(s.Name)-1

	// Added 01/17/07
	WAVE lt = LegendText
	if (!WaveExists(lt))
		Make/N=(s.Count+1)/T LegendText = s.Name
		Make/N=(s.Count+1)/D LegendShape = 1
	endif
	WAVE/T s.LegendText = LegendText
	WAVE s.LegendShape = LegendShape

	WAVE rule_check = Rule
	if (!WaveExists(rule_check))
		Make/N=(s.Count+1)/T Rule = ""
		Make/N=(s.Count+1)/D Model = 0
		Make/N=(s.Count+1)/D LineColor = s.Color
	endif
	WAVE/T s.Rule
	WAVE s.Model
	WAVE s.LineColor

	SetDataFolder saveDF
end

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

static function GetLinesStruct(dataDFR, s, [flag])
	DFREF dataDFR
	Struct LinesStruct &s
	Variable flag	// If flag is nozero, dataSet is actually path to the Lines Folder, not the DataSet folder
	
	DFREF saveDF = GetDataFolderDFR()
	SetDataFolder dataDFR
	if (!flag)
		SetDataFolder Lines
	endif
	
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
end

structure AssignmentListStruct
	WAVE/T Assignment
	WAVE/T Notes
	WAVE Frequency
	WAVE LSmask
	WAVE Intensity
	WAVE LWmask
	WAVE SeriesIndex
	WAVE theM
	WAVE theP
	WAVE USmask
	WAVE Width
EndStructure

static function GetAssignmentListStruct(dataDFR, s, [flag])
	DFREF dataDFR
	Struct AssignmentListStruct &s
	Variable flag	// If flag is nozero, DataSet is actually the path to the Assignments Folder, not the DataSet folder

	DFREF saveDF = GetDataFolderDFR()
	SetDataFolder dataDFR
	if (!flag)
		SetDataFolder $"Assignments"
	endif
	
	WAVE/T s.Assignment = Assignment
	WAVE/T s.Notes = Notes
	WAVE s.Frequency = Frequency
	WAVE s.LSmask = LSmask
	WAVE s.Intensity = Intensity
	WAVE s.LWmask = LWmask
	WAVE s.SeriesIndex = SeriesIndex
	WAVE s.theM = theM
	WAVE s.theP = theP
	WAVE s.USmask = USmask
	WAVE s.Width = Width

	SetDataFolder saveDF
end

structure SeriesFitStruct
	WAVE theM
	WAVE Frequency
	WAVE Residual
	WAVE Mask
	WAVE Intensity
	WAVE Width
	WAVE W_coef
	WAVE W_sigma
	WAVE M_Covar
	WAVE M_Correl
	WAVE/T Labels
	NVAR ChiSq
	NVAR nPnts
	NVAR Order
	SVAR Name
EndStructure

static function GetSeriesFitStruct(dataDFR, s, [flag])
	DFREF dataDFR
	Struct SeriesFitStruct &s
	Variable flag	// If flag is nozero, DataSet is actually the path to the Series Folder, not the DataSet folder

	DFREF saveDF = GetDataFolderDFR()
	SetDataFolder dataDFR
	if (!flag)
		SetDataFolder SeriesFit
	endif
	
	WAVE s.theM = theM
	WAVE s.Frequency = Frequency
	WAVE s.Residual = Residual
	WAVE s.Mask = Mask
	WAVE s.Intensity = Intensity
	WAVE s.Width = Width
	WAVE s.W_coef = W_coef
	WAVE s.W_sigma = W_sigma
	WAVE s.M_Covar = M_Covar
	WAVE s.M_Correl = M_Correl
	NVAR s.ChiSq = Chisq

	SetDataFolder saveDF
end

Structure LwInfo
	Variable valid
	Variable version
	DFREF plot
	DFREF data
EndStructure

static function GetLwInfo(theWinType, s)
	variable theWinType
	struct LwInfo &s 
// This function tests to see if the top window is a Loomis-Wood plot.
// If the top window is a Loomis-Wood plot, it will contain "LoomisWood=ver" in its note.
// Use theWinType = 1 if only the top GRAPH needs to be a Loomis-Wood plot
// Use theWinType = 3 if the top GRAPH or TABLE needs to be a Loomis-Wood plot or associated Table
// Use theWinType = -1 if the overall top WINDOW needs to be a Loomis-Wood plot
	s.valid = 0
	string DataSet = ""
	string PlotFolder = ""

	string TopWinName = WinName(0, theWinType < 0 ? -1 : theWinType)

	if (!cmpstr(TopWinName,""))	//This is necessary b/c this function may be called when there are no active windows.
		Beep
		Print LW_ERROR3
		return 0
	endif
	
	if (theWinType < 0)
		if (cmpstr(TopWinName, WinName(0, -theWinType)))
			// Topmost window is wrong type
			Beep
			Print LW_ERROR3
			return 0
		endif
	endif

	GetWindow $TopWinName, note
	variable theVersion = NumberByKey("LoomisWood",S_Value,"=",",")

	if (theVersion > 0)
		s.version = theVersion
		s.valid = 1
		DFREF s.data = $StringByKey("DataSet",S_Value,"=",",")
		DFREF s.plot = $StringByKey("PlotFolder",S_Value,"=",",")
		return 1
	else
		Beep
		Print LW_ERROR3
		return 0
	endif
end


/// New Stuff:
function SynchronizeSeries2Lines()
	Struct LwInfo info
	if (!GetLwInfo(1, info))
		return 0
	endif

	Struct SeriesStruct series
	GetSeriesStruct(info.data, series)

	Struct LinesStruct lines
	GetLinesStruct(info.data, lines)

	series.Data = ""
	Variable i, j, jmax, series_num
	String item
	for(i = 0 ; i < lines.Count ; i+=1)
		jmax = ItemsInList(lines.assignments[i])
		for(j = 0 ; j < jmax ; j+=1)
			item = StringFromList(j,lines.assignments[i])
			series_num = Str2Num(StringFromList(0,item,":"))
			do
			if (series_num > series.Count)
				Redimension/N=(series_num+1) series.Name, series.Data, series.Color, series.Shape, series.Order
				series.Name[series.Count+1,] = "Series"+num2istr(p)
				series.Count = series_num
				continue
			endif
			while(0)
			item = StringFromList(1,item,":")
			series.Data[series_num] += num2istr(i)+":"+item+";"
		endfor
	endfor
end

function SynchronizeLines2Series()
	Struct LwInfo info
	if (!GetLwInfo(1, info))
		return 0
	endif

	Struct SeriesStruct series
	GetSeriesStruct(info.data, series)

	Struct LinesStruct lines
	GetLinesStruct(info.data, lines)

	lines.assignments = ""
	Variable i, j, jmax, point
	String item
	for(i = 1 ; i <= series.Count ; i+=1)
		jmax = ItemsInList(series.data[i])
		for(j = 0 ; j < jmax ; j+=1)
			item = StringFromList(j,series.data[i])
			point = Str2Num(StringFromList(0,item,":"))
			item = StringFromList(1,item,":")
			lines.assignments[point] += num2istr(i)+":"+item+";"
		endfor
	endfor
end

function UpdateLinesFolder(FreqTol)
	Variable FreqTol

	Struct LwInfo info
	if (!GetLwInfo(1, info))
		return 0
	endif

	DFREF SaveDF = GetDataFolderDFR()

	SetDataFolder info.data
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
	
	SetDataFolder info.data
	NewDataFolder/O LinesBak
	KillDataFolder LinesBak
	DuplicateDataFolder Lines, LinesBak
	DFREF backupDFR = LinesBak
	
	If (FreqTol < 0 || numType(FreqTol) != 0)
		FreqTol = 0.001
		Prompt FreqTol, LW_STRING22
		DoPrompt LW_TITLE, FreqTol
	EndIf
	
	Struct LinesStruct LinesBak
	GetLinesStruct(backupDFR, LinesBak, flag=1)

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
				printf LW_STRING24, i, 0+LinesBak.Frequency[i], 0+LinesBak.Intensity[i]
			endif
		endif
	endfor
	
	SynchronizeSeries2Lines()
	SetDataFolder info.plot
	WAVE BandCoeff
	BandCoeff *= 1
	SetDataFolder SaveDF
	Return 1
end

function AverageFits(a,b)
	Variable a, b

	Struct LwInfo info
	if (!GetLwInfo(1, info))
		return 0
	endif

	WAVE/SDFR=info.plot BandCoeff
	WAVE/SDFR=info.plot LastCoeff

	FitSeries(a)
	FitSeries(b)
	BandCoeff += LastCoeff
	BandCoeff /= 2
end

function AddLegend(perLine)
	variable perLine
	
	Struct LwInfo info
	if (!GetLwInfo(1, info))
		return 0
	endif
	
	Struct SeriesStruct s
	GetSeriesStruct(info.data, s)
	WAVE/SDFR=info.data Colors

	string legendtext, marker, temp="\\JC\\[0\\y-08\\[1"
	variable i, j
	TextBox/C/N=lwLegend/F=0/A=MB/X=0.00/Y=0.00/E "\\JC\\[0\\y-08\\[1"
	for(i=1; i <= s.Count ; i += 1)
		if (s.LegendShape[i] != 0)
			legendtext = ""
			if (s.LegendShape[i] > 0)
				marker = "\\Y1\\W517\\Y0"
				//marker = "\\W517"
			else
				marker = "\\W523"
			endif
			sprintf legendtext, "\\K(%d,%d,%d)\\k(%d,%d,%d)", Colors[s.Color[i]][0],Colors[s.Color[i]][1],Colors[s.Color[i]][2],Colors[s.Color[i]][3],Colors[s.Color[i]][4],Colors[s.Color[i]][5]
			legendtext += marker
			legendtext += "\\K(0,0,0)"
			legendtext += s.LegendText[i]
			j += 1
			if (mod(j, perLine)==0 && i < s.Count)
				//printf "%d\t", strlen(temp)
				legendtext += "\r\\[0\\y-08\\[1"
			else
				legendtext += ""
			endif
			AppendText/N=lwLegend /NOCR legendtext
			temp += legendtext
		endif
	endfor
	//print strlen(temp)
	//legendtext = "\\{CalcLegendStr("+GetWavesDataFolder(s.LegendText, 2)
	//legendtext = legendtext + ","+GetWavesDataFolder(s.LegendShape, 2)
	//legendtext = legendtext + ","+GetWavesDataFolder(s.Color, 2)
	//legendtext = legendtext + ","+GetWavesDataFolder(Colors, 2)
	//legendtext = legendtext + ","+num2istr(PerLine)+")}"
	//TextBox/C/N=lwLegend/F=0/A=MB/X=0.00/Y=0.00/E legendtext
end

function/S CalcLegendStr(Text,Shape,Color,Colors,PerLine)
	Wave/T Text
	Wave Shape, Color
	Wave Colors
	Variable PerLine
	
	Variable i, imax=numpnts(Text), j
	string legendtext = "", marker
	for(i=1 ; i < imax ; i += 1)
		if (Shape[i] != 0)
			if (Shape[i] > 0)
				marker = "\\Y1\\W517\\Y0"
				//marker = "\\W517"
			else
				marker = "\\W523"
			endif
			sprintf legendtext, "\\K(%d,%d,%d)\\k(%d,%d,%d)", Colors[Color[i]][0],Colors[Color[i]][1],Colors[Color[i]][2],Colors[Color[i]][3],Colors[Color[i]][4],Colors[Color[i]][5]
			legendtext += marker
			legendtext += "\\K(0,0,0)"
			legendtext += Text[i]
			j += 1
			if (mod(j, perLine)==0 && i < imax)
				legendtext += "\r\\[0\\y-08\\[1"
			else
				legendtext += ""
			endif
		endif
	endfor

	return legendtext	
end

function OrderSetVarProc(ctrlName,varNum,varStr,varName) : SetVariableControl
	string ctrlName
	variable varNum
	string varStr
	string varName

	Struct LwInfo info
	if (!GetLwInfo(1, info))
		return 0
	endif
	
	Struct SeriesStruct series
	GetSeriesStruct(info.data, series)

	NVAR/SDFR=info.plot CurrentSeries
	variable old_value = series.Order[CurrentSeries]
	
	if (old_value != varnum)
		series.Order[CurrentSeries] = varNum
	endif
end

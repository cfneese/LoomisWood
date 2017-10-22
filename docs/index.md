#Loomis-Wood Manual

Loomis-Wood Add-In

Version 2.08

June 3, 2005

Christopher F. Neese

cfneese@uchicago.edu

http://fermi.uchicago.edu/freeware/LoomisWood.shtml

##Contents

var toc = require('markdown-toc');
toc('# One\n\n# Two').content;

// Theory
// License
// Features
// System Requirements
// Upgrading
// Getting Started with the Add-In
// Working with Band Heads
// How It Works
// Troubleshooting
// Menu/Command Reference
// Keyboard Reference
// Function Reference
// Structures
// Customization
// Revision List
// To Do List
// References

##Theory

Most molecular spectra contain series of lines that are readily fitted to
polynomials of the quantum number _J_, or some index directly related to _J_.
For example, for a linear molecule, the _P_ and _R_ branches can be to fit to the same polynomial
if we use _m_ instead of _J_, where _m_= -_J_ for a _P_-branch line and _m_ = _J_ - 1 for an _R_-branch line.
�
If we plot _m_ verses the residual of such a fit, we have a basic Loomis-Wood plot.
In this plot a well-fit rotational series will appear as a vertical line of points.
If the fit is not optimal but close, a series will appear as a line of points with a small slope
and/or a small curvature from the error of the fit.
It is relatively easy to follow such a series in a Loomis-Wood plot even when the
series is not-so-obvious in the actual spectrum.
The extra dimension of the Loomis-Wood plot creates a higher information-density than in the raw spectrum.
By plotting the Loomis-Wood plot using triangles of height and width proportional to line intensity and line width,
this information density can be increased further.


Loomis and Wood were the first to use this two-dimensional representation of a spectrum in 1928.
While simply drawing Loomis-Wood plots is relatively straightforward, the time required to manually
create a Loomis-Wood diagram limited the usefulness of these plots in the
initial assignment of spectra before the advent of microcomputers.
The first computer program to generate a Loomis-Wood plot was written at the Ohio State University in the 1960s.
When a Loomis-Wood plot is made interactive so that assignments can be made in the plot and linked to an assignment database a powerful tool is created.
The first interactive Loomis-Wood applications by Winnewisser _et al._ appeared in
the 1980s.
The Loomis-Wood add-in follows in the tradition of these interactive programs.

#License

Copyright (c) 2005
Christopher F. Neese

THIS SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For the time being, users should cite this work as:

An Interactive Loomis-wood Package for Spectral Assignment in Igor Pro, Version 2.0.,
Neese, C. F.
_Fifty-sixth Ohio State University International Symposium on Molecular Spectroscopy_,
Columbus, Ohio, June 20-24, 2005.

(Please check the website for latest information on citing this work.)

#Features

* The add-in is Macintosh and Windows compatible. (Version 1.0 was not Macintosh compatible.)
* The add-in provides an organized line/assignment database.
* Lines can be assigned to multiple series.
* Multiple Loomis-Wood data sets can be created within a single Igor experiment.
* Multiple plots of a single Loomis-Wood data set can be created within a single Igor experiment.
* There is a user-extensible extract assignments feature. This feature allows the add-in to be used
easily with external fitting programs.

Since the add-in is written for Igor (instead of as a stand-alone program) all of
Igor�s features are available to the add-in.
For example, printing and graphics export are provided by Igor, not the
add-in.

##System Requirements

The add-in requires Igor 5.02 or later. Performance should be acceptable on any Pentium-4 based computer.

# Upgrading

The data format for version 2.x of the Loomis-Wood add-in is substantially
different from version 1.0.  Therefore no direct upgrade route has been provided.
If you need a method to upgrade an experiment using Loomis-Wood 1.0 to
2.x please contact the author.

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>If the
user needs to update from version 2.x to a newer version of the Add-In, it may
be necessary to close all LW plots and recreate them from the Loomis-Wood
menu.<span style='mso-spacerun:yes'>� </span>This can be done without losing
any assignments, and is only necessary if the user finds odd behavior after an
update.<span style='mso-spacerun:yes'>� </span>The author will try to note any
upgrades that require this procedure here.<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Getting
Started with the Add-In<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>0.<span
style='mso-tab-count:1'>���� </span>Install Igor Pro or the Igor Pro demo.<span
style='mso-spacerun:yes'>� </span>If you are new to Igor, read �Volume I:<span
style='mso-spacerun:yes'>� </span><u><span style='color:blue'>Getting Started</span></u><span
style='color:black'>� of the Igor manual.<o:p></o:p></span></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman";
color:black'>1.<span style='mso-tab-count:1'>���� </span>Copy the
&quot;LoomisWood.ipf&quot; procedure file to the &quot;User Procedures&quot;
subfolder of the IGOR program folder.<span style='mso-spacerun:yes'>�
</span>The path for the &quot;User Procedures&quot; folder is typically &quot;C:\Program
Files\WaveMetrics\Igor Pro Folder\User Procedures&quot; for a Windows PC.<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman";
color:black'>2.<span style='mso-tab-count:1'>���� </span>Load/Create a line
list of your data in Igor.<span style='mso-spacerun:yes'>� </span>(A sample
experiment, �ethylene-lw.pxp�, which includes a spectrum and line list of
ethylene from HITRAN is provided with the add-in.)<span
style='mso-spacerun:yes'>� </span>The Add-In requires a listing of line-center
frequencies contained in a single 1D wave.<span style='mso-spacerun:yes'>�
</span>A listing of line intensities and/or line widths is optional.<span
style='mso-spacerun:yes'>� </span>If provided, these lists should be contained
in separate 1D waves.<span style='mso-spacerun:yes'>� </span>The intensity wave
should reflect absorption not transmission.<span style='mso-spacerun:yes'>�
</span>Also, the values in the intensity wave should all be positive.<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman";
color:black'>3.<span style='mso-tab-count:1'>���� </span>Open the procedure
window of your IGOR experiment.<span style='mso-spacerun:yes'>� </span>(Press
Ctrl-M.)<span style='mso-spacerun:yes'>� </span>Add the line <o:p></o:p></span></p>

<p class=CodeIndented>#include &quot;LoomisWood&quot; </p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>to the
top of the procedure window.<span style='mso-spacerun:yes'>� </span>This will
create the <b>Loomis-Wood</b> menu and make available all of the procedures
associated with this add-in.<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>4.<span
style='mso-tab-count:1'>���� </span>Create a Loomis-Wood data set by selecting <b>Loomis-Wood
| Data Sets | Create a New Loomis-Wood Data Set...</b>.<span
style='mso-spacerun:yes'>� </span>A dialog box will ask you for the name of the
new folder, then a second dialog box will ask you to select the waves of your
line listing.<span style='mso-spacerun:yes'>� </span>You can choose _constant_
if you do not have waves with line widths and/or line intensities.<span
style='mso-spacerun:yes'>� </span>You can work with multiple data sets in the
same Igor Experiment by creating multiple Loomis-Wood folders.<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>5.<span
style='mso-tab-count:1'>���� </span>A Loomis-Wood plot named &quot;Plot0&quot;
will be created automatically.<span style='mso-spacerun:yes'>� </span>You can
create multiple Loomis-Wood plots for the same Loomis-Wood folder by selecting <b>Loomis-Wood
| Plots | Create a New Loomis-Wood Plot...</b><span style='mso-spacerun:yes'>�
</span>A dialog box will ask you for the Loomis-Wood folder containing the data
for the plot, and a name for the subfolder that will contain data specific to
the new Loomis-Wood plot.<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>6.<span
style='mso-tab-count:1'>���� </span>In the new plot you will see the lines from
your data set represented as triangles.<span style='mso-spacerun:yes'>�
</span>The height and width of these shapes will reflect the relative line
intensities and the line widths of your data set.<span
style='mso-spacerun:yes'>� </span>There is a cursor that you can move from line
to line using the arrow keys.<span style='mso-spacerun:yes'>� </span>If you
click on a single line, the cursor will jump to that line. At the top of the
plot the details of the currently selected line are displayed.<span
style='mso-spacerun:yes'>� </span>You can use the PageUp and PageDn keys to
scroll the plot up or down to the region of interest.<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>7.<span
style='mso-tab-count:1'>���� </span>Edit the band constants to make the
Loomis-Wood plot match a series in your spectrum.<span
style='mso-spacerun:yes'>� </span>Do this by choosing <b>Loomis-Wood | Plots |
Edit Band Constants...</b>.<span style='mso-spacerun:yes'>� </span>Even if you
do not have precise constants for your molecule, you will need to provide
initial guesses for the band origin and rotational constants to get a
meaningful display.<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>8.<span
style='mso-tab-count:1'>���� </span>If your band constants are reasonable, you
should be able to identify a series as a vertical line of triangles in the
display area.<span style='mso-spacerun:yes'>� </span>You probably will need to
scroll to the region of interest using the Page keys if you have not already
done so.<span style='mso-spacerun:yes'>� </span>If you cannot identify a
series, you will need to go back to step 7 and refine your constants.<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>9.<span
style='mso-tab-count:1'>���� </span>The next step is to assign a series.<span
style='mso-spacerun:yes'>� </span>Begin by creating a new series by choosing <b>Loomis-Wood
| Series | Start a New Series...</b>.<span style='mso-spacerun:yes'>�
</span>You will be asked to name the series and choose a color for the
series.<span style='mso-spacerun:yes'>� </span>You can now assign the series by
selecting the lines to assign with the cursor and pressing the Enter key.<span
style='mso-spacerun:yes'>� </span>You can use the Delete key to remove an
incorrect assignment.<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>10.<span
style='mso-tab-count:1'>�� </span>Once you have a series assigned or partially
assigned, you can refine the rotational constants by performing a fit.<span
style='mso-spacerun:yes'>� </span>Do this by selecting <b>Loomis-Wood | Series
| Fit Current Series</b>.<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>11.<span
style='mso-tab-count:1'>�� </span>If the value of <i>m</i> is off
(corresponding to misassignment of <i>J</i>), then the constants produced by
the fit will be meaningless.<span style='mso-spacerun:yes'>� </span>To correct
this, choose <b>Loomis-Wood | Series | M-Shift Current Series�</b>.<span
style='mso-spacerun:yes'>� </span>You will be asked for a correction which will
be added to the current <i>m</i> values of the current series.<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>12.<span
style='mso-tab-count:1'>�� </span>Repeat steps 7-11 to assign additional
series.<span style='mso-spacerun:yes'>� </span>A complete list of assignments
can be created by selecting <b>Loomis-Wood | Data Sets | Extract Assignments...</b>.<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Working
with Band Heads<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>When a
series has a band head, the fitting function is no longer monotonic.<span
style='mso-spacerun:yes'>� </span>Since the add-in relies on inversion of the
fitting function to create the Loomis-Wood plot, this causes problems.<span
style='mso-spacerun:yes'>� </span>To deal with this problem, the add-in
calculates the regions of monotonicity of the fitting function.<span
style='mso-spacerun:yes'>� </span>Initially, the add-in uses the region of
monotonicity that includes <i>m</i>=0.<span style='mso-spacerun:yes'>�
</span>The <b>Loomis-Wood | Plots | Change Region...</b> command can be used to
select another region of monotonicity.<span style='mso-spacerun:yes'>�
</span>Using this command, both sides of a band head can be assigned.<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>Please
note that when a series has a band head, the width of each line will get
smaller as one approaches the band head.<span style='mso-spacerun:yes'>�
</span>This gives the Loomis-Wood plot a triangular appearance.<span
style='mso-spacerun:yes'>� </span>If you notice that a Loomis-Wood plot takes
on a triangular or trapezoidal appearance, you can be pretty sure that your
fitting function involves a band head.<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>Finally
note that as one works away from a band head the distance between lines can
become quite large.<span style='mso-spacerun:yes'>� </span>If this occurs the
Loomis-Wood plot may become unreadable.<span style='mso-spacerun:yes'>�
</span>To fix this, you should zoom in on the horizontal axis. <span
style='mso-spacerun:yes'>�</span>This cannot be done with the mouse (as the
add-in overrides mouse input), but can be done via the <b>Graph</b> menu or the
command line.<span style='mso-spacerun:yes'>� </span>Also, you may need to edit
the value of the FIVEMAX_PEAKS_PER_PLOT constant in the procedure file.<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>How it
Works<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>The
Loomis-Wood Add-In makes extensive use of Igor's data folders.<span
style='mso-spacerun:yes'>� </span>By using data folders, the add-in is able to
work with multiple data sets and plots within a single IGOR experiment
file.<span style='mso-spacerun:yes'>� </span>An additional advantage is that
the add-in will not accidentally conflict with the user�s other data.<span
style='mso-spacerun:yes'>� </span>Users unfamiliar with data folders in Igor
may want to skim the �<u><span style='color:blue'>Data Folders</span></u><span
style='color:black'>� chapter in the Igor manual.<span
style='mso-spacerun:yes'>� </span>The Add-In will create a folder named
�root:LW�.<span style='mso-spacerun:yes'>� </span>(The name of this folder can
be changed by modifying the BASE_FOLDER strconstant in the procedure
file.)<span style='mso-spacerun:yes'>� </span>Within this folder the Add-In
will create data set folder(s).<span style='mso-spacerun:yes'>� </span>All of
the data that the add-in needs for a data set is stored within the data set
folder.<o:p></o:p></span></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>The
Loomis-Wood data set folder:<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>When a
new Loomis-Wood data set folder is created, the following subfolders and waves
are created within that folder:<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'><span
style='mso-tab-count:1'>������� </span>Lines subfolder:<span
style='mso-spacerun:yes'>� </span>Frequency, Intensity, Width, and Assignments<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'><span
style='mso-tab-count:1'>������� </span>Series subfolder:<span
style='mso-spacerun:yes'>� </span>Name, Color, Order, Data, and Shape<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'><span
style='mso-tab-count:1'>������� </span>Band2Poly, Poly2Band, and
BandCoeffLabels , and Colors<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>The
waves in the Lines subfolder are copied from the line listing used to create
the Loomis-Wood folder.<span style='mso-spacerun:yes'>� </span>The waves will
be sorted by frequency. Assignments is a text wave reflecting assignments.<span
style='mso-spacerun:yes'>� </span>An unassigned line will have an empty string
in this wave, where as an assigned line will contain a semicolon-separated list
of assignments, e.g. &quot;1:-29,1,1,1,;3:10,1,1,1,&quot;.<span
style='mso-spacerun:yes'>� </span>The assignments in this wave are of the form
&quot;series:m,mask1,mask2,mask3,note&quot;, where <i>series</i> is the number
of the series, <i>m</i> is the polynomial index (related to <i>J</i>), and <i>mask1,
mask2, </i>and <i>mask3</i> are 1 or 0 depending on whether the line is used in
fitting or not, and <i>note</i> is a note about the assignment.<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>The
waves in the Series subfolder contain information on assigned series.<span
style='mso-spacerun:yes'>� </span>In particular, Data is a text wave with a
semicolon separated list of assignments.<span style='mso-spacerun:yes'>�
</span>The assignments in this wave are of the form
&quot;pnt:m,mask1,mask2,mask3,note&quot;, where <i>pnt</i> is the point number
in the Lines subfolder waves and <i>m</i>, <i>mask1, mask2, mask3,</i> and <i>note</i>
are the same as above.<span style='mso-spacerun:yes'>� </span>The first element
in these waves applies to unassigned lines.<span style='mso-spacerun:yes'>�
</span>This allows the color and shape of unassigned lines to be changed.<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>The
shape of a line is a hollow peak for Shape=0, a solid peak for Shape &gt; 0 and
invisible for Shape &lt; 0.<span style='mso-spacerun:yes'>� </span>Note that invisible
lines can still be selected with the cursor.<span style='mso-spacerun:yes'>�
</span>The color of a line is a number corresponding to RCG pair in the Colors
wave.<span style='mso-spacerun:yes'>� </span>If a line is assigned multiple
times, it will take its color and shape from the first series in the
Lines.Assignments string.<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>The
Colors wave is a three-column wave containing RGB values.<span
style='mso-spacerun:yes'>� </span>These values determine the colors associated
with the Series:Color wave.<span style='mso-spacerun:yes'>� </span>The labels
of this wave contain the names for these colors.<span
style='mso-spacerun:yes'>� </span>The first row in these waves is used by
default for unassigned lines.<span style='mso-spacerun:yes'>� </span>This wave
can quickly be edited by selecting Loomis-wood | Data Sets | Edit Colors...<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>The
Band2Poly and Poly2Band are the linear transformation matrices between the
polynomial coefficients and rotational constants. With these matrices, curve
fitting can be done using a polynomial and then the results transformed into
rotational constants.<span style='mso-spacerun:yes'>� </span>The default
constants used are nu0, B&quot;, deltaB, D&quot;, deltaD, H&quot; and
deltaH&quot;.<span style='mso-spacerun:yes'>� </span>If the user prefers a
different set of constants (such as nu0, B&quot;, B', D&quot;, D', H&quot;, H')
these two matrices can be edited.<span style='mso-spacerun:yes'>� </span>The
BandCoeffLabels text wave simply contains descriptions for the rotational
constants.<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>In
addition to the above waves, the Loomis-Wood folder may contain a Plots folder
(containing one or more plot folders), a SeriesFit folder, and/or an
Assignments folder.<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>The
add-in�s �assignment database� is comprised essentially of the Series:Data and
Lines:Assignments waves.<span style='mso-spacerun:yes'>� </span>By having the
assignment information recorded both �by line� and �by series�, the add-in can
quickly access assignment information.<span style='mso-spacerun:yes'>� </span>A
catch to this system is that any function that modifies assignments must change
both of these waves.<span style='mso-spacerun:yes'>� </span>If only one of
these two waves is changed, the SynchronizeSeries2Lines() or
SynchronizeLines2Series() functions can be used to recalculate the other wave.<o:p></o:p></span></p>

<p class=TopicBody><b><span style='mso-bidi-font-family:"Times New Roman"'>Warning:<span
style='mso-spacerun:yes'>� </span>It is very important not to manually edit the
waves in the Lines subfolder.<span style='mso-spacerun:yes'>� </span>Changing
these waves can scramble assignments!!!<o:p></o:p></span></b></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>If one
does need to edit the waves in the Lines subfolder, one should call <b>Loomis-wood
| Data Sets | Synchronize Series to Lines</b> when finished.<span
style='mso-spacerun:yes'>� </span>This routine will sort the waves and update
the Series folder so that the Loomis-Wood add-in continues to function.<span
style='mso-spacerun:yes'>� </span>Even with this function, functionality can be
lost if one is not careful.<span style='mso-spacerun:yes'>� </span>Make sure
your experiment is saved before trying this!!!<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>An
alternative to manually editing the Lines subfolder is the <b>Data Sets |
Update Line List...</b> command.<span style='mso-spacerun:yes'>� </span>This
command is provided for situations where the line list is not static.<span
style='mso-spacerun:yes'>� </span>For example, if the user wants to measure
lines as the assignment progresses you would call this function each time you
measured new lines.<o:p></o:p></span></p>

<p class=TopicBody><b><span style='mso-bidi-font-family:"Times New Roman"'>The
waves in the Series subfolder may be edited but should not be sorted or
redimensioned.<span style='mso-spacerun:yes'>� </span>The Data wave in the
Series subfolder should not be manually edited.<o:p></o:p></span></b></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>If one
does need to sort the waves in his folder, run the <b>Loomis-wood | Data Sets |
Synchronize Lines to Series</b> when finished.<span style='mso-spacerun:yes'>�
</span>Again make sure your experiment is saved before trying this!!!<o:p></o:p></span></p>

<p class=TopicBody><b><span style='mso-bidi-font-family:"Times New Roman"'>Band2Poly
and Poly2Band may be edited, but they must be matrix inverses of each other.<o:p></o:p></span></b></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>The
Loomis-Wood plot folder:<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>A
Loomis-Wood plot folder contains the waves used to render a Loomis-Wood
plot.<span style='mso-spacerun:yes'>� </span>In particular, each plot has a
wave named BandCoeff that contains the rotational constants used to create the
Loomis-Wood plot.<span style='mso-spacerun:yes'>� </span>A Loomis-Wood folder
can contain multiple Loomis-Wood folders so that different plots of the same
data set can be shown concurrently.<span style='mso-spacerun:yes'>� </span>Four
dependency formulas keep the data in the Loomis-Wood plot folder synchronized so
that the display is accurate:<o:p></o:p></span></p>

<p class=CodeIndented>BandCoeffUpdate := DoBandCoeffUpdate(BandCoeff)</p>

<p class=CodeIndented>TriangleUpdate := DoTriangleUpdate(Line_LWm,
::Lines:Assignments, ::Series:Color,</p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>::Series:Shape,
StartM, EndM, Zoom)</p>

<p class=CodeIndented>SeriesOrder := DoSeriesOrderUpdate(::Series:Order, CurrentSeries)</p>

<p class=CodeIndented>SeriesNameUpdate := DoSeriesNameUpdate(::Series:Name,
CurrentSeries)</p>

<p class=CodeIndented><o:p>&nbsp;</o:p></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>The use
of dependencies to keep the Loomis-Wood plot accurate is important, since the
data that trigger these dependencies are not necessarily changed
programmatically.<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>DoBandCoeffUpdate
calculates Line_LWm and Line_DF (delta frequency) whenever BandCoeff
changes.<span style='mso-spacerun:yes'>� </span>The Loomis-Wood plot is
essentially a scatter plot of Line_LWm vs. Line_DF.<span
style='mso-spacerun:yes'>� </span>Since BandCoeff changes rather infrequently,
Line_LWm and Line_DF can be calculated completely whenever BandCoeff changes,
without performance degradation.<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>However,
in order to get the triangle line shape that reflects intensity, width, and
assignment in the Loomis-Wood plot, we actually plot Triangle_Yup,
Triangle_Ydown vs Triangle_X, with the mode of Triangle_Yup set to Fill to
Next.<span style='mso-spacerun:yes'>� </span>The Triangle_ waves (including
Triangle_Color) are calculated by DoTriangleUpdate.<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>DoTriangleUpdate
executes whenever the ::Lines:Assignments wave is changed.<span
style='mso-spacerun:yes'>� </span>This occurs whenever an assignment is made,
changed or removed.<span style='mso-spacerun:yes'>� </span>The response of
making an assignment must be rapid, hence this function must execute as quickly
as possible.<span style='mso-spacerun:yes'>� </span>Thus, the Triangle_ waves
do not contain information to render the entire line list, but just the portion
of the line list that is to be displayed.<span style='mso-spacerun:yes'>�
</span>Furthermore, the size of these waves is fixed at
FIVEMAX_PEAKS_PER_PLOT.<span style='mso-spacerun:yes'>� </span>Redimensioning
the Triangle_ waves takes too much time.<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>The
DoSeriesOrderUpdate() function updates the SeriesOrder variable whenever the
user changes the Series:Order wave or changes the current series.<span
style='mso-spacerun:yes'>� </span>This is done so that the order SetVariable
control of the Loomis-Wood plot can reference a variable (SeriesOrder) instead
of an element of a wave (::Series:Order[CurrentSeries]).<span
style='mso-spacerun:yes'>� </span><o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>The
DoSeriesNameUpdate() function updates the current series popup menu whenever
the user changes the Series:Name wave or changes the current series.<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Useful
Data in the Loomis-Wood plot folder:<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>There
are several waves and variables created in the Loomis-Wood plot folder that may
be useful to the user.<span style='mso-spacerun:yes'>� </span>In particular,
the user may wish to create dependencies to these variables to keep a graph of
the original spectrum synchronized with a Loomis-Wood plot.<span
style='mso-spacerun:yes'>� </span>(See the chapter �<u><span style='color:blue'>Dependencies</span></u><span
style='color:black'>� in the Igor manual for more information.)<span
style='mso-spacerun:yes'>� </span>Please note that these variables should be
considered �read-only.�<o:p></o:p></span></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman";
color:black'>The following list is the data most useful for creating other
displays.<span style='mso-spacerun:yes'>� </span>The data in the SeriesFit and
Assignments folders (described below) will also be useful.<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'>startNu,
endNu<span style='mso-tab-count:1'>���������������� </span>The starting and
ending frequency of the Loomis-Wood plot.<span style='mso-spacerun:yes'>�
</span>Note that endNu &lt; startNu is possible when d</span><span
style='font-family:Symbol;mso-bidi-font-family:Symbol'>n</span>/d<i>m</i> &lt;
0.</p>

<p class=KeyList>startM, endM<span style='mso-tab-count:1'>������������������� </span>The
starting and ending <i>m</i> of the Loomis-Wood plot.</p>

<p class=KeyList>startP, endP<span style='mso-tab-count:1'>�������������������� </span>The
start and ending point numbers of the lines drawn in the Loomis-Wood plot.<span
style='mso-spacerun:yes'>� </span>Note that the number of lines drawn is
limited by the constant FIVEMAX_PEAKS_PER_PLOT.</p>

<p class=KeyList>minNu, maxNu<span style='mso-tab-count:1'>����������������� </span>The
current frequency limits of monotonicity of the fitting polynomial.<span
style='mso-spacerun:yes'>� </span>Note that if d<span style='font-family:Symbol;
mso-bidi-font-family:Symbol'>n</span>/d<i>m</i> &lt; 0, minNu corresponds to
maxM and maxNu corresponds to minNu.</p>

<p class=KeyList>minM, maxM<span style='mso-tab-count:1'>������������������� </span>The
current <i>m</i> limits of monotonicity of the polynomial.</p>

<p class=KeyList>minP, maxP<span style='mso-tab-count:1'>�������������������� </span>The
first and last point number (from the Lines data folder) that are within the
limits of monotonicity.</p>

<p class=KeyList>lwCursor_P<span style='mso-tab-count:1'>��������������������� </span>The
point number of the line selected by the Loomis-wood cursor.</p>

<p class=KeyList>lwCursor_M<span style='mso-tab-count:1'>��������������������� </span>The
<i>m</i> value of the line selected by the Loomis-wood cursor.</p>

<p class=KeyList>lwCursor_Nu<span style='mso-tab-count:1'>�������������������� </span>The
frequency of the line selected by the Loomis-wood cursor.</p>

<p class=KeyList>lwCursor_dNu<span style='mso-tab-count:1'>������������������ </span>The
residual of the line selected by the Loomis-wood cursor.<span
style='mso-spacerun:yes'>� </span>(this is the horizontal axis of the
Loomis-Wood plot.)</p>

<p class=KeyList>lwCursor_I<span style='mso-tab-count:1'>����������������������� </span>The
intensity of the line selected by the Loomis-wood cursor.</p>

<p class=KeyList>lwCursor_W<span style='mso-tab-count:1'>��������������������� </span>The
width of the line selected by the Loomis-wood cursor.</p>

<p class=KeyList>CombX<span style='mso-tab-count:1'>��������������������������� </span>The
frequency values of the fitting polynomial.<span style='mso-spacerun:yes'>�
</span>Append CombY vs CombX to a graph of the spectrum and set the mode to
sticks to zero to show the fitting polynomial on the original spectrum</p>

<p class=KeyList>CombY<span style='mso-tab-count:1'>��������������������������� </span>A
wave of ones of the same length as CombX.</p>

<p class=KeyList>CombM<span style='mso-tab-count:1'>�������������������������� </span>The
<i>m</i> values corresponding do CombX.</p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>The
SeriesFit folder:<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>The
SeriesFit folder is where data for a series is extracted for the <b>Series |
View Current Series�</b> and <b>Series | Fit Current Series</b> commands.<span
style='mso-spacerun:yes'>� </span>In this folder, you will find the following
waves:<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'>Frequency<span
style='mso-tab-count:1'>����������������������� </span>the frequency of the
line.<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'>Intensity<span
style='mso-tab-count:1'>�������������������������� </span>the intensity of the
line.<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'>Width<span
style='mso-tab-count:1'>������������������������������ </span>the width of the
line.<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'>theM<span
style='mso-tab-count:1'>������������������������������� </span>the y-axis of
the Loomis-Wood plot<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'>Select<span
style='mso-tab-count:1'>����������������������������� </span>a flag indicating
whether this line will used in fitting.<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'>Residual<span
style='mso-tab-count:1'>������������������������� </span>the x-axis of the
Loomis-Wood plot<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>If the
series is fit, the following waves will contain the results of the fit:<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'>M_Correl<span
style='mso-tab-count:1'>������������������������� </span>the correlation matrix<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'>M_Covar<span
style='mso-tab-count:1'>������������������������� </span>the covariance matrix<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'>W_Coef<span
style='mso-tab-count:1'>�������������������������� </span>the coefficients of
the fit<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'>W_Sigma<span
style='mso-tab-count:1'>������������������������ </span>the error in the
coefficients of the fit<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'><o:p>&nbsp;</o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>Note
the data in this folder is not synchronized with the Loomis-Wood data set.<span
style='mso-spacerun:yes'>� </span>Editing the data in this folder will not
assign , unassign, mask, or unmask lines in the data set.<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>The
Assignments folder:<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>The
Assignments folder is where the data from the <b>Data Sets | Extract
Assignments�</b> command is collected.<span style='mso-spacerun:yes'>�
</span>(The waves in this folder must be updated manually using the Extract
Assignments command.)<span style='mso-spacerun:yes'>� </span>When the user
selects Extract Assignments, a dialog will ask for an Assignment Function.<span
style='mso-spacerun:yes'>� </span>This function is user supplied and must use
the following prototype:<o:p></o:p></span></p>

<p class=CodeIndented>function LWLabelProto(a, s)</p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>STRUCT
AssignmentListStruct &amp;a</p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>STRUCT
SeriesStruct &amp;s</p>

<p class=CodeIndented>end</p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>By
implementing this function, the Extract Assignments command can generate a
complete set of quantum numbers compatible with other fitting programs such as
CALFIT.<span style='mso-spacerun:yes'>� </span>Some example code is: <o:p></o:p></span></p>

<p class=CodeIndented>function ProlateAsym(a, s)</p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>STRUCT
AssignmentListStruct &amp;a</p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>STRUCT SeriesStruct
&amp;s</p>

<p class=CodeIndented><span style='mso-tab-count:2'>������ </span></p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>variable i, imax,
freq, weight</p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>imax =
numpnts(a.Frequency)</p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span></p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>string DF =
GetDataFolder(1)</p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>SetDataFolder
GetWavesDataFolder(a.Frequency, 1)</p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>Make/T/O/N=(imax)
QN_US, QN_LS</p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>SetDataFolder DF</p>

<p class=CodeIndented><o:p>&nbsp;</o:p></p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>string QN</p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>for (i=0 ; i &lt;
imax ; i += 1)</p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span><span
style='mso-tab-count:1'>�� </span>freq = a.Frequency[i]</p>

<p class=CodeIndented><span style='mso-tab-count:2'>������ </span>weight =
a.LSmask[i] &amp;&amp; a.USmask[i]</p>

<p class=CodeIndented><span style='mso-tab-count:2'>������ </span>QN =
ProlateAsymQN(s.Name[a.SeriesIndex[i]], a.theM[i])</p>

<p class=CodeIndented><span style='mso-tab-count:2'>������ </span>QN_US[i] =
QN[0,11]</p>

<p class=CodeIndented><span style='mso-tab-count:2'>������ </span>QN_LS[i] =
QN[12,23]</p>

<p class=CodeIndented><span style='mso-tab-count:2'>������ </span>sprintf QN,
&quot;%s %14.6f %14.6f %15.6f&quot;, QN, freq, -0.001, weight</p>

<p class=CodeIndented><span style='mso-tab-count:2'>������ </span>a.Assignment[i]
= QN</p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>endfor</p>

<p class=CodeIndented>end</p>

<p class=CodeIndented><o:p>&nbsp;</o:p></p>

<p class=CodeIndented>Function/S ProlateAsymQN(name, m)</p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>string name</p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>variable m</p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span></p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>if (
ItemsInList(name,&quot;,&quot;) != 6 )</p>

<p class=CodeIndented><span style='mso-tab-count:2'>������ </span>return
&quot;&quot;</p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>endif</p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span></p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>string dKa =
UpperStr(StringFromList(1,name,&quot;,&quot;))</p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>string dJ =
UpperStr(StringFromList(2,name,&quot;,&quot;))</p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>variable Ka =
round(str2Num(StringFromList(3,name,&quot;,&quot;)))</p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>string SR =
UpperStr(StringFromList(4,name,&quot;,&quot;))</p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>variable S =
round(str2num (StringFromList(5,name,&quot;,&quot;)))!=0</p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span></p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>if (Ka &lt; 0)</p>

<p class=CodeIndented><span style='mso-tab-count:2'>������ </span>return
&quot;&quot;</p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>elseif (Ka==0
&amp;&amp; S != 0)</p>

<p class=CodeIndented><span style='mso-tab-count:2'>������ </span>return
&quot;&quot;</p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>endif</p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span></p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>variable Ka2 = Ka
+ char2num(dKa) - char2num(&quot;Q&quot;)</p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>variable J, J2</p>

<p class=CodeIndented><o:p>&nbsp;</o:p></p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>strswitch (dJ)</p>

<p class=CodeIndented><span style='mso-tab-count:2'>������ </span>// Treat P
and R the same so that P and R lines can be fir to same polynomial </p>

<p class=CodeIndented><span style='mso-tab-count:2'>������ </span>case
&quot;P&quot;:</p>

<p class=CodeIndented><span style='mso-tab-count:2'>������ </span>case
&quot;R&quot;:</p>

<p class=CodeIndented><span style='mso-tab-count:3'>��������� </span>if (M &lt;
0)</p>

<p class=CodeIndented><span style='mso-tab-count:4'>������������� </span>J = -M</p>

<p class=CodeIndented><span style='mso-tab-count:4'>������������� </span>J2 =
J-1</p>

<p class=CodeIndented><span style='mso-tab-count:3'>��������� </span>else</p>

<p class=CodeIndented><span style='mso-tab-count:4'>������������� </span>J =
M-1</p>

<p class=CodeIndented><span style='mso-tab-count:4'>������������� </span>J2 =
J+1</p>

<p class=CodeIndented><span style='mso-tab-count:3'>��������� </span>endif</p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span><span
style='mso-tab-count:2'>������ </span>break</p>

<p class=CodeIndented><span style='mso-tab-count:2'>������ </span>case
&quot;Q&quot;:</p>

<p class=CodeIndented><span style='mso-tab-count:3'>��������� </span>J = abs(M)</p>

<p class=CodeIndented><span style='mso-tab-count:3'>��������� </span>J2 = J</p>

<p class=CodeIndented><span style='mso-tab-count:3'>��������� </span>break</p>

<p class=CodeIndented><span style='mso-tab-count:2'>������ </span>default:</p>

<p class=CodeIndented><span style='mso-tab-count:3'>��������� </span>return
&quot;&quot;</p>

<p class=CodeIndented><span style='mso-tab-count:3'>��������� </span>break</p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>endswitch</p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span></p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>if (Ka &gt; J ||
Ka2 &gt; J2)</p>

<p class=CodeIndented><span style='mso-tab-count:2'>������ </span>return
&quot;&quot;</p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>endif</p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span></p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>Variable S2 =
abs(S+J2-J)</p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>strswitch (SR)</p>

<p class=CodeIndented><span style='mso-tab-count:2'>������ </span>case
&quot;A&quot;:</p>

<p class=CodeIndented><span style='mso-tab-count:3'>��������� </span>if (
mod(abs(Ka2 - Ka), 2) != 0)</p>

<p class=CodeIndented><span style='mso-tab-count:4'>������������� </span>return
&quot;&quot;</p>

<p class=CodeIndented><span style='mso-tab-count:3'>��������� </span>endif</p>

<p class=CodeIndented><span style='mso-tab-count:3'>��������� </span>S2=mod(S2+1,2)</p>

<p class=CodeIndented><span style='mso-tab-count:3'>��������� </span>break</p>

<p class=CodeIndented><span style='mso-tab-count:2'>������ </span>case
&quot;B&quot;:</p>

<p class=CodeIndented><span style='mso-tab-count:3'>��������� </span>if (
mod(abs(Ka2 - Ka), 2) != 1)</p>

<p class=CodeIndented><span style='mso-tab-count:4'>������������� </span>return
&quot;&quot;</p>

<p class=CodeIndented><span style='mso-tab-count:3'>��������� </span>endif</p>

<p class=CodeIndented><span style='mso-tab-count:3'>��������� </span>S2=mod(S2,2)</p>

<p class=CodeIndented><span style='mso-tab-count:3'>��������� </span>break</p>

<p class=CodeIndented><span style='mso-tab-count:2'>������ </span>case
&quot;C&quot;:</p>

<p class=CodeIndented><span style='mso-tab-count:3'>��������� </span>if (
mod(abs(Ka2 - Ka), 2) != 1)</p>

<p class=CodeIndented><span style='mso-tab-count:4'>������������� </span>return
&quot;&quot;</p>

<p class=CodeIndented><span style='mso-tab-count:3'>��������� </span>endif</p>

<p class=CodeIndented><span style='mso-tab-count:3'>��������� </span>S2=mod(S2+1,2)</p>

<p class=CodeIndented><span style='mso-tab-count:3'>��������� </span>break</p>

<p class=CodeIndented><span style='mso-tab-count:2'>������ </span>default:</p>

<p class=CodeIndented><span style='mso-tab-count:3'>��������� </span>S2 = NaN</p>

<p class=CodeIndented><span style='mso-tab-count:3'>��������� </span>break</p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>endswitch<span
style='mso-tab-count:1'> </span></p>

<p class=CodeIndented><o:p>&nbsp;</o:p></p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>if (Ka2==0
&amp;&amp; S2 != 0)</p>

<p class=CodeIndented><span style='mso-tab-count:2'>������ </span>return
&quot;&quot;</p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>endif</p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span></p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>Variable Kc = J -
Ka + S</p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>Variable Kc2 = J2
- Ka2 + S2</p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span></p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>String res</p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>sprintf res,
&quot;%3d%3d%3d<span style='mso-spacerun:yes'>� </span>1%3d%3d%3d<span
style='mso-spacerun:yes'>� </span>0<span style='mso-spacerun:yes'>�����������
</span>&quot;, J2, Ka2, Kc2, J, Ka, Kc</p>

<p class=CodeIndented><span style='mso-tab-count:1'>�� </span>return res</p>

<p class=CodeIndented>End</p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'><o:p>&nbsp;</o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>This
above code uses the Series Name wave to assign prolate asymmetric top quantum
numbers.<span style='mso-spacerun:yes'>� </span>The series name should be a
list of the form <i>name, </i></span><i><span style='font-family:Symbol;
mso-bidi-font-family:Symbol'>D</span>J, </i><i><span style='font-family:Symbol;
mso-bidi-font-family:Symbol'>D</span>K, Ka, SR, s</i> where <i><span
style='font-family:Symbol;mso-bidi-font-family:Symbol'>D</span>J</i> is �P�,
�Q�, or �R�, <i><span style='font-family:Symbol;mso-bidi-font-family:Symbol'>D</span>K</i>
is �P�, �Q�, or �R�, etc., SR is �A�, �B�, or �C�, and <i>s</i> = <i>Ka</i> + <i>Kc</i>
� <i>J</i>.<span style='mso-spacerun:yes'>� </span>Using the above code as an
example, it should be fairly easy to create an assignment function for any type
of molecule.</p>

<p class=TopicBody>Note that the data in this folder is not synchronized with
the Loomis-Wood data set.<span style='mso-spacerun:yes'>� </span>Editing the
data in this folder will not assign , unassign, mask, or unmask lines in the
data set.</p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Troubleshooting<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>If you
have problems with the add-in, please try the following.<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>1.<span
style='mso-tab-count:1'>���� </span>If one of the add-in routines aborts, Igor
may be left in one of the Loomis-Wood data folders.<span
style='mso-spacerun:yes'>� </span>The telltale symptom of this problem is
&quot;missing&quot; data.<span style='mso-spacerun:yes'>� </span>You can check
the current data folder using the Data Browser, or simply change the datafolder
by typing:<o:p></o:p></span></p>

<p class=CodeIndented>SetDataFolder root:</p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>in the
Command Window.<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>2.<span
style='mso-tab-count:1'>���� </span>If something goes wrong with the
Loomis-Wood display, simply close the plot, then Create a New Loomis-Wood Plot
from the Loomis-Wood menu.<span style='mso-spacerun:yes'>� </span>This can be
done without losing any assignments, and will correct any problems created by
bad constants or accidental user modifications of the graph or underling dependancies.<span
style='mso-spacerun:yes'>� </span>(Often, you can reuse the existing plot
folder name during this fix without any problems.)<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>3.<span
style='mso-tab-count:1'>���� </span>The Loomis-Wood add-in will only display
lines within a single monotonic region of the fit polynomial.<span
style='mso-spacerun:yes'>� </span>(See <u><span style='color:blue'>Working with
Band Heads</span></u><span style='color:black'>.)<o:p></o:p></span></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman";
color:black'>4.<span style='mso-tab-count:1'>���� </span>Most of the menu items
in the LoomisWood menu are only available if the top graph is a Loomis-Wood
plot.<span style='mso-spacerun:yes'>� </span>If a menu item is disabled, make
sure you have a Loomis-Wood plot as the top graph.<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman";
color:black'>5.<span style='mso-tab-count:1'>���� </span>If the Loomis-Wood
plot does not respond to keystrokes, check to make sure the plot is the active
window.<span style='mso-spacerun:yes'>� </span>You may also find that the plot
only responds to keystrokes when the mouse cursor is over the plot area.<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Menu/Command
Reference<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Data
Sets | Create a New Loomis-Wood Data Set...<span style='mso-tab-count:2'>������������������������������ </span>NewLWDataSet()<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>This
command creates a new Loomis-Wood data set.<span style='mso-spacerun:yes'>�
</span>The user will be asked for a folder name, then for a wave containing
line frequencies and optional intensities and widths.<span
style='mso-spacerun:yes'>� </span>These waves will be used to create a new data
set folder and a default plot named �Plot0� will be created.<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Data Sets
| Delete a Loomis-Wood Data Set...<span style='mso-tab-count:2'>�������������������������������������� </span>DeleteLWDataSet(&quot;&quot;)<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>This
command will delete an existing Loomis-Wood data set.<span
style='mso-spacerun:yes'>� </span>With a null (��) argument a dialog will ask
for the name of the folder.<span style='mso-spacerun:yes'>� </span>Otherwise,
the argument should be the path-free name of the folder to delete.<span
style='mso-spacerun:yes'>� </span>Before calling this command, all plot windows
should be closed.<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Data
Sets | View Line List...<span style='mso-tab-count:2'>����������������������������������������������������������������� </span>ViewLineList()<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>This
command will create a table of the waves in the Lines subfolder of the data set
associated with the top LW plot.<span style='mso-spacerun:yes'>� </span>This
data should not be manually edited, but if editing is necessary, call the <b>Data
Sets | Synchronize Series to Lines</b> command when finished.<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Data
Sets | View Series List...<span style='mso-tab-count:1'>�������������������������������������� </span>(F8)<span
style='mso-tab-count:1'>����������������� </span>ViewSeriesList()<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>This
command will create a table of the waves in the Series subfolder of the data
set associated with the top LW plot.<span style='mso-spacerun:yes'>�
</span>This data can be manually edited, but if sorting or reordering is
neccessary, call the <b>Data Sets | Synchronize Lines to Series</b> command
when finished.<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Data
Sets | Fit All Series<span style='mso-tab-count:1'>���������������������������������������������� </span>(Shift-F9)<span
style='mso-tab-count:1'>��������� </span>FitAll()<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>This
command will fit each series in the Data Set and create a report in a notebook
named LWresults.<span style='mso-spacerun:yes'>� </span>The Command also
creates a two-dimensional wave of the band coefficients in the Series folder
named BandCoeffTable.<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Data
Sets | Extract Assignments...<span style='mso-tab-count:1'>������������������������������� </span>(F9)<span
style='mso-tab-count:1'>����������������� </span>ExtractAssignments(&quot;&quot;)<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>This
command will create a table containing a listing of the assigned lines in the
data set.<span style='mso-spacerun:yes'>� </span>With a null (��) argument, the
user will be asked for an optional assignment function.<span
style='mso-spacerun:yes'>� </span>This function can be used to quickly convert
the add-ins listing to a form suitable for a separate fitting program.<span
style='mso-spacerun:yes'>� </span>See �The Assignments folder� above.<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>Please
note that the data in the resulting table is not synchronized with the master
line list.<span style='mso-spacerun:yes'>� </span>.<span
style='mso-spacerun:yes'>� </span>Editing the data in this table will not
assign , unassign, mask, or unmask lines in the data set.<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Data
Sets | Update Line List...<span style='mso-tab-count:2'>������������������������������������������������������������� </span>UpdateLinesFolder(NaN)<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>This
command is designed to be run when your line-listing as been modified outside
of the add-in.<span style='mso-spacerun:yes'>� </span>For example, if you
re-measure lines or add lines to the line listing, you should call this
function.<span style='mso-spacerun:yes'>� </span>You can also call this
function to add or remove widths and/or intensities from the data-folder.<span
style='mso-spacerun:yes'>� </span>(Backup your data first, as assignments can
be lost.)<span style='mso-spacerun:yes'>� </span>With NaN as an argument, the
user will be asked for a tolerance.<span style='mso-spacerun:yes'>� </span>If
lines have only been added ore removed, then tolerance can be 0.<span
style='mso-spacerun:yes'>� </span>If the line centers have changed however,
tolerance should be larger than zero.<span style='mso-spacerun:yes'>� </span>If
a line in the new line listing is within +/- tolerance of the old listing, then
the two lines are considered the same, and the new line will inherit the
assignments of the old line.<span style='mso-spacerun:yes'>� </span>If there
are multiple new lines within +/- tolerance of the old line, the closest new
line will inherit the assignments of the old line.<span
style='mso-spacerun:yes'>� </span>If no line in the new listing is within +/-
tolerance of an assigned line in the old listing, then a warning will be
printed to the history window.<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>The
first thing this command does is duplicate the Lines folder as LinesBak.<span
style='mso-spacerun:yes'>� </span>Thus, if you have problems, you can copy the
data from the LinesBak subfolder back to the Lines subfolder.<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Data
Sets | Synchronize Series to Lines<span style='mso-tab-count:2'>���������������������������������������������� </span>SynchronizeLines2Series()<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>This
command sorts the waves in the Lines subfolder by Lines:Frequency, then
recreates the Series:Data wave from the Lines:Assignments wave.<span
style='mso-spacerun:yes'>� </span>This is necessary when the waves in the Lines
folder are manually edited.<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Data
Sets | Synchronize Lines to Series<span style='mso-tab-count:2'>���������������������������������������������� </span>SynchronizeSeries2Lines()<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>This
command recreates the Lines:Assignments wave from the Series:Data wave.<span
style='mso-spacerun:yes'>� </span>This is necessary when the waves in the Series
folder are manually sorted, redimensioned or otherwise reordered.<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Data
Sets | Edit Colors<span style='mso-tab-count:2'>������������������������������������������������������������������������ </span>EditColors()<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>This
command creates a table containing the Colors wave.<span
style='mso-spacerun:yes'>� </span>This table can be manually edited as needed.<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'><o:p>&nbsp;</o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Plots |
Create a New Loomis-Wood Plot...<span style='mso-tab-count:2'>������������������������������������������� </span>NewLWPlot(&quot;&quot;,&quot;&quot;)<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>This
command creates another Loomis-Wood plot.<span style='mso-spacerun:yes'>�
</span>With null arguments, the user will be asked for an existing data set and
a name for the new plot.<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Plots |
Change M-axis scaling...<span style='mso-tab-count:1'>���������������������������������� </span>(F11)<span
style='mso-tab-count:1'>���������������� </span>ChangeRange(0,0)<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>This
command can be used to change the y-axis scaling of a Loomis-Wood plot.<span
style='mso-spacerun:yes'>� </span>With 0,0 as the arguments, the user will be
asked for the new minimum and maximum values for <i>m</i>.<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Plots |
Edit Band Constants...<span style='mso-tab-count:1'>������������������������������������� </span>(F12)<span
style='mso-tab-count:1'>���������������� </span>EditBandConstants()<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>This
command allows the user to manually edit the constants used to draw the lop
Loomis-Wood plot.<span style='mso-spacerun:yes'>� </span>This is necessary in
the beginning of an assignment to get the assignment started.<span
style='mso-spacerun:yes'>� </span>After the assignment is started, one usually
adjusts the constants via <b>Series | Fit Current Series</b>.<span
style='mso-spacerun:yes'>� </span>The change can be undone with <b>Series |
Undo Last Fit</b>.<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Plots |
Change Region...<span style='mso-tab-count:1'>��������������������������������������������� </span>(Shift-F12)<span
style='mso-tab-count:1'>������� </span>ChangeRegion()<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>This
command allows the user to select which monotonic region the plot
displays.<span style='mso-spacerun:yes'>� </span>This is necessary when working
with series that involve band heads.<span style='mso-spacerun:yes'>� </span>See
<u><span style='color:blue'>Working with Band Heads</span></u><span
style='color:black'> for more details.<o:p></o:p></span></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'><o:p>&nbsp;</o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Series |
Start a New Series...<span style='mso-tab-count:1'>��������������������������������������� </span>(F2)<span
style='mso-tab-count:1'>����������������� </span>AddSeries()<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>Starts
a new series.<span style='mso-spacerun:yes'>� </span>The user will be asked for
a name and color for the new series.<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Series |
Select a Series�<span style='mso-tab-count:1'>�������������������������������������������� </span>(F3)<span
style='mso-tab-count:1'>����������������� </span>SelectSeries()<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>Changes
the current series.<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Series |
Delete a Series�<span style='mso-tab-count:1'>�������������������������������������������� </span>(F4)<span
style='mso-tab-count:1'>����������������� </span>DeleteSeries()<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>Deletes
a series.<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Series |
Fit Current Series<span style='mso-tab-count:1'>������������������������������������������� </span>(F5)<span
style='mso-tab-count:1'>����������������� </span>Print
FitSeries(GetCurrentSeriesNumber())<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>Fits
the current series.<span style='mso-spacerun:yes'>� </span>Can be undone with <b>Series
| Undo Last Fit</b>.<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Series |
Undo Last Fit<span style='mso-tab-count:1'>�������������������������������������������������� </span>(Shift-F5)<span
style='mso-tab-count:1'>��������� </span>UndoFit()<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>Reverts
the constants used in the topmost Loomis-Wood plot to their<span
style='mso-spacerun:yes'>� </span>previous values.<span
style='mso-spacerun:yes'>� </span>(The Undo level is only one.)<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Series |
M-Shift Current Series<span style='mso-tab-count:1'>������������������������������������ </span>(F6)<span
style='mso-tab-count:1'>����������������� </span>ShiftSeries(GetCurrentSeriesNumber(),0,1)<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>This
command adjusts the assignment of <i>m</i> for the current series and adjusts
the current constants to reflect this change.<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Series |
View Current Series�<span style='mso-tab-count:1'>������������������������������������ </span>(F7)<span
style='mso-tab-count:1'>����������������� </span>ViewSeries(GetCurrentSeriesNumber())<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>This
command creates a table containing the current series.<span
style='mso-spacerun:yes'>� </span>This table is not updated when new
assignments are made, but is updated upon a fit.<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>Please
note that the data in the resulting table is not synchronized with the master
line list.<span style='mso-spacerun:yes'>� </span>.<span
style='mso-spacerun:yes'>� </span>Editing the data in this table will not
assign , unassign, mask, or unmask lines in the data set.<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Series |
View Series List...<span style='mso-tab-count:1'>������������������������������������������ </span>(F8)<span
style='mso-tab-count:1'>����������������� </span>ViewSeriesList()<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>Same as
<b>Data Sets | View Series List...</b>.<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'><o:p>&nbsp;</o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Keyboard
Reference<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>F2<span
style='mso-tab-count:1'>������������������������������������������������������������������������������� </span>Start
a New Series...<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>F3<span
style='mso-tab-count:1'>������������������������������������������������������������������������������� </span>Select
a Series�<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>F4<span
style='mso-tab-count:1'>������������������������������������������������������������������������������� </span>Delete
a Series�<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>F5<span
style='mso-tab-count:1'>������������������������������������������������������������������������������� </span>Fit
Current Series<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Shift-F5<span
style='mso-tab-count:1'>����������������������������������������������������������������������� </span>Undo
Last Fit<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>F6<span
style='mso-tab-count:1'>������������������������������������������������������������������������������� </span>M-Shift
Current Series<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>F7<span
style='mso-tab-count:1'>������������������������������������������������������������������������������� </span>View
Current Series�<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>F8<span
style='mso-tab-count:1'>������������������������������������������������������������������������������� </span>View
Series List...<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>F9<span
style='mso-tab-count:1'>������������������������������������������������������������������������������� </span>Extract
Assignments...<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>F11<span
style='mso-tab-count:1'>������������������������������������������������������������������������������ </span>Change
M-axis Scaling...<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>F12<span
style='mso-tab-count:1'>������������������������������������������������������������������������������ </span>Edit
Band Constants...<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>The
actions corresponding to the function keys are described above.<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Enter<span
style='mso-tab-count:1'>��������������������������������������������������������������������������� </span>Assign
Line<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>Enter
assigns the current line to the current series.<span style='mso-spacerun:yes'>�
</span>There is no menu command corresponding to this action.<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Delete (Ctrl-Backspace)<span
style='mso-tab-count:1'>������������������������������������������������ </span>Unassign
Line (From Current Series)<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>Delete
unassigns the current line from the current series.<span
style='mso-spacerun:yes'>� </span>There is no menu command corresponding to
this action.<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Backspace<span
style='mso-tab-count:1'>������������������������������������������������������������������� </span>Reserved<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Home<span
style='mso-tab-count:1'>�������������������������������������������������������������������������� </span>Reserved<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>End<span
style='mso-tab-count:1'>����������������������������������������������������������������������������� </span>Reserved<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Up<span
style='mso-tab-count:1'>������������������������������������������������������������������������������� </span>Move
Cursor Up<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Down<span
style='mso-tab-count:1'>�������������������������������������������������������������������������� </span>Move
Cursor Down<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Left<span
style='mso-tab-count:1'>����������������������������������������������������������������������������� </span>Move
Cursor Left<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Right<span
style='mso-tab-count:1'>��������������������������������������������������������������������������� </span>Move
Cursor Right<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>The
cursor can also be moved by single-clicking a line with the mouse.<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>PageUp/PageDn<span
style='mso-tab-count:1'>���������������������������������������������������������� </span>Scroll
Up/Down<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>The
graph can also be scrolled using the <b>Change M-axis Scaling...</b> (F7)
command.<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>K<span
style='mso-tab-count:1'>��������������������������������������������������������������������������������� </span>Toggle
Loomis-Wood Fit Flag<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>U<span
style='mso-tab-count:1'>��������������������������������������������������������������������������������� </span>Toggle
Upper State Fit Flag<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>L<span
style='mso-tab-count:1'>��������������������������������������������������������������������������������� </span>Toggle
Lower State Fit Flag<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>The
Loomis-Wood fit Flag determines whether the add-in uses a line in a fit or
not.<span style='mso-spacerun:yes'>� </span>The other two fit flags are
provided for external use.<span style='mso-spacerun:yes'>� </span>There are no
menu commands corresponding to K, U, or L but the flags can also be toggled
with the listbox in the control bar of a Loomis-Wood plot.<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Loomis-Wood
Toolbar<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'><!--[if gte vml 1]><v:shapetype
 id="_x0000_t75" coordsize="21600,21600" o:spt="75" o:preferrelative="t"
 path="m@4@5l@4@11@9@11@9@5xe" filled="f" stroked="f">
 <v:stroke joinstyle="miter"/>
 <v:formulas>
  <v:f eqn="if lineDrawn pixelLineWidth 0"/>
  <v:f eqn="sum @0 1 0"/>
  <v:f eqn="sum 0 0 @1"/>
  <v:f eqn="prod @2 1 2"/>
  <v:f eqn="prod @3 21600 pixelWidth"/>
  <v:f eqn="prod @3 21600 pixelHeight"/>
  <v:f eqn="sum @0 0 1"/>
  <v:f eqn="prod @6 1 2"/>
  <v:f eqn="prod @7 21600 pixelWidth"/>
  <v:f eqn="sum @8 21600 0"/>
  <v:f eqn="prod @7 21600 pixelHeight"/>
  <v:f eqn="sum @10 21600 0"/>
 </v:formulas>
 <v:path o:extrusionok="f" gradientshapeok="t" o:connecttype="rect"/>
 <o:lock v:ext="edit" aspectratio="t"/>
</v:shapetype><v:shape id="_x0000_i1025" type="#_x0000_t75" style='width:467.25pt;
 height:39pt'>
 <v:imagedata src="image001.png" o:title=""/>
</v:shape><![endif]--><![if !vml]><img width=623 height=52
src="image002.jpg" v:shapes="_x0000_i1025"><![endif]><o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'>P<span
style='mso-tab-count:1'>������������������������������������ </span>The point
number of the selected line.<span style='mso-spacerun:yes'>�
</span>(Non-editable)<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'>Nu<span
style='mso-tab-count:1'>���������������������������������� </span>The frequency
of the selected line.<span style='mso-spacerun:yes'>� </span>(Non-editable)<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'>dNu<span
style='mso-tab-count:1'>�������������������������������� </span>The residual of
the selected line. (X-axis of plot)<span style='mso-spacerun:yes'>�
</span>(Non-editable)<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'>W<span
style='mso-tab-count:1'>����������������������������������� </span>The width of
the selected line.<span style='mso-spacerun:yes'>� </span>(Non-editable)<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'>I<span
style='mso-tab-count:1'>������������������������������������� </span>The
intensity of the selected line.<span style='mso-spacerun:yes'>�
</span>(Non-editable)<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'>M<span
style='mso-tab-count:1'>����������������������������������� </span>The <i>m</i>
selected line.<span style='mso-spacerun:yes'>� </span>(Y-axis of plot)<span
style='mso-spacerun:yes'>� </span>(Non-editable)<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'>dM<span
style='mso-tab-count:1'>��������������������������������� </span>The relative
residual of the selected line.<span style='mso-spacerun:yes'>� </span>(Non-editable)<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'>Current
Series<span style='mso-tab-count:1'>����������������� </span>The current series
being assigned.<span style='mso-spacerun:yes'>� </span>Changing the series here
is equivalent to <b>Series | Select a Series�<o:p></o:p></b></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'>Order<span
style='mso-tab-count:1'>������������������������������ </span>The order to
which the current series will be fit.<span style='mso-spacerun:yes'>�
</span>Editing this value is equivalent to modifying Order on the <b>Data Sets
| View Series List...</b> table.<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'>Zoom<span
style='mso-tab-count:1'>����������������������������� </span>The magnification
on the triangle heights in the plot.<span style='mso-spacerun:yes'>�
</span>Increase this value to focus on weaker series.<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'>Assignments
List Box<span style='mso-tab-count:1'>������ </span>The assignments of the
current line are listed in the list box on the right hand side of the toolbar.<span
style='mso-spacerun:yes'>� </span>This is where you can add a note to an
assignment, as well as toggle the various flags associated with the assignment
(akin to <b>K</b>, <b>U</b>, and <b>L</b> on the keyboard )<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Function
List<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>The
functions below are listed in the order they appear in the source code.<span
style='mso-spacerun:yes'>� </span>In addition, three slashes �///� are used to
create comments corresponding to the headings below, allowing for quick
searching.<span style='mso-spacerun:yes'>� </span>Only functions used by the
menus or various dependency formulas are non-static.<span
style='mso-spacerun:yes'>� </span>However, the procedure file defines LWA as a
module name so static procedures are available using the module syntax.<span
style='mso-spacerun:yes'>� </span>For example:<o:p></o:p></span></p>

<p class=CodeIndented>LWA#VMoveCursor(-1)</p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>This
has been done to minimize the risk of namespace conflicts and to prevent the
accidental use of some functions.<span style='mso-spacerun:yes'>� </span>For
example the above function returns an error message if the tow window is not a
Loomis-Wood plot.<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>A
description of most of the non-static functions can be found above.<span
style='mso-spacerun:yes'>� </span>The static functions are described (as
needed) in the source code.<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Menu
support functions:<o:p></o:p></span></p>

<p class=CodeIndented>static function/S OnLWmenuBuild()</p>

<p class=CodeIndented>static function/S LWDynamicMenuItem()</p>

<p class=CodeIndented>static function About()</p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>General
utility functions:<o:p></o:p></span></p>

<p class=CodeIndented>static function BinarySearch2(w, y)</p>

<p class=CodeIndented>static function/S Real1DWaveList(arg1,arg2,arg3)</p>

<p class=CodeIndented>static function/S FolderList(sourceFolderStr)</p>

<p class=CodeIndented>static function/S TextWave2List(theTextWave)</p>

<p class=CodeIndented>static function/S DimLabels2List(w, dim)</p>

<p class=CodeIndented>static function/S List2DimLabels(w, dim, list)</p>

<p class=CodeIndented>static function/S StandardBandLabels(order)</p>

<p class=CodeIndented>static function StandardBand2Poly(row, column, deltaJ)</p>

<p class=CodeIndented>static function poly2(coeff, order, theX)</p>

<p class=CodeIndented>static function/C bound_poly(coeff, order, theX)</p>

<p class=CodeIndented>static function CompareFunctions(f1, f2)</p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Misc.
Loomis-Wood functions:<o:p></o:p></span></p>

<p class=CodeIndented>static function isTopWinLWPlot(theWinType)</p>

<p class=CodeIndented>static function/S GetPlotList()</p>

<p class=CodeIndented>static function/S GetPlotFolderList()</p>

<p class=CodeIndented>static function GetFolders(theWinType, DataSet,
PlotFolder)</p>

<p class=CodeIndented>static function ValidateSourceFolder (DataSet)</p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Main
Loomis-Wood interface functions:<o:p></o:p></span></p>

<p class=CodeIndented>function NewLWDataSet()</p>

<p class=CodeIndented>static function/S GetNewLWDataFolder()</p>

<p class=CodeIndented>static function GetPeakfinderWaves(Line_Frequency, Line_Intensity,
Line_Width)</p>

<p class=CodeIndented>static function VerifyInputWaveDims(Line_Frequencies,
Line_Intensities, Line_Widths)</p>

<p class=CodeIndented>static function
GetNumLines(Line_Frequencies,Line_Intensities,Line_Widths)</p>

<p class=CodeIndented>static function NewLinesFolder(SourceDF, LWDF)</p>

<p class=CodeIndented>static function NewSeriesFolder(DataSet)</p>

<p class=CodeIndented>function DeleteLWDataSet(DataSet)</p>

<p class=CodeIndented>function DeleteLWPlotFolder(PlotFolder)</p>

<p class=CodeIndented>function ViewLineList()</p>

<p class=CodeIndented>function EditColors()</p>

<p class=CodeIndented>function NewLWPlot(DataSet, PlotFolder)</p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Data
dependency functions:<o:p></o:p></span></p>

<p class=CodeIndented>function DoBandCoeffUpdate(BandCoeff)</p>

<p class=CodeIndented>function DoSeriesOrderUpdate(Series_Order, CurrentSeries)</p>

<p class=CodeIndented>function DoTriangleUpdate(LWm, Assignments, Series_Color,
Series_Shape, StartM, EndM, Zoom)</p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Loomis-Wood
plot hook functions:<o:p></o:p></span></p>

<p class=CodeIndented>function LWHookFunction(s)</p>

<p class=CodeIndented>function OrderSetVarProc(ctrlName,varNum,varStr,varName) :
SetVariableControl</p>

<p class=CodeIndented>function
CurrentSeriesPopupMenuControl(ctrlName,popNum,popStr) : PopupMenuControl</p>

<p class=CodeIndented>function ListBoxProc(LB_Struct) : ListBoxControl</p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Loomis-Wood
plot event handlers:<o:p></o:p></span></p>

<p class=CodeIndented>static function HitTest(s)</p>

<p class=CodeIndented>static function NearestPeak(theX, theY)</p>

<p class=CodeIndented>static function VerticalScroll(Amount)</p>

<p class=CodeIndented>static function LinesPerFrame()</p>

<p class=CodeIndented>static function UpdateCursor()</p>

<p class=CodeIndented>static function AssignmentString2ListBoxWaves(str,
seriesNames, tw, sw)</p>

<p class=CodeIndented>static function MoveCursor(theP)</p>

<p class=CodeIndented>static function CursorPosition()</p>

<p class=CodeIndented>static function CursorM()</p>

<p class=CodeIndented>static function VMoveCursor(Amount)</p>

<p class=CodeIndented>static function HMoveCursor(Amount)</p>

<p class=CodeIndented>function ChangeRange(theMin, theMax)<span
style='mso-tab-count:1'>� </span>//F11</p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Series-related
functions:<o:p></o:p></span></p>

<p class=CodeIndented>function AddSeries()<span style='mso-tab-count:1'> </span>//
F2</p>

<p class=CodeIndented>function SelectSeries()<span style='mso-tab-count:1'> </span>//
F3</p>

<p class=CodeIndented>static function ChangeCurrentSeries(theSeries)</p>

<p class=CodeIndented>function DeleteSeries()<span style='mso-tab-count:1'> </span>//
F4</p>

<p class=CodeIndented>function GetCurrentSeriesNumber()</p>

<p class=CodeIndented>function/S FitSeries(theSeries)<span style='mso-tab-count:
1'>�� </span>// F5</p>

<p class=CodeIndented>function/S GetFitRes(s)</p>

<p class=CodeIndented>function FitAll()</p>

<p class=CodeIndented>function/S UndoFit()<span style='mso-tab-count:1'> </span>//
Shift-F5</p>

<p class=CodeIndented>static function FetchSeries(theSeries)</p>

<p class=CodeIndented>function ShiftSeries(theSeries, theShift,
autoFixConstants)<span style='mso-tab-count:1'>�� </span>// F6</p>

<p class=CodeIndented>static function ShiftConstants(theShift)</p>

<p class=CodeIndented>function ViewSeries(theSeries)<span style='mso-tab-count:
1'> </span>// F7</p>

<p class=CodeIndented>function ViewSeriesList()<span style='mso-tab-count:1'>� </span>//
F8</p>

<p class=CodeIndented>function EditBandConstants()<span style='mso-tab-count:
2'>����� </span>//F12</p>

<p class=CodeIndented>static function ChangeRegions()</p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Assignment-related
functions:<o:p></o:p></span></p>

<p class=CodeIndented>structure AssignmentStruct</p>

<p class=CodeIndented>static function ReadAssignment(theP, theSeries, s)</p>

<p class=CodeIndented>static function AssignLine2(s)</p>

<p class=CodeIndented>static function AssignLine(theP, theSeries, theM, LWmask,
USmask, LSmask, Notes)</p>

<p class=CodeIndented>static function UnAssignLine(theP, theSeries)</p>

<p class=CodeIndented>function ExtractAssignments(functionName)<span
style='mso-tab-count:1'>��� </span>// F9</p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Structures:<o:p></o:p></span></p>

<p class=CodeIndented>structure SeriesStruct</p>

<p class=CodeIndented>static function GetSeriesStruct(DataSet, s, [flag])</p>

<p class=CodeIndented>structure LinesStruct</p>

<p class=CodeIndented>static function GetLinesStruct(DataSet, s, [flag])</p>

<p class=CodeIndented>structure AssignmentListStruct</p>

<p class=CodeIndented>static function GetAssignmentListStruct(DataSet, s,
[flag])</p>

<p class=CodeIndented>structure SeriesFitStruct</p>

<p class=CodeIndented>static function GetSeriesFitStruct(DataSet, s, [flag])</p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>New
stuff:<o:p></o:p></span></p>

<p class=CodeIndented>function SynchronizeSeries2Lines()</p>

<p class=CodeIndented>function SynchronizeLines2Series()</p>

<p class=CodeIndented>function UpdateLinesFolder(FreqTol)</p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Structures<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>The
data contained in the Lines, Series, Assignments, and SeriesFit subfolders is
accessible through structures.<span style='mso-spacerun:yes'>� </span>Use the
GetLinesStruct(), GetSeriesStruct(), GetAssignmentListStruct(), and
GetSeriesFitStruct() functions to create a structure referencing these
folders.<span style='mso-spacerun:yes'>� </span>This greatly simplifies writing
functions to access this data, and simplifies the code of the add-in as well.<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>The
add-in does not implement structures for the data in a plot subfolder.<span
style='mso-spacerun:yes'>� </span>The reason for this is that many of the
functions that use this data need fast response to prevent the add-in from
becoming sluggish.<span style='mso-spacerun:yes'>� </span>Since dereferencing a
global data object involves a significant overhead, it is best to only
dereference (using NVAR, SVAR, and WAVE). the objects needed.<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Customization<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>There are
several function of the Add-In that the user may want to customize.<span
style='mso-spacerun:yes'>� </span>The most important is the Extract Assignments
feature, which has already been discussed.<span style='mso-spacerun:yes'>�
</span>(See <u><span style='color:blue'>The Assignments Folder:</span></u><span
style='color:black'>.)<span style='mso-spacerun:yes'>� </span>There are several
other function this user may want to customize.<span style='mso-spacerun:yes'>�
</span>Most of these can be changed using </span><u><span style='color:blue'>Function
Overrides</span></u><span style='color:black'>, although you can edit the main
procedure file if you want.<span style='mso-spacerun:yes'>� </span>Functions
the user may want to customize are:<o:p></o:p></span></span></p>

<p class=CodeIndented>static function/S StandardBandLabels(order)</p>

<p class=CodeIndented>static function StandardBand2Poly(row, column, deltaJ)</p>

<p class=TopicBody style='margin-left:.5in'><span style='mso-bidi-font-family:
"Times New Roman"'>These two functions create the Band2Poly, Poly2Band and
BandCoeffLabels waves.<span style='mso-spacerun:yes'>� </span>If one overrides
these functions, you can alter the fitting constants for all new data sets in
an entire experiment.<span style='mso-spacerun:yes'>� </span>(You can also edit
these waves manually on a per-data-set basis.)<span style='mso-spacerun:yes'>�
</span>For example, you may prefer to fit series in terms of <i>B</i>� and <i>B</i>�
instead of <i>B</i>� and </span><span style='font-family:Symbol;mso-bidi-font-family:
Symbol'>D</span><i>B</i>.<span style='mso-spacerun:yes'>� </span>Another
example would be changing the fitting for <span style='font-family:Symbol;
mso-bidi-font-family:Symbol'>D</span><i>J</i> = 2 transitions.<span
style='mso-spacerun:yes'>� </span>If you want to change the fitting to a
non-polynomial model, a lot more work is involved.<span
style='mso-spacerun:yes'>� </span>However it should be possible by editing any
function that uses the PolyCoeff wave.</p>

<p class=CodeIndented>function/S GetFitRes(s)</p>

<p class=TopicBody style='margin-left:.5in'><span style='mso-bidi-font-family:
"Times New Roman"'>Overriding this function allows the user to customize the
output the fitting routine prints after every fit.<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Globalization<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>All
text used in dialogs is contained in strconstants at the top of the procedure
file.<span style='mso-spacerun:yes'>� </span>If someone needs to translate the
text, all that needs to be edited are these constants, and the menu that
immediately follows these constants.<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>Revision
Notes<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'>1.00<span
style='mso-tab-count:1'>�������������������������������� </span>Loomis-Wood
Add-In first released.<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'>2.00<span
style='mso-tab-count:1'>�������������������������������� </span>LWA is no
longer dependant on SetWindowExt XOP, but requires Igor 5.02.<span
style='mso-spacerun:yes'>� </span>LWA currently does not respond to wheel or
double-click mouse events, because of this change.<span
style='mso-spacerun:yes'>� </span>However, it should be Mac compatible.<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'>2.01<span
style='mso-tab-count:1'>�������������������������������� </span>Colors are now
based upon a RGB color wave named M_Colors.<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'><span
style='mso-tab-count:1'>�������������������������������������� </span>The
control bar of a Loomis-Wood plot is now a sub-window.<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'><span
style='mso-tab-count:1'>�������������������������������������� </span>A zoom
feature was added.<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'><span
style='mso-tab-count:1'>�������������������������������������� </span>Assignments
are now tracked with text waves.<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'><span
style='mso-tab-count:1'>�������������������������������������� </span>More
error handling was added to FitSeries.<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'><span
style='mso-tab-count:1'>�������������������������������������� </span>Added
Undo last fit.<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'><span
style='mso-tab-count:1'>�������������������������������������� </span>All Make
commands specify precision explicitly, preventing accidental use of single
precision.<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'>2.05<span
style='mso-tab-count:1'>�������������������������������� </span>Reorganized
data folder structures:<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'><span
style='mso-tab-count:1'>�������������������������������������� </span>Waves
that previously began with �Peak_� are now in the Lines subfolder.<span
style='mso-spacerun:yes'>� </span>Waves that previously began with �Series_�
are in the Series subfolder.<span style='mso-spacerun:yes'>� </span>All plot
folders are now within a Plots subfolder instead of in the base LW data folder.<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'><span
style='mso-tab-count:1'>�������������������������������������� </span>Added
structures and functions to create structures so that coding with the new
folder structure is more transparent.<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'><span
style='mso-tab-count:1'>�������������������������������������� </span>Reorganized
Loomis-Wood menu.<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'><span
style='mso-tab-count:1'>�������������������������������������� </span>Converted
control bar of Loomis-Wood graphs to a subwindow.<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'>2.06 <span
style='mso-tab-count:1'>������������������������������� </span>M_Colors renamed
to just Colors and ColorNames wave removed.<span style='mso-spacerun:yes'>�
</span>The color names are now labels in the Colors wave.<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'><span
style='mso-tab-count:1'>�������������������������������������� </span>Added
line breaks to strings used in dialogs.<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'><span
style='mso-tab-count:1'>�������������������������������������� </span>Added
�Update Line List�, �Synchronize Series to Lines�, and �Synchronize Lines to
Series� commands.<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'><span
style='mso-tab-count:1'>�������������������������������������� </span>Rewrote
code that creates Loomis-wood graph windows (in the NewLWplot function).<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'><span
style='mso-tab-count:1'>�������������������������������������� </span>Implemented
an assignment structure.<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'><span
style='mso-tab-count:1'>�������������������������������������� </span>Added
upper and lower state flags and note to assignments.<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'><span
style='mso-tab-count:1'>�������������������������������������� </span>Added
ListBox control to control bar.<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'><span
style='mso-tab-count:1'>�������������������������������������� </span>Added
Create/Modify Comb waves to DoBandCoeffUpdate() function.<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'><span
style='mso-tab-count:1'>�������������������������������������� </span>Added
static GetFolders() function.<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'><span
style='mso-tab-count:1'>�������������������������������������� </span>Added
�Fit All� command.<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'><span
style='mso-tab-count:1'>�������������������������������������� </span>Added
user enabled assignment function to �Extract Assignments� command.<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'>2.07<span
style='mso-tab-count:1'>�������������������������������� </span>Reordered code
and eliminated some old commented code.<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'><span
style='mso-tab-count:1'>�������������������������������������� </span>Added
GetPlotList(), GetPlotFolderList()<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'><span
style='mso-tab-count:1'>�������������������������������������� </span>Implemented
SeriesFit structure.<span style='mso-spacerun:yes'>� </span>Modified
FetchSeries(), ViewSeries(), and FitSeries()<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'><span
style='mso-tab-count:1'>�������������������������������������� </span>Edit Band
Constants is now Undoable via UndoFit().<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'><span
style='mso-tab-count:1'>�������������������������������������� </span>Added
CompareFunctions() and FunctionList2().<span style='mso-spacerun:yes'>�
</span>Removed TestLWLabelProto() and LWLabelList()<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'><span
style='mso-tab-count:1'>�������������������������������������� </span>Added
optional flag parameter to GetLinesStruct(), and GetSeriesStruct().<span
style='mso-spacerun:yes'>� </span>Removed GetLinesStruct2().<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'><span
style='mso-tab-count:1'>�������������������������������������� </span>FIVEMAX_PEAKS_PER_PLOT
can now be changed without recreating the Loomis-Wood plot<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'><span
style='mso-tab-count:1'>�������������������������������������� </span>Added
DoSeriesNameUpdate() and moved command that updates the Current Series popup
from ChangeCurrentSeries() to DoSeriesNameUpdate().<span
style='mso-spacerun:yes'>� </span>Now the popup updates when Series:Name is
edited.<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'><span
style='mso-tab-count:1'>�������������������������������������� </span>Edited
DeleteSeries().<span style='mso-spacerun:yes'>� </span>DeleteSeries() now uses
SynchronizeLines2Series() simplifying the code.<span style='mso-spacerun:yes'>�
</span>DeleteSeries() also goes through all plots and adjusts CurrentSeries as
needed.<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'><span
style='mso-tab-count:1'>�������������������������������������� </span>Added a
Colors wave to the Assignments folder.<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'>2.08<span
style='mso-tab-count:1'>�������������������������������� </span>Table Windows
are now named.<span style='mso-spacerun:yes'>� </span>The name is the Data Set
folder name + �_AL�, �_LL�, �_SL�, �_CS�, or �_CT�.<span
style='mso-spacerun:yes'>� </span>Each call to a view function no longer
creates a new window.<o:p></o:p></span></p>

<p class=KeyList><span style='mso-bidi-font-family:"Times New Roman"'><span
style='mso-tab-count:1'>�������������������������������������� </span>Fixed
several problems relating to �backwards series� (d</span><span
style='font-family:Symbol;mso-bidi-font-family:Symbol'>n</span> / d<i>m</i>
&lt; 0).</p>

<p class=KeyList><span style='mso-tab-count:1'>�������������������������������������� </span>Killing
Loomis-Wood plot now attempts to delete the plot folder.<span
style='mso-spacerun:yes'>� </span>This will quietly fail if the user has
created any windows referencing the data in this folder.</p>

<p class=KeyList><span style='mso-tab-count:1'>�������������������������������������� </span>Implemented
MatrixOp in several places for cleaner code.</p>

<p class=KeyList><span style='mso-tab-count:1'>�������������������������������������� </span>Changed
LWLabelProto(), and modified ExtractAssignments() accordingly.</p>

<p class=KeyList><span style='mso-tab-count:1'>�������������������������������������� </span>ExtractAssignments()
now remembers last used Assignment Function.</p>

<p class=KeyList><span style='mso-tab-count:1'>�������������������������������������� </span>Added
ChangeRegions() function and modified DoBandCoeffUpdate().<span
style='mso-spacerun:yes'>� </span>The Add-In now has a method to handle band
heads.</p>

<p class=KeyList><span style='mso-tab-count:1'>�������������������������������������� </span>Added
GetFitRes().</p>

<p class=KeyList><span style='mso-tab-count:1'>�������������������������������������� </span>Series
with Shape= -1 are now hidden.</p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>To Do
List<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>Feature
to synchronize LW plot with spectrum plot.<span style='mso-spacerun:yes'>�
</span>(Currently, this can be done manually by creating a dependency to the
variables in the Plot folder.)<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>Implement
structure for Cursor data and move Cursor data to subfolder<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>Implement
structure for Plot data<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>Import/Export
feature<o:p></o:p></span></p>

<p class=Subtopic><span style='mso-bidi-font-family:"Times New Roman"'>References<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>F. W.
Loomis and R. W. Wood <i>Phys. Rev. </i>32, 223-236 (1928).<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>J. F.
Scott and K. Narahari Rao <i>J. Mol. Spectrosc. </i>20, 461-463 (1966).<o:p></o:p></span></p>

<p class=TopicBody><span style='mso-bidi-font-family:"Times New Roman"'>Brenda
P. Winnewisser, J�rgen Reinst�dtler, Koichi M. T. Yamada , and J�rg Behrend, <i>J.
Mol. Spectrosc. </i>136, 12{16 (1989)<o:p></o:p></span></p>

</div>

</body>

</html>
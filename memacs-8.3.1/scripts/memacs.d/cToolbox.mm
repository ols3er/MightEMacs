# cToolbox.mm	Ver. 8.3.1
#	MightEMacs macros for C source-file editing.

# Don't load this file if it has already been done so.
if defined? 'c' & subString($LangNames,index($LangNames,':') + 1)
	return
endif

require 'toolbox'

# Set the following variable to a regular expression that will match the first line of a C function in a source file; that is,
# the line containing the name of the function.  The langFindRoutine macro will replace the '%NAME%' string with the name of the
# function being searched for each time the RE is used.  The langFindRoutine macro is called by the cFindFunc macro, which is
# bound to 'C-c C-f'.  The default RE here matches a line where the opening brace for the function is on the same line as the name.
$CFuncRE = '^[\l_].+[^\l_]%NAME%\(.+{[ \t]*$:re'

##### Macros #####

# Wrap "#if 0" and "#endif" around a block of lines.
macro cWrapIf0,0
	$0 => langWrapPrep false,'#','0','endif'
endmacro

# Wrap "#if 1" and "#endif" around a block of lines.
macro cWrapIf1,0
	$0 => langWrapPrep false,'#','1','endif'
endmacro

# Wrap "#if 0" and "#else" around a block of lines, duplicate them, and add "#endif".
macro cWrapIfElse,0
	$0 => langWrapIfElse '#'
endmacro

# Prompt for macro name.
macro cNamePrompt,0
	defined?('$cWrapName') && !null?($cWrapName) or $cWrapName = nil
	$cWrapName = prompt 'Macro name',$cWrapName
endmacro

# Wrap "#if !<name>" and "#endif" around a block of lines.
macro cWrapIfName0,0
	cNamePrompt
	void?($cWrapName) || $0 => langWrapPrep false,'#','!' & $cWrapName,'endif'
endmacro

# Wrap "#if <name>" and "#endif" around a block of lines.
macro cWrapIfName1,0
	cNamePrompt
	void?($cWrapName) || $0 => langWrapPrep false,'#',$cWrapName,'endif'
endmacro

# Wrap "#if <name>" and "#else" around a block of lines, duplicate them, and add "#endif".
macro cWrapIfElseName,0
	cNamePrompt
	if !void?($cWrapName)
		formerMsgState = -1 => alterGlobalMode 'msg'
		$0 => langWrapPrep true,'#',$cWrapName,'else'
		setMark
		yank
		insert "#endif\r"
		swapMark
		beginText
		formerMsgState => alterGlobalMode 'msg'
	endif
endmacro

# Find first file that contains requested function name and render it according to n argument if found.
macro cFindFunc,0
	$0 => langFindRoutine '$CFuncRE','$cFindDir','*.c','Function'
endmacro

# Go to matching #if... or #endif if current line begins with one of the two keywords.  Save current position in mark '.', set
# mark 'T' to #if... line, mark 'E' to #else (if it exists), and mark 'B' to #endif.  If $0 == 0, be silent about errors.
# Return true if successful; otherwise, false.
macro cGotoIfEndif,0

	# Current line begin with #if... or #endif?
	x = subLine -$lineOffset,6
	if subString(x,0,3) == '#if'
		isIf = true
	elsif x == '#endif'
		isIf = false
	else
		$0 == 0 || beep
		return false
	endif

	# if/endif found.  Prepare for forward or backward search.
	formerMsgState = -1 => alterGlobalMode 'msg'
	-1 => setMark
	beginLine
	if isIf
		alias _nextLine = forwLine
		this = '#if'
		thisLen = 3
		1 => setMark 'T'
		force deleteMark 'B'
		that = '#endif'
		thatLen = 6
		thatMark = 'B'
	else
		alias _nextLine = backLine
		this = '#endif'
		thisLen = 6
		1 => setMark 'B'
		force deleteMark 'T'
		that = '#if'
		thatLen = 3
		thatMark = 'T'
	endif

	level = 0
	foundElse = false
	found = true
	force deleteMark 'E'

	# Scan lines until other keyword found.
	loop
		if _nextLine() == false
			gotoMark '.'				# Other keyword not found!
			if $0 != 0
				beep
				0 => notice that,' not found'
			endif
			found = false
			break
		endif

		if subLine(0,thatLen) == that
			if level == 0
				1 => setMark thatMark		# Found other keyword.
				break
			else
				--level
			endif
		elsif subLine(0,thisLen) == this
			++level
		elsif subLine(0,5) == '#else' && level == 0
			foundElse = true
			1 => setMark 'E'
		endif
	endloop

	# Clean up.
	deleteAlias _nextLine
	formerMsgState => alterGlobalMode 'msg'
	found
endmacro

# Remove conditional preprocessor lines from current buffer and return custom result message, given (1), Boolean "keep 'not'
# lines".  Used by cNukePPLines macro.
macro cNukePPLines1,1
	formerMsgState = -1 => alterGlobalMode 'msg'
	ifCount = 0
	until huntForw() == false				# Found #if line.
		isNot = (1 => match 1) == '!'			# Grab '!' if present.
		if 0 => cGotoIfEndif				# Find #else (mark 'E') and #endif (mark 'B').
			gotoMark 'T'				# Move to beginning of #if line.
			++ifCount

			# Delete #if block if applicable.
			if $1 != isNot				# (Keeping "not" lines) != ('!' present)?
				setMark				# Yes, delete.
				if 1 => defined? 'E'		# Have #else?
					gotoMark 'B'		# Yes, go to #endif ...
					deleteLine		# nuke it ...
					gotoMark 'E'		# and go to #else.
				else
					gotoMark 'B'		# No #else.  Go to #endif.
				endif
				0 => deleteLine			# Delete #if block.
			else					# Not deleting #if block.
				if 1 => defined? 'E'		# Have #else?
					gotoMark 'E'		# Yes, go to #else ...
					setMark
					gotoMark 'B'		# go to #endif ...
					0 => deleteLine		# and delete #else block.
				else				# No #else.
					gotoMark 'B'		# Go to #endif ...
					deleteLine		# and delete it.
				endif
				gotoMark 'T'			# Return to #if ...
				deleteLine			# and delete it.
			endif
		else
			# No matching #endif found.  Bail out.
			formerMsgState => alterGlobalMode 'msg'
			return -1 => notice '#endif not found!'
		endif
	endloop

	# No (more) #if lines found in current buffer.
	formerMsgState => alterGlobalMode 'msg'
	saveBuf
	"#{ifCount} '#if' blocks resolved"
endmacro

# Scan multiple buffers (files) and remove conditional preprocessor lines.  #if lines must be in form "#if MACRO" or
# "#if !MACRO".
macro cNukePPLines,0

	# Get list of buffers to search: either all visible buffers or only those also in $grepList.
	if (searchList = $0 => getBufList) == false
		return false
	endif
	whichBufs = shift searchList,"\e"
	whichBufs = whichBufs ? 'all' : 'selected'

	# Prompt for Boolean-qualified macro name.
	macName = prompt "In #{whichBufs} buffers, keep lines for macro name (!NAME or NAME)"
	if void?(macName) || macName == '!'
		return
	endif

	# Get ready for scan.
	search = $searchPat
	if subString(macName,0,1) == '!'
		notMatch = true
		macPlain = subString macName,1
	else
		notMatch = false
		macPlain = macName
	endif
	$searchPat = "^#if[ \\t]+(!?)#{macPlain}[ \\t]*$:re"

	# Process buffers.
	result = doBufList searchList,'cNukePPLines1',notMatch

	# Clean up.
	$searchPat = search
	result
endmacro

# Activate or deactivate tools, given tool activator name and Boolean argument.
macro cInit,2

	# Proceed only if activation request and tools not active or deactivation request and tools active.
	if $2 != (binding('C-c C-g') == 'cGotoIfEndif')
		$wordChars = ''
		bindings = join "\r","cFindFunc\tC-c C-f","cGotoIfEndif\tC-c C-g","cNukePPLines\tC-c #"
		bindings = join "\r",bindings,"cWrapIf0\tM-0","cWrapIf1\tM-1","cWrapIfElse\tM-2"
		bindings = join "\r",bindings,"cWrapIfName0\tC-c 0","cWrapIfName1\tC-c 1","cWrapIfElseName\tC-c 2"
		eval "#{$1} 'C',bindings,$2"
	endif
endmacro

# Done!
notice 'C tools loaded'

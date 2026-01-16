$CONSOLE:ONLY
OPTION BASE 0

DIM handles&(24)
DIM Content$(LBOUND(handles&) TO UBOUND(handles&))

ON ERROR GOTO errorhand

'To avoid triggering server security blocking our IP by calling the same URL
'hundred times within the fraction of a second, we now have a list of URLs to
'randomly pick from and also quartered the number of files and added a _DELAY
'in the request loop below.
CONST NUM_URLS = 767 'number of URLs in 'urls.txt'
DIM Urls$(1 TO NUM_URLS)
OPEN "I", #1, _STARTDIR$ + "urls.txt"
FOR i% = 1 TO NUM_URLS
    LINE INPUT #1, Urls$(i%)
NEXT i%
CLOSE #1

RANDOMIZE TIMER
FOR x = LBOUND(handles&) TO UBOUND(handles&)
    ' The math here "randomizes" the order of the handles in the array, while
    ' still keeping the result predictable. The numbers are picked so that
    ' every entry still gets filled in.
    hn% = (x * 3) MOD (UBOUND(handles&) + 1) 'handle index
    un% = RangeRand%(1, NUM_URLS) 'url number
    FOR i% = 1 TO 5
        handles&(hn%) = _OPENCLIENT(Urls$(un%))
        _DELAY 0.6 'lets scatter the requests over 15 seconds
        IF handles&(hn%) <> _CLIENT_FAILED THEN EXIT FOR
    NEXT i%
NEXT x

' Read from all the connections in parallel
Done& = 0
WHILE NOT Done&
    _LIMIT 50
    Done& = -1

    FOR x = LBOUND(handles&) TO UBOUND(handles&)
        GET #handles&(x), , s$
        Content$(x) = Content$(x) + s$

        Done& = Done& AND EOF(handles&(x))
    NEXT x
WEND

FOR x = LBOUND(handles&) TO UBOUND(handles&)
    PRINT "Handle: "; handles&(x); ", Match: "; _IIF(LOF(handles&(x)) = LEN(Content$(x)), "yes", "no"); ", Status Code: "; _STATUSCODE(handles&(x))

    CLOSE #handles&(x)
NEXT x

abort:
SYSTEM

errorhand:
PRINT "Error:"; ERR; ", Line:"; _ERRORLINE
RESUME abort

'======================================================================
FUNCTION RangeRand% (low%, high%)
RangeRand% = INT(RND(1) * (high% - low% + 1)) + low%
END FUNCTION


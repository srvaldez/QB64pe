$CONSOLE:ONLY
OPTION BASE 0

DIM handles&(99)
DIM Content$(LBOUND(handles&) TO UBOUND(handles&))

'To avoid triggering server security blocking our IP by calling the same URL
'hundred times within the fraction of a second, we now have a list of URLs to
'randomly pick from and also added a _DELAY in the request loop below.
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
    ' every entry 0 to 99 still gets filled in.
    handles&((x * 3) MOD (UBOUND(handles&) + 1)) = _OPENCLIENT(Urls$(RangeRand%(1, NUM_URLS)))
    _DELAY 0.15 'lets scatter the requests over 15 seconds
NEXT

' Read from all the connections in parallel
Done& = 0
WHILE NOT Done&
    _LIMIT 50
    Done& = -1

    FOR x = LBOUND(handles&) TO UBOUND(handles&)
        GET #handles&(x), , s$
        Content$(x) = Content$(x) + s$

        Done& = Done& AND EOF(handles&(x))
    NEXT
WEND

FOR x = LBOUND(handles&) TO UBOUND(handles&)
    PRINT "Handle: "; handles&(x); ", Match: "; _IIF(LOF(handles&(x)) = LEN(Content$(x)), "yes", "no"); ", Status Code: "; _STATUSCODE(handles&(x))

    CLOSE #handles&(x)
NEXT

SYSTEM

'======================================================================
FUNCTION RangeRand% (low%, high%)
RangeRand% = INT(RND(1) * (high% - low% + 1)) + low%
END FUNCTION


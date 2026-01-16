$CONSOLE:ONLY
OPTION BASE 0

DIM handles&(99)
DIM Content$(LBOUND(handles&) TO UBOUND(handles&))

'To avoid triggering server security blocking our IP by calling the same URL
'hundred times within the fraction of a second, we now have a list of URLs to
'randomly pick from and also added a _DELAY in the request loop below.
DIM Urls$(19)
Urls$(0) = "https://qb64phoenix.com/qb64wiki/index.php/PRINT"
Urls$(1) = "https://qb64phoenix.com/qb64wiki/index.php/PMAP"
Urls$(2) = "https://qb64phoenix.com/qb64wiki/index.php/POINT"
Urls$(3) = "https://qb64phoenix.com/qb64wiki/index.php/MEMPUT"
Urls$(4) = "https://qb64phoenix.com/qb64wiki/index.php/MEMNEW"
Urls$(5) = "https://qb64phoenix.com/qb64wiki/index.php/MEMFILL"
Urls$(6) = "https://qb64phoenix.com/qb64wiki/index.php/GlHint"
Urls$(7) = "https://qb64phoenix.com/qb64wiki/index.php/GlFinish"
Urls$(8) = "https://qb64phoenix.com/qb64wiki/index.php/GlFlush"
Urls$(9) = "https://qb64phoenix.com/forum/forumdisplay.php?fid=49"
Urls$(10) = "https://qb64phoenix.com/forum/showthread.php?tid=2979"
Urls$(11) = "https://qb64phoenix.com/forum/forumdisplay.php?fid=49&page=3"
Urls$(12) = "https://qb64phoenix.com/forum/showthread.php?tid=1271"
Urls$(13) = "https://qb64phoenix.com/forum/showthread.php?tid=1114"
Urls$(14) = "https://qb64phoenix.com/forum/forumdisplay.php?fid=49&page=2"
Urls$(15) = "https://qb64phoenix.com/forum/showthread.php?tid=2671"
Urls$(16) = "https://qb64phoenix.com/forum/showthread.php?tid=2671&pid=25155#pid25155"
Urls$(17) = "https://qb64phoenix.com/forum/showthread.php?tid=2800"
Urls$(18) = "https://qb64phoenix.com/forum/memberlist.php"
Urls$(19) = "https://qb64phoenix.com/forum/calendar.php"

RANDOMIZE TIMER
FOR x = LBOUND(handles&) TO UBOUND(handles&)
    ' The math here "randomizes" the order of the handles in the array, while
    ' still keeping the result predictable. The numbers are picked so that
    ' every entry 0 to 99 still gets filled in.
    handles&((x * 3) MOD (UBOUND(handles&) + 1)) = _OPENCLIENT(Urls$(RangeRand%(0, 19)))
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


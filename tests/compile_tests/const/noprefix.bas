$NOPREFIX
$CONSOLE:ONLY
_DEST _CONSOLE

' This list comprises all of the math functions usable in CONST
CONST const_PI = PI
CONST const_PIfunc = PI(2)
CONST const_ACOS = ACOS(.2)
CONST const_ASIN = ASIN(.2)
CONST const_ARCSEC = ARCSEC(1.2)
CONST const_ARCCOT = ARCCOT(.2)
CONST const_ARCCSC = ARCCSC(1.2)
CONST const_SECH = SECH(.2)
CONST const_CSCH = CSCH(.2)
CONST const_COTH = COTH(.2)
CONST const_D2R = _D2R(.2)
CONST const_D2G = D2G(.2)
CONST const_R2D = R2D(.2)
CONST const_R2G = R2G(.2)
CONST const_G2D = G2D(.2)
CONST const_G2R = G2R(.2)
CONST const_ROUND = ROUND(20.2)
CONST const_CEIL = CEIL(20.2)
CONST const_SEC = SEC(2)
CONST const_CSC = CSC(2)
CONST const_COT = COT(2)
' CONST const_ASC = ASC("a") ' Bugged, not implemented
CONST const__RGB32 = RGB32(2, 3, 4)
CONST const__RGBA32 = RGBA32(2, 3, 4, 5)
CONST const__RGB32_1 = RGB32(2)
CONST const__RGB32_2 = RGB32(2, 3)
CONST const__RGB32_4 = RGB32(2, 3, 4, 5)
CONST const__RGB = RGB(2, 3, 4, 2)
CONST const__RGBA = RGBA(2, 3, 4, 2, 2)
CONST const__RED32 = RED32(22)
CONST const__GREEN32 = GREEN32(22)
CONST const__BLUE32 = BLUE32(22)
CONST const__ALPHA32 = ALPHA32(22)
CONST const__RED = RED(22, 0)
CONST const__GREEN = GREEN(22, 0)
CONST const__BLUE = BLUE(22, 0)
CONST const__ALPHA = ALPHA(2222, 0)

' The answers have to be within the allowed range, to account for floating point
' differences.
PRINT "PI: "; 3.141592653589793 * .999999 < const_PI; 3.141592653589793 * 1.000001 > const_PI
PRINT "PI: "; 6.283185307179586 * .999999 < const_PIfunc; 6.283185307179586 * 1.000001 > const_PIfunc
PRINT "ACOS: "; 1.369438406004566 * .999999 < const_ACOS; 1.369438406004566 * 1.000001 > const_ACOS
PRINT "ASIN: "; .2013579207903308 * .999999 < const_ASIN; .2013579207903308 * 1.000001 > const_ASIN
PRINT "ARCSEC: "; .5856855434571508 * .999999 < const_ARCSEC; .5856855434571508 * 1.000001 > const_ARCSEC
PRINT "ARCCOT: "; 1.373400766945016 * .999999 < const_ARCCOT; 1.373400766945016 * 1.000001 > const_ARCCOT
PRINT "ARCCSC: "; .9851107833377457 * .999999 < const_ARCCSC; .9851107833377457 * 1.000001 > const_ARCCSC
PRINT "SECH: "; .9803279976447253 * .999999 < const_SECH; .9803279976447253 * 1.000001 > const_SECH
PRINT "CSCH: "; 4.966821568814516 * .999999 < const_CSCH; 4.966821568814516 * 1.000001 > const_CSCH
PRINT "COTH: "; 1.44280551632034 * .999999 < const_COTH; 1.44280551632034 * 1.000001 > const_COTH
PRINT "D2R: "; .0034906585 * .999999 < const_D2R; .0034906585 * 1.000001 > const_D2R
PRINT "D2G: "; .22222222222 * .999999 < const_D2G; .22222222222 * 1.000001 > const_D2G
PRINT "R2D: "; 11.4591559 * .999999 < const_R2D; 11.4591559 * 1.000001 > const_R2D
PRINT "R2G: "; .0031415926 * .999999 < const_R2G; .0031415926 * 1.000001 > const_R2G
PRINT "G2D: "; .18 * .999999 < const_G2D; .18 * 1.000001 > const_G2D
PRINT "G2R: "; 12.7323954474 * .999999 < const_G2R; 12.7323954474 * 1.000001 > const_G2R
PRINT "CSC: "; 1.099750170294616 * .999999 < const_CSC; 1.099750170294616 * 1.000001 > const_CSC

PRINT "SEC: "; -2.402997961722381 * .999999 > const_SEC; -2.402997961722381 * 1.000001 < const_SEC
PRINT "COT: "; -.4576575543602858 * .999999 > const_COT; -.4576575543602858 * 1.000001 < const_COT

PRINT "ROUND: "; const_ROUND
PRINT "CEIL: "; const_CEIL
PRINT "RGB32: "; HEX$(const__RGB32)
PRINT "RGBA32: "; HEX$(const__RGBA32)
PRINT "1: "; HEX$(const__RGB32_1)
PRINT "2: "; HEX$(const__RGB32_2)
PRINT "4: "; HEX$(const__RGB32_4)
PRINT "RGB: "; HEX$(const__RGB)
PRINT "RGBA: "; HEX$(const__RGBA)
PRINT "RED32: "; HEX$(const__RED32)
PRINT "GREEN32: "; const__GREEN32
PRINT "BLUE32: "; const__BLUE32
PRINT "ALPHA32: "; const__ALPHA32
PRINT "RED: "; const__RED
PRINT "GREEN: "; const__GREEN
PRINT "BLUE: "; const__BLUE
PRINT "ALPHA: "; const__ALPHA

SYSTEM

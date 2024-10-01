
#include "libqb-common.h"

#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "qbs.h"
#include <stdint.h>

// STR() functions
// singed integers
qbs *qbs_str(int64_t value) {
    qbs *tqbs;
    tqbs = qbs_new(20, 1);
    tqbs->len = sprintf((char *)tqbs->chr, "% " PRId64, value);
    return tqbs;
}
qbs *qbs_str(int32_t value) {
    qbs *tqbs;
    tqbs = qbs_new(11, 1);
    tqbs->len = sprintf((char *)tqbs->chr, "% i", value);
    return tqbs;
}
qbs *qbs_str(int16_t value) {
    qbs *tqbs;
    tqbs = qbs_new(6, 1);
    tqbs->len = sprintf((char *)tqbs->chr, "% i", value);
    return tqbs;
}
qbs *qbs_str(int8_t value) {
    qbs *tqbs;
    tqbs = qbs_new(4, 1);
    tqbs->len = sprintf((char *)tqbs->chr, "% i", value);
    return tqbs;
}
// unsigned integers
qbs *qbs_str(uint64_t value) {
    qbs *tqbs;
    tqbs = qbs_new(21, 1);
    tqbs->len = sprintf((char *)tqbs->chr, " %" PRIu64, value);
    return tqbs;
}
qbs *qbs_str(uint32_t value) {
    qbs *tqbs;
    tqbs = qbs_new(11, 1);
    tqbs->len = sprintf((char *)tqbs->chr, " %u", value);
    return tqbs;
}
qbs *qbs_str(uint16_t value) {
    qbs *tqbs;
    tqbs = qbs_new(6, 1);
    tqbs->len = sprintf((char *)tqbs->chr, " %u", value);
    return tqbs;
}
qbs *qbs_str(uint8_t value) {
    qbs *tqbs;
    tqbs = qbs_new(4, 1);
    tqbs->len = sprintf((char *)tqbs->chr, " %u", value);
    return tqbs;
}

uint8_t func_str_fmt[7];
uint8_t qbs_str_buffer[32];
uint8_t qbs_str_buffer2[32];

qbs *qbs_str(float value) {
    static qbs *tqbs;
    tqbs = qbs_new(16, 1);
    static int32_t l, i, i2, i3, digits, exponent;
    l = sprintf((char *)&qbs_str_buffer, "% .6E", value);
    // IMPORTANT: assumed l==14
    if (l == 13) {
        memmove(&qbs_str_buffer[12], &qbs_str_buffer[11], 2);
        qbs_str_buffer[11] = 48;
        l = 14;
    }

    digits = 7;
    for (i = 8; i >= 1; i--) {
        if (qbs_str_buffer[i] == 48) {
            digits--;
        } else {
            if (qbs_str_buffer[i] != 46)
                break;
        }
    } // i
    // no significant digits? simply return 0
    if (digits == 0) {
        tqbs->len = 2;
        tqbs->chr[0] = 32;
        tqbs->chr[1] = 48; // tqbs=[space][0]
        return tqbs;
    }
    // calculate exponent
    exponent = (qbs_str_buffer[11] - 48) * 100 + (qbs_str_buffer[12] - 48) * 10 + (qbs_str_buffer[13] - 48);
    if (qbs_str_buffer[10] == 45)
        exponent = -exponent;
    if ((exponent <= 6) && ((exponent - digits) >= -8))
        goto asdecimal;
    // fix up exponent to conform to QBASIC standards
    // i. cull trailing 0's after decimal point (use digits to help)
    // ii. cull leading 0's of exponent

    i3 = 0;
    i2 = digits + 2;
    if (digits == 1)
        i2--; // don't include decimal point
    for (i = 0; i < i2; i++) {
        tqbs->chr[i3] = qbs_str_buffer[i];
        i3++;
    }
    for (i = 9; i <= 10; i++) {
        tqbs->chr[i3] = qbs_str_buffer[i];
        i3++;
    }
    exponent = abs(exponent);
    // i2=13;
    // if (exponent>9) i2=12;
    i2 = 12; // override: if exponent is less than 10 still display a leading 0
    if (exponent > 99)
        i2 = 11;
    for (i = i2; i <= 13; i++) {
        tqbs->chr[i3] = qbs_str_buffer[i];
        i3++;
    }
    tqbs->len = i3;
    return tqbs;
/////////////////////
asdecimal:
    // calculate digits after decimal point in var. i
    i = -(exponent - digits + 1);
    if (i < 0)
        i = 0;
    func_str_fmt[0] = 37; //"%"
    func_str_fmt[1] = 32; //" "
    func_str_fmt[2] = 46; //"."
    func_str_fmt[3] = i + 48;
    func_str_fmt[4] = 102; //"f"
    func_str_fmt[5] = 0;
    tqbs->len = sprintf((char *)tqbs->chr, (const char *)&func_str_fmt, value);
    if (tqbs->chr[1] == 48) { // must manually cull leading 0
        memmove(tqbs->chr + 1, tqbs->chr + 2, tqbs->len - 2);
        tqbs->len--;
    }
    return tqbs;
}

qbs *qbs_str(double value){
    static qbs *tqbs;
    tqbs=qbs_new(32,1);
    char buf1[32];
    static int32_t l, i,j,digits,exponent, digits1, exponent1;
   
    sprintf((char*)&buf1,"% .14e", value);
    sprintf((char*)&qbs_str_buffer,"% .15e", value);

    exponent=atoi((char*)&qbs_str_buffer[19]);
    exponent1=atoi((char*)&buf1[18]);
    digits=17;
    while((qbs_str_buffer[digits]=='0')&&(digits>0)) digits--;
    digits1=16;
    while((buf1[digits1]=='0')&&(digits1>0)) digits1--;
    if(((digits-digits1)>1)&&(exponent==exponent1)){
		for(i=1;i<17;i++){
			qbs_str_buffer[i]=buf1[i];
		}
		qbs_str_buffer[17]='0';
		digits=17;
		while((qbs_str_buffer[digits]=='0')&&(digits>0)) digits--;
	}
    tqbs->chr[0]=qbs_str_buffer[0]; // copy sign
    if(exponent==0){
        for(i=1;i<=(digits);i++){
            tqbs->chr[i]=qbs_str_buffer[i];
        }
        if(tqbs->chr[digits]=='.') // if no digits after . then nip it
            tqbs->len=digits;  // by zero terminating
        else
            tqbs->len=digits+1; // terminate
    }
    else if(exponent<0){
        if((digits-exponent)>=19){ // use sci format
            for(i=1;i<=digits;i++){
                tqbs->chr[i]=qbs_str_buffer[i];
            }
            if(tqbs->chr[digits]=='.'){
                tqbs->chr[digits]='D';
                sprintf((char*)&tqbs->chr[digits+1],"%+03d", exponent);
                l=digits+1;
                while((tqbs->chr[l])!=0) l++;
                tqbs->len=l;
            }
            else{
                tqbs->chr[digits+1]='D';
                sprintf((char*)&tqbs->chr[digits+2],"%+03d", exponent);
                l=digits+2;
                while((tqbs->chr[l])!=0) l++;
                tqbs->len=l;
            }
        }
        else{
            tqbs->chr[1]='.';
            for(i=2;i<=abs(exponent);i++){
                tqbs->chr[i]='0';
            }
            tqbs->chr[abs(exponent)+1]=qbs_str_buffer[1]; // first non-zero digit
            j=3;                    // skip decimal point
            for(i=abs(exponent)+2;i<(abs(exponent)+digits);i++){
                tqbs->chr[i]=qbs_str_buffer[j];
                j++;
            }
            tqbs->len=abs(exponent)+digits; // terminate
        }
    }
    else if(exponent>0){
        if((digits<18)&&(exponent<16)){
            tqbs->chr[1]=qbs_str_buffer[1]; // first digit
            j=3;            // skip over .
            for(i=2;i<=(exponent+1);i++){
                tqbs->chr[i]=qbs_str_buffer[j];
                j++;
            }
            if((digits>exponent)&&(digits>(j-1))){
                tqbs->chr[exponent+2]='.';
                for(i=exponent+3;i<=(digits);i++){
                    tqbs->chr[i]=qbs_str_buffer[j];
                    j++;
                }
                tqbs->len=digits+1;
            }
            else{
                tqbs->len=exponent+2;
            }
    }
    else{
        for(i=0;i<=digits;i++){
            tqbs->chr[i]=qbs_str_buffer[i];
        }
        if(tqbs->chr[digits]=='.'){
            tqbs->chr[digits]='D';
            sprintf((char*)&tqbs->chr[digits+1],"%+03d", exponent);
            l=digits+1;
            while((tqbs->chr[l])!=0) l++;
            tqbs->len=l;
        }
        else{
            tqbs->chr[digits+1]='D';
            sprintf((char*)&tqbs->chr[digits+2],"%+03d", exponent);
            l=digits+2;
            while((tqbs->chr[l])!=0) l++;
            tqbs->len=l;
        }
    }
}
    return tqbs;
}

qbs *qbs_str(long double value){
    static qbs *tqbs;
    tqbs=qbs_new(32,1);
    static int32_t l, i,j,digits,exponent;
   
    #ifdef QB64_MINGW
        __mingw_sprintf((char*)&qbs_str_buffer,"% .17Le", value);
    #else
        sprintf((char*)&qbs_str_buffer,"% .17Le", value);
    #endif
    exponent=atoi((char*)&qbs_str_buffer[21]);
    digits=19;
    while((qbs_str_buffer[digits]=='0')&&(digits>0)) digits--;
    tqbs->chr[0]=qbs_str_buffer[0]; // copy sign
    if(exponent==0){
        for(i=1;i<=(digits);i++){
            tqbs->chr[i]=qbs_str_buffer[i];
        }
        if(tqbs->chr[digits]=='.') // if no digits after . then nip it
            tqbs->len=digits;  // by zero terminating
        else
            tqbs->len=digits+1; // terminate
    }
    else if(exponent<0){
        if((digits-exponent)>=22){ // use sci format
            for(i=1;i<=digits;i++){
                tqbs->chr[i]=qbs_str_buffer[i];
            }
            if(tqbs->chr[digits]=='.'){
                tqbs->chr[digits]='F';
                sprintf((char*)&tqbs->chr[digits+1],"%+03d", exponent);
				l=digits+1;
				while((tqbs->chr[l])!=0) l++;
				tqbs->len=l;
            }
            else{
                tqbs->chr[digits+1]='F';
                sprintf((char*)&tqbs->chr[digits+2],"%+03d", exponent);
				l=digits+2;
				while((tqbs->chr[l])!=0) l++;
				tqbs->len=l;
            }
        }
        else{
            tqbs->chr[1]='.';
            for(i=2;i<=abs(exponent);i++){
                tqbs->chr[i]='0';
            }
            tqbs->chr[abs(exponent)+1]=qbs_str_buffer[1]; // first non-zero digit
            j=3;                    // skip decimal point
            for(i=abs(exponent)+2;i<(abs(exponent)+digits);i++){
                tqbs->chr[i]=qbs_str_buffer[j];
                j++;
            }
            tqbs->len=abs(exponent)+digits; // terminate
        }
    }
    else if(exponent>0){
        if((digits<20)&&(exponent<18)){
            tqbs->chr[1]=qbs_str_buffer[1]; // first digit
            j=3;            // skip over .
            for(i=2;i<=(exponent+1);i++){
                tqbs->chr[i]=qbs_str_buffer[j];
                j++;
            }
            if((digits>exponent)&&(digits>(j-1))){
                tqbs->chr[exponent+2]='.';
                for(i=exponent+3;i<=(digits);i++){
                    tqbs->chr[i]=qbs_str_buffer[j];
                    j++;
                }
                tqbs->len=digits+1;
            }
            else{
                tqbs->len=exponent+2;
            }
    }
    else{
        for(i=0;i<=digits;i++){
            tqbs->chr[i]=qbs_str_buffer[i];
        }
        if(tqbs->chr[digits]=='.'){
            tqbs->chr[digits]='F';
            sprintf((char*)&tqbs->chr[digits+1],"%+03d", exponent);
			l=digits+1;
			while((tqbs->chr[l])!=0) l++;
			tqbs->len=l;
        }
        else{
            tqbs->chr[digits+1]='F';
            sprintf((char*)&tqbs->chr[digits+2],"%+03d", exponent);
			l=digits+2;
			while((tqbs->chr[l])!=0) l++;
			tqbs->len=l;
        }
    }
}
    return tqbs;
}

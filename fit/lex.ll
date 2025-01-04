%option noyywrap
%option nounput
%{
#include <strstream>
#include <fit.h>
#include <fitparse.h>
extern int lineno;
%}

real	[+-]?([0-9]+\.?)([Ee][+-][0-9]+)?|[+-]?([0-9]*\.[0-9]+)([Ee][+-][0-9]+)?
integer [0-9]+

%%

#.*$ {
		/* comment */ ;
	}

\(\ *{real}\ *,\ *{real}\ *\) {
		double r,i;
		char p;
		istrstream is(yytext);
		is >> p >> r >> p >> i >> p;
		complex<double> c(r,i);
		yylval.sym = install("", NUMBER, c);
		return NUMBER;
	}

[ \t]	{ 
			; 
		}

{integer} {
		int i;
		sscanf(yytext,"%d", &i);
		yylval.sym = install("", INTEGER, i);;
		return INTEGER;
	}


{real} {
		double d;
		sscanf(yytext,"%lf", &d);
		yylval.sym = install("", NUMBER, d);
		return NUMBER;
	}

complex {
		return CTYPE;
	}

rmat {
	return RMTYPE;
	}

damp {
		return ATYPE;
	}

par {
		return PTYPE;
	}

realpar {
		return RPTYPE;
	}

event_loop {
		return ELOOPSTATE;
	}

normalization {
		return NORMSTATE;
	}

integral {
		// cerr << "found \"integral\"" << endl;
		return ITYPE;
	}
index {
		return STR_INDEX;
	}


nev {
		return NEVFIELD;
	}
	
[a-zA-Z0-9_][-=+a-zA-Z0-9_.]* {
		Symbol *s;
		if ((s=lookup(yytext)) == 0) {
			//cerr << "installing " << yytext << " in lexer: s was " << s << endl;
			s = install(yytext, UNDEF, 0.0);
		}
		//cerr << "found " << yytext << " in lexer: s was " << s << endl;
		yylval.sym = s;
		return s->type;
}

\n	{ 
		lineno++; 
		/* return '\n' */; 
	}

.	{ 
		return yytext[0]; 
	}
\/\/.*\n  {
                /* COMMENT, do nothing*/;
        }

%{
#include <iostream>
#include <complex>
#include <fit.h>
#define code1(c1)		code((Inst)c1)
#define code2(c1,c2)	code((Inst)c1); code((Inst)c2)
#define code3(c1,c2,c3)	code((Inst)c1); code((Inst)c2); code((Inst)c3)

void yyerror(char* s);  // gets rid of implicit declaration warning in /usr/share/misc/bison.simple:327
int yylex();  // gets rid of implicit declaration warning in /usr/share/misc/bison.simple:387
%}

%union {
	Symbol *sym;
	Inst *inst;
	int ival;
}
%token	<sym> NUMBER VAR BLTIN UNDEF CTYPE RPTYPE PTYPE ATYPE RMTYPE ITYPE STR_INDEX NORMSTATE ELOOPSTATE NEVFIELD
%token  <ival> INTEGER
%right	'='
%left	'+' '-'
%left	'*' '/'
%left	UNARYMINUS
%right	'^'

%%

program: list { /* code2(print, STOP); return 1; */ ; }
	;
list:	/* nothing */
/*	| list '\n'
	| list asgn '\n'	{ code2(pop, STOP); return 1; } */
	| list statement {;}	
/*	| list error    { yyerrok; } */
	;

statement: asgn ';'
	| expr ';'
	| declaration ';'
	| normstate ':'
	| eloopstate ':'
	;

eloopstate: ELOOPSTATE {
	init_event_code();;
	}
	;

normstate: NORMSTATE {
	init_norm_code();;
	}
	;

declaration: CTYPE UNDEF { 
		Symbol* sp;
		sp = lookup($2->name);
		sp->type = CTYPE;
	}
	| PTYPE UNDEF {
		Symbol* sp;
		sp = lookup($2->name);
		sp->type = PTYPE;
	}
	| RPTYPE UNDEF {
		Symbol* sp;
		sp = lookup($2->name);
		sp->type = RPTYPE;
	}
	| ATYPE UNDEF {
		Symbol* sp;
		sp = lookup($2->name);
		sp->type = ATYPE;
	}
	| RMTYPE UNDEF {
		Symbol* sp;
		sp = lookup($2->name);
		sp->type = RMTYPE;
	}
	| ITYPE UNDEF {
		Symbol* sp;
		string s($2->name);
		sp = lookup($2->name);
		sp->type = ITYPE;
	}
	| ITYPE UNDEF '(' UNDEF ')' {
		Symbol* sp;
		string s($2->name);
		string f($4->name);
		read_integral(s,f);
		// print_integral(s);
		sp = lookup($2->name);
		sp->type = ITYPE;
	}
	| STR_INDEX UNDEF {
		Symbol* sp;
		sp = lookup($2->name);
		sp->type = STR_INDEX;
	}
	;
	
asgn: CTYPE '=' expr	{
		code3(varpush, (Inst)$1, assign);
	}
/*
	| PTYPE '=' expr {
		code3(varpush, (Inst)$1, assign);
	}
	| ATYPE '=' expr {
		code3(varpush, (Inst)$1, assign);
	}
*/
	;

expr:	NUMBER	{ code2(constpush, (Inst)$1); }
	| CTYPE 	{ code3(varpush, (Inst)$1, eval); }
	| PTYPE 	{ code3(varpush, (Inst)$1, evalptype); }
	| RPTYPE 	{ code3(varpush, (Inst)$1, evalptype); }
	| ATYPE 	{ code3(varpush, (Inst)$1, eval); }
	| RMTYPE '[' INTEGER ',' INTEGER ']' { code2(constpush,(Inst)$3); code2(constpush,(Inst) $5);code3(varpush, (Inst)$1, evalrmat);}
	| ITYPE '$' NEVFIELD 	{ 
		code3(varpush,(Inst)$1,evalnormev);
	}
	| ITYPE '[' ATYPE ',' ATYPE ']' 	{ 
		code2(varpush,(Inst)$3);
		code2(varpush,(Inst)$5);
		code3(varpush,(Inst)$1,evalnorm);
	}
	| ITYPE '[' STR_INDEX ',' STR_INDEX ']' 	{ 
		code2(varpush,(Inst)$3);
		code2(varpush,(Inst)$5);
		code3(varpush,(Inst)$1,evalnorm);
	}
/* ----------------------------
	| ITYPE '$' NEVFIELD 	{ 
		complex<double> z;
		Symbol* s;
		z = get_integral($1->name).nevents();
		s = install("",NUMBER,z);
		code2(constpush, (Inst)s); 
	}
	| ITYPE '[' ATYPE ',' ATYPE ']' 	{ 
		complex<double> z;
		string s1, wv1, wv2;
		Symbol* s;
		s1 = $1->name; wv1 = $3->name; wv2 = $5->name;
		z = get_integral_val(s1,wv1,wv2);
		s = install("",NUMBER,z);
		code2(constpush, (Inst)s); 
	}
	| ITYPE '[' STR_INDEX ',' STR_INDEX ']' 	{ 
		complex<double> z;
		string s1, wv1, wv2;
		Symbol* s;
		s1 = $1->name; wv1 = $3->name; wv2 = $5->name;
		z = get_integral_val(s1,wv1,wv2);
		s = install("",NUMBER,z);
		code2(constpush, (Inst)s); 
	}
-------------------------------- */
	| asgn
	| BLTIN '(' expr ')' { code2(bltin, (Inst)$1->ptr); }
	| '(' expr ')'
	| expr '+' expr { code1(add); }
	| expr '-' expr { code1(sub); }
	| expr '*' expr { code1(mul); }
	| expr '/' expr { code1(divide); }
	| expr '^' expr { code1(power); }
	| '-' expr %prec UNARYMINUS { code1(Negate); }
	// unary + has same precedence as unary - but we just ignore it.
	| '+' expr %prec UNARYMINUS { ; } 
	;
%%


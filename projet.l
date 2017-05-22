%{
	#include <stdio.h>
	#include <stdlib.h>
	#include "projet.tab.h"
	#include <math.h>
	int line_num = 1;
%}

blan [\t ]+
Chiffre [0-9]
CHE [1-2]{Chiffre}|(30)|[1-9]
CHA {Chiffre}+
LettreMin [a-z]
LettreMaj [A-Z]
IDvar {LettreMin}+
IDens {LettreMaj}+

%%

"app"	{return APP;}
"comp"	{return COMP;}
"card"	{return CARD;}
"==" { return AFFICHE ;}
"|" { return UNIO ;}
"&" {return INTER ;}
"/" { return prive ;}
{IDvar} {yylval.integer = (yytext[0]-97); return IDV ; } 
{IDens} {yylval.integer = (yytext[0]-65); return IDE ; }
[-/()*+=,{}] {return yytext[0] ; }
";"	return END;
{CHE} {yylval.integer = pow(2,atoi(yytext)); return CHIF;}
{CHA} {yylval.integer = atoi(yytext); return CHIFA;}
{blan} //
.  // 
\n    { line_num++;yylval.integer = line_num; return ENDL; }

%%

int yywrap(){return 1;}



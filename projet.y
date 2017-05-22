%{
	#include <stdio.h>
	#include "projet.tab.h"
	#include <math.h>
	int yylex();
	int aminz[26] = { 0 };
	int AmajZ[26] = { 0 };


%}

%union {int integer;char *str;}

%token APP
%token ENDL
%token COMP
%token CARD
%token IDV
%token IDE
%token CHIFA
%token CHIF
%token END
%token UNIO
%token INTER 
%token prive 
%token AFFICHE 

%left '+' '-'
%left '*' '/'
%left UNIO prive
%left INTER
%left COMP

%type <integer> CHIF CHIFA nbr ensemble expr_arth expr_set val IDV IDE ENDL
%type <str> COMP CARD expr

%%

exprs:  exprs expr END ENDL
		| error END ENDL {  yyerrok; printf("%d\n",$3 - 1 ); }
		| expr END ENDL
        ;

nbr : CHIF { $$ = $1 ; }
	| CHIF ',' nbr { $$= ($1 | $3); }
; 

ensemble : IDE {  $$ = AmajZ[$1]; }
	| '{' nbr '}' {  $$ = $2; }
	;

expr_set : ensemble { $$ = $1; }
	| '(' expr_set ')'  { $$ = $2; }
	| expr_set UNIO expr_set  { $$ = $1 | $3; }
	| expr_set INTER expr_set { $$ = $1 & $3; }
	| COMP expr_set	{ $$ = ($2) ^ 1073741823;}
	| expr_set prive expr_set { $$ = $1 & (~$3); }
	; 

val : CHIFA { $$ = $1; }
	| CHIF { $$ = (int) (log ($1) / log(2)) ; }
	| IDV {  $$ = aminz[$1];}
	| CARD expr_set	{ $$ = nbrCard($2);}
	;
 
expr_arth: val { $$ = $1; }
	| '(' expr_arth ')' { $$ = $2; }
	| expr_arth '*' expr_arth { $$ = $1 * $3; }
	| expr_arth '/' expr_arth { $$ = $1 / $3; }
	| expr_arth '+' expr_arth	 { $$ = $1 + $3; }
	| expr_arth '-' expr_arth { $$ = $1 - $3; }
	;

expr:   IDV '=' expr_arth			{ aminz[$1] = $3; }
		| IDE '=' expr_set			{ AmajZ[$1] = $3; }
		| IDE AFFICHE			{ printf("%c = ",($1+65)); showNbr(AmajZ[$1]); }
		| IDV AFFICHE			{ printf("%c = %d\n",($1+97),aminz[$1]); }
		| IDV APP IDE			{ char *ch = ( (aminz[$1]&AmajZ[$3]) != (aminz[$1]) )? ("True") : ("False") ; printf("%s\n",ch);  }
		;

%%


void showNbr(int x){
	printf("{");
	long i=0;
	while(x!=0){
		if((x%2)!=0){
			if((x/2)==0){
				printf(" %d ",i);
			}else{
				printf(" %d,",i);
			}
		}
		x=x/2;
		i++;	
	}
	printf("}\n");
}

int nbrCard(int x){
	int i=0;
	while(x!=0){
		if((x%2)!=0){
			i++;
		}
		x=x/2;	
	}
	printf("\n");
	return i;
}

void yyerror(char *s) {
    printf( "Error at line " );
}


int main(void) {
    yyparse();
    return 0;
}

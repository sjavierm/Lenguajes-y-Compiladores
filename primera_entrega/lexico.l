%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>

#include "y.tab.h"
FILE  *yyin;

char *yyltext;


int yyerror(void);
int error(char* mensaje);


%}



%option noyywrap  
%option yylineno 

DIGITO			[0-9]
LETRA			[a-zA-Z]

CTE		        {DIGITO}+
CTE_STR			\"({LETRA}|{DIGITO}|.)+\"
CTE_REAL        {DIGITO}+"."{DIGITO}+
ID			    {LETRA}({LETRA}|{DIGITO})*
OP_AS   	    ":""="
OP_SUM		    "+"
OP_MUL          "*"
OP_RES		    "-"
OP_DIV          "/"
OP_MEN			"<"
OP_MAY			">"
OP_MENI			"<="
OP_MAYI			">="
OP_IGUAL		"=="
OP_DIST			"><"
PA			    "("
PC			    ")"
CA				"["
CC				"]"
COMA            ","
COMEN_I			"//"
COMEN_F			"//"
COMENTARIO		{COMEN_I}.*{COMEN_F}



%%

"BEGINP"        {
	//printf("\nInicio del codigo: %s\n", yytext);
	return BEGINP;
	}
"ENDP"          {
	//printf("\nFin del codigo: %s\n", yytext);
	return ENDP;
	}
"DEFINE"        {
	//printf("\nInicio del define: %s\n", yytext);
	return DEFINE;
	}
"ENDDEFINE"     {
	//printf("\nFin del define: %s\n", yytext);
	return ENDDEFINE;
	}
"INTEGER"       {
	//printf("\nTipo de dato: %s\n", yytext);
	return INTEGER;
	}
"REAL"          {
	//printf("\nTipo de dato: %s\n", yytext);
	return REAL;
	}
"STRING"        {
	//printf("\nTipo de dato: %s\n", yytext);
	return STRING;
	}
"IF"            {
	//printf("\nIF: %s\n", yytext);
	return IF;
	}
"ENDIF"         {
	//printf("\nENDIF: %s\n", yytext);
	return ENDIF;
	}
"THEN"          {
	//printf("\nTHEN: %s\n", yytext);
	return THEN;
	}
"ELSE"          {
	//printf("\nELSE: %s\n", yytext);
	return ELSE;
	}
"AND"          	{
	//printf("\nAND: %s\n", yytext);
	return AND;
	}
"OR"            {
	//printf("\nOR: %s\n", yytext);
	return OR;
	}
"NOT"           {
	//printf("\nNOT: %s\n", yytext);
	return NOT;
	}
"DO"            {
	//printf("\nDO: %s\n", yytext);
	return DO;
	}
"WHILE"         {
	//printf("\nWHILE: %s\n", yytext);
	return WHILE;
	}
"ENDWHILE"      {
	//printf("\nENDWHILE: %s\n", yytext);
	return ENDWHILE;
	}
"UNTILLOOP"     {
	//printf("\nUNTILLOOP: %s\n", yytext);
	return UNTILLOOP;
	}
"APLICARDESCUENTO" {
	//printf("\nAPLICARDESCUENTO: %s\n", yytext);
	return APLICARDESCUENTO;
	}
"READ"          {
	//printf("\nREAD: %s\n", yytext);
	return READ;
	}
"WRITE"         {
	//printf("\nWRITE: %s\n", yytext);
	return WRITE;
	}
{CTE}			{
				if(atoll(yytext)<=2147483647){
					//printf("\n	Constante: %s\n", yytext);
					yylval.valor_int = atoi(yytext);
					return CTE;
				}
				error("ERROR: superaste el tamanio para numeros enteros.");
}
{CTE_STR}		{
				if(strlen(yytext)<=30){
					//printf("\n	Constante String: %s\n", yytext);
					int length = strlen(yytext);
					char nombre_cte[length];
					strcpy(nombre_cte, "_");
					strcat(nombre_cte, yytext+1);
					strcpy(nombre_cte + strlen(nombre_cte) - 1, "\0");
					yylval.valor_string = strdup(nombre_cte);
					return CTE_STR;
				}
				error("ERROR: superaste el tamanio para los string.");
}


{CTE_REAL}		{
				if(atof(yytext)<=3.40282347e+38F){
					//printf("\n	Constante Real: %s\n", yytext);
					yylval.valor_real = atof(yytext);
					return CTE_REAL;
				}
				error("ERROR: superaste el tamanio para numeros reales.");
}
{ID}			{
				if(strlen(yytext) <= 30){
					//printf("\n	Identificador: %s\n", yytext);
					yylval.string_val = strdup(yytext);
					return ID;
				}
				error("ERROR: ID se paso de tamanio.");
}
{OP_SUM}		{
	//printf("\n	Suma: %s\n", yytext);
	return OP_SUM;
	}
{OP_AS}			{
	//printf("\n	Asignacion: %s\n", yytext);
	return OP_AS;
	}
{OP_MUL}		{
	//printf("\n	Multiplicacion: %s\n", yytext);
	return OP_MUL;
	}
{OP_RES}		{
	//printf("\n	Resta: %s\n", yytext);
	return OP_RES;
	}
{OP_DIV}		{
	//printf("\n	Division: %s\n", yytext);
	return OP_DIV;
	}
{OP_MEN}		{
	//printf("\n	Menor: %s\n", yytext);
	return OP_MEN;
	}
{OP_MAY}		{
	//printf("\n	Mayor: %s\n", yytext);
	return OP_MAY;
	}
{OP_MENI}		{
	//printf("\n	Menor igual: %s\n", yytext);
	return OP_MENI;
	}
{OP_MAYI}		{
	//printf("\n	Mayor igual: %s\n", yytext);
	return OP_MAYI;
	}
{OP_IGUAL}		{
	//printf("\n	Igual: %s\n", yytext);
	return OP_IGUAL;
	}
{OP_DIST}		{
	//printf("\n	Distinto: %s\n", yytext);
	return OP_DIST;
	}
{PA}			{
	//printf("\n	ParAbre: %s\n", yytext);
	return PA;
	}
{PC}			{
	//printf("\n	ParCierra: %s\n", yytext);
	return PC;
	}
{CA}			{
	//printf("\n	CorAbre: %s\n", yytext);
	return CA;
	}
{CC}			{
	//printf("\n	CorCierra: %s\n", yytext);
	return CC;
	}
{COMA}          {
	//printf("\n	Coma: %s\n", yytext);
	return COMA;
	}
{COMENTARIO}
"\n"      		
"\t"
"\n\t"
" "             		
"\r\n"
.			 {
	//printf( "ERROR LEXICO : Caracter no reconocido: %s\n", yytext );
	exit (0);
	}
%%

int error(char* mensaje)
{
	printf("Error lexico: %s\n", mensaje);
	system ("Pause");
	exit (1);
}
%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>
#include "y.tab.h"
int yystopparser=0;
FILE  *yyin;

int yyerror();
int yylex();


#define Int 1
#define Real 2
#define String 3
#define Cte 4
#define CteStr 5
#define CteReal 6


#define TAM_TABLA 500
#define TAM_NOMBRE 32

typedef struct {
		char nombre[TAM_NOMBRE];
		int tipoDato;
		int valor_int;
		float valor_real;
		char valor_string[TAM_NOMBRE];
		int longitud;
	} datos;

datos tabla_datos[TAM_TABLA];
int fin_tabla = -1;


void agregarIdATabla(char* nombre);
void escribirNombreEnTabla(char* nombre, int pos);
void guardarTabla();
int buscarEnTabla(char* nombre);
void verificarIdEnTabla(char* nombre);
void agregarCteATabla(int valor);
void agregarCteFloatATabla(float valor);
void agregarCteStringATabla(char* nombre);
 
char nom[50];
int tipoDato;
int contador=0;
char*nom_id;

%}

%union{
	int valor_int;
	float valor_real;
	char *valor_string;
	char *string_val;
}

%token <valor_int> CTE
%token <valor_string> CTE_STR
%token <valor_real> CTE_REAL
%token <string_val> ID
%token OP_AS
%token OP_SUM
%token OP_MUL
%token OP_RES
%token OP_DIV
%token PA
%token PC
%token CA
%token CC
%token BEGINP
%token ENDP
%token DEFINE
%token ENDDEFINE
%token INTEGER
%token REAL
%token STRING
%token COMA
%token IF
%token THEN
%token ENDIF
%token ELSE
%token OP_MEN
%token OP_MAY
%token OP_MENI
%token OP_MAYI
%token OP_IGUAL
%token OP_DIST
%token AND
%token OR
%token NOT
%token WHILE
%token ENDWHILE
%token DO
%token UNTILLOOP
%token APLICARDESCUENTO
%token READ
%token WRITE


%%
programa:
	{printf("\nINICIO DEL PROGRAMA\n");} definiciones algoritmo {printf("FIN DEL PROGRAMA\n");
	guardarTabla();
	}
	;

definiciones:
	{printf("\n		//////////Inicio de las declaraciones////////// \n");} DEFINE  declaraciones ENDDEFINE {printf("R1:DEFINE declaraciones ENDDEFINE es definiciones\n");} {printf("\n		//////////Fin de las Declaraciones//////////\n\n");}
	;

declaraciones:
	declaraciones declaracion{printf("R2:declaraciones declaracion es declaraciones\n\n");}
	|declaracion{printf("R3:declaracion es declaraciones\n\n");}
	;

declaracion:
	t_dato lista_var{printf("R4:t_dato lista_var es declaracion\n");}
	;

t_dato:
	INTEGER {
		printf("R5:INTEGER es t_dato\n");
		tipoDato=Int;
	}
	|STRING {
		printf("R6:STRING es t_dato\n");
		tipoDato=String;
	}
	|REAL	{
		printf("R7:REAL es t_dato\n");
		tipoDato=Real;
	}
	;
	
lista_var:
	lista_var COMA ID {
		printf("R8:lista_var COMA ID es lista_var\n");
		agregarIdATabla(yylval.string_val);
		//printf("%s\n",yylval.string_val);
	}
	|ID {
		printf("R9:ID es lista_var\n");
		agregarIdATabla(yylval.string_val);
		//printf("%s\n",yylval.string_val);
	}
	;

algoritmo:
	{printf("\n		//////////Inicio de los bloques//////////\n");}BEGINP bloque  ENDP {printf("R10:BEGINP bloque ENDP es algoritmo\n");}{printf("\n		//////////Fin de los bloques//////////\n\n");}
	;

bloque:
	bloque sentencia {printf("R11:bloque sentencia es bloque\n\n");}
	|sentencia{printf("R12:sentencia es bloque\n\n");}
	;

sentencia:
	asignacion{printf("R13:asignacion es sentencia\n");}
	|seleccion{printf("R14:seleccion es sentencia\n");}
	|iteracion{printf("R15:iteracion es sentencia\n");}
	|untilloop{printf("R16:untilloop es sentencia\n");}
	|aplicardescuento{printf("R17:aplicardescuento es sentencia\n");}
	|read{printf("R18:read es sentencia\n");} 
	|write{printf("R19:write es sentencia\n");} 
	;

read:
	READ PA ID PC{
		printf("R20:READ PA ID PC es read\n");
		verificarIdEnTabla($3);
	}
	;
	
write:
	WRITE PA ID PC{
		printf("R20:WRITE PA ID PC es write\n");
		verificarIdEnTabla($3);
	}
	;

aplicardescuento:
	APLICARDESCUENTO PA descuento PC {
		printf("R21:APLICARDESCUENTO PA descuento PC es aplicardescuento\n");
	}
	;
	
descuento:
	CTE_REAL COMA CA lista CC COMA CTE{
		printf("R22:CTE_REAL COMA CA lista CC COMA CTE es descuento\n");
		if($1<0||$1>100){
			printf("ERROR: el monto de descuento tiene que ser mayor a 0 y menor a 100.");
			exit(1);
		}
		if(contador<$7){
			printf("ERROR: el indice es mayor a la cantidad de elementos.");
			exit(1);
		}
		contador=0;
	}
	|CTE COMA CA lista CC COMA CTE{
		printf("R23:CTE COMA CA lista CC COMA CTE es descuento\n");
		if($1<0||$1>100){
			printf("ERROR: el monto de descuento tiene que ser mayor a 0 y menor a 100.");
			exit(1);
		}
		if(contador<$7){
			printf("ERROR: el indice es mayor a la cantidad de elementos.");
			exit(1);
		}
		contador=0;
	}
	|CTE_REAL COMA CA CC COMA CTE{
		printf("ERROR: la lista de precios se encuentra vacia.");
		exit(1);
	}
	|CTE COMA CA CC COMA CTE{
		printf("ERROR: la lista de precios se encuentra vacia.");
		exit(1);
	}
	;

lista:
	CTE_REAL{
		printf("R24:CTE_REAL es lista\n");
		agregarCteFloatATabla(yylval.valor_real);
		contador++;
		}
	|lista COMA CTE_REAL{
		printf("R25:lista COMA CTE_REAL es lista\n");
		agregarCteFloatATabla(yylval.valor_real);
		contador++;
		}
	|CTE{
		printf("R26:CTE es lista\n");
		agregarCteATabla(yylval.valor_int);
		contador++;
		}
	|lista COMA CTE{
		printf("R27:lista COMA CTE es lista\n");
		agregarCteATabla(yylval.valor_int);
		contador++;
		}
	;

untilloop:
	UNTILLOOP PA CTE OP_MAY ID COMA asignacion PC {
		printf("R28:UNTILLOOP PA CTE OP_MAY ID COMA asignacion PC es un untilloop\n");
		if(strcmp($5,nom_id)<0){
			printf("ERROR: los ID son diferentes.");
			exit(1);
		}
		free(nom_id);
}
	;
	
iteracion:
	WHILE PA condiciones PC bloque ENDWHILE {printf("R29:WHILE PA condiciones PC bloque ENDWHILE es una iteracion\n");}
	;

seleccion:
	IF PA condiciones PC THEN bloque ENDIF{printf("R30:IF PA condiciones PC THEN bloque ENDIF es seleccion\n");}
	;

condiciones:
    condicion {printf("R31:condicion es condiciones\n");}
	|NOT condicion {printf("R32:NOT condicion es condiciones\n");}
    |condiciones AND condicion{printf("R33:condiciones AND condicion es condiciones\n");}
	|condiciones OR condicion{printf("R34:condiciones OR condicion es condiciones\n");}
	|condiciones AND NOT condicion{printf("R35:condiciones AND NOT condicion es condiciones\n");}
	|condiciones OR NOT condicion{printf("36:condiciones OR NOT condicion es condiciones\n");}
	;

condicion:
	 expresion OP_MEN expresion  {printf("R37:expresion OP_MEN expresion es condicion\n");}
	| expresion OP_MAY expresion  {printf("R38:expresion OP_MAY expresion es condicion\n");}
	| expresion OP_MENI expresion  {printf("R39:expresion OP_MENI expresion es condicion\n");}
	| expresion OP_MAYI expresion  {printf("R40:expresion OP_MAYI expresion es condicion\n");}
	| expresion OP_IGUAL expresion  {printf("R41:expresion OP_IGUAL expresion es condicion\n");}
	| expresion OP_DIST expresion  {printf("R42:expresion OP_DIST expresion es condicion\n");}
	;

asignacion: 
    ID OP_AS expresion {
		printf("R43:ID OP_AS Expresion es ASIGNACION\n");
		verificarIdEnTabla($1);
		nom_id=strdup($1);
	}
	;
	
expresion:
    termino {printf("R44:termino es Expresion\n");}
	|expresion OP_SUM termino {printf("R45:expresion+Termino es Expresion\n");}
	|expresion OP_RES termino {printf("R46:expresion-Termino es Expresion\n");}
	|expresion_cadena{printf("R47:expresion_cadena es Expresion\n");}
	;

expresion_cadena:
	CTE_STR {
		printf("R48:CTE_STR es expresion_cadena\n");
		agregarCteStringATabla(yylval.valor_string);
	}
	;

termino: 
    factor {printf("R49:factor es Termino\n");}
    |termino OP_MUL factor {printf("R50:termino*Factor es Termino\n");}
    |termino OP_DIV factor {printf("R51:termino/Factor es Termino\n");}
    ;

factor: 
    ID {
		printf("R52:ID es Factor \n");
		verificarIdEnTabla(yylval.valor_string);
	}
    | CTE {
		printf("R53:CTE es Factor\n");
		agregarCteATabla(yylval.valor_int);
	}
	| CTE_REAL {
		printf("R54:CTE_REAL es Factor\n");
		agregarCteFloatATabla(yylval.valor_real);
	}
	| PA expresion PC {printf("R55:PA expresion PC es Factor\n");}
    ;


%%


int main(int argc, char *argv[])
{
    if((yyin = fopen(argv[1], "rt"))==NULL)
    {
        printf("\nNo se puede abrir el archivo de prueba: %s\n", argv[1]);
       
    }
    else
    { 
         
        yyparse();
        
    }
	fclose(yyin);
        return 0;
}
int yyerror()
     {
       printf("Error Sintactico\n");
	 exit (1);
     }
	 
int buscarEnTabla(char * nombre){
   int i=0;
   while(i<=fin_tabla){
	   if(strcmp(tabla_datos[i].nombre,nombre) == 0){
		   return i;
	   }
	   i++;
   }
   return -1;
}

void agregarIdATabla(char* nombre){
	if(fin_tabla >= TAM_TABLA - 1){
		 printf("Error: No hay espacio, tabla llena.\n");
		 system("Pause");
		 exit(2);
	 }
	 if(buscarEnTabla(nombre) == -1){
		 fin_tabla++;
		 escribirNombreEnTabla(nombre, fin_tabla);
		 tabla_datos[fin_tabla].tipoDato=tipoDato;
	 }
	 else{
		printf("ERROR: Habia un ID repetido.\n");
		exit(1);
	 }
 }

void escribirNombreEnTabla(char* nombre, int pos){
	strcpy(tabla_datos[pos].nombre, nombre);
}


void guardarTabla(){
	if(fin_tabla == -1)
		yyerror();

	FILE* arch = fopen("symbol-table.txt", "w+");
	if(!arch){
		printf("No pude crear el archivo TablaSimbolo.txt\n");
		return;
	}

	for(int i = 0; i <= fin_tabla; i++){
		fprintf(arch, "%s\t\t", &(tabla_datos[i].nombre) );
		
		
		switch (tabla_datos[i].tipoDato){
		case Int:
			fprintf(arch,"%15s","INTEGER");
			break;
		case Real:
			fprintf(arch,"%15s","REAL");
			break;
		case String:
			fprintf(arch,"%15s","STRING");
			break;
		case Cte:
			fprintf(arch,"%15s%15d","CTE_INT",tabla_datos[i].valor_int);
			break;
		case CteReal:
			fprintf(arch,"%15s%15g" ,"CTE_REAL",tabla_datos[i].valor_real);
			break;
		case CteStr:
			fprintf(arch, "%15s\t%s\t%15d","CTE_STRING",tabla_datos[i].valor_string,tabla_datos[i].longitud );
			break;
		}
		
		fprintf(arch, "\n");
	}
	fclose(arch);
}


void verificarIdEnTabla(char* nombre){
	
	if( buscarEnTabla(nombre) == -1){
		printf("ERROR: se declaro una ID nuevo en esta seccion de codigo.");
		exit(1);
	}
}


void agregarCteATabla(int valor){
	if(fin_tabla >= TAM_TABLA - 1){
		printf("Error: No hay espacio, tabla llena.\n");
		system("Pause");
		exit(2);
	}

	
	char nombre[30];
	sprintf(nombre, "_%d", valor);


	if(buscarEnTabla(nombre) == -1){
		fin_tabla++;
		escribirNombreEnTabla(nombre, fin_tabla);
		tabla_datos[fin_tabla].tipoDato = Cte;
		tabla_datos[fin_tabla].valor_int = valor;
		
	}
}


void agregarCteFloatATabla(float valor){
	if(fin_tabla >= TAM_TABLA - 1){
		printf("Error: no hay espacio, tabla llena.\n");
		system("Pause");
		exit(2);
	}

	
	char nombre[12];
	sprintf(nombre, "_%g", valor);

	
	if(buscarEnTabla(nombre) == -1){
		fin_tabla++;
		escribirNombreEnTabla(nombre, fin_tabla);
		tabla_datos[fin_tabla].tipoDato =CteReal ;
		tabla_datos[fin_tabla].valor_real = valor;
	}
}

void agregarCteStringATabla(char* nombre){
	if(fin_tabla >= TAM_TABLA - 1){
		printf("Error: no hay espacio, tabla llena.\n");
		system("Pause");
		exit(2);
	}
	
	
	if(buscarEnTabla(nombre) == -1){
		
		fin_tabla++;
		escribirNombreEnTabla(nombre, fin_tabla);
		tabla_datos[fin_tabla].tipoDato = CteStr;
		strcpy(tabla_datos[fin_tabla].valor_string, nombre+1); 
		tabla_datos[fin_tabla].longitud = strlen(nombre) - 1;
	}
}
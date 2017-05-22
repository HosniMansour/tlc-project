#/bin/bash

flex -o projet.lex.c -l projet.l
byacc -o projet.tab.c -vd projet.y
gcc -o projet projet.lex.c projet.tab.c -lm -ll
./projet


// Project: MDI Tower Defense 
// Created: 2017-05-11

#include "initialise.agc"
#include "startscreen.agc"

global puntuacion =5
global vidas =1
global mousex as float
global mousey as float
global torres=10
global stack = 0
global stack2= 0
Initialise() 

initStartScreen()

do
	iniciar()
	salir()
    Sync()
loop



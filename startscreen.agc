#include "enemigo.agc"
#include "BotonTorre.agc"
#include "TorreA.agc"
#include "TorreB.agc"
#include "balas.agc"

function initStartScreen()
	// Creación de botones virtuales
	AddVirtualButton(1, displayWidth*0.5+6, displayHeight*0.6+20, 180)
	SetVirtualButtonText(1, "Jugar")
	AddVirtualButton(2, displayWidth*0.5+6, displayHeight*0.6+206, 180)
	SetVirtualButtonAlpha(2, 0)
	SetVirtualButtonText(2, "Salir")
	// Texto
	CreateText(3,"Ubica la torre en el mapa")
	SetTextColorAlpha (3, 0)
	SetTextSize(3,40)
	SetTextPosition(3,540,55)
endfunction

function salir()
	if GetVirtualButtonPressed(2) then end // Sale del juego
	if GetRawKeyPressed(27) then end // Con la tecla Esc sale del juego
endfunction

function iniciar()
	// Espera a que el boton Jugar se presione
	if GetVirtualButtonPressed(1)
		
		LoadImage(2, "CaminoFinal.png")	
		LoadImage (7, "towerDefense_tile249.png") //torre a
		LoadImage (8, "towerDefense_tile250.png") //torre b
		LoadImage(3, "towerDefense_tile248.png") //enemigo
		Loadimage (9, "fondotorre.png")
		LoadImage (10, "towerDefense_tile180.png") //base fija de las torres - no usada
		
		CreateSprite(2,2)
		crearEnemigo()
		initBullets()
		CrearBotonTorre ()	
		ResetTimer() // resetea el timer					
	
		while (vidas>0)	
			jugar()
		endwhile
	
		if (vidas = 0)
			SetSpriteVisible(3,0) //esconde al enemigo			
			ShowGameOverScreen()
		endif
		
	endif
endfunction

function jugar() //toda la función se repite while vidas>0
	
	// Carga el timer y borra los botones anteriores
		a#=timer()
		reloj(a#)
		SetVirtualButtonActive(1, 0)
		SetVirtualButtonVisible(1, 0)
		SetVirtualButtonActive(2, 0)
		SetVirtualButtonVisible(2, 0)
	
	// Inicia elementos	
			iniciarbotones()		//botonera para colocar torres
			indicadores()
			movEnemigos()
			LlegaALaBase()	
			
		if GetVirtualButtonPressed (3) // iniciar torre A si toca el boton
			torrea()
		
		elseif GetVirtualButtonPressed (5) // iniciar torre B si toca el boton
			torreb()	
		endif	  
		
		if stack >= 1
			SetSpriteImage (2,9)
			SetTextColorAlpha (3, 200)
			fijar ()
			colisiontorrea ()
		elseif stack2>=1
			SetSpriteImage (2,9)
			SetTextColorAlpha (3, 200)
			fijar2 ()
			colisiontorreb ()
		else
			SetSpriteImage (2,2)
			SetTextColorAlpha (3, 0)
		endif
		
		if i>0 // Cuando hay al menos una torre tipo A
			if GetRawKeyPressed(80) //Se dispara al presionar la P
				playerShoot()
			endif
			if GetSpriteDistance(3, torresA[i]) < 10 //Se dispara si la distancia es 10 pixeles
				playerShoot()				
			endif
			if enemigoRecibeBala()=1
				killEnemy()
				crearEnemigo()
			endif
		endif		
		
		UpdatePlayerBullet()
		sync()

endfunction
			
function indicadores()			
	// Muestra indicadores varios
		Print("X: "+str(GetSpriteX(3),1))
		Print("Y: "+str(GetSpriteY(3),1))
		Print ("Puntos: "+ str(puntuacion))
		Print ("Monedas: "+ str(monedas))
		Print ("Vidas: "+ str(vidas))

endfunction

function ShowGameOverScreen() 
	// Pantalla de game over cuando se terminan las vidas
		SetVirtualButtonVisible(3,0) //desaparecer el botón de la torre
		SetVirtualButtonVisible(4,0) //desaparecer el botón de la torre
		SetVirtualButtonVisible(5,0) //desaparecer el botón de la torreB
		SetVirtualButtonVisible(6,0) //desaparecer el botón de la torreB
		SetTextColorAlpha (3, 0)
		
		LoadImage(6,"GAMEOVER.png")
		CreateSprite(6,6)
		CreateText(2,"Presiona ESC para salir")
		SetTextSize(2,40)
		SetTextPosition(2,520,510)
endfunction

function reloj(sec as float) 
	// Reloj 
        local min as Float
        min = trunc(sec / 60.0)
        sec = sec - min * 60.0
        
        local ms as Float
        ms = sec - trunc(sec) 
        ms = ms * 100.0
        
        sec = trunc(sec)
        Print(right("00"+str(min,0),2)+":"+right("00"+str(sec,0),2))
endfunction

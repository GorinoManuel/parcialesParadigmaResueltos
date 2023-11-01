





































import objects.*

class Computadora{
	var property tamanioDisco
	var property tamanioMemoria
	var property programasEnEjecucion = []
	var property programasInstalados = []
	var property vulnerable = false
	
	
	//PUNTO 1
	method instalarPrograma(programa){
		if(self.sePuedeInstalar(programa)){
			throw new Exception(message = "No se cuenta con memoria suficiente para instalar este programa")
		}else {
			self.instalar(programa,programa.parteDelDiscoTotalAOcupar())
		}
	}

	method sePuedeInstalar(programa) = tamanioDisco > programa.parteDelDiscoTotalAOcupar()
	
	method instalar(programa,tamanioAOcupar){
		programasInstalados.add(programa)
		tamanioDisco -= tamanioAOcupar
	}
	
	// PUNTO 21
	method ejecutarPrograma(programa){
		if(self.puedeSerEjecutado(programa)){
			programasEnEjecucion.add(programa)
			self.modificarMemoria(programa.memoriaAOcupar())
			programa.ejecutar(self)
		}
	}
	
	method puedeSerEjecutado(programa){
		return self.estaInstalado(programa) && self.noEstaSiendoEjecutado(programa) && self.hayMemoriaPara(programa)
	}
	
	method modificarMemoria(cantidad){ 
		tamanioMemoria -= cantidad
	}
	
	method modificarEspacioDisco(cantidad){ tamanioDisco -= cantidad }
	
	method estaInstalado(programa) = programasInstalados.contains(programa)
	
	method noEstaSiendoEjecutado(programa) = not programasEnEjecucion.contains(programa)
	
	method hayMemoriaPara(programa) = tamanioMemoria <= programa.memoriaTotalAOcupar()
	
	method cuantasVecesFueEjecutado(programa) = programa.vecesQueSeEjecutoEn(self)
	
	
	// PUNTO 3
	method detenerPrograma(programa){
		
		programasEnEjecucion.remove(programa)
		self.liberarMemoria(programa.memoriaAOcupar())
	}

	method liberarMemoria(cantidad){ tamanioMemoria -= cantidad}
	
	
	// PUNTO 4
	method programaQueMasMemoriaConsume() = programasEnEjecucion.max{ p => p.memoriaAOcupar() }
	
	method alunoEsMuyPesado() = programasInstalados.any{ p => p.parteDelDisco() > tamanioDisco/2 }
		
		
	method desinstalar(programa){
		programasInstalados.remove(programa)
		self.modificarMemoria(-programa.memoriaAOcupar())
		self.modificarEspacioDisco(-programa.parteDelDisco())
	}
	
}	

object conjuntoDeComputadoras{
	var property computadoras = []
	
	method sePuedeInstalar(programa) = computadoras.filter{ c => c.sePuedeInstalar(programa) }
	
	
}
















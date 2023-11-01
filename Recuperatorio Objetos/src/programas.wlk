class Programa{
	var property parteDelDisco
	var property memoriaAOcupar
	var property maquinasEnLasCualFueEjecutado = []
	var property hospedadores = []
	
	method vecesQueSeEjecutoEn(maquina) = maquinasEnLasCualFueEjecutado.count{ m => m == maquina }
	
	method memoriaTotalAOcupar() = memoriaAOcupar + self.memeoriaTotalDeHospedadores()
	
	method parteDelDiscoTotalAOcupar() = parteDelDisco + self.parteDelDiscoTotalDeHospedadores()
	
	method memeoriaTotalDeHospedadores() = hospedadores.sum{ h => h.memoriaAOcupar() }
	
	method parteDelDiscoTotalDeHospedadores() = hospedadores.sum{ h => h.parteDelDisco() }
	
	method ejecutar(maquina) = hospedadores.forEach{ h => h.efectoMalicioso(maquina) }
	
	method esSano() = hospedadores.size() == 0
}

class ProgramaMalicioso{
	var property parteDelDisco
	var property memoriaAOcupar
	
	method hospedarseEn(programa) = programa.hospedadores().add(self)
	
	method impacto(maquina)
	
}
class Troyano inherits ProgramaMalicioso{

	method efectoMalicioso(maquina) = maquina.vulnerable(true)

}

class Virus inherits ProgramaMalicioso{
	var property potencia
	
	method efectoMalicioso(maquina) = self.noTienenElVirus(maquina).forEach{ p => p.hospedadores().add(self) }
	
	method seEjecutoMasVeces(maquina) = maquina.programasInstalados().filter{ p => p.vecesQueSeEjecutoEn(maquina) > potencia }

	method noTienenElVirus(maquina) = self.seEjecutoMasVeces(maquina).filter{ p => not p.hospedadores().contains(self) }
	
}

class Destructor inherits ProgramaMalicioso{
	var property cantidadDeEjecuciones
	
	method efectoMalicioso(maquina){ self.desinstalarPrograma(maquina) }
	
	method desinstalarPrograma(maquina){
		cantidadDeEjecuciones -= 1
		if(cantidadDeEjecuciones > 0){
			maquina.desinstalar(maquina.programasEnEjecucion().last())// el ultimo que se esta corriendo es el ultimo de la lista
		}
	}

}

class VirusInteligente inherits ProgramaMalicioso{
	
	method efectoMalicioso(maquina){ 
		self.romperMemoria(maquina) //deja a la memoria en 0
		maquina.programasInstalados().forEach{ p => self.hospedarseEn(p)}//se hospeda en todos los programas
	}
	method romperMemoria(maquina) = maquina.tamanioMemoria(0)
	
}

object conjuntoDeVirus{
	var property virus = []
	
	method cantidadDeProgramasQueInfecto(maquina) = maquina.programasInstalados().hospedadores().count{ h => maquina.programasInstalados().hospedadores() == h}
	
	method virusDeMayorImpacto(maquina) = virus.sortedBy{ a,b => a.cantidadDeProgramasQueInfecto(maquina) > b.cantidadDeProgramasQueInfecto(maquina)}.take(3)
	
}


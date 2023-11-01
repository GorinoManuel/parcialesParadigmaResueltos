object Universo{
	const tiempoEspecificado= 200
	method tiempoEspecificado()=tiempoEspecificado
}
class Jugador {
	var recursos = []
	var personajes = []
	method recursos() = recursos
	method recursosValiosos() = recursos.filter{r=>r.recursoValioso()}.size()
	method atrapadasTotal() = personajes.sum{p=> p.cantAtrapadas()}
	method mayorAtrapadas() = personajes.max{p=>p.cantAtrapadasMayorA10()}
	method jugadoresAdversarios() = personajes.flatMap({p=>p.atrapadasMenorA10()}).map({a=>a.jugadorAdversario()}).withoutDuplicates()
}
class Personaje {
	var jugador
	var property atrapadas = []
	method addAtrapada(atrapada)= atrapadas.add(atrapada)
	method jugador() = jugador
	method cantAtrapadas() =  atrapadas.size()
	method cantAtrapadasMayorA10() = atrapadas.count{a=>a.puntajeMayorA10()}
	method atrapadasMenorA10() = atrapadas.filter{a=>a.puntajeMenorIgual10()}
	method atrapa(pAtrapado, tiempo, puntos){
		const atrapada = new Atrapada(personajeAtrapado=pAtrapado, tiempo = tiempo, puntaje = puntos)
		self.addAtrapada(atrapada)
		jugador.recursos().forEach{r => r.aumentar(atrapada, jugador)}
		atrapada.jugadorAdversario().recursos().forEach{r => r.disminuir(atrapada,jugador)}
	} 
	
}
class Atrapada {
	var personajeAtrapado
	var tiempo
	var puntaje
	method tiempo() = tiempo
	method puntaje() = puntaje
	method personajeAtrapado() = personajeAtrapado
	
	method puntajeMayorA10() = self.puntaje() > 10
	method puntajeMenorIgual10() = not self.puntajeMayorA10()
	method jugadorAdversario() = self.personajeAtrapado().jugador()
	
	method pasaTiempoEspecificado() = tiempo>Universo.tiempoEspecificado()
}

class Recurso{
    var cantidad
    var cotizacion = 100	
	method cambiarCotizacion(nuevaCotizacion){
		cotizacion = nuevaCotizacion
	}
    method valor() = cantidad * cotizacion
	method recursoValioso()= self.valor() > 100
    method formulaRara(atrapada) = atrapada.tiempo() * atrapada.puntaje()
    method aumentar(atrapada,personaje){
    	if (atrapada.pasaTiempoEspecificado())cantidad+=self.formulaRara(atrapada) cantidad += atrapada.puntaje()
    }
    method disminuir(atrapada,personaje)
}
//En mi opinion la implementacion de la formula rara debe ir en Recurso ya que en este esta aumentar, entonces se
//va a cambiar solo aca como se modifican los recursos y va a funcionar para todos los recursos
class Gema inherits Recurso{
    var property nivelImportancia

    override method valor() = super() * self.nivelImportancia()
	
	override method disminuir(atrapada,personaje){
		cantidad -= atrapada.puntaje() * nivelImportancia
	}
}
class Huevo inherits Recurso{
	var tamanio
	method tamanio() = tamanio
    override method valor() = super() * tamanio
	
    override method aumentar(atrapada,personaje){
    	cantidad += 10 
    }
}
class Constructivo inherits Recurso{
}
//Justificacion
//Aca se puede apreciar como gracias al concepto de polimorfismo y herencia, se puede agregar un nuevo recurso
//facilmente sin tener que cambiar logica de arriba, ya que al atrapar untiza para todos los recursos su 
//funcion aumentar/disminuir(que es distinta para cada recurso), entonces se le puede agregar logica al recurso nuevo sin cambiar nada.
//En el ejemplo del huevo hago que siempre aumente 10 en cantidad y tambien el valor cambia(se multiplica por el tamanio)
class Personalizado inherits Recurso{
    var personajesBeneficiados=[]
	method addPersonajeBeneficiado(personaje) = personajesBeneficiados.add(personaje)
    override method aumentar(atrapada,personaje){
        if(personajesBeneficiados.contains(personaje)) cantidad=cantidad*2  super(atrapada,personaje)
     }

}

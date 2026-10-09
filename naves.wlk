class Nave{
  var property velocidad = 0
  var property direccion = 0
  var property combustible = 0

  method acelerar(cuanto){
    velocidad = cuanto.min(100000).max(0)
  }

  method desacelerar(cuanto){
    velocidad = cuanto.max(0)
  }

  method cargarCombustible(cantidad){
    combustible = cantidad
  }
  
  method estaTranquila(){
    return self.combustible() > 4000 and self.velocidad() < 12000
  }

  method irHaciaElSol(){
    direccion = 10 
  }

  method escaparDelSol(){
    direccion = -10
  }

  method ponerseParaleloAlSol(){
    direccion = 0
  }
  method acercarseUnPocoAlSol(){
    direccion = (direccion + 1).min(10)
  }

  method alejarseUnPocoDelSol(){
   direccion = (direccion - 1).max(-10)
  }

  method recibirAmenaza() {}

  method escapar() {}

  method avisar() {}

  method estaDeRelajo(){
    return self.estaTranquila() and self.tienePocaActividad()
  }
  method tienePocaActividad()
}

class NavesBaliza inherits Nave{
  var color = "verde"
  var property cambiosDeColor = 0

  method color() { return color}
  method cambiarColorDeBaliza(colorNuevo){
    color = colorNuevo
    cambiosDeColor += 1
  } 
  method esVerde(){
    return color == "verde"
  }

  method esRoja(){
    return color == "rojo"
  }

  method prepararViaje(){
    self.cambiarColorDeBaliza("verde")
    self.cargarCombustible(30000)
    self.ponerseParaleloAlSol()
    self.acelerar(5000)
  }

  override method estaTranquila(){
    return super() and not self.esRoja()
  }

  override method recibirAmenaza(){
    self.escapar()
    self.avisar()
  }
  override method escapar() {
    self.irHaciaElSol()
  }

  override method avisar() {
    self.cambiarColorDeBaliza("rojo")
  }

  override method tienePocaActividad(){
    return cambiosDeColor == 0
  }
}

class NavesDePasajeros inherits Nave{
  var property pasajeros = 0
  var property bebida = 0
  var property comida = 0
  var property comidaRepartida = 0
 
  method cargarComida(cantidad){
    comida = cantidad
  }

  method cargarBebida(cantidad){
    bebida = cantidad
  }

  method descargarNave(cantidad){
    bebida = cantidad.max(0)
    comida = cantidad.max(0)
  }

  method prepararViaje(){
    self.cargarComida(4)
    self.cargarBebida(6)
    self.cargarCombustible(30000)
    self.acercarseUnPocoAlSol()
  }

  override method recibirAmenaza() {
    self.escapar()
    self.avisar()
  }

  override method escapar() {
    velocidad = self.velocidad() * 2
  }

  method repartirComida(cantidad){
    comida = comida - cantidad.max(0)
    comidaRepartida = comidaRepartida + cantidad.max(0)
  }
  method repartirBebida(cantidad){
    bebida = bebida - cantidad.max(0)
  }

  override method avisar(){
    self.repartirComida(pasajeros * 1)
    self.repartirBebida(pasajeros * 2)
  }

  override method tienePocaActividad(){
    return comidaRepartida < 50
  }
}

class NaveHospital inherits NavesDePasajeros{
  var quirofano = true
  var property tieneQuirofanoPreparado = true

  method tieneQuirofano() {
    quirofano = true
  }

  method noTieneQuirofano(){
    quirofano = false
  }

  method tieneQuirofanoPreparado() {
    return tieneQuirofanoPreparado
  }

  override method estaTranquila(){
   return super() and self.tieneQuirofanoPreparado()
  }

  method prepararQuirofano(){
      if (not self.tieneQuirofanoPreparado()) {
        tieneQuirofanoPreparado = true
      }
  }
  override method recibirAmenaza() {
    super();
    self.prepararQuirofano()
  }
}
class NavesDeCombate inherits Nave{
  var estaVisible = true
  var estaDesplegado = true

  const mensajes = [] 

  method ponerseVisible(){
    estaVisible = true
  }
  method ponerseInvisible(){
    estaVisible = false
  }

  method desplegarMisiles(){
    estaDesplegado = true
  }

  method misilesPlegados(){
    estaDesplegado = false
  }

  method emitirMensaje(mensaje) {
    mensajes.add(mensaje)
  }

  method mensajesEmitidos(){
    return mensajes
  }

  method primerMensajeEmitido(){
    mensajes.first()
  }
  method ultimoMensajeEmitido(){
    mensajes.last()
  }

  method emitioMensaje(mensaje){
    mensajes.contains(mensaje)
  }

  method esEscueta(){
    return mensajes.all({m => m.size() <= 30})
  }

  method prepararViaje(){
    self.ponerseVisible()
    self.desplegarMisiles()
    self.cargarCombustible(30000)
    self.acelerar(15000)
    self.acelerar(5000)
    self.emitioMensaje("Saliendo en misión")
  }

  override method estaTranquila(){
    return super() and not estaDesplegado
  }

  override method recibirAmenaza() {
    self.escapar()
    self.avisar()
  }

  override method escapar() {
    self.acercarseUnPocoAlSol()
    self.acercarseUnPocoAlSol()
  }

  override method avisar(){
    self.emitioMensaje("Amenaza recibida")
  }

  override method tienePocaActividad(){}
}
class NaveDeCombateSigilosa inherits NavesDeCombate{

  override method estaTranquila() {
    return super() and estaVisible
  }
  override method recibirAmenaza(){
    super();
    self.desplegarMisiles()
    self.ponerseInvisible()
  }
}
# MAP DESIGN — UNIVERSO ARCADE

**Versión:** 0.2  
**Estado:** Salón principal construido; ampliaciones pendientes  
**Última actualización:** Noviembre de 2026  
**Lema:** INSERT COIN. PLAY FOREVER.

---

# 1. Visión general

Universo Arcade es un salón recreativo virtual inspirado en los establecimientos arcade de los años 80 y 90, reinterpretado mediante una estética retrofuturista oscura, iluminación de neón y elementos geométricos originales.

El mapa está diseñado para ofrecer un espacio reconocible, fácil de recorrer y preparado para recibir nuevas zonas y experiencias mediante futuras actualizaciones.

El salón principal constituye el núcleo inicial de la experiencia. Su arquitectura está construida mediante scripts Luau y piezas nativas de Roblox, manteniendo una estructura modular que facilita su mantenimiento y ampliación.

El diseño prioriza:

- Una distribución clara de las cuatro salas iniciales.
- Un núcleo central que conecta las diferentes zonas.
- Corredores que facilitan la circulación.
- Identidad visual propia para cada minijuego.
- Espacios reservados para futuras expansiones.
- Una arquitectura que no requiera reconstruir las zonas existentes para seguir creciendo.

# 2. Dimensiones del salón principal

El salón principal tiene unas dimensiones definitivas de:

| Información | Valor |
|---|---:|
| Anchura | 120 studs |
| Profundidad | 100 studs |
| Superficie | 12.000 studs² |
| Centro del mapa | (0, 0, 0) |
| Altura de paredes | 16 studs |
| Grosor del suelo | 1 stud |
| Diámetro del núcleo central | 20 studs |
| Anchura de corredores principales | 10 studs |

La distribución utiliza el centro del mapa como referencia para calcular las posiciones de las diferentes estructuras.

Orientación:

- Norte: eje Z negativo.
- Sur: eje Z positivo.
- Oeste: eje X negativo.
- Este: eje X positivo.

Las dimensiones y posiciones principales están centralizadas en `src/shared/Config/MapConfig.luau`.

La configuración actual define las dimensiones del salón, el centro, la altura del suelo, el núcleo central, los corredores y los colores de las cuatro zonas.

# 3. Dirección artística

## 3.1. Estética

La dirección artística combina elementos de los salones recreativos clásicos con una ambientación futurista.

Características principales:

- Inspiración arcade de los años 80 y 90.
- Ambiente oscuro y ligeramente espacial.
- Superficies geométricas.
- Arquitectura modular.
- Iluminación ambiental de tonos morados y azulados.
- Elementos de neón cian, magenta y otros colores de acento.
- Máquinas recreativas diferenciadas por temática.
- Decoración integrada en las superficies arquitectónicas.

El resultado busca transmitir la sensación de un salón recreativo clásico reinterpretado como un espacio futurista.

## 3.2. Paleta de colores

La paleta general utiliza:

| Color | Aplicación |
|---|---|
| Negro azulado | Suelo y superficies principales |
| Morado | Iluminación ambiental y detalles |
| Cian | Elementos tecnológicos y señalización |
| Azul eléctrico | Decoración y elementos de las salas |
| Magenta | Acentos y elementos decorativos |
| Naranja y amarillo | Detalles de Brick Breaker |
| Blanco | Iluminación funcional |

Se evita utilizar superficies excesivamente claras y una iluminación demasiado intensa.

La decoración debe mantener una buena visibilidad y no competir con las máquinas.

# 4. Distribución del edificio

## 4.1. Estructura general

El salón principal se organiza en cuatro cuadrantes conectados mediante corredores y un núcleo central.

La distribución permite identificar cada zona desde el espacio principal y desplazarse entre ellas sin atravesar otras salas.

Las cuatro zonas iniciales son:

| Cuadrante | Minijuego | Identidad visual |
|---|---|---|
| Noroeste | Block Puzzle | Cian y azul |
| Noreste | Bubble Shooter | Magenta y rosa |
| Suroeste | Space Shooter | Azul y morado |
| Sureste | Brick Breaker | Naranja y amarillo |

Cada sala dispone de siete máquinas arcade, formando un total de 28 máquinas en el salón principal.

## 4.2. Núcleo central

El núcleo central es el punto de conexión entre las cuatro salas.

Características:

- Diámetro aproximado de 20 studs.
- Posición central en el mapa.
- Conexión con los cuatro corredores principales.
- Punto de referencia para orientarse dentro del salón.
- Ubicación del punto de aparición inicial de los jugadores.

El núcleo central debe mantenerse despejado para facilitar la circulación.

## 4.3. Corredores

El salón dispone de cuatro corredores principales de 10 studs de anchura.

Cada corredor conecta el núcleo central con una de las zonas recreativas.

Los corredores mantienen un diseño visual sencillo, con superficies diferenciadas del suelo general para facilitar la orientación.

No deben convertirse en espacios excesivamente decorados que dificulten el tránsito.

## 4.4. Salas de minijuegos

Cada sala dispone de una identidad visual propia y de una distribución de máquinas adaptada a su temática.

**Block Puzzle**

- Ubicación: noroeste.
- Colores principales: cian y azul.
- Decoración geométrica inspirada en bloques y cuadrículas irregulares.
- Máquinas dedicadas a Block Puzzle.

**Bubble Shooter**

- Ubicación: noreste.
- Colores principales: rosa y magenta.
- Decoración basada en curvas, arcos y trayectorias entrelazadas.
- Máquinas dedicadas a Bubble Shooter.

**Space Shooter**

- Ubicación: suroeste.
- Colores principales: azul eléctrico y morado.
- Decoración basada en diagonales, trayectorias y formas angulares.
- Máquinas dedicadas a Space Shooter.

**Brick Breaker**

- Ubicación: sureste.
- Colores principales: naranja y amarillo.
- Decoración basada en bloques escalonados y composiciones inspiradas en ladrillos.
- Máquinas dedicadas a Brick Breaker.

Las salas están separadas parcialmente mediante paredes y elementos arquitectónicos. Las divisiones permiten diferenciar los espacios sin convertir el salón en un conjunto de habitaciones completamente aisladas.

# 5. Arquitectura y construcción

## 5.1. Estructura física

El salón principal dispone actualmente de:

- Suelo general.
- Cuatro salas delimitadas.
- Núcleo central.
- Cuatro corredores.
- Paredes exteriores.
- Separaciones interiores.
- Marcos y estructuras arquitectónicas.
- Techo compuesto por paneles y vigas.
- Accesos reservados para futuras ampliaciones.

La geometría principal se genera mediante `MapBuilder.luau`.

La construcción está organizada mediante funciones que permiten generar los diferentes componentes del escenario sin tener que colocarlos manualmente en Roblox Studio.

## 5.2. Techo

El salón dispone de un techo construido mediante cuatro paneles principales y una estructura de vigas.

La construcción cubre la superficie del salón manteniendo libres los accesos exteriores reservados para futuras expansiones.

El techo y sus elementos estructurales se consideran terminados y aprobados.

No deberán modificarse innecesariamente durante la implementación de los sistemas jugables.

## 5.3. Suelo

El suelo general utiliza una superficie oscura de aspecto similar a una moqueta arcade.

Sus características son:

- Tonalidad negro azulada.
- Material Fabric.
- Base visual oscura.
- Patrones geométricos decorativos distribuidos por las cuatro salas.

Los corredores utilizan un acabado diferenciado y uniforme para distinguir las zonas de circulación.

El núcleo central permanece libre de patrones decorativos para mantener su función como espacio de conexión.

## 5.4. Paredes

Las paredes interiores incorporan patrones geométricos integrados en sus superficies.

Cada sala dispone de una composición propia:

- Block Puzzle: bloques geométricos y cuadrículas irregulares.
- Bubble Shooter: curvas y trayectorias entrelazadas.
- Space Shooter: diagonales y formas angulares.
- Brick Breaker: bloques escalonados y composiciones de ladrillos.

Los patrones utilizan tonos oscuros con acentos de color relacionados con cada sala.

También existen elementos decorativos superiores que aportan identidad visual sin alterar la estructura de las paredes.

La colocación definitiva de algunos pósteres todavía necesita ajustes para que queden sobre los tramos de pared y no sobre los marcos de las puertas.

## 5.5. Máquinas arcade

El salón principal dispone de 28 máquinas:

- 7 máquinas de Block Puzzle.
- 7 máquinas de Bubble Shooter.
- 7 máquinas de Space Shooter.
- 7 máquinas de Brick Breaker.

Las máquinas están distribuidas dentro de sus respectivas salas.

La integración funcional todavía está pendiente.

El siguiente objetivo será implementar un sistema común de interacción, disponibilidad, reservas y sesiones que permita utilizar las máquinas sin duplicar la lógica entre minijuegos.

# 6. Iluminación

La iluminación del salón se ha implementado mediante servicios independientes.

## 6.1. Iluminación ambiental

`LightingService.luau` configura la iluminación general del entorno.

Incluye:

- Ambiente oscuro.
- Tonos azulados y morados.
- Ajustes de exposición y contraste.
- Bloom.
- ColorCorrection.
- Atmosphere.

Su objetivo es crear una ambientación retrofuturista sin oscurecer excesivamente las zonas de juego.

## 6.2. Iluminación arquitectónica

`ArcadeLightingService.luau` genera la iluminación funcional del salón.

Distribución actual:

| Zona | Focos |
|---|---:|
| Cuatro salas | 16 |
| Corredores | 12 |
| Núcleo central | 4 |
| Total | 32 |

Los focos utilizan iluminación blanca para mantener la visibilidad de las máquinas y de las zonas de circulación.

El núcleo central incorpora además cuatro elementos LED decorativos.

La iluminación arquitectónica se considera aprobada y no debe modificarse sin una necesidad justificada.

# 7. Arquitectura modular y futuras expansiones

El edificio está diseñado para crecer mediante nuevas habitaciones, pasillos y zonas temáticas.

Se han reservado puntos de conexión para futuras ampliaciones.

En la configuración actual se contemplan accesos de expansión al norte, este y oeste.

Las futuras habitaciones podrán conectarse al edificio principal sin tener que reconstruir el salón inicial.

Las ampliaciones podrán incluir:

- Nuevos pasillos.
- Habitaciones adicionales.
- Nuevas zonas temáticas.
- Nuevos minijuegos.
- Máquinas especiales.
- Experiencias adicionales.

Los accesos reservados no deberán bloquearse mediante nuevas paredes, techos u otros elementos arquitectónicos.

# 8. Salas desbloqueables y acceso individual

Las futuras salas podrán desbloquearse mediante Arcade Tokens (AT).

Reglas de diseño:

- El acceso será permanente e individual.
- Cada sala nueva incluirá al menos dos minijuegos gratuitos.
- Ninguna máquina requerirá un pago individual.
- Los minijuegos incluidos estarán disponibles al desbloquear la sala.
- Los jugadores podrán conseguir todo el contenido jugable mediante progresión gratuita.
- Las compras opcionales podrán acelerar la progresión, pero no serán necesarias.

## 8.1. Acceso visual individual

Cada jugador verá las puertas y accesos según sus propios desbloqueos.

Un jugador podrá ver una puerta abierta mientras otro jugador del mismo servidor ve esa misma puerta cerrada.

La presentación visual será responsabilidad del cliente, pero el servidor tendrá siempre la autoridad para validar el acceso real.

No se confiará únicamente en ocultar puertas o bloquear visualmente los accesos.

Este sistema todavía está pendiente de implementación.

# 9. Entrada, zona social y parking

Estas zonas forman parte de la planificación futura del edificio, pero no están construidas actualmente.

Se desarrollarán después de disponer de las funcionalidades jugables fundamentales.

**Entrada principal**

Se prevé incorporar:

- Acceso al salón.
- Cartel principal de Universo Arcade.
- Lema del proyecto.
- Señalización de las diferentes zonas.

**Zona social**

Se prevé incorporar:

- Espacios de reunión.
- Elementos de interacción social.
- Información general.
- Acceso a futuras clasificaciones y récords.

**Pasillo de acceso**

Conectará la entrada con el salón principal mediante una transición visual y ambiental.

**Parking**

Se construirá fuera del salón principal, como una zona independiente de acceso al edificio.

La entrada, el pasillo y el parking no deben confundirse con los corredores interiores que conectan las cuatro salas.

# 10. Cámaras y experiencia de juego

En el salón principal se utilizará la cámara habitual de Roblox, permitiendo explorar el entorno en primera o tercera persona.

Durante los minijuegos se utilizará una cámara adaptada a cada experiencia.

Diseños previstos:

- Block Puzzle: cámara enfocada en el tablero.
- Bubble Shooter: cámara centrada en el área de disparo.
- Space Shooter: cámara adaptada al desplazamiento y combate espacial.
- Brick Breaker: cámara frontal o lateral enfocada en la zona de juego.

El personaje no deberá obstaculizar la visión ni los controles del minijuego.

La transición entre la exploración del salón y la utilización de las máquinas está pendiente de implementación.

# 11. Rendimiento y mantenimiento

El mapa deberá mantener un rendimiento adecuado en Roblox.

Se evitará:

- Exceso de luces dinámicas.
- Demasiadas piezas innecesarias.
- Decoración excesivamente compleja.
- Scripts individuales para cada elemento cuando pueda utilizarse un sistema compartido.
- Modificaciones constantes de la geometría ya aprobada.

Se favorecerán:

- Componentes reutilizables.
- Configuración centralizada.
- Generación mediante scripts Luau.
- Servicios independientes para cada responsabilidad.
- Organización clara de los elementos dentro de Workspace.

La construcción visual y arquitectónica no deberá interferir con la implementación de las funcionalidades jugables.

# 12. Organización técnica del mapa

Los principales componentes de construcción se encuentran organizados en:

`src/server/Services/`

Servicios actuales relacionados con el escenario:

| Servicio | Responsabilidad |
|---|---|
| MapBuilder | Construcción de la geometría principal del mapa |
| LightingService | Configuración de la iluminación ambiental |
| ArcadeLightingService | Iluminación funcional y arquitectónica |
| WallArchitectureService | Patrones geométricos de las paredes |
| WallDecorationService | Elementos decorativos superiores |
| WallPosterService | Generación de pósteres decorativos |

La configuración general del mapa se encuentra en:

`src/shared/Config/MapConfig.luau`

El punto de entrada del servidor se encuentra en:

`src/server/Main.server.luau`

La inicialización construye primero el mapa y sus elementos asociados, y después aplica la iluminación.

El punto de aparición de los jugadores se crea dentro del núcleo central.

# 13. Desarrollo por etapas

## Etapa 1 — Construcción del salón principal

**Estado: Completada y aprobada.**

- [x] Establecer las dimensiones definitivas.
- [x] Crear el suelo general.
- [x] Construir las cuatro salas.
- [x] Crear el núcleo central.
- [x] Construir los cuatro corredores.
- [x] Construir las paredes y separaciones.
- [x] Crear la arquitectura perimetral.
- [x] Reservar accesos para futuras expansiones.
- [x] Construir el techo.
- [x] Colocar las 28 máquinas.

## Etapa 2 — Ambientación del salón principal

**Estado: Implementada en gran parte.**

- [x] Configurar la iluminación ambiental.
- [x] Implementar la iluminación arquitectónica.
- [x] Decorar el suelo.
- [x] Incorporar patrones geométricos en las paredes.
- [x] Incorporar elementos decorativos superiores.
- [x] Crear el punto de aparición.
- [ ] Ajustar la colocación definitiva de los pósteres.
- [ ] Revisar y completar los últimos detalles decorativos.

La iluminación y la arquitectura principal están aprobadas.

## Etapa 3 — Funcionalidad de las máquinas

**Estado: Pendiente. Próxima prioridad.**

- [ ] Identificar las máquinas mediante registros únicos.
- [ ] Implementar la interacción.
- [ ] Mostrar la disponibilidad.
- [ ] Gestionar reservas.
- [ ] Crear sesiones individuales.
- [ ] Integrar la interfaz de juego.
- [ ] Implementar la entrada y salida de partidas.
- [ ] Gestionar abandonos y desconexiones.

## Etapa 4 — Minijuegos

**Estado: Pendiente.**

- [ ] Implementar Block Puzzle.
- [ ] Implementar Bubble Shooter.
- [ ] Implementar Space Shooter.
- [ ] Implementar Brick Breaker.
- [ ] Integrar los cuatro minijuegos con el sistema común de sesiones.
- [ ] Implementar puntuaciones y récords personales.

## Etapa 5 — Ampliación del edificio

**Estado: Pendiente.**

- [ ] Construir la entrada principal.
- [ ] Crear el pasillo de acceso.
- [ ] Diseñar la zona social.
- [ ] Construir el parking.
- [ ] Completar la señalización general.
- [ ] Incorporar elementos ambientales adicionales.

## Etapa 6 — Expansiones y progresión

**Estado: Planificado.**

- [ ] Implementar Arcade Tokens.
- [ ] Implementar desbloqueos permanentes.
- [ ] Implementar accesos individuales.
- [ ] Incorporar nuevas salas.
- [ ] Añadir nuevos minijuegos y máquinas.

# 14. Principios fundamentales

1. El mapa debe poder ampliarse sin reconstruir las zonas existentes.
2. Las cuatro salas iniciales deben ser reconocibles y fáciles de encontrar.
3. La estética debe mantenerse coherente con la identidad retrofuturista.
4. Las máquinas deben poder integrarse con sistemas comunes.
5. Los accesos a futuras salas serán individuales.
6. Ninguna máquina requerirá un pago para jugar.
7. El rendimiento tendrá prioridad frente a la decoración innecesaria.
8. La geometría y la iluminación aprobadas no deberán modificarse sin una necesidad justificada.
9. La construcción deberá mantenerse mediante scripts y componentes reutilizables.
10. El mapa debe poder mantenerse y ampliarse sin depender de herramientas externas de modelado 3D.

---

*Este documento describe el diseño físico y visual de Universo Arcade. Las funcionalidades de interacción, progresión y acceso se desarrollarán de acuerdo con el roadmap y la arquitectura técnica del proyecto.*
# Universo Arcade — Game Design Document

| Información | Detalle |
|---|---|
| Nombre del proyecto | Universo Arcade |
| Género | Arcade / Minijuegos / Social |
| Plataforma | Roblox |
| Público objetivo | Jugadores de Roblox interesados en experiencias arcade y competición casual |
| Estado | En desarrollo |
| Versión del documento | 0.3 |
| Versión objetivo inicial | 0.1 |
| Última actualización | Noviembre de 2026 |
| Idioma base | Inglés |
| Idioma adicional inicial | Español |

**Lema:** INSERT COIN. PLAY FOREVER.

---

# 1. Visión general

## 1.1. Concepto

Universo Arcade es una experiencia de Roblox inspirada en los salones recreativos clásicos de los años 80 y 90.

Los jugadores podrán explorar un salón recreativo, descubrir diferentes máquinas arcade e iniciar partidas individuales de distintos minijuegos.

Cada máquina representará una experiencia de juego independiente. Los jugadores podrán competir por conseguir sus mejores puntuaciones, superar sus propios récords y, en futuras versiones, comparar sus resultados con amigos y con la comunidad.

El objetivo es combinar la nostalgia de los salones recreativos tradicionales con las posibilidades sociales y técnicas de Roblox.

## 1.2. Pilares del diseño

El desarrollo de Universo Arcade se apoyará en cinco pilares:

1. **Diversión inmediata:** los jugadores deben poder acercarse a una máquina y empezar a jugar sin procesos innecesarios.
2. **Variedad:** cada máquina ofrecerá una experiencia de juego diferente.
3. **Competición:** las puntuaciones y los récords personales proporcionarán objetivos a largo plazo.
4. **Identidad visual:** el salón debe transmitir la personalidad de un arcade retro, colorido y reconocible.
5. **Arquitectura escalable:** añadir nuevas máquinas y minijuegos no debería obligar a rehacer los sistemas existentes.

---

# 2. Ambientación y dirección artística

## 2.1. Ambientación

El escenario principal será un salón recreativo inspirado en los establecimientos arcade de las décadas de 1980 y 1990.

La dirección artística combina elementos retro y futuristas: geometría sencilla, superficies oscuras, patrones geométricos, colores neón controlados y elementos decorativos inspirados en la tecnología arcade.

El entorno deberá transmitir una sensación acogedora, divertida y ligeramente nostálgica.

La arquitectura y la iluminación del salón principal ya cuentan con una primera implementación aprobada. Las siguientes tareas visuales se centrarán en los detalles decorativos pendientes y en las futuras zonas del edificio.

## 2.2. Elementos visuales

El salón principal incorpora o contempla los siguientes elementos:

- Suelo oscuro de estética arcade, con acabado similar a una moqueta y patrones geométricos.
- Caminos de color diferenciado que conectan las salas con el núcleo central.
- Máquinas arcade con diseños y colores diferenciados.
- Cuatro salas temáticas.
- Arquitectura interior y exterior del salón.
- Techo estructural y elementos arquitectónicos.
- Iluminación ambiental y focos arquitectónicos.
- Patrones integrados en las paredes interiores.
- Carteles y pósteres decorativos.
- Elementos de señalización y detalles retrofuturistas.
- Futuras zonas sociales y de acceso.

## 2.3. Identidad de las máquinas

Cada máquina tendrá una identidad visual propia, relacionada con el minijuego que contiene.

Las máquinas deberán ser reconocibles a distancia y mantener una coherencia estética con el resto del salón.

## 2.4. Estado visual actual

El salón principal dispone de una primera construcción completa de su arquitectura esencial:

- Distribución de las cuatro salas.
- Núcleo central y corredores.
- Suelo y caminos.
- Máquinas arcade colocadas.
- Paredes y separaciones.
- Techo y estructura.
- Iluminación ambiental y arquitectónica.
- Primera decoración geométrica de las paredes.
- Primera implementación de carteles y pósteres.

La arquitectura y la iluminación están aprobadas. Los pósteres están implementados, pero su posición todavía necesita ajustes para que queden dentro de las salas y no sobre los marcos de las puertas.

La decoración secundaria no debe impedir que se avance en los sistemas jugables. La prioridad actual se centra en completar y estabilizar la funcionalidad de las máquinas.

---

# 3. Experiencia del jugador

## 3.1. Flujo principal

La experiencia básica del jugador seguirá este recorrido:

1. El jugador entra en Universo Arcade.
2. Aparece en el salón recreativo.
3. Explora el entorno y descubre las máquinas disponibles.
4. Se acerca a una máquina.
5. Interactúa con ella.
6. El servidor comprueba si la máquina está disponible.
7. Se inicia una partida individual.
8. El jugador completa la partida o pierde.
9. Se calcula y registra la puntuación.
10. Se actualiza el récord personal si corresponde.
11. El jugador regresa a la exploración del salón.

Este flujo representa el objetivo funcional del juego. Todavía debe completarse el sistema general de interacción, reserva y sesiones de las máquinas.

## 3.2. Interacción con las máquinas

Las máquinas serán objetos físicos dentro del escenario.

La interacción deberá resultar intuitiva y permitir que el jugador entienda cuándo puede utilizar una máquina.

Se utilizará una combinación de elementos:

- Proximidad física a la máquina.
- Indicaciones de interacción.
- Comprobación de disponibilidad.
- Interfaz gráfica para el minijuego.
- Cámara adaptada a la experiencia de juego.

## 3.3. Experiencia de juego

La partida se desarrollará principalmente mediante una interfaz superpuesta, manteniendo parte de la identidad visual de la máquina arcade y del entorno.

Distribución visual orientativa:

| Elemento | Proporción aproximada |
|---|---:|
| Área principal del minijuego | 75 % |
| Marco e identidad de la máquina | 15 % |
| Entorno del salón | 10 % |

Estas proporciones son una referencia artística inicial, no restricciones técnicas.

---

# 4. Minijuegos

## 4.1. Concepto general

Cada máquina ofrecerá un minijuego independiente.

Las partidas serán individuales y estarán gestionadas de forma independiente por el servidor.

Varias máquinas podrán ofrecer el mismo minijuego simultáneamente, sin compartir el estado de sus partidas.

## 4.2. Minijuegos previstos

### 4.2.1. Block Puzzle

Inspiración: juegos clásicos de colocación y eliminación de bloques.

Características previstas:

- Tablero de juego.
- Piezas de diferentes formas.
- Movimiento y rotación.
- Eliminación de líneas completas.
- Incremento progresivo de dificultad.
- Sistema de puntuación.

Será uno de los minijuegos principales de Universo Arcade. Su desarrollo funcional completo se abordará progresivamente.

### 4.2.2. Bubble Shooter

Inspiración: juegos clásicos de lanzamiento y agrupación de burbujas, como Puzzle Bobble.

Características previstas:

- Lanzador de burbujas controlado por el jugador.
- Burbujas de diferentes colores.
- Formación de grupos de burbujas del mismo color.
- Eliminación de grupos al alcanzar las combinaciones necesarias.
- Rebotes contra los límites del escenario.
- Sistema de puntuación.
- Dificultad progresiva.

La experiencia estará orientada a la precisión, la planificación de disparos y la creación de combinaciones de colores.

### 4.2.3. Space Shooter

Inspiración: los clásicos juegos arcade de defensa espacial.

Características previstas:

- Nave controlada por el jugador.
- Enemigos con patrones de movimiento.
- Disparos y colisiones.
- Oleadas progresivas.
- Sistema de puntuación.
- Dificultad creciente.

Su diseño tendrá identidad propia, tomando como referencia general los juegos clásicos de invasión espacial.

### 4.2.4. Brick Breaker

Inspiración: los juegos clásicos de destrucción de bloques.

Características implementadas y previstas:

- Plataforma controlada por el jugador.
- Pelota con movimiento y rebotes.
- Bloques destructibles.
- Diferentes configuraciones de niveles.
- Sistema de puntuación y vidas.
- Progresión de dificultad.
- Potenciadores temporales con diferentes efectos.
- Transiciones automáticas entre niveles.
- Pantalla inicial PRESS START.
- Pantalla de pausa con opciones para continuar o abandonar.
- Confirmación antes de abandonar una partida.
- Pantalla GAME OVER a pantalla completa.
- Visualización de la puntuación final y el récord.
- Reinicio de partida mediante teclado o ratón.
- Preparación de la pelota sobre la plataforma antes de cada lanzamiento.

El funcionamiento de la partida sigue un flujo arcade: el jugador inicia la experiencia, prepara el lanzamiento y juega hasta completar los niveles o quedarse sin vidas.

Los controles permiten seleccionar entre teclado y ratón. Durante la partida se respeta el método de control elegido, mientras que las acciones de inicio y reinicio admiten las entradas previstas por la interfaz.

El juego incorpora potenciadores temporales que modifican determinadas características de la partida, así como recompensas y límites específicos para evitar acumulaciones no deseadas.

El almacenamiento permanente de récords personales queda pendiente de implementación.

Los nombres anteriores describen las inspiraciones jugables. Las implementaciones, diseños, gráficos y niveles serán originales.

## 4.3. Arquitectura de los minijuegos

Los minijuegos deberán integrarse en una arquitectura común.

Se buscará reutilizar los siguientes elementos:

- Inicio y finalización de partidas.
- Gestión de sesiones.
- Comunicación entre cliente y servidor.
- Validación de puntuaciones.
- Registro de resultados.
- Gestión de récords personales.

Cada minijuego conservará su propia lógica y estado.

El desarrollo se realizará de manera incremental, priorizando inicialmente Brick Breaker como primera experiencia jugable avanzada.

La arquitectura se irá consolidando a partir de las necesidades reales de los minijuegos, procurando mantener separados sus sistemas internos y reutilizar los componentes comunes cuando resulte conveniente.

---

# 5. Máquinas arcade y gestión de sesiones

## 5.1. Máquinas independientes

Cada máquina tendrá su propia identidad y estado.

Una máquina solamente podrá admitir una partida activa a la vez.

Cuando un jugador interactúe con una máquina:

1. El servidor comprobará su disponibilidad.
2. Si está libre, reservará la máquina para ese jugador.
3. Se creará una sesión independiente.
4. El jugador podrá comenzar la partida.
5. Al finalizar, se liberará la máquina.

Si está ocupada, se informará al jugador de que no está disponible.

## 5.2. Sesiones independientes

Dos máquinas del mismo tipo podrán ejecutar partidas simultáneas.

Por ejemplo:

- Un jugador utiliza la máquina de Block Puzzle número 1.
- Otro jugador utiliza la máquina de Block Puzzle número 2.
- Ambos juegan de manera independiente.
- Las puntuaciones y estados de las partidas no se mezclan.

## 5.3. Abandono de partida

El sistema deberá contemplar situaciones como:

- El jugador abandona voluntariamente.
- El jugador pierde la conexión.
- El jugador sale del servidor.
- La máquina deja de estar disponible.
- Se produce un error durante la partida.

Las sesiones deberán finalizar correctamente y liberar los recursos asociados.

La salida voluntaria de una partida deberá distinguirse de su finalización normal. El sistema de puntuaciones tendrá que evitar que se pierdan resultados válidos o se registren resultados incompletos.

---

# 6. Puntuaciones y progresión

## 6.1. Sistema de puntuación

Cada minijuego tendrá sus propias reglas de puntuación.

La puntuación final deberá ser validada por el servidor antes de registrarse.

No se confiará directamente en las puntuaciones comunicadas por el cliente.

## 6.2. Récord personal

Desde la primera versión se pretende almacenar el mejor resultado individual de cada jugador para cada minijuego.

El récord deberá mantenerse aunque el jugador abandone la experiencia y vuelva en otro momento.

En Brick Breaker ya existe una interfaz preparada para mostrar la puntuación final y el récord. Sin embargo, el almacenamiento persistente de esos resultados todavía está pendiente de implementación.

El sistema definitivo deberá guardar los récords de forma segura y permitir recuperarlos cuando el jugador vuelva a entrar en la experiencia.

## 6.3. Clasificaciones futuras

Se contemplan diferentes niveles de competición:

- Récord personal.
- Comparación con amigos.
- Clasificaciones globales.

Las clasificaciones sociales y mundiales se incorporarán progresivamente.

---

# 7. Economía y recompensas

La economía no formará parte de la primera versión funcional.

En futuras versiones se estudiará la incorporación de:

- Arcade Tokens obtenidos jugando.
- Desbloqueo de salas y elementos cosméticos.
- Personalización de determinados elementos.
- Recompensas por objetivos.
- Nuevas máquinas y contenidos.

Las máquinas iniciales deberán seguir siendo accesibles gratuitamente.

La monetización, si se incorpora, deberá respetar la experiencia de juego y evitar ventajas competitivas injustas.

## 7.1. Arcade Tokens

Arcade Tokens (AT) será el nombre de la moneda interna.

Se podrán conseguir jugando, completando desafíos, participando en eventos y mediante otras actividades de progresión.

Su utilización principal será desbloquear nuevas salas y contenido de progresión.

## 7.2. Monetización

El modelo elegido será Pay to Fast, no Pay to Win.

Se podrán ofrecer multiplicadores de obtención de AT, packs de moneda y elementos cosméticos.

Las compras no podrán modificar las puntuaciones, proporcionar ventajas competitivas ni hacer obligatorio el gasto para disfrutar del contenido jugable.

---

# 8. Interfaz y controles

## 8.1. Plataformas prioritarias

El desarrollo inicial estará centrado en PC.

Se priorizarán los controles mediante teclado y ratón.

La compatibilidad con dispositivos móviles y consolas se abordará posteriormente, procurando que las decisiones iniciales no impidan su incorporación.

## 8.2. Interfaz

La interfaz deberá ser clara, intuitiva y coherente con la estética arcade.

Se evitarán elementos innecesarios que dificulten la visibilidad del minijuego.

Las interfaces de las máquinas deberán mantener una identidad visual coherente con el salón recreativo y con la experiencia concreta que ofrezca cada minijuego.

En Brick Breaker se utiliza una estética inspirada en las recreativas clásicas, con tipografía arcade, pantallas de transición y mensajes directos.

## 8.3. Cámara

La experiencia utilizará una transición entre la exploración del salón y la utilización de las máquinas.

Se estudiará un sistema de cámara que permita acercarse a la máquina y centrar la atención en el minijuego.

## 8.4. Inicio, pausa y finalización de partida

Las máquinas deberán disponer de interfaces que permitan al jugador comprender el estado de su partida.

En Brick Breaker se contemplan los siguientes estados:

- **PRESS START:** pantalla inicial que permite comenzar la experiencia.
- **Gameplay:** pantalla principal durante la partida.
- **Pause:** interfaz de pausa con opciones para continuar o abandonar.
- **Exit Confirmation:** confirmación antes de salir de la partida.
- **Level Transition:** transición automática que informa de la finalización de un nivel y del comienzo del siguiente.
- **GAME OVER:** pantalla final que muestra la puntuación y el récord, y permite reiniciar la partida.

Las transiciones entre niveles no requieren una confirmación manual. El cambio se realiza automáticamente después de mostrar los mensajes correspondientes.

La pantalla GAME OVER utiliza un fondo negro a pantalla completa, sin paneles ni botones de acción. El jugador puede reiniciar mediante teclado o ratón.

---

# 9. Multijugador y experiencia social

El salón será un espacio compartido por varios jugadores.

Los jugadores podrán explorar el entorno y encontrarse con otros usuarios.

Durante las primeras versiones no será necesario visualizar las partidas ajenas en tiempo real.

Cada jugador tendrá su propia sesión de minijuego.

En futuras versiones se estudiarán funcionalidades sociales adicionales, como:

- Clasificaciones entre amigos.
- Comparación de récords.
- Nuevos elementos de interacción social.
- Eventos y desafíos.
- Zona social compartida.

---

# 10. Idiomas y localización

El inglés será el idioma base de la experiencia.

El español será el primer idioma adicional que se incorporará manualmente.

Se utilizarán los sistemas de localización de Roblox para facilitar la ampliación a otros idiomas.

Los textos visibles para el jugador deberán estar preparados para su traducción.

---

# 11. Alcance y versiones

Universo Arcade se desarrollará de manera incremental.

| Versión | Objetivo |
|---|---|
| 0.1 | Primera máquina, primer minijuego, puntuación y récord personal persistente. |
| 0.2 | Mejoras de jugabilidad, interfaz y estabilidad. |
| 0.3 | Consolidación del primer minijuego funcional y preparación para incorporar nuevos minijuegos. |
| 0.4 | Ampliación del salón recreativo y experiencia social. |
| 0.5 | Primera implementación de economía y recompensas. |
| 0.6 | Clasificaciones entre amigos. |
| 0.7 | Clasificación global. |
| 1.0 | Primera versión pública completa. |

Las versiones representan objetivos de desarrollo y podrán ajustarse según los resultados de las pruebas.

## 11.1. Objetivo de la versión 0.1

La primera versión funcional deberá permitir:

1. Entrar en el salón recreativo.
2. Localizar una máquina disponible.
3. Interactuar con ella.
4. Iniciar un minijuego individual.
5. Jugar y obtener una puntuación.
6. Finalizar la partida.
7. Guardar el récord personal.
8. Volver a entrar y recuperar el récord.

La prioridad será conseguir una experiencia completa y estable, aunque inicialmente solo exista una máquina funcional.

---

# 12. Principios de desarrollo

El proyecto seguirá los siguientes principios:

- Priorizar la calidad sobre la cantidad de funcionalidades.
- Mantener una arquitectura modular.
- Separar correctamente cliente y servidor.
- Validar en servidor las operaciones importantes.
- Evitar duplicar sistemas entre minijuegos.
- Mantener una documentación actualizada.
- Utilizar control de versiones mediante Git.
- Realizar pruebas incrementales.
- Evitar dependencias innecesarias.
- Diseñar pensando en futuras ampliaciones.
- Priorizar la funcionalidad jugable frente a la decoración secundaria.
- Evitar modificaciones innecesarias en sistemas que ya hayan sido probados y aprobados.

---

# 13. Fuera del alcance inicial

Las siguientes funcionalidades no serán necesarias para alcanzar la versión 0.1:

- Economía y tienda.
- Clasificaciones globales.
- Clasificaciones entre amigos.
- Multijugador competitivo dentro de los minijuegos.
- Visualización de partidas ajenas.
- Compatibilidad completa con todas las plataformas.
- Eventos y temporadas.
- Sistemas avanzados de personalización.
- Desbloqueo de salas adicionales.

Estas funcionalidades podrán incorporarse cuando los sistemas fundamentales estén terminados y probados.

---

# 14. Estado actual del proyecto

El proyecto dispone de un entorno de desarrollo basado en Roblox Studio, VS Code, Luau, Rojo y Git.

El salón principal ya cuenta con una primera implementación física y visual.

## 14.1. Elementos construidos

- Salón principal de 120 × 100 studs.
- Cuatro salas temáticas.
- Núcleo central circular.
- Cuatro corredores.
- 28 máquinas arcade colocadas, siete por sala.
- Suelo oscuro con acabado de estética arcade.
- Caminos diferenciados hacia las salas.
- Patrones geométricos en el suelo.
- Arquitectura de paredes interiores.
- Patrones decorativos propios para las cuatro salas.
- Carteles y pósteres decorativos en una primera implementación.
- Techo estructural.
- Iluminación ambiental y arquitectónica.
- Punto de aparición configurado para evitar que el jugador aparezca fuera del mapa.
- Eliminación o corrección de elementos predeterminados que interferían con el escenario.

## 14.2. Elementos aprobados

- Distribución general del salón.
- Geometría principal.
- Suelo y caminos.
- Arquitectura interior.
- Techo.
- Iluminación.
- Patrones geométricos de paredes.

## 14.3. Elementos pendientes de ajuste visual

- Recolocar los pósteres para que queden dentro de las salas y no sobre los marcos de las puertas.
- Completar detalles decorativos secundarios cuando no interfieran con el desarrollo de las máquinas.

## 14.4. Estado de los sistemas jugables

Las máquinas están colocadas físicamente, pero todavía está pendiente completar su funcionalidad general:

- Interacción.
- Disponibilidad y reserva.
- Sesiones individuales.
- Integración general de los minijuegos.
- Validación de puntuaciones.
- Récords personales y persistencia.

## 14.5. Estado de los minijuegos

**Brick Breaker**

Es actualmente el minijuego con mayor grado de desarrollo.

Dispone de una implementación funcional que incluye:

- Tablero de juego.
- Bloques destructibles.
- Movimiento de la plataforma mediante teclado o ratón.
- Lanzamiento de la pelota.
- Sistema de vidas y puntuación.
- Potenciadores y efectos temporales.
- Progresión entre niveles.
- Pantalla inicial PRESS START.
- Sistema de pausa y confirmación de salida.
- Transiciones automáticas entre niveles.
- Pantalla GAME OVER a pantalla completa.
- Visualización de puntuación final y récord.
- Reinicio mediante ESPACIO o clic.
- Preparación de la pelota sobre la plataforma antes de un nuevo lanzamiento.

Las mecánicas de los potenciadores contemplan duraciones, límites y recompensas específicas para evitar acumulaciones no deseadas.

La jugabilidad y las principales interfaces están siendo probadas y ajustadas.

Quedan pendientes, entre otras tareas, el almacenamiento permanente de récords, las pruebas de estabilidad y la integración definitiva con los sistemas generales de máquinas y sesiones.

**Block Puzzle, Bubble Shooter y Space Shooter**

Todavía están pendientes de desarrollo como minijuegos funcionales completos.

## 14.6. Prioridad actual de desarrollo

La prioridad actual es completar y estabilizar Brick Breaker, implementar el almacenamiento permanente de récords personales y consolidar los sistemas comunes necesarios para incorporar progresivamente los demás minijuegos.

La decoración secundaria del salón continuará desarrollándose sin desplazar las tareas fundamentales de jugabilidad.

---

# 15. Expansión del arcade y progresión

Universo Arcade estará diseñado para crecer mediante nuevas zonas, habitaciones y experiencias jugables.

El salón inicial será gratuito y contendrá los cuatro minijuegos originales. Las futuras actualizaciones podrán incorporar nuevas salas temáticas conectadas al edificio principal.

## 15.1. Salas desbloqueables

Las salas adicionales podrán desbloquearse utilizando Arcade Tokens (AT).

Reglas:

- El desbloqueo será permanente e individual.
- Cada nueva sala incluirá al menos dos minijuegos disponibles desde el momento de su desbloqueo.
- Los minijuegos adicionales podrán conseguirse mediante la progresión gratuita.
- No se cobrará por utilizar una máquina ni por iniciar una partida.
- No será necesario realizar pagos con Robux para disfrutar del contenido jugable.
- El jugador podrá seguir progresando hasta desbloquear todo el contenido jugable.

## 15.2. Acceso individual

Cada jugador tendrá sus propios desbloqueos.

Las puertas, accesos y elementos visuales de las salas reflejarán el progreso individual de cada jugador.

Dos jugadores que compartan servidor podrán ver estados diferentes de una misma puerta. El servidor será responsable de validar los permisos reales de acceso.

Cuando un jugador invite a sus amigos, estos necesitarán disponer de sus propios desbloqueos para entrar en las salas correspondientes.

---

# 16. Economía y monetización

La economía tendrá como objetivo recompensar la actividad del jugador y permitir que el proyecto genere ingresos sin perjudicar la competición.

## 16.1. Arcade Tokens

Arcade Tokens (AT) será la moneda interna.

Se podrán conseguir jugando, completando desafíos, participando en eventos y mediante otras actividades de progresión.

Su utilización principal será desbloquear nuevas salas y contenido de progresión.

El equilibrio económico deberá permitir avanzar a un ritmo razonable sin necesidad de realizar compras.

No se utilizarán esperas artificiales ni requisitos excesivamente largos para forzar el gasto de Robux.

## 16.2. Monetización mediante Robux

Universo Arcade podrá incorporar compras opcionales con Robux.

Se permitirá:

- Multiplicadores de obtención de Arcade Tokens, como un x2.
- Packs de Arcade Tokens.
- Estelas, skins y efectos visuales.
- Títulos y elementos cosméticos.
- Otras opciones de personalización.

Las compras deberán facilitar la progresión o ampliar las opciones visuales, nunca proporcionar ventajas competitivas.

## 16.3. Juego competitivo justo

La habilidad del jugador será el único factor determinante de sus puntuaciones y posiciones competitivas.

Queda expresamente descartado:

- Multiplicadores de puntuación comprables.
- Ventajas de rendimiento en los minijuegos por pagar.
- Récords o posiciones de clasificación comprables.
- Máquinas de pago.
- Contenido jugable obligatorio de pago.

Los jugadores que no gasten Robux deberán poder conseguir todo el contenido jugable mediante la progresión normal.

## 16.4. Principio de monetización

El modelo elegido será Pay to Fast, no Pay to Win.

El jugador podrá conseguir todo jugando, pero tendrá la posibilidad de acelerar la obtención de moneda mediante compras opcionales.

La monetización nunca deberá perjudicar artificialmente el ritmo de progresión gratuito ni convertir las clasificaciones en una competición económica.

---

# 17. Principios de diseño económico

1. La habilidad siempre estará por encima del gasto.
2. Ninguna compra podrá mejorar las puntuaciones.
3. Ninguna máquina requerirá un pago para jugar.
4. El contenido jugable podrá conseguirse gratuitamente.
5. Las nuevas salas deberán aportar contenido suficiente desde su desbloqueo.
6. Los accesos serán permanentes e individuales.
7. Las compras serán opcionales.
8. La economía deberá resultar razonable tanto para jugadores gratuitos como para quienes decidan apoyar el proyecto económicamente.

---

# 18. Historial del documento

| Versión | Fecha | Cambios |
|---|---|---|
| 0.1 | Inicial | Visión, diseño y alcance inicial del proyecto. |
| 0.2 | Noviembre de 2026 | Actualización del estado real del salón, dirección artística, dimensiones, máquinas colocadas y prioridad de desarrollo jugable. |
| 0.3 | Noviembre de 2026 | Actualización del estado de desarrollo de Brick Breaker, sus mecánicas, controles e interfaces. Corrección de la referencia artística de Bubble Shooter y actualización de las prioridades de desarrollo.
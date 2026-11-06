# Universo Arcade — Roadmap de desarrollo

| Información | Detalle |
|---|---|
| Proyecto | Universo Arcade |
| Documento | Roadmap de desarrollo |
| Versión del documento | 0.3 |
| Estado | En desarrollo |
| Última actualización | Noviembre de 2026 |

---

# 1. Objetivo general

El desarrollo de Universo Arcade se organizará en hitos incrementales.

Cada hito deberá aportar funcionalidades completas, probadas y compatibles con la arquitectura existente.

La prioridad será conseguir una experiencia jugable completa y estable antes de ampliar el número de minijuegos o incorporar sistemas secundarios.

El proyecto seguirá un desarrollo progresivo: primero se consolidarán los sistemas fundamentales, después se completará la primera experiencia jugable y, finalmente, se ampliarán las funcionalidades sociales, económicas y de personalización.

El desarrollo de BrickBreaker ha avanzado en paralelo a la planificación inicial. Por este motivo, el orden de las tareas se ha adaptado para aprovechar el trabajo ya realizado y utilizar este minijuego como referencia para las siguientes implementaciones.

No se establecerán fechas de entrega rígidas. El avance dependerá de la finalización y validación de las tareas de cada etapa.

# 2. Estado general del proyecto

Universo Arcade dispone actualmente de una base técnica, un salón recreativo principal construido mediante scripts Luau y una primera implementación avanzada de BrickBreaker.

Se han completado los siguientes elementos:

- [x] Configuración inicial del entorno de desarrollo.
- [x] Integración de Git, GitHub, Rojo y Roblox Studio.
- [x] Estructura inicial de directorios.
- [x] Configuración de sincronización mediante Rojo.
- [x] Generación del mapa principal mediante scripts.
- [x] Construcción de las cuatro salas iniciales.
- [x] Construcción del núcleo central y los corredores.
- [x] Colocación de 28 máquinas arcade, siete por sala.
- [x] Construcción de la arquitectura perimetral y divisiones interiores.
- [x] Construcción del techo y sus elementos estructurales.
- [x] Implementación de la iluminación ambiental y arquitectónica.
- [x] Decoración geométrica del suelo.
- [x] Decoración arquitectónica de las paredes.
- [x] Incorporación de elementos decorativos superiores.
- [x] Creación de un punto de aparición propio para los jugadores.
- [x] Eliminación de los elementos predeterminados de Roblox Studio que interferían con el escenario.
- [x] Implementación avanzada de BrickBreaker, con mecánicas, controles e interfaces principales.
- [x] Implementación de pantallas de inicio, pausa, transición de niveles y GAME OVER en BrickBreaker.

La arquitectura visual y la iluminación del salón principal se consideran aprobadas.

Todavía queda pendiente completar el funcionamiento general de las máquinas, incluyendo su disponibilidad, reservas, gestión de sesiones e integración definitiva con los minijuegos.

La decoración de los pósteres también tiene un ajuste pendiente: su colocación deberá corregirse para que queden sobre los tramos de pared interiores y no sobre los marcos de las puertas.

El almacenamiento permanente de récords personales todavía no está implementado.

# 3. Fases de desarrollo

## Fase 0 — Preparación del entorno

<badge color="success">Completada en su mayor parte</badge>

**Objetivo:** disponer de un entorno de desarrollo organizado y preparado para trabajar.

- [x] Instalar Git.
- [x] Configurar la identidad de Git.
- [x] Instalar Rokit.
- [x] Instalar Rojo.
- [x] Instalar el plugin de Rojo en Roblox Studio.
- [x] Instalar extensiones de Luau en VS Code.
- [x] Crear la carpeta raíz del proyecto.
- [x] Crear la estructura inicial de directorios.
- [x] Inicializar el repositorio Git.
- [x] Configurar el archivo `.gitignore`.
- [x] Crear la configuración inicial de Rojo.
- [x] Comprobar la generación de un archivo de Roblox mediante Rojo.
- [x] Crear el repositorio remoto en GitHub.
- [x] Realizar los primeros commits.

**Pendiente de comprobación:**

- [ ] Reconectar Rojo con Roblox Studio al iniciar una nueva sesión de desarrollo.
- [ ] Comprobar que todos los servicios y directorios se sincronizan correctamente.

**Criterio de finalización:** el proyecto debe poder abrirse, sincronizarse con Roblox Studio y estar respaldado mediante GitHub.

## Fase 1 — Consolidación del proyecto y documentación

<badge color="warning">En progreso</badge>

**Objetivo:** establecer un punto de control fiable antes de continuar ampliando los sistemas generales del juego.

- [x] Reconectar Rojo con Roblox Studio.
- [x] Verificar la estructura completa del proyecto en el Explorer.
- [x] Comprobar que los servicios existentes se sincronizan correctamente.
- [x] Revisar el estado del repositorio Git.
- [x] Actualizar el Game Design Document.
- [x] Actualizar el Roadmap.
- [x] Revisar la documentación de arquitectura.
- [x] Actualizar el README.
- [x] Comprobar que la documentación distingue correctamente lo implementado y lo pendiente.
- [x] Revisar que los nombres y las rutas de los módulos coinciden con el proyecto.
- [x] Guardar el estado actual del proyecto.
- [x] Crear un nuevo checkpoint mediante Git.
- [x] Comprobar que los cambios están respaldados en GitHub.

**Criterio de finalización:** disponer de un proyecto sincronizado, documentado y respaldado, preparado para continuar con los sistemas generales de las máquinas arcade.

## Fase 2 — Sistema común de máquinas arcade

**Objetivo:** completar la infraestructura que permitirá utilizar las máquinas del salón.

BrickBreaker ya dispone de una implementación propia de su interfaz y de su lógica de partida. Esta fase deberá consolidar los sistemas generales para que los distintos minijuegos puedan integrarse de manera uniforme.

### 2.1. Identificación de máquinas

- [x] Definir un identificador único para cada máquina.
- [x] Asociar cada máquina con su tipo de minijuego.
- [x] Registrar las máquinas disponibles en el servidor.
- [x] Vincular los registros con sus modelos físicos.
- [x] Definir la configuración individual de cada máquina.

### 2.2. Interacción

- [x] Detectar cuándo un jugador se aproxima a una máquina.
- [x] Mostrar una indicación visual de interacción.
- [x] Permitir solicitar el uso de una máquina.
- [x] Validar en servidor la distancia del jugador.
- [x] Comprobar que la máquina existe y puede utilizarse.
- [x] Informar al jugador cuando una máquina esté ocupada o no disponible.

### 2.3. Disponibilidad y reservas

- [x] Implementar los estados generales de las máquinas.
- [x] Crear el sistema de reserva.
- [x] Impedir que dos jugadores reserven simultáneamente una misma máquina.
- [x] Asociar cada reserva a un jugador.
- [x] Liberar correctamente las reservas canceladas.
- [x] Gestionar errores durante el proceso de reserva.

### 2.4. Integración con la interfaz

- [ ] Crear una interfaz general de interacción.
- [x] Mostrar el nombre del minijuego de cada máquina.
- [ ] Mostrar información sobre su disponibilidad.
- [x] Preparar la transición entre la exploración del salón y la experiencia de juego.
- [x] Permitir cancelar la interacción y volver al salón.
- [ ] Adaptar la interfaz común a los distintos minijuegos.

**Criterio de finalización:** un jugador puede acercarse a una máquina, interactuar con ella y reservarla de forma segura. El sistema reconoce qué minijuego contiene y evita que otro jugador utilice simultáneamente esa misma máquina.

## Fase 3 — Sistema de sesiones de juego

**Objetivo:** crear un sistema reutilizable para gestionar las partidas individuales.

### 3.1. Creación de sesiones

- [x] Diseñar el modelo de datos de una sesión.
- [x] Generar identificadores únicos.
- [x] Asociar cada sesión a un jugador.
- [x] Asociar cada sesión a una máquina.
- [x] Identificar el minijuego correspondiente.
- [x] Impedir que un jugador tenga varias sesiones arcade activas inicialmente.

### 3.2. Ciclo de vida

- [x] Implementar la inicialización de sesiones.
- [x] Implementar el inicio de partida.
- [x] Gestionar los estados de las sesiones.
- [x] Implementar la finalización.
- [x] Implementar la cancelación.
- [x] Gestionar errores durante la ejecución.
- [x] Liberar la máquina al terminar la sesión.

### 3.3. Entrada y salida

- [x] Preparar la entrada del jugador al minijuego.
- [x] Integrar la interfaz correspondiente.
- [x] Gestionar los controles de cada minijuego.
- [x] Preparar la salida voluntaria.
- [x] Restaurar la experiencia de exploración del salón.
- [x] Recuperar correctamente la cámara y los controles del jugador.

### 3.4. Abandonos y desconexiones

- [x] Gestionar la desconexión del jugador.
- [x] Cancelar sesiones interrumpidas.
- [x] Liberar las máquinas asociadas.
- [x] Evitar sesiones bloqueadas indefinidamente.
- [x] Garantizar que la limpieza pueda ejecutarse varias veces sin generar inconsistencias.

**Criterio de finalización:** el sistema puede crear, ejecutar, finalizar y limpiar sesiones individuales, permitiendo que diferentes jugadores utilicen distintas máquinas al mismo tiempo.

## Fase 4 — BrickBreaker: primera experiencia jugable avanzada

<badge color="warning">En desarrollo avanzado</badge>

**Objetivo:** completar y estabilizar BrickBreaker, utilizando su implementación actual como referencia para validar las mecánicas, interfaces y estructura de los futuros minijuegos.

### 4.1. Mecánicas principales

- [x] Diseñar el tablero de juego.
- [x] Implementar la plataforma.
- [x] Implementar el movimiento de la pelota.
- [x] Implementar los rebotes.
- [x] Crear los bloques destructibles.
- [x] Implementar el sistema de vidas.
- [x] Implementar el sistema de puntuación.
- [x] Implementar la progresión entre niveles.
- [x] Preparar la pelota sobre la plataforma antes del lanzamiento.
- [x] Implementar el final de partida al perder todas las vidas.
- [x] Ampliar y revisar las configuraciones de niveles.
- [ ] Realizar pruebas adicionales de estabilidad y casos límite.

### 4.2. Potenciadores y efectos

- [x] Implementar los potenciadores.
- [x] Implementar los efectos temporales.
- [x] Implementar el escudo.
- [x] Implementar la bola de fuego.
- [x] Implementar la vida extra.
- [x] Gestionar los límites de acumulación de vidas.
- [x] Gestionar la sustitución de potenciadores repetidos.
- [x] Gestionar la finalización y limpieza de los efectos temporales.
- [x] Revisar el equilibrio general de los potenciadores.
- [x] Probar diferentes combinaciones de efectos.

Reglas específicas implementadas:

- El escudo dura 12 segundos.
- Si se recoge otro escudo mientras ya existe uno activo, el nuevo se convierte directamente en 100 puntos.
- Si el escudo termina sin utilizarse, también concede 100 puntos.
- La bola de fuego dura 3 segundos.
- Solo puede aparecer una vida extra por nivel.
- El máximo de vidas acumuladas es 5.

### 4.3. Interfaz y presentación

- [x] Implementar la pantalla inicial PRESS START.
- [x] Implementar la pantalla principal de juego.
- [x] Implementar la pantalla de pausa.
- [x] Implementar las opciones RESUME y EXIT GAME.
- [x] Implementar la confirmación antes de abandonar.
- [x] Implementar las transiciones automáticas entre niveles.
- [x] Implementar la pantalla LEVEL COMPLETE.
- [x] Implementar la presentación del siguiente nivel.
- [x] Implementar la pantalla GAME OVER.
- [x] Mostrar la puntuación final.
- [x] Preparar el espacio visual para mostrar el récord.
- [x] Permitir reiniciar mediante ESPACIO o clic.
- [x] Preparar la pelota para el siguiente lanzamiento después de reiniciar.
- [x] Revisar todos los estados de interfaz y sus transiciones.
- [x] Realizar pruebas adicionales de resolución y legibilidad.

### 4.4. Controles

- [x] Implementar el movimiento de la plataforma mediante teclado.
- [x] Implementar el movimiento de la plataforma mediante ratón.
- [x] Permitir seleccionar el modo de control.
- [x] Implementar el lanzamiento de la pelota mediante ESPACIO.
- [x] Implementar el lanzamiento mediante clic dentro del tablero durante la partida.
- [x] Permitir reiniciar mediante clic en cualquier punto de GAME OVER.
- [x] Permitir reiniciar mediante ESPACIO en GAME OVER.
- [x] Evitar que una misma entrada ejecute acciones duplicadas.
- [x] Realizar pruebas adicionales de controles y cambios de estado.

### 4.5. Integración y pruebas

- [ ] Integrar BrickBreaker con el sistema común de máquinas.
- [ ] Integrarlo con el sistema general de sesiones.
- [ ] Iniciar el minijuego desde una máquina real.
- [ ] Asociar la partida a la máquina correspondiente.
- [ ] Devolver los resultados al sistema común.
- [ ] Validar las puntuaciones en servidor.
- [ ] Liberar correctamente la máquina al terminar.
- [ ] Probar el abandono de una partida.
- [ ] Probar desconexiones durante una partida.
- [ ] Comprobar que el estado de una partida no afecta a otra.

**Criterio de finalización:** BrickBreaker ofrece una experiencia estable y completa, puede iniciarse desde una máquina real, utiliza correctamente los sistemas comunes y devuelve los resultados de la partida.

## Fase 5 — Persistencia y récords personales

**Objetivo:** permitir que los resultados del jugador se conserven entre sesiones.

### 5.1. Datos del jugador

- [ ] Diseñar el modelo de datos persistentes.
- [ ] Definir la estructura de los récords.
- [ ] Implementar la lectura de datos.
- [ ] Implementar la creación de datos iniciales.
- [ ] Gestionar versiones del esquema.

### 5.2. Récords

- [ ] Implementar la lectura del récord personal.
- [ ] Comparar nuevos resultados con el récord existente.
- [ ] Guardar únicamente mejoras válidas.
- [ ] Evitar que resultados inferiores sustituyan récords superiores.
- [ ] Mostrar el récord personal en la interfaz.
- [ ] Integrar el sistema de récords con BrickBreaker.
- [ ] Preparar el sistema para los siguientes minijuegos.

### 5.3. Seguridad y fiabilidad

- [ ] Validar las puntuaciones en servidor.
- [ ] Utilizar DataStoreService.
- [ ] Gestionar errores temporales de almacenamiento.
- [ ] Implementar reintentos controlados.
- [ ] Evitar sobrescrituras incorrectas.
- [ ] Gestionar los límites de solicitudes.
- [ ] Probar la persistencia entre diferentes sesiones.

**Criterio de finalización:** el jugador puede completar una partida, guardar su récord y recuperarlo al abandonar y volver a entrar en Universo Arcade.

## Fase 6 — Validación de la primera versión jugable

**Objetivo:** disponer de una primera versión jugable, estable y completa.

- [ ] Probar el recorrido completo desde el salón hasta BrickBreaker.
- [ ] Probar el inicio y la finalización de partidas.
- [ ] Probar la reserva y liberación de máquinas.
- [ ] Probar varias máquinas simultáneamente.
- [ ] Comprobar que las sesiones no comparten estado.
- [ ] Probar desconexiones durante una partida.
- [ ] Comprobar el guardado de récords.
- [ ] Comprobar la recuperación de datos.
- [ ] Revisar los errores del servidor.
- [ ] Corregir errores críticos.
- [ ] Realizar pruebas con varios jugadores.

**Criterio de finalización:** Universo Arcade ofrece una experiencia completa con al menos una máquina funcional, un minijuego jugable y récords personales persistentes.

## Fase 7 — Mejoras de la experiencia

**Objetivo:** mejorar la calidad de la primera versión jugable.

- [ ] Mejorar las interfaces.
- [ ] Añadir efectos visuales y sonoros.
- [ ] Mejorar las animaciones de las máquinas.
- [ ] Revisar los controles.
- [ ] Mejorar las transiciones entre el salón y los minijuegos.
- [ ] Optimizar los recursos utilizados.
- [ ] Revisar la accesibilidad de la interfaz.
- [ ] Realizar pruebas adicionales.
- [ ] Corregir errores detectados.

**Criterio de finalización:** la primera máquina ofrece una experiencia consistente, comprensible y suficientemente pulida.

## Fase 8 — Incorporación de nuevos minijuegos

**Objetivo:** ampliar el catálogo de experiencias reutilizando la arquitectura común y tomando como referencia el desarrollo de BrickBreaker.

### 8.1. Block Puzzle

- [ ] Diseñar el tablero de juego.
- [ ] Definir las dimensiones y los límites.
- [ ] Implementar la generación de piezas.
- [ ] Implementar las diferentes formas de piezas.
- [ ] Implementar el movimiento.
- [ ] Implementar la rotación.
- [ ] Detectar colisiones.
- [ ] Detectar límites del tablero.
- [ ] Implementar la colocación de piezas.
- [ ] Detectar líneas completas.
- [ ] Eliminar las líneas completadas.
- [ ] Actualizar el tablero después de cada eliminación.
- [ ] Detectar el final de la partida.
- [ ] Implementar la puntuación.
- [ ] Implementar la progresión de dificultad.
- [ ] Crear su interfaz.
- [ ] Integrar el minijuego con el sistema de sesiones.
- [ ] Crear su máquina correspondiente.
- [ ] Implementar sus récords personales.

### 8.2. Bubble Shooter

Inspiración: juegos clásicos de lanzamiento y agrupación de burbujas, como Puzzle Bobble.

- [ ] Diseñar las mecánicas.
- [ ] Implementar el lanzador de burbujas.
- [ ] Implementar el apuntado y el disparo.
- [ ] Implementar las burbujas de diferentes colores.
- [ ] Implementar los rebotes contra los límites del escenario.
- [ ] Detectar grupos de burbujas del mismo color.
- [ ] Eliminar los grupos que cumplan las condiciones.
- [ ] Implementar la caída de burbujas desconectadas, si corresponde al diseño definitivo.
- [ ] Implementar la puntuación.
- [ ] Implementar la progresión de dificultad.
- [ ] Crear su interfaz.
- [ ] Integrar el minijuego con el sistema de sesiones.
- [ ] Crear su máquina correspondiente.
- [ ] Implementar sus récords personales.

### 8.3. Space Shooter

Inspiración: los clásicos juegos arcade de defensa espacial, con identidad y diseño originales.

- [ ] Diseñar las mecánicas.
- [ ] Implementar el movimiento de la nave.
- [ ] Implementar los disparos.
- [ ] Implementar los enemigos.
- [ ] Implementar patrones de movimiento.
- [ ] Crear las oleadas.
- [ ] Implementar colisiones.
- [ ] Implementar la puntuación.
- [ ] Implementar la progresión de dificultad.
- [ ] Crear su interfaz.
- [ ] Integrar el minijuego con el sistema de sesiones.
- [ ] Crear su máquina correspondiente.
- [ ] Implementar sus récords personales.

### 8.4. Validación

- [ ] Probar partidas simultáneas del mismo minijuego.
- [ ] Probar partidas simultáneas de minijuegos diferentes.
- [ ] Comprobar que los resultados son independientes.
- [ ] Revisar el rendimiento general.
- [ ] Comprobar la integración con las máquinas.

**Criterio de finalización:** los cuatro minijuegos iniciales pueden ejecutarse de forma independiente y reutilizan correctamente los sistemas comunes.

## Fase 9 — Ampliación del salón recreativo

**Objetivo:** ampliar el escenario y completar las zonas que rodean al salón principal.

El salón principal ya dispone de una base arquitectónica y decorativa. Esta fase se centrará en completar los elementos pendientes y construir las zonas adicionales.

- [ ] Revisar y finalizar los detalles decorativos pendientes del salón principal.
- [ ] Corregir la colocación de los pósteres.
- [ ] Completar la señalización del salón.
- [ ] Diseñar la zona social.
- [ ] Construir la entrada.
- [ ] Construir el pasillo de acceso.
- [ ] Diseñar y construir el parking.
- [ ] Incorporar elementos ambientales.
- [ ] Mejorar la navegación por el escenario.
- [ ] Optimizar el rendimiento del mapa.

**Criterio de finalización:** el entorno ofrece una experiencia coherente, navegable y preparada para recibir jugadores.

## Fase 10 — Economía y recompensas

**Objetivo:** incorporar progresión y recompensas sin perjudicar la competición.

- [ ] Diseñar la economía del juego.
- [ ] Implementar Arcade Tokens (AT).
- [ ] Definir las fuentes de obtención.
- [ ] Diseñar las recompensas.
- [ ] Implementar las recompensas por jugar.
- [ ] Diseñar el sistema de desbloqueo de salas.
- [ ] Implementar los desbloqueos permanentes.
- [ ] Crear una interfaz de progresión.
- [ ] Validar las transacciones en servidor.
- [ ] Probar la persistencia de los datos.
- [ ] Comprobar el equilibrio de la progresión gratuita.

**Criterio de finalización:** los jugadores pueden conseguir y utilizar recompensas mediante un sistema seguro y equilibrado.

## Fase 11 — Expansión y acceso individual

**Objetivo:** permitir que el salón crezca mediante nuevas salas y contenido.

- [ ] Diseñar la estructura de las nuevas salas.
- [ ] Implementar la validación individual de accesos.
- [ ] Implementar la representación visual individual de las puertas.
- [ ] Impedir el acceso a salas no desbloqueadas.
- [ ] Permitir que cada jugador conserve sus propios desbloqueos.
- [ ] Incorporar nuevas salas temáticas.
- [ ] Añadir nuevos minijuegos.
- [ ] Comprobar el funcionamiento con varios jugadores.

Cada nueva sala deberá incluir al menos dos minijuegos disponibles desde el momento de su desbloqueo.

**Criterio de finalización:** los jugadores pueden desbloquear y acceder a nuevas salas de forma individual, sin que sus permisos afecten a los de otros usuarios.

## Fase 12 — Clasificaciones

**Objetivo:** ampliar las posibilidades de competición.

### 12.1. Clasificaciones entre amigos

- [ ] Diseñar la visualización.
- [ ] Obtener los resultados de amigos.
- [ ] Mostrar récords por minijuego.
- [ ] Gestionar jugadores sin puntuaciones.
- [ ] Optimizar las consultas.

### 12.2. Clasificación global

- [ ] Diseñar el sistema de clasificación mundial.
- [ ] Implementar el almacenamiento de puntuaciones globales.
- [ ] Gestionar actualizaciones de resultados.
- [ ] Implementar consultas paginadas.
- [ ] Gestionar empates.
- [ ] Prevenir puntuaciones manipuladas.
- [ ] Optimizar las consultas.
- [ ] Realizar pruebas de rendimiento.

**Criterio de finalización:** los jugadores pueden consultar clasificaciones fiables, tanto entre amigos como a escala global.

## Fase 13 — Monetización y personalización

**Objetivo:** incorporar compras opcionales y elementos cosméticos respetando el modelo Pay to Fast.

- [ ] Diseñar los productos opcionales.
- [ ] Implementar compras mediante MarketplaceService.
- [ ] Incorporar multiplicadores de obtención de AT.
- [ ] Incorporar packs de AT.
- [ ] Implementar skins.
- [ ] Implementar estelas y efectos visuales.
- [ ] Implementar títulos y elementos cosméticos.
- [ ] Validar las compras en servidor.
- [ ] Evitar entregas duplicadas.
- [ ] Comprobar que ninguna compra afecta a las puntuaciones.

**Criterio de finalización:** el juego permite realizar compras opcionales sin introducir ventajas competitivas ni bloquear contenido jugable para los usuarios gratuitos.

## Fase 14 — Preparación para publicación

**Objetivo:** preparar una primera versión pública completa.

- [ ] Revisar todos los sistemas.
- [ ] Corregir errores críticos y graves.
- [ ] Revisar seguridad y validaciones.
- [ ] Comprobar persistencia de datos.
- [ ] Optimizar rendimiento.
- [ ] Revisar compatibilidad de dispositivos.
- [ ] Completar localización al español.
- [ ] Revisar textos y presentación.
- [ ] Preparar icono y materiales promocionales.
- [ ] Realizar pruebas con usuarios externos.
- [ ] Publicar la primera versión completa.

**Criterio de finalización:** Universo Arcade ofrece una experiencia estable, completa y preparada para su lanzamiento público.

# 4. Prioridades de desarrollo

El orden de prioridades será:

1. Consolidación y documentación del proyecto.
2. Estabilidad del entorno de desarrollo y sincronización mediante Rojo.
3. Completar y estabilizar BrickBreaker.
4. Sistema común de máquinas arcade.
5. Gestión general de sesiones de juego.
6. Integración de BrickBreaker con los sistemas comunes.
7. Validación de puntuaciones y persistencia.
8. Pruebas con varios jugadores.
9. Incorporación de Block Puzzle, Bubble Shooter y Space Shooter.
10. Mejoras de la experiencia y del entorno.
11. Sistemas de progresión y economía.
12. Expansiones, clasificaciones y monetización.

La construcción de nuevas zonas decorativas no tendrá prioridad sobre la implementación de funcionalidades jugables y la estabilidad de los sistemas existentes.

# 5. Gestión del trabajo

El desarrollo se organizará en tareas pequeñas y verificables.

Cada tarea deberá:

- Tener un objetivo concreto.
- Tener una ubicación clara dentro de la arquitectura.
- Poder probarse individualmente cuando sea posible.
- Documentar las decisiones importantes.
- Integrarse mediante Git.
- Evitar cambios innecesarios en funcionalidades ya terminadas.

Se utilizarán los siguientes estados:

| Estado | Significado |
|---|---|
| Pendiente | Todavía no se ha iniciado. |
| En progreso | Se está desarrollando. |
| En revisión | Pendiente de pruebas o revisión. |
| Completada | Implementada y validada. |
| Bloqueada | No puede avanzar por una dependencia o problema. |

Una tarea solo se marcará como completada después de probarla y verificar su funcionamiento.

# 6. Control de versiones

Se utilizará Git para mantener un historial claro de los cambios.

Los commits seguirán la convención:

`tipo: descripción breve en español`

Tipos principales:

- `feat`: nuevas funcionalidades.
- `fix`: correcciones.
- `docs`: documentación.
- `refactor`: reorganización del código.
- `test`: pruebas.
- `chore`: mantenimiento y configuración.
- `style`: formato y estilo.

Los cambios se agruparán en commits pequeños, coherentes y descriptivos.

Antes de realizar un commit importante se comprobará que el proyecto funciona correctamente en Roblox Studio.

Los cambios no se considerarán respaldados en GitHub hasta que se haya realizado también el correspondiente push.

# 7. Criterios generales de calidad

Una funcionalidad no se considerará terminada únicamente porque funcione en una prueba aislada.

Se deberá comprobar, cuando corresponda:

- Comportamiento esperado.
- Casos límite.
- Errores y desconexiones.
- Seguridad.
- Rendimiento.
- Compatibilidad con el resto del proyecto.
- Funcionamiento con varios jugadores.
- Actualización de documentación.

Las funcionalidades ya aprobadas no deberán modificarse innecesariamente.

# 8. Estado actual del desarrollo

**Fase de planificación actual: Fase 1 — Consolidación del proyecto y documentación.**

El entorno de desarrollo y la estructura inicial están creados. El salón principal se encuentra construido y su arquitectura e iluminación han sido aprobadas.

En paralelo, BrickBreaker ha avanzado hasta convertirse en el minijuego con mayor grado de desarrollo.

Su implementación actual incluye las mecánicas principales, los controles, los potenciadores, la progresión entre niveles y las pantallas de inicio, pausa, transición y GAME OVER.

El siguiente trabajo será:

1. Terminar de actualizar y validar la documentación del proyecto.
2. Comprobar la sincronización de Rojo con Roblox Studio.
3. Revisar la estructura y el estado del repositorio.
4. Completar y estabilizar BrickBreaker.
5. Diseñar e implementar la persistencia de récords personales.
6. Consolidar el sistema común de máquinas y sesiones.
7. Integrar BrickBreaker con dichos sistemas.

La planificación de las fases posteriores se adaptará al resultado de estas tareas.

# 9. Decisiones de expansión y economía

## 9.1. Expansión del arcade

El salón inicial contendrá cuatro salas temáticas:

- Block Puzzle.
- Bubble Shooter.
- Space Shooter.
- BrickBreaker.

Las futuras salas podrán desbloquearse mediante Arcade Tokens (AT).

Cada desbloqueo será permanente e individual.

Cada nueva sala incluirá al menos dos minijuegos gratuitos.

Los jugadores necesitarán disponer de sus propios desbloqueos para acceder a cada sala.

La estructura del mapa deberá permitir incorporar nuevas zonas sin reconstruir el salón original.

## 9.2. Acceso individual

Cada jugador tendrá sus propios desbloqueos.

Las puertas, accesos y elementos visuales reflejarán el progreso individual de cada jugador.

Dos jugadores que compartan servidor podrán ver estados diferentes de una misma puerta.

El servidor será responsable de validar los permisos reales de acceso.

## 9.3. Economía y monetización

La economía se desarrollará en una fase posterior, una vez que los minijuegos principales funcionen correctamente.

Se utilizará Arcade Tokens (AT) como moneda interna.

Los jugadores podrán obtener AT jugando y utilizarlos para desbloquear nuevas salas y contenido de progresión.

La monetización opcional mediante Robux podrá incluir:

- Multiplicadores de obtención de moneda, como x2 AT.
- Packs de AT.
- Skins, estelas, títulos y efectos cosméticos.

Quedan descartadas las compras que proporcionen ventajas competitivas, multipliquen puntuaciones o permitan comprar máquinas.

El modelo será Pay to Fast, nunca Pay to Win.

## 9.4. Criterios económicos de calidad

Antes de publicar cualquier sistema económico se comprobará que:

1. Todo el contenido jugable puede conseguirse gratuitamente.
2. Las máquinas y partidas nunca requieren pagos.
3. El progreso gratuito tiene un ritmo razonable.
4. No existen esperas artificiales diseñadas para forzar compras.
5. Las compras no alteran puntuaciones ni clasificaciones.
6. Los desbloqueos individuales se validan en el servidor.
7. Las compras se procesan de forma segura y no duplican recompensas.

Los precios, recompensas y tiempos de desbloqueo se definirán mediante pruebas de juego.

---

*El roadmap es un documento vivo. Los objetivos y prioridades podrán cambiar según el progreso, las pruebas y las decisiones técnicas del proyecto.*
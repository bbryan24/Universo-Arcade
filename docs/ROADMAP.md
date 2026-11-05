# Universo Arcade — Roadmap de desarrollo

| Información | Detalle |
|---|---|
| Proyecto | Universo Arcade |
| Documento | Roadmap de desarrollo |
| Versión del documento | 0.2 |
| Estado | En desarrollo |
| Última actualización | Noviembre de 2026 |

---

# 1. Objetivo general

El desarrollo de Universo Arcade se organizará en hitos incrementales.

Cada hito deberá aportar funcionalidades completas, probadas y compatibles con la arquitectura existente.

La prioridad será conseguir una experiencia jugable completa y estable antes de ampliar el número de minijuegos o incorporar sistemas secundarios.

El proyecto seguirá un desarrollo progresivo: primero se construirán los sistemas fundamentales, después se implementarán las experiencias jugables y, finalmente, se ampliarán las funcionalidades sociales, económicas y de personalización.

No se establecerán fechas de entrega rígidas. El avance dependerá de la finalización y validación de las tareas de cada etapa.

# 2. Estado general del proyecto

Universo Arcade dispone actualmente de una base técnica y de un salón recreativo principal construido mediante scripts Luau.

Se han completado los siguientes elementos:

- Configuración inicial del entorno de desarrollo.
- Integración de Git, GitHub, Rojo y Roblox Studio.
- Estructura inicial de directorios.
- Configuración de sincronización mediante Rojo.
- Generación del mapa principal mediante scripts.
- Construcción de las cuatro salas iniciales.
- Construcción del núcleo central y los corredores.
- Colocación de 28 máquinas arcade, siete por sala.
- Construcción de la arquitectura perimetral y divisiones interiores.
- Construcción del techo y sus elementos estructurales.
- Implementación de la iluminación ambiental y arquitectónica.
- Decoración geométrica del suelo.
- Decoración arquitectónica de las paredes.
- Incorporación de elementos decorativos superiores.
- Creación de un punto de aparición propio para los jugadores.
- Eliminación de los elementos predeterminados de Roblox Studio que interferían con el escenario.

La arquitectura visual y la iluminación del salón principal se consideran aprobadas.

Todavía no se ha implementado el funcionamiento de las máquinas ni de los minijuegos.

La decoración de los pósteres también tiene un ajuste pendiente: su colocación deberá corregirse para que queden sobre los tramos de pared interiores y no sobre los marcos de las puertas.

# 3. Fases de desarrollo

## Fase 0 — Preparación del entorno

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

**Criterio de finalización:** el proyecto debe poder abrirse, compilarse y sincronizarse con Roblox Studio, y estar respaldado mediante GitHub.

## Fase 1 — Consolidación del proyecto y documentación

**Objetivo:** establecer un punto de control fiable antes de comenzar la programación de las máquinas.

- [ ] Reconectar Rojo con Roblox Studio.
- [ ] Verificar la estructura completa del proyecto en el Explorer.
- [ ] Comprobar que los servicios existentes se sincronizan correctamente.
- [ ] Revisar el estado del repositorio Git.
- [ ] Actualizar el Game Design Document.
- [ ] Actualizar el Roadmap.
- [ ] Actualizar la documentación de arquitectura.
- [ ] Revisar que la documentación distingue correctamente lo implementado y lo pendiente.
- [ ] Guardar el estado actual del proyecto.
- [ ] Crear un nuevo checkpoint mediante Git.
- [ ] Comprobar que los cambios están respaldados en GitHub.

**Criterio de finalización:** disponer de un proyecto sincronizado, documentado y respaldado, preparado para comenzar la implementación de las funcionalidades jugables.

## Fase 2 — Sistema común de máquinas arcade

**Objetivo:** implementar la infraestructura que permitirá utilizar las máquinas del salón.

Antes de desarrollar los cuatro minijuegos por separado, se construirá un sistema común que gestione las interacciones, reservas y sesiones.

### 2.1. Identificación de máquinas

- [ ] Definir un identificador único para cada máquina.
- [ ] Asociar cada máquina con su tipo de minijuego.
- [ ] Registrar las máquinas disponibles en el servidor.
- [ ] Vincular los registros con sus modelos físicos.
- [ ] Definir la configuración individual de cada máquina.

### 2.2. Interacción

- [ ] Detectar cuándo un jugador se aproxima a una máquina.
- [ ] Mostrar una indicación visual de interacción.
- [ ] Permitir solicitar el uso de una máquina.
- [ ] Validar en servidor la distancia del jugador.
- [ ] Comprobar que la máquina existe y puede utilizarse.
- [ ] Informar al jugador cuando una máquina esté ocupada o no disponible.

### 2.3. Disponibilidad y reservas

- [ ] Implementar los estados de las máquinas.
- [ ] Crear el sistema de reserva.
- [ ] Impedir que dos jugadores reserven simultáneamente una misma máquina.
- [ ] Asociar cada reserva a un jugador.
- [ ] Liberar correctamente las reservas canceladas.
- [ ] Gestionar errores durante el proceso de reserva.

### 2.4. Integración con la interfaz

- [ ] Crear una interfaz inicial de interacción.
- [ ] Mostrar el nombre del minijuego de cada máquina.
- [ ] Mostrar información sobre su disponibilidad.
- [ ] Preparar la transición entre la exploración del salón y la experiencia de juego.
- [ ] Permitir cancelar la interacción y volver al salón.

**Criterio de finalización:** un jugador puede acercarse a una máquina, interactuar con ella y reservarla de forma segura. El sistema reconoce qué minijuego contiene y evita que otro jugador utilice simultáneamente esa misma máquina.

## Fase 3 — Sistema de sesiones de juego

**Objetivo:** crear un sistema reutilizable para gestionar las partidas individuales.

### 3.1. Creación de sesiones

- [ ] Diseñar el modelo de datos de una sesión.
- [ ] Generar identificadores únicos.
- [ ] Asociar cada sesión a un jugador.
- [ ] Asociar cada sesión a una máquina.
- [ ] Identificar el minijuego correspondiente.
- [ ] Impedir que un jugador tenga varias sesiones arcade activas inicialmente.

### 3.2. Ciclo de vida

- [ ] Implementar la inicialización de sesiones.
- [ ] Implementar el inicio de partida.
- [ ] Gestionar el estado de las sesiones.
- [ ] Implementar la finalización.
- [ ] Implementar la cancelación.
- [ ] Gestionar errores durante la ejecución.
- [ ] Liberar la máquina al terminar la sesión.

### 3.3. Entrada y salida

- [ ] Preparar la entrada del jugador al minijuego.
- [ ] Implementar la interfaz de juego.
- [ ] Gestionar los controles correspondientes.
- [ ] Preparar la salida voluntaria.
- [ ] Restaurar la experiencia de exploración del salón.
- [ ] Recuperar correctamente la cámara y los controles del jugador.

### 3.4. Abandonos y desconexiones

- [ ] Gestionar la desconexión del jugador.
- [ ] Cancelar sesiones interrumpidas.
- [ ] Liberar las máquinas asociadas.
- [ ] Evitar sesiones bloqueadas indefinidamente.
- [ ] Garantizar que la limpieza pueda ejecutarse varias veces sin generar inconsistencias.

**Criterio de finalización:** el sistema puede crear, ejecutar, finalizar y limpiar sesiones individuales, permitiendo que diferentes jugadores utilicen distintas máquinas al mismo tiempo.

## Fase 4 — Primer minijuego: Block Puzzle

**Objetivo:** implementar la primera experiencia jugable completa de Universo Arcade.

Se utilizará Block Puzzle como primer minijuego para validar la arquitectura general antes de desarrollar los demás.

### 4.1. Mecánicas principales

- [ ] Diseñar el tablero de juego.
- [ ] Definir las dimensiones y límites.
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

### 4.2. Puntuación y dificultad

- [ ] Definir las reglas de puntuación.
- [ ] Calcular la puntuación de cada acción válida.
- [ ] Implementar la progresión de dificultad.
- [ ] Mostrar la puntuación actual.
- [ ] Preparar la pantalla de resultados.
- [ ] Validar los resultados antes de registrarlos.

### 4.3. Interfaz y presentación

- [ ] Diseñar la interfaz del minijuego.
- [ ] Mostrar el tablero.
- [ ] Mostrar las piezas disponibles.
- [ ] Mostrar la puntuación.
- [ ] Mostrar la información de partida.
- [ ] Implementar la pantalla de inicio.
- [ ] Implementar la pantalla de finalización.
- [ ] Integrar la identidad visual de Universo Arcade.

### 4.4. Integración con el sistema común

- [ ] Conectar Block Puzzle con el registro de minijuegos.
- [ ] Integrarlo con el sistema de sesiones.
- [ ] Iniciar el minijuego desde una máquina real.
- [ ] Asociar la partida a la máquina correspondiente.
- [ ] Devolver los resultados al sistema común.
- [ ] Liberar la máquina al terminar.

**Criterio de finalización:** un jugador puede acercarse a una máquina de Block Puzzle, iniciar una partida, jugar, obtener una puntuación y regresar al salón correctamente.

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

### 5.3. Seguridad y fiabilidad

- [ ] Validar las puntuaciones en servidor.
- [ ] Utilizar DataStoreService.
- [ ] Gestionar errores temporales de almacenamiento.
- [ ] Implementar reintentos controlados.
- [ ] Evitar sobrescrituras incorrectas.
- [ ] Gestionar los límites de solicitudes.
- [ ] Probar la persistencia entre diferentes sesiones.

**Criterio de finalización:** el jugador puede completar una partida, guardar su récord y recuperarlo al abandonar y volver a entrar en Universo Arcade.

## Fase 6 — Validación de la versión 0.1

**Objetivo:** disponer de una primera versión jugable, estable y completa.

- [ ] Probar el recorrido completo desde el salón hasta el minijuego.
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

**Objetivo:** ampliar el catálogo de experiencias reutilizando la arquitectura común.

### 8.1. Bubble Shooter

- [ ] Diseñar las mecánicas.
- [ ] Implementar el sistema de disparo.
- [ ] Implementar los comportamientos de las burbujas.
- [ ] Implementar la división de burbujas.
- [ ] Incorporar obstáculos y elementos de escenario.
- [ ] Implementar la puntuación.
- [ ] Integrar el minijuego con el sistema de sesiones.
- [ ] Crear su máquina correspondiente.
- [ ] Implementar sus récords personales.

### 8.2. Space Shooter

- [ ] Diseñar las mecánicas.
- [ ] Implementar el movimiento de la nave.
- [ ] Implementar los disparos.
- [ ] Implementar los enemigos.
- [ ] Implementar patrones de movimiento.
- [ ] Crear las oleadas.
- [ ] Implementar la puntuación.
- [ ] Integrar el minijuego con el sistema de sesiones.
- [ ] Crear su máquina correspondiente.
- [ ] Implementar sus récords personales.

### 8.3. Brick Breaker

- [ ] Diseñar las mecánicas.
- [ ] Implementar la plataforma.
- [ ] Implementar el movimiento de la pelota.
- [ ] Implementar los rebotes.
- [ ] Crear los bloques destructibles.
- [ ] Diseñar diferentes configuraciones de niveles.
- [ ] Implementar la puntuación.
- [ ] Integrar el minijuego con el sistema de sesiones.
- [ ] Crear su máquina correspondiente.
- [ ] Implementar sus récords personales.

### 8.4. Validación

- [ ] Probar partidas simultáneas del mismo minijuego.
- [ ] Probar partidas simultáneas de minijuegos diferentes.
- [ ] Comprobar que los resultados son independientes.
- [ ] Revisar el rendimiento general.

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

Cada nueva sala deberá incluir al menos dos minijuegos disponibles desde su desbloqueo.

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

1. Sincronización y estabilidad del entorno de desarrollo.
2. Documentación y control de versiones.
3. Sistema común de máquinas arcade.
4. Gestión de sesiones de juego.
5. Primer minijuego funcional.
6. Validación de puntuaciones y persistencia.
7. Pruebas multijugador.
8. Incorporación de nuevos minijuegos.
9. Mejoras de la experiencia y del entorno.
10. Sistemas de progresión y economía.
11. Expansiones, clasificaciones y monetización.

La construcción de nuevas zonas decorativas no tendrá prioridad sobre la implementación de funcionalidades jugables.

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

**Fase actual: Fase 1 — Consolidación del proyecto y documentación.**

El entorno de desarrollo y la estructura inicial están creados. El salón principal se encuentra construido y su arquitectura e iluminación han sido aprobadas.

El siguiente trabajo será:

1. Reconectar Rojo con Roblox Studio.
2. Comprobar la sincronización de los servicios existentes.
3. Actualizar y validar la documentación.
4. Guardar el proyecto y crear un nuevo checkpoint Git.
5. Comenzar la implementación del sistema común de máquinas.

La funcionalidad de las máquinas y los minijuegos todavía está pendiente.

# 9. Decisiones de expansión y economía

## 9.1. Expansión del arcade

El salón inicial contendrá cuatro salas temáticas:

- Block Puzzle.
- Bubble Shooter.
- Space Shooter.
- Brick Breaker.

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
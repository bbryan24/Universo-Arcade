# Universo Arcade — Roadmap de desarrollo

| Información | Detalle |
|---|---|
| Proyecto | Universo Arcade |
| Documento | Roadmap de desarrollo |
| Versión del documento | 0.1 |
| Estado | En desarrollo |
| Última actualización | Noviembre de 2026 |

---

# 1. Objetivo general

El desarrollo de Universo Arcade se organizará en hitos incrementales.

Cada hito deberá aportar funcionalidades completas, probadas y compatibles con la arquitectura existente.

Se priorizará disponer de una experiencia funcional y estable antes de ampliar el número de minijuegos o incorporar sistemas secundarios.

No se establecerán fechas de entrega rígidas. El avance dependerá de la finalización y validación de las tareas de cada etapa.

# 2. Fases de desarrollo

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
- [x] Conectar el proyecto con Roblox Studio mediante Rojo.
- [x] Crear el repositorio remoto en GitHub.
- [x] Realizar el primer commit.

**Criterio de finalización:** el proyecto debe poder abrirse, compilarse y sincronizarse con Roblox Studio, y estar respaldado mediante GitHub.

## Fase 1 — Arquitectura técnica

**Objetivo:** establecer los fundamentos que utilizarán todas las funcionalidades del juego.

- [ ] Definir las responsabilidades del cliente y del servidor.
- [ ] Establecer convenciones de programación Luau.
- [ ] Definir la estructura de módulos y dependencias.
- [ ] Diseñar el sistema común de máquinas arcade.
- [ ] Diseñar el ciclo de vida de las partidas.
- [ ] Definir el modelo de datos de jugadores y puntuaciones.
- [ ] Diseñar la comunicación entre cliente y servidor.
- [ ] Definir los mecanismos de validación de resultados.
- [ ] Preparar una estrategia de pruebas.
- [ ] Documentar las decisiones arquitectónicas.

**Criterio de finalización:** disponer de una arquitectura documentada que permita incorporar minijuegos sin duplicar los sistemas fundamentales.

## Fase 2 — Primera máquina arcade y minijuego

<badge color="info">Hito principal: versión 0.1</badge>

**Objetivo:** construir la primera experiencia jugable completa.

### 2.1. Entorno y máquina

- [ ] Crear el primer espacio del salón recreativo.
- [ ] Diseñar el modelo de la primera máquina.
- [ ] Incorporar la máquina al escenario.
- [ ] Implementar la interacción del jugador.
- [ ] Mostrar la disponibilidad de la máquina.
- [ ] Gestionar la reserva de la máquina.

### 2.2. Sistema de partidas

- [ ] Crear el sistema de sesiones individuales.
- [ ] Implementar el inicio de partida.
- [ ] Gestionar el estado de cada sesión.
- [ ] Implementar la finalización de partida.
- [ ] Liberar correctamente las máquinas.
- [ ] Gestionar abandonos y desconexiones.

### 2.3. Primer minijuego: Block Puzzle

- [ ] Diseñar el tablero.
- [ ] Implementar la generación de piezas.
- [ ] Implementar el movimiento de piezas.
- [ ] Implementar la rotación.
- [ ] Detectar colisiones y límites.
- [ ] Implementar la eliminación de líneas.
- [ ] Crear el sistema de puntuación.
- [ ] Implementar la progresión de dificultad.
- [ ] Crear las pantallas de inicio y finalización.
- [ ] Integrar el minijuego con la máquina arcade.

### 2.4. Récords personales

- [ ] Diseñar el modelo de almacenamiento.
- [ ] Implementar la lectura de récords.
- [ ] Implementar la validación de puntuaciones.
- [ ] Guardar los nuevos récords.
- [ ] Recuperar los datos al volver a entrar.
- [ ] Gestionar errores y límites de almacenamiento.

### 2.5. Validación de la versión 0.1

- [ ] Probar una partida completa.
- [ ] Probar varias máquinas simultáneas.
- [ ] Verificar que las sesiones no comparten estado.
- [ ] Comprobar la liberación de máquinas.
- [ ] Comprobar el guardado de récords.
- [ ] Verificar la recuperación de datos.
- [ ] Probar desconexiones durante una partida.
- [ ] Corregir errores críticos.

**Criterio de finalización:** un jugador puede entrar, utilizar una máquina, jugar, conseguir una puntuación, guardar su récord y recuperarlo en una sesión posterior.

## Fase 3 — Mejoras de la experiencia

**Objetivo:** mejorar la calidad de la primera versión jugable.

- [ ] Mejorar la interfaz del minijuego.
- [ ] Añadir efectos visuales y sonoros.
- [ ] Mejorar las animaciones de las máquinas.
- [ ] Revisar los controles.
- [ ] Mejorar la experiencia de entrada y salida de partidas.
- [ ] Optimizar los recursos utilizados.
- [ ] Realizar pruebas con varios jugadores.
- [ ] Corregir errores detectados.

**Criterio de finalización:** la primera máquina ofrece una experiencia consistente, comprensible y suficientemente pulida.

## Fase 4 — Ampliación de minijuegos

<badge>Versión 0.3</badge>

**Objetivo:** demostrar que la arquitectura permite incorporar nuevas experiencias.

- [ ] Diseñar el sistema de integración de minijuegos.
- [ ] Implementar Bubble Shooter.
- [ ] Crear su máquina correspondiente.
- [ ] Integrar su puntuación y récord personal.
- [ ] Implementar Space Shooter.
- [ ] Crear su máquina correspondiente.
- [ ] Integrar su puntuación y récord personal.
- [ ] Implementar Brick Breaker.
- [ ] Crear su máquina correspondiente.
- [ ] Integrar su puntuación y récord personal.
- [ ] Probar la ejecución simultánea de diferentes minijuegos.

**Criterio de finalización:** los minijuegos pueden ejecutarse de forma independiente y reutilizan correctamente los sistemas comunes.

## Fase 5 — Ampliación del salón recreativo

<badge>Versión 0.4</badge>

**Objetivo:** convertir el primer espacio de pruebas en un salón recreativo reconocible y social.

- [ ] Diseñar la distribución del salón.
- [ ] Incorporar todas las máquinas disponibles.
- [ ] Crear una zona social.
- [ ] Mejorar la iluminación y decoración.
- [ ] Incorporar elementos ambientales.
- [ ] Mejorar la navegación por el escenario.
- [ ] Optimizar el rendimiento del entorno.

**Criterio de finalización:** el salón ofrece un espacio coherente, navegable y preparado para recibir jugadores.

## Fase 6 — Economía y recompensas

<badge>Versión 0.5</badge>

**Objetivo:** incorporar progresión y recompensas sin perjudicar la competición.

- [ ] Diseñar la economía del juego.
- [ ] Implementar monedas.
- [ ] Definir las fuentes de obtención.
- [ ] Diseñar las recompensas.
- [ ] Implementar elementos desbloqueables.
- [ ] Crear una interfaz de progresión.
- [ ] Validar las transacciones en servidor.
- [ ] Probar la persistencia de los datos.

**Criterio de finalización:** los jugadores pueden conseguir y utilizar recompensas mediante un sistema seguro y equilibrado.

## Fase 7 — Clasificaciones entre amigos

<badge>Versión 0.6</badge>

**Objetivo:** permitir que los jugadores comparen sus resultados con sus amigos.

- [ ] Diseñar la visualización de clasificaciones.
- [ ] Obtener los resultados de amigos.
- [ ] Mostrar récords por minijuego.
- [ ] Gestionar jugadores sin puntuaciones.
- [ ] Optimizar las consultas de datos.

**Criterio de finalización:** los jugadores pueden consultar y comparar sus mejores resultados con los de sus amigos.

## Fase 8 — Clasificación global

<badge>Versión 0.7</badge>

**Objetivo:** introducir competición a escala global.

- [ ] Diseñar el sistema de clasificación mundial.
- [ ] Implementar el almacenamiento de puntuaciones globales.
- [ ] Gestionar actualizaciones de resultados.
- [ ] Implementar consultas paginadas.
- [ ] Gestionar empates.
- [ ] Prevenir puntuaciones manipuladas.
- [ ] Optimizar las consultas y actualizaciones.
- [ ] Realizar pruebas de rendimiento.

**Criterio de finalización:** los jugadores pueden consultar clasificaciones globales fiables y actualizadas.

## Fase 9 — Preparación para publicación

<badge color="success">Objetivo: versión 1.0</badge>

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

---

# 3. Prioridades de desarrollo

El orden de prioridades será:

1. Funcionamiento correcto de las partidas.
2. Arquitectura modular y mantenible.
3. Seguridad y validación en servidor.
4. Persistencia fiable de datos.
5. Experiencia de usuario.
6. Diseño visual.
7. Sistemas sociales y progresión.
8. Ampliaciones y funcionalidades secundarias.

Las prioridades podrán revisarse cuando aparezcan problemas técnicos o nuevas necesidades.

# 4. Gestión del trabajo

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

# 5. Control de versiones

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

# 6. Criterios generales de calidad

Una funcionalidad no se considerará terminada únicamente porque funcione en una prueba aislada.

Se deberá comprobar, cuando corresponda:

- Comportamiento esperado.
- Casos límite.
- Errores y desconexiones.
- Seguridad.
- Rendimiento.
- Compatibilidad con el resto del proyecto.
- Actualización de documentación.

# 7. Estado actual

**Fase actual: Fase 0 — Preparación del entorno.**

Herramientas principales instaladas y configuración inicial de Rojo validada mediante una compilación de prueba.

Pendiente:

- Conexión de Rojo con Roblox Studio.
- Configuración y publicación del repositorio remoto.
- Finalización de documentación inicial.
- Primer commit del proyecto.

---

## 8. Actualización de planificación: expansión y economía

**Fecha de actualización:** 04/11/2026.

Esta actualización recoge las decisiones definitivas sobre la expansión del arcade, el acceso individual a las salas y el modelo de monetización.

### 8.1. Diseño del mapa

Se establece un diseño conceptual inicial para el salón:

- Dimensiones orientativas de 100 × 80 studs.
- Entrada y núcleo central.
- Cuatro zonas iniciales diferenciadas, una por cada minijuego.
- Zona social y espacio para clasificaciones.
- Puntos de conexión reservados para futuras expansiones.

El diseño completo se encuentra en `docs/MAP_DESIGN.md`.

El mapa se construirá principalmente con piezas nativas de Roblox y scripts Luau, priorizando la modularidad y el rendimiento.

El diseño del mapa se prepara desde las primeras fases, pero su construcción completa se realizará cuando corresponda dentro de la planificación.

### 8.2. Expansión mediante nuevas salas

Las futuras salas podrán desbloquearse mediante Arcade Tokens (AT).

Condiciones:
- Cada desbloqueo será permanente e individual.
- Cada sala nueva incluirá al menos dos minijuegos gratuitos.
- No se venderán máquinas ni partidas individuales.
- Los jugadores necesitarán sus propios desbloqueos para acceder a cada sala.
- El servidor validará los permisos de acceso.

La estructura inicial deberá permitir añadir nuevas habitaciones y zonas sin reconstruir el salón original.

### 8.3. Economía y monetización

La economía se desarrollará en una fase posterior, una vez que los minijuegos principales funcionen correctamente.

Se utilizará Arcade Tokens (AT) como moneda provisional.

Los jugadores podrán obtener AT jugando y utilizarlos para desbloquear nuevas salas y contenido de progresión.

La monetización opcional mediante Robux podrá incluir:

- Multiplicadores de obtención de moneda, como x2 AT.
- Packs de AT.
- Skins, estelas, títulos y efectos cosméticos.

Quedan descartadas las compras que proporcionen ventajas competitivas, multipliquen puntuaciones o permitan comprar máquinas.

El modelo será Pay to Fast, nunca Pay to Win.

### 8.4. Ajustes en las fases de desarrollo

**Fase 1 — Primer minijuego funcional**
- Se mantiene como prioridad implementar una primera experiencia jugable completa.
- No requiere economía ni desbloqueos de salas.

**Fase 2 — Persistencia**
- Guardado y recuperación de récords personales.
- Preparación para ampliar posteriormente los datos persistentes del jugador.

**Fase 3 — Nuevos minijuegos**
- Incorporación progresiva de las experiencias previstas.
- Mantener la independencia de las sesiones y las máquinas.

**Fase 4 — Salón arcade**
- Construcción del salón principal.
- Implementación de las cuatro zonas iniciales.
- Incorporación de entrada, núcleo central y zona social.
- Preparación de conexiones para futuras expansiones.

**Fase 5 — Economía**
- Implementación de Arcade Tokens.
- Recompensas por jugar.
- Desbloqueo permanente de salas.
- Validación de permisos individuales.
- Pruebas de equilibrio de progresión.

**Fase 6 — Clasificaciones**
- Ranking de amigos.
- Ranking global.
- Garantizar que las compras no afecten a las puntuaciones.

**Fases posteriores — Monetización y expansión**
- Incorporación de compras opcionales con Robux.
- Multiplicadores de obtención de AT.
- Cosméticos.
- Nuevas salas y minijuegos.

### 8.5. Criterios económicos de calidad

Antes de publicar cualquier sistema económico se comprobará que:

1. Todo el contenido jugable puede conseguirse gratuitamente.
2. Las máquinas y partidas nunca requieren pagos.
3. El progreso gratuito tiene un ritmo razonable.
4. No existen esperas artificiales diseñadas para forzar compras.
5. Las compras no alteran puntuaciones ni clasificaciones.
6. Los desbloqueos individuales se validan en el servidor.
7. Las compras se procesan de forma segura y no duplican recompensas.

Los precios, recompensas y tiempos de desbloqueo se definirán mediante pruebas de juego. No se fijarán cantidades arbitrarias antes de disponer de una experiencia jugable con la que medir el progreso.

*El roadmap es un documento vivo. Los objetivos y prioridades podrán cambiar según el progreso, las pruebas y las decisiones técnicas del proyecto.*
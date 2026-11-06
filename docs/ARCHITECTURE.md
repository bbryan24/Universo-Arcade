# UNIVERSO ARCADE — ARQUITECTURA TÉCNICA

| Información | Detalle |
|---|---|
| Proyecto | Universo Arcade |
| Documento | Arquitectura técnica |
| Versión del documento | 0.3 |
| Fecha | Noviembre de 2026 |
| Estado | Arquitectura inicial definida; BrickBreaker en desarrollo avanzado |
| Lenguaje principal | Luau |
| Motor | Roblox |
| Sincronización | Rojo 7.7.1 |
| Control de versiones | Git / GitHub |

---

# 1. Introducción

## 1.1. Objetivo

Este documento define la arquitectura técnica de Universo Arcade y establece las bases para implementar sus sistemas principales.

El proyecto está concebido como una experiencia multijugador de Roblox que reúne diferentes minijuegos independientes dentro de un salón recreativo.

La arquitectura debe permitir desarrollar nuevos minijuegos reutilizando los sistemas comunes y evitando duplicaciones innecesarias.

Se priorizarán:

- Modularidad.
- Separación de responsabilidades.
- Seguridad.
- Mantenibilidad.
- Reutilización de componentes.
- Independencia entre sesiones de juego.
- Posibilidad de ampliar el proyecto progresivamente.

Este documento diferencia los sistemas que ya están implementados de aquellos que forman parte del diseño técnico y todavía necesitan desarrollarse.

## 1.2. Principios arquitectónicos

El proyecto seguirá los siguientes principios:

- Separación entre cliente y servidor.
- Validación de operaciones importantes en servidor.
- Reutilización de sistemas comunes.
- Independencia entre minijuegos.
- Dependencias explícitas entre módulos.
- Persistencia de datos controlada.
- Gestión segura de errores.
- Código legible y documentado.
- Configuración centralizada.
- Evolución incremental de la arquitectura.
- Evitar abstracciones innecesarias.

## 1.3. Tecnologías

| Tecnología | Responsabilidad |
|---|---|
| Roblox Studio | Motor y entorno de ejecución |
| Luau | Lenguaje de programación |
| Visual Studio Code | Desarrollo y edición |
| Rojo 7.7.1 | Sincronización entre archivos y Roblox Studio |
| Rokit | Gestión de herramientas |
| Git | Control de versiones |
| GitHub | Alojamiento del repositorio |

---

# 2. Arquitectura general

## 2.1. Separación de ejecución

La arquitectura se dividirá en tres grandes áreas.

### Cliente

Se ejecutará en el dispositivo del jugador.

Responsabilidades:

- Gestionar la interfaz.
- Recoger las entradas del jugador.
- Controlar las cámaras.
- Mostrar información de las partidas.
- Presentar animaciones y efectos.
- Enviar solicitudes al servidor.
- Representar visualmente el estado de las máquinas.
- Mostrar los resultados de las partidas.

El cliente no tendrá autoridad sobre las puntuaciones finales, las reservas de máquinas ni los datos persistentes.

En la implementación actual de BrickBreaker, la lógica de juego y su representación se ejecutan principalmente en el cliente. Su integración con una futura validación autoritativa del servidor queda pendiente.

### Servidor

Se ejecutará en Roblox y será responsable de la lógica importante del juego.

Responsabilidades:

- Gestionar las máquinas.
- Reservar y liberar máquinas.
- Crear y finalizar sesiones.
- Validar las acciones de los jugadores.
- Gestionar las partidas.
- Controlar las puntuaciones.
- Gestionar los récords personales.
- Validar recompensas y desbloqueos.
- Acceder al almacenamiento persistente.

### Código compartido

Contendrá módulos utilizados tanto por el cliente como por el servidor.

Responsabilidades:

- Configuraciones comunes.
- Constantes.
- Tipos de datos.
- Definiciones de interfaces.
- Utilidades compartidas.

No deberá contener secretos ni lógica que necesite permanecer protegida en el servidor.

## 2.2. Correspondencia con Roblox

La estructura de Rojo utiliza las siguientes correspondencias:

| Directorio del proyecto | Ubicación en Roblox |
|---|---|
| `src/client` | `StarterPlayer/StarterPlayerScripts/Client` |
| `src/server` | `ServerScriptService/Server` |
| `src/shared` | `ReplicatedStorage/Shared` |

El archivo `default.project.json` define estos mapeos.

Los recursos visuales, modelos y elementos del mapa se organizarán mediante los mecanismos de Roblox y Rojo que correspondan.

---

# 3. Estructura de directorios

La estructura actual del proyecto separa el código cliente, servidor y compartido.

```text
Universo Arcade/
│
├── src/
│   ├── client/
│   │   ├── Controllers/
│   │   │   └── MachineClientController.client.luau
│   │   │
│   │   ├── UI/
│   │   │   └── MachineInterface.luau
│   │   │
│   │   └── Minigames/
│   │       └── BrickBreaker/
│   │           ├── BrickBreakerController.luau
│   │           └── BrickBreakerInput.luau
│   │
│   ├── server/
│   │   ├── Main.server.luau
│   │   └── Services/
│   │       ├── MapBuilder.luau
│   │       ├── LightingService.luau
│   │       ├── ArcadeLightingService.luau
│   │       ├── WallArchitectureService.luau
│   │       ├── WallDecorationService.luau
│   │       └── WallPosterService.luau
│   │
│   └── shared/
│       └── Config/
│           └── MapConfig.luau
│
├── default.project.json
├── aftman.toml
└── ...
```

Esta estructura refleja los componentes conocidos del proyecto. Se ampliará a medida que se implementen los sistemas jugables.

La estructura de los módulos de BrickBreaker podrá evolucionar conforme se incorporen nuevas responsabilidades, evitando duplicar módulos o introducir dependencias innecesarias.

## 3.1. Client

Contendrá los controladores responsables de coordinar las funcionalidades del cliente.

### Controllers

Responsables de coordinar las funcionalidades del jugador.

Controlador implementado actualmente:

- `MachineClientController.client.luau`: coordina la interacción del cliente con la interfaz y la experiencia de las máquinas.

Se contemplan otros controladores para futuras funcionalidades, como la interacción general con máquinas y la gestión de cámaras.

### UI

Contendrá los componentes y pantallas de interfaz.

Elemento implementado actualmente:

- `MachineInterface.luau`: gestiona la interfaz de la experiencia de las máquinas, incluyendo las pantallas utilizadas por BrickBreaker.

La interfaz de BrickBreaker contempla:

- Pantalla inicial `PRESS START`.
- Interfaz de juego.
- Información de puntuación y vidas.
- Menú de pausa.
- Confirmación de salida.
- Transiciones entre niveles.
- Pantalla `GAME OVER`.
- Puntuación final y récord mostrado.
- Reinicio de la partida.

La organización podrá ampliarse con componentes específicos cuando aparezcan necesidades reales.

### Minigames

Contendrá los módulos propios de cada minijuego.

Minijuego con implementación avanzada:

- `BrickBreaker`: contiene la lógica de juego, la gestión de controles y los elementos necesarios para ejecutar la experiencia en el cliente.

Módulos actuales:

- `BrickBreakerController.luau`: coordina la lógica y el estado de la partida.
- `BrickBreakerInput.luau`: gestiona los controles del jugador.

Se podrán incorporar módulos adicionales, como los encargados de representar el tablero o gestionar elementos concretos, respetando los módulos que ya existan en el proyecto.

Los demás minijuegos se incorporarán progresivamente cuando comience su desarrollo.

## 3.2. Server

Contendrá la lógica autoritativa del juego.

### Main

`Main.server.luau` es el punto de entrada del servidor.

Se encarga de cargar los servicios y ejecutar la inicialización del proyecto.

### Services

Contiene los servicios encargados de gestionar funcionalidades centrales.

**Servicios implementados actualmente:**

| Servicio | Responsabilidad | Estado |
|---|---|---|
| `MapBuilder` | Construcción del mapa principal | Implementado |
| `LightingService` | Iluminación ambiental | Implementado |
| `ArcadeLightingService` | Iluminación arquitectónica | Implementado |
| `WallArchitectureService` | Patrones geométricos de paredes | Implementado |
| `WallDecorationService` | Elementos decorativos superiores | Implementado |
| `WallPosterService` | Generación de pósteres | Implementado |

**Servicios previstos para la funcionalidad jugable:**

- `MachineService`
- `SessionService`
- `ScoreService`
- `PlayerDataService`

Estos servicios todavía no forman parte de la implementación funcional.

### Systems

Contendrá sistemas reutilizables que no necesariamente representan servicios centrales.

Sistemas previstos:

- `MachineAvailabilitySystem`
- `MinigameRegistry`
- `SessionLifecycleSystem`

La necesidad de separar estos sistemas en módulos independientes se evaluará durante la implementación.

### Data

Contendrá estructuras y módulos relacionados con los datos persistentes.

Elementos previstos:

- `PlayerDataRepository`
- `PlayerDataSchema`
- `DataValidation`

## 3.3. Shared

Contendrá módulos que puedan utilizar tanto el cliente como el servidor.

### Config

Configuraciones generales del proyecto.

**Configuración implementada:**

- `MapConfig.luau`

Contiene las dimensiones y parámetros principales del mapa.

Se añadirán progresivamente configuraciones de máquinas y minijuegos.

### Types

Contendrá definiciones de tipos Luau.

Tipos previstos:

- `MachineTypes`
- `SessionTypes`
- `ScoreTypes`
- `PlayerDataTypes`

### Modules

Contendrá módulos compartidos y utilidades generales.

Su organización se definirá conforme aparezcan necesidades reales.

Los ejemplos anteriores son propuestas de organización, no módulos que deban crearse todos desde el principio.

---

# 4. Punto de entrada e inicialización

## 4.1. Main.server.luau

El servidor utiliza `Main.server.luau` como punto de entrada.

Actualmente, su inicialización sigue este orden general:

1. Cargar los servicios necesarios.
2. Eliminar objetos predeterminados de Studio que no forman parte del mapa.
3. Construir el mapa principal mediante `MapBuilder`.
4. Crear el punto de aparición propio.
5. Aplicar la arquitectura de paredes.
6. Aplicar la decoración de paredes.
7. Generar los pósteres.
8. Aplicar la iluminación ambiental.
9. Aplicar la iluminación arquitectónica.
10. Finalizar la inicialización.

El punto de aparición se crea dentro del núcleo central del salón.

La eliminación de los objetos predeterminados afecta al `Baseplate` y al `SpawnLocation` original de Studio. No debe eliminarse el punto de aparición propio del proyecto.

## 4.2. Responsabilidades de los servicios del mapa

Cada servicio mantiene una responsabilidad diferenciada:

- `MapBuilder`: geometría y construcción principal.
- `LightingService`: configuración ambiental.
- `ArcadeLightingService`: focos y elementos de iluminación arquitectónica.
- `WallArchitectureService`: patrones integrados en las paredes.
- `WallDecorationService`: elementos decorativos superiores.
- `WallPosterService`: pósteres generados mediante código.

Los servicios visuales no deben modificar innecesariamente la geometría principal del mapa.

---

# 5. Arquitectura de máquinas arcade

## 5.1. Concepto

Cada máquina será una entidad independiente dentro del salón recreativo.

Una máquina tendrá:

- Identificador único.
- Tipo de minijuego.
- Estado de disponibilidad.
- Jugador asignado, si está ocupada.
- Referencia a su modelo físico.

La máquina no deberá contener directamente toda la lógica del minijuego.

Su función será actuar como punto de acceso a una experiencia de juego.

El salón principal dispone de 28 máquinas, distribuidas en cuatro salas con siete máquinas cada una.

La integración funcional de estas máquinas todavía está pendiente.

## 5.2. Identificación

Cada máquina deberá disponer de un identificador único y estable.

El identificador permitirá:

- Reconocer la máquina.
- Consultar su configuración.
- Asociarla a un minijuego.
- Gestionar su disponibilidad.
- Relacionarla con una sesión.

La identificación definitiva se establecerá durante la implementación.

No se deberá depender únicamente del nombre visual del modelo para identificar una máquina.

## 5.3. Estados de una máquina

Se contemplan los siguientes estados:

| Estado | Descripción |
|---|---|
| `Available` | Disponible para jugar |
| `Reserved` | Reservada por un jugador |
| `InUse` | Partida en ejecución |
| `Unavailable` | Temporalmente fuera de servicio |

Las transiciones deberán estar controladas por el servidor.

## 5.4. Reserva de máquinas

Cuando un jugador interactúe con una máquina:

1. El servidor comprobará que el jugador es válido.
2. Comprobará la distancia de interacción.
3. Verificará que la máquina existe.
4. Comprobará que la máquina está disponible.
5. Validará que el jugador puede utilizarla.
6. Reservará la máquina para ese jugador.
7. Creará una sesión de juego.
8. Confirmará al cliente que puede comenzar.

La reserva deberá realizarse de forma controlada para impedir que dos jugadores ocupen simultáneamente la misma máquina.

## 5.5. Liberación

La máquina deberá volver a estar disponible cuando:

- Finalice la partida.
- El jugador abandone voluntariamente.
- El jugador se desconecte.
- Se produzca un error que obligue a cancelar la sesión.

La liberación deberá ser segura e idempotente: ejecutarla varias veces no deberá dejar estados inconsistentes.

---

# 6. Arquitectura de minijuegos

## 6.1. Independencia

Cada minijuego tendrá su propia lógica y estado.

Los sistemas generales no deberán conocer los detalles internos de las mecánicas específicas.

La comunicación se realizará mediante contratos comunes definidos por la arquitectura.

BrickBreaker constituye actualmente la primera implementación avanzada de un minijuego. Su desarrollo permite probar la organización de módulos, la gestión de controles, las pantallas y el ciclo de una partida antes de completar el sistema general de máquinas y sesiones.

## 6.2. Registro de minijuegos

Se utilizará un registro central que permita identificar los minijuegos disponibles.

Cada entrada deberá proporcionar información suficiente para iniciar una partida del tipo correspondiente.

Minijuegos iniciales:

- `BlockPuzzle`
- `BubbleShooter`
- `SpaceShooter`
- `BrickBreaker`

El registro evitará tener que añadir condiciones específicas para cada minijuego en el sistema general de sesiones.

La implementación definitiva del registro está pendiente.

## 6.3. Ciclo de vida

Todos los minijuegos deberán seguir un ciclo de vida común:

1. Preparación.
2. Inicialización.
3. Inicio.
4. Ejecución.
5. Finalización.
6. Limpieza.

La implementación interna podrá variar, pero deberá respetar las responsabilidades y transiciones generales.

BrickBreaker ya dispone de una gestión propia de inicio, pausa, continuación de nivel, finalización y reinicio. Esta gestión todavía no equivale a la integración con un ciclo de vida común administrado por el servidor.

## 6.4. Separación de lógica y presentación

La lógica del minijuego y su representación visual estarán separadas.

El cliente se encargará de presentar la experiencia y recoger los controles.

El servidor será responsable de validar las acciones y determinar los resultados.

En BrickBreaker, la lógica de la partida y su representación se ejecutan actualmente en el cliente. Esto permite desarrollar y probar sus mecánicas y su interfaz, pero no constituye todavía una simulación autoritativa en servidor.

La integración futura deberá estudiar cómo validar las acciones y resultados desde el servidor, evitando confiar directamente en las puntuaciones comunicadas por el cliente.

La estrategia podrá adaptarse a cada minijuego siempre que se mantenga una validación segura de resultados.

---

# 7. Sistema de sesiones

## 7.1. Concepto

Una sesión representa una partida individual de un jugador en una máquina.

Cada sesión tendrá:

- Identificador único.
- Jugador propietario.
- Máquina asociada.
- Tipo de minijuego.
- Estado actual.
- Puntuación.
- Datos específicos de la partida.

## 7.2. Estados de una sesión

| Estado | Descripción |
|---|---|
| `Initializing` | Preparando la partida |
| `Active` | Partida en ejecución |
| `Completed` | Finalizada correctamente |
| `Cancelled` | Cancelada |
| `Failed` | Finalizada por un error |

Las transiciones estarán controladas por el servidor.

## 7.3. Independencia de sesiones

Cada sesión mantendrá su propio estado.

No se utilizarán variables globales compartidas para almacenar datos específicos de diferentes partidas.

El sistema deberá permitir que varios jugadores ejecuten el mismo minijuego simultáneamente, siempre que utilicen máquinas diferentes.

## 7.4. Relación entre máquinas y sesiones

La relación inicial será:

- Una máquina podrá tener como máximo una sesión activa.
- Un jugador podrá tener como máximo una sesión arcade activa.
- Una sesión pertenecerá a un único jugador.
- Una sesión estará asociada a una única máquina.

Estas restricciones podrán ampliarse en futuras versiones si el diseño del juego lo requiere.

---

# 8. Comunicación entre cliente y servidor

## 8.1. Principios

La comunicación se realizará mediante los mecanismos de red de Roblox, principalmente `RemoteEvents` y `RemoteFunctions` cuando corresponda.

Las solicitudes deberán estar claramente definidas.

No se permitirá que el cliente modifique directamente el estado interno del servidor.

Se priorizará el uso de `RemoteEvents` para solicitudes y notificaciones cuando no sea necesario esperar una respuesta síncrona.

## 8.2. Operaciones previstas

Entre las operaciones iniciales se encuentran:

- Solicitar acceso a una máquina.
- Recibir confirmación o rechazo.
- Recibir actualizaciones de disponibilidad.
- Confirmar el inicio de una sesión.
- Enviar acciones del minijuego.
- Solicitar la finalización de una partida.
- Recibir resultados.

Los nombres y contratos definitivos de los eventos se establecerán durante la implementación.

## 8.3. Seguridad

El servidor deberá validar:

- Identidad del jugador.
- Propiedad de la sesión.
- Estado actual de la partida.
- Tipo de operación solicitada.
- Parámetros recibidos.
- Frecuencia de solicitudes.
- Distancia a la máquina cuando corresponda.

Los datos enviados por el cliente siempre se considerarán no confiables.

---

# 9. Sistema de puntuaciones

## 9.1. Responsabilidad

El servidor será responsable de determinar la puntuación válida.

La puntuación no podrá aceptarse únicamente porque el cliente la comunique.

## 9.2. Validaciones

Se comprobará:

- Que exista una sesión válida.
- Que pertenezca al jugador.
- Que el minijuego corresponda a esa sesión.
- Que la partida se encuentre en un estado válido.
- Que el resultado cumpla las reglas del minijuego.

## 9.3. Récords

Cada jugador tendrá un registro independiente por minijuego.

Se conservará el mejor resultado válido.

La actualización de un récord no deberá sustituir un resultado superior por otro inferior.

BrickBreaker muestra actualmente la puntuación final y un campo destinado al récord en su pantalla de `GAME OVER`. Sin embargo, el almacenamiento persistente y la actualización segura de récords todavía no están implementados.

El sistema general de puntuaciones continúa pendiente de implementación.

---

# 10. Persistencia de datos

## 10.1. Tecnología

Se utilizará inicialmente `DataStoreService` de Roblox para almacenar los datos persistentes de los jugadores.

El acceso a este servicio estará limitado al servidor.

## 10.2. Datos previstos

El modelo inicial podrá incluir:

- Identificador del jugador.
- Récord de cada minijuego.
- Arcade Tokens.
- Salas desbloqueadas.
- Datos de personalización.
- Fecha de actualización.
- Versión del esquema de datos.

Los campos se incorporarán progresivamente según se implementen las funcionalidades correspondientes.

## 10.3. Requisitos

El sistema deberá contemplar:

- Lectura de datos al entrar.
- Guardado de cambios.
- Actualización segura de récords.
- Reintentos controlados ante errores temporales.
- Prevención de sobrescrituras incorrectas.
- Límites de solicitudes.
- Gestión de desconexiones.
- Evolución del esquema de datos.

Se utilizarán operaciones de actualización seguras cuando sea necesario evitar que diferentes servidores sobrescriban información más reciente.

## 10.4. Separación de responsabilidades

La lógica de juego no accederá directamente a `DataStoreService`.

Los servicios de juego utilizarán una capa de acceso a datos que centralizará las operaciones de lectura y escritura.

La persistencia todavía está pendiente de implementación.

---

# 11. Seguridad y protección frente a trampas

La seguridad será una responsabilidad transversal de la arquitectura.

Se aplicarán los siguientes principios:

- El servidor tendrá autoridad sobre el estado de las partidas.
- El cliente no podrá reservar máquinas directamente.
- Las puntuaciones serán validadas.
- Las solicitudes tendrán límites de frecuencia.
- Se comprobarán los datos recibidos.
- No se confiará en identificadores enviados por el cliente sin validación.
- Los datos persistentes solo se modificarán desde el servidor.
- Las recompensas se calcularán y concederán desde el servidor.

Se evitará exponer información sensible en módulos compartidos o código del cliente.

---

# 12. Gestión de errores y limpieza

Los sistemas deberán contemplar errores sin dejar recursos ocupados indefinidamente.

Se prestará especial atención a:

- Sesiones interrumpidas.
- Jugadores desconectados.
- Errores de inicialización.
- Fallos de comunicación.
- Errores de almacenamiento.
- Finalizaciones duplicadas.
- Referencias a objetos eliminados.
- Máquinas que queden reservadas accidentalmente.

Los recursos asociados a una sesión deberán liberarse al finalizarla.

La limpieza deberá poder ejecutarse de forma segura aunque algunos pasos anteriores hayan fallado.

---

# 13. Pruebas y calidad

Se aplicarán diferentes niveles de pruebas.

## 13.1. Pruebas de módulos

Comprobarán las funciones individuales y sus casos límite.

## 13.2. Pruebas de integración

Comprobarán la interacción entre:

- Máquinas y sesiones.
- Sesiones y minijuegos.
- Minijuegos y puntuaciones.
- Puntuaciones y persistencia.
- Jugadores y desbloqueos.

## 13.3. Pruebas multijugador

Se comprobarán situaciones con varios jugadores y varias máquinas.

Se prestará especial atención a las reservas simultáneas y a la independencia de las sesiones.

## 13.4. Pruebas de errores

Se probarán desconexiones, solicitudes inválidas, finalizaciones duplicadas y fallos de almacenamiento.

Una funcionalidad no se considerará terminada hasta superar las pruebas relevantes para su responsabilidad.

---

# 14. Convenciones de desarrollo

## 14.1. Nomenclatura

Se utilizarán nombres descriptivos y coherentes.

| Elemento | Convención | Ejemplo |
|---|---|---|
| Variables | camelCase | `activeSession` |
| Funciones | camelCase | `startSession()` |
| Módulos | PascalCase | `SessionService` |
| Tipos Luau | PascalCase | `SessionData` |
| Constantes | UPPER_SNAKE_CASE | `MAX_SESSION_TIME` |

## 14.2. Código

- Preferir módulos pequeños y con una responsabilidad clara.
- Evitar duplicación de lógica.
- Utilizar anotaciones de tipos Luau.
- Evitar dependencias circulares.
- Documentar decisiones complejas.
- No introducir abstracciones innecesarias.
- Mantener las funciones fáciles de probar.
- Centralizar las configuraciones que deban compartirse.

## 14.3. Control de versiones

Se utilizará Git para registrar los cambios del proyecto.

Los commits seguirán la convención:

`tipo: descripción breve en español`

Se evitarán commits que mezclen funcionalidades independientes.

Los cambios se probarán antes de considerarlos terminados y antes de crear un checkpoint estable.

---

# 15. Sistemas futuros de progresión y monetización

Esta sección define la arquitectura prevista para los sistemas económicos y de desbloqueo de Universo Arcade.

Su inclusión en el diseño técnico no implica que deban implementarse durante la primera versión.

## 15.1. CurrencyService

Responsable de gestionar los Arcade Tokens (AT).

Responsabilidades:

- Consultar el saldo del jugador.
- Añadir o descontar moneda.
- Validar que las operaciones sean legítimas.
- Registrar las recompensas obtenidas al finalizar partidas.
- Guardar y recuperar el saldo mediante `DataStoreService`.

Las operaciones económicas estarán controladas por el servidor.

El cliente nunca podrá establecer directamente su propio saldo ni decidir cuántas monedas recibe.

## 15.2. UnlockService

Gestionará los desbloqueos permanentes de salas.

Responsabilidades:

- Consultar las salas desbloqueadas por un jugador.
- Validar si dispone de AT suficientes.
- Procesar los desbloqueos.
- Evitar compras duplicadas de una misma sala.
- Persistir los desbloqueos asociados al `UserId`.

Cada jugador tendrá su propia progresión.

Los desbloqueos no se compartirán entre amigos ni dependerán de quién haya creado el servidor.

## 15.3. RoomAccess y RoomPresentation

Se separará la validación real del acceso de su representación visual.

**RoomAccess — servidor**

- Comprobará si el jugador tiene permiso para entrar.
- Bloqueará el acceso a salas no desbloqueadas.
- Validará también el acceso a las máquinas y minijuegos de cada sala.

**RoomPresentation — cliente**

- Representará visualmente las puertas y accesos según los desbloqueos individuales.
- Mostrará las salas disponibles y las pendientes de desbloqueo.
- Permitirá que dos jugadores vean estados diferentes de una misma puerta.

La representación visual nunca sustituirá a la validación del servidor.

## 15.4. MonetizationService

Gestionará las compras opcionales con Robux utilizando `MarketplaceService`.

Responsabilidades:

- Procesar productos de desarrollador (`Developer Products`).
- Gestionar posibles pases de juego (`Game Passes`).
- Aplicar multiplicadores de obtención de AT.
- Gestionar la entrega de productos cosméticos.
- Validar las compras desde el servidor.

Las entregas de Developer Products deberán ser idempotentes: una misma compra no podrá entregar recompensas duplicadas, incluso si Roblox vuelve a notificar su recibo.

Los multiplicadores de AT afectarán exclusivamente a la moneda obtenida.

Nunca modificarán las puntuaciones, el rendimiento de las máquinas ni las condiciones competitivas.

## 15.5. CosmeticService

Gestionará los elementos de personalización del jugador.

Podrá incluir:

- Skins.
- Estelas.
- Efectos visuales.
- Títulos.
- Otros elementos estéticos.

Los cosméticos estarán separados de los sistemas de puntuación y de la lógica de los minijuegos.

## 15.6. Reglas obligatorias

- Todas las máquinas serán gratuitas.
- No existirá un sistema de compra individual de máquinas.
- Los minijuegos no se venderán individualmente.
- El acceso a una sala dependerá de los desbloqueos del jugador.
- El servidor será la autoridad sobre moneda, compras, permisos y recompensas.
- El cliente solo solicitará operaciones y representará sus resultados.
- Ninguna compra podrá modificar puntuaciones ni proporcionar ventajas competitivas.

## 15.7. Orden previsto de implementación

1. Persistencia de datos del jugador.
2. Sistema de recompensas y Arcade Tokens.
3. Desbloqueo de salas.
4. Representación visual individual de accesos.
5. Compras opcionales y monetización.
6. Personalización cosmética.

No se implementará la economía antes de disponer de minijuegos funcionales y una experiencia jugable que permita evaluar correctamente las recompensas.

---

# 16. Decisiones técnicas pendientes

Las siguientes decisiones se concretarán durante la implementación:

- Contratos definitivos de los minijuegos.
- Identificadores y configuración de las máquinas.
- Organización final de los `RemoteEvents` y `RemoteFunctions`.
- Estrategia de simulación y validación de cada minijuego.
- Modelo definitivo de persistencia.
- Estrategia de pruebas automatizadas.
- Gestión de versiones del esquema de datos.
- Organización de los recursos visuales.
- Estrategia de localización.
- Gestión de errores y registros de depuración.

Cada decisión importante deberá documentarse cuando se tome.

---

# 17. Estado actual de la arquitectura

La arquitectura del proyecto se encuentra en una fase de implementación incremental. Los sistemas de construcción del salón están implementados y BrickBreaker constituye actualmente el minijuego con mayor desarrollo funcional.

## 17.1. Implementado

**Estructura e infraestructura**

- [x] Estructura básica de cliente, servidor y código compartido.
- [x] Configuración de Rojo.
- [x] Punto de entrada del servidor.
- [x] Construcción procedural del mapa.
- [x] Configuración de iluminación ambiental.
- [x] Iluminación arquitectónica.
- [x] Arquitectura decorativa de paredes.
- [x] Generación de elementos decorativos superiores.
- [x] Generación de pósteres.
- [x] Punto de aparición propio.
- [x] Configuración centralizada de las dimensiones principales del mapa.

**BrickBreaker — implementación avanzada en cliente**

- [x] Controlador principal del minijuego.
- [x] Módulo de gestión de controles.
- [x] Movimiento de la pala mediante teclado y ratón.
- [x] Inicio de partida mediante teclado o clic.
- [x] Pantalla inicial `PRESS START`.
- [x] Gestión de puntuación y vidas durante la partida.
- [x] Gestión de niveles y transición entre niveles.
- [x] Sistema de pausa.
- [x] Menú de pausa con opción de reanudar.
- [x] Confirmación de salida de la partida.
- [x] Pantalla `GAME OVER`.
- [x] Visualización de la puntuación final.
- [x] Visualización del campo destinado al récord.
- [x] Reinicio de la partida mediante teclado o clic.
- [x] Preparación de la bola sobre la pala después del reinicio.

La implementación de BrickBreaker continúa evolucionando. Su lógica actual se ejecuta principalmente en el cliente y todavía no está integrada con un sistema general de sesiones, puntuaciones autoritativas y persistencia en servidor.

## 17.2. Diseñado, pero pendiente de implementación

- [ ] Registro general de máquinas.
- [ ] Sistema de interacción con máquinas.
- [ ] Gestión de disponibilidad.
- [ ] Reservas de máquinas.
- [ ] Sistema general de sesiones.
- [ ] Ciclo de vida común de los minijuegos.
- [ ] Comunicación general de partidas entre cliente y servidor.
- [ ] Validación autoritativa de resultados.
- [ ] Sistema general de puntuaciones.
- [ ] Persistencia de datos mediante `DataStoreService`.
- [ ] Guardado y actualización de récords.
- [ ] Integración de BrickBreaker con los sistemas generales.

## 17.3. Planificado para versiones posteriores

- [ ] Arcade Tokens.
- [ ] Sistema de recompensas.
- [ ] Desbloqueo de salas.
- [ ] Accesos individuales.
- [ ] Clasificaciones.
- [ ] Monetización opcional.
- [ ] Personalización cosmética.
- [ ] Desarrollo de Block Puzzle.
- [ ] Desarrollo de Bubble Shooter.
- [ ] Desarrollo de Space Shooter.

## 17.4. Próximo objetivo técnico

El siguiente objetivo arquitectónico será implementar el sistema común de máquinas arcade.

El orden de trabajo previsto es:

1. Verificar la sincronización entre Visual Studio Code y Roblox Studio mediante Rojo.
2. Consolidar y guardar la versión actual del proyecto.
3. Definir la identificación y configuración de las máquinas.
4. Implementar la interacción entre jugador y máquina.
5. Implementar la disponibilidad y las reservas.
6. Crear el sistema de sesiones.
7. Definir la integración de los minijuegos con el sistema común.
8. Integrar progresivamente los minijuegos existentes.
9. Incorporar la validación de resultados y la persistencia de puntuaciones.

La implementación deberá realizarse de forma incremental, probando cada sistema antes de continuar con el siguiente.

BrickBreaker podrá seguir evolucionando en paralelo, sin que ello implique adelantar la implementación de sistemas generales que todavía no estén preparados.

---

# 18. Historial del documento

| Versión | Fecha | Cambios |
|---|---|---|
| 0.1 | Inicial | Primera definición de la arquitectura técnica del proyecto. |
| 0.2 | Noviembre de 2026 | Actualización de la estructura del proyecto y de los servicios de construcción del salón. |
| 0.3 | Noviembre de 2026 | Incorporación del estado real de BrickBreaker, sus módulos de cliente, interfaz y funcionalidades implementadas. Actualización de los sistemas pendientes y de los objetivos técnicos. |

---

*Este documento define la arquitectura técnica de Universo Arcade. Las funcionalidades descritas como diseñadas o planificadas no se considerarán implementadas hasta que exista código funcional y hayan superado las pruebas correspondientes.*
# Universo Arcade — Arquitectura técnica

| Información | Detalle |
|---|---|
| Proyecto | Universo Arcade |
| Documento | Arquitectura técnica |
| Versión del documento | 0.1 |
| Estado | Diseño inicial |
| Lenguaje principal | Luau |
| Motor | Roblox |

---

# 1. Introducción

## 1.1. Objetivo

Este documento define la arquitectura técnica de Universo Arcade y establece las bases para implementar sus sistemas principales.

La arquitectura debe permitir desarrollar diferentes minijuegos independientes, reutilizando los sistemas comunes y evitando duplicaciones innecesarias.

Se priorizarán la modularidad, la seguridad, la mantenibilidad y la posibilidad de ampliar el proyecto progresivamente.

## 1.2. Principios arquitectónicos

El proyecto seguirá los siguientes principios:

- Separación de responsabilidades.
- Separación entre cliente y servidor.
- Validación de operaciones importantes en servidor.
- Reutilización de sistemas comunes.
- Independencia entre sesiones de juego.
- Dependencias explícitas entre módulos.
- Persistencia de datos controlada.
- Gestión centralizada de errores.
- Código legible y documentado.
- Evolución incremental de la arquitectura.

## 1.3. Tecnologías

| Tecnología | Responsabilidad |
|---|---|
| Roblox Studio | Motor y entorno de ejecución |
| Luau | Lenguaje de programación |
| Visual Studio Code | Desarrollo y edición |
| Rojo | Sincronización entre archivos y Roblox Studio |
| Rokit | Gestión de herramientas |
| Git | Control de versiones |
| GitHub | Alojamiento del repositorio |

---

# 2. Arquitectura general

## 2.1. Separación de ejecución

La arquitectura se dividirá en tres grandes áreas:

### Cliente

Se ejecuta en el dispositivo del jugador.

Responsabilidades:

- Gestionar la interfaz.
- Recoger las entradas del jugador.
- Controlar las cámaras.
- Mostrar información de las partidas.
- Presentar animaciones y efectos.
- Enviar solicitudes al servidor.

El cliente no tendrá autoridad sobre las puntuaciones finales, las reservas de máquinas ni los datos persistentes.

### Servidor

Se ejecuta en Roblox y será responsable de la lógica importante del juego.

Responsabilidades:

- Gestionar las máquinas.
- Reservar y liberar máquinas.
- Crear y finalizar sesiones.
- Validar las acciones de los jugadores.
- Controlar las puntuaciones.
- Gestionar los récords personales.
- Acceder al almacenamiento persistente.

### Código compartido

Contendrá módulos utilizados tanto por el cliente como por el servidor.

Responsabilidades:

- Configuraciones comunes.
- Tipos de datos.
- Constantes.
- Definiciones de interfaces.
- Utilidades que puedan utilizar ambos entornos.

No deberá contener secretos ni lógica que necesite permanecer protegida en el servidor.

## 2.2. Correspondencia con Roblox

| Directorio del proyecto | Ubicación en Roblox |
|---|---|
| `src/client` | `StarterPlayerScripts/Client` |
| `src/server` | `ServerScriptService/Server` |
| `src/shared` | `ReplicatedStorage/Shared` |

Los recursos visuales y modelos se organizarán mediante los mecanismos de Roblox y Rojo que se definan durante la implementación.

---

# 3. Estructura de directorios

La estructura inicial será:

```text
src/
├── client/
│   ├── Controllers/
│   └── UI/
│
├── server/
│   ├── Data/
│   ├── Services/
│   └── Systems/
│
└── shared/
    ├── Config/
    ├── Modules/
    └── Types/
```

## 3.1. Client

### Controllers

Contendrá los controladores responsables de coordinar las funcionalidades del cliente.

Ejemplos previstos:

- ArcadeInteractionController
- CameraController
- MinigameController
- InputController

### UI

Contendrá los componentes y pantallas de interfaz.

Ejemplos previstos:

- ArcadeHUD
- MinigameUI
- ScoreUI
- ResultsUI

## 3.2. Server

### Services

Contendrá servicios encargados de gestionar funcionalidades centrales del servidor.

Ejemplos previstos:

- MachineService
- SessionService
- ScoreService
- PlayerDataService

### Systems

Contendrá sistemas de lógica reutilizable que no necesariamente representan servicios centrales.

Ejemplos previstos:

- MachineAvailabilitySystem
- MinigameRegistry
- SessionLifecycleSystem

### Data

Contendrá estructuras y módulos relacionados con los datos persistentes.

Ejemplos previstos:

- PlayerDataRepository
- PlayerDataSchema
- DataValidation

## 3.3. Shared

### Config

Configuraciones generales del proyecto.

Ejemplos:

- Configuración de máquinas.
- Parámetros generales.
- Configuración de minijuegos.

### Types

Definiciones de tipos Luau.

Ejemplos:

- MachineTypes
- SessionTypes
- ScoreTypes
- PlayerDataTypes

### Modules

Módulos compartidos y utilidades generales.

Ejemplos:

- Constants
- UtilityModules
- SharedValidation

Los ejemplos anteriores son propuestas de organización. Los módulos concretos se crearán cuando exista una necesidad real.

---

# 4. Arquitectura de máquinas arcade

## 4.1. Concepto

Cada máquina será una entidad independiente dentro del salón recreativo.

Una máquina tendrá:

- Identificador único.
- Tipo de minijuego.
- Estado de disponibilidad.
- Jugador asignado, si está ocupada.
- Referencia a su modelo físico.

La máquina no deberá contener directamente toda la lógica del minijuego.

Su función será actuar como punto de acceso a una experiencia de juego.

## 4.2. Estados de una máquina

Se contemplan los siguientes estados:

| Estado | Descripción |
|---|---|
| Available | Disponible para jugar |
| Reserved | Reservada por un jugador |
| InUse | Partida en ejecución |
| Unavailable | Temporalmente fuera de servicio |

Las transiciones deberán estar controladas por el servidor.

## 4.3. Reserva de máquinas

Cuando un jugador interactúe con una máquina:

1. El servidor comprobará que el jugador es válido.
2. Comprobará la distancia de interacción.
3. Verificará que la máquina existe y está disponible.
4. Reservará la máquina para el jugador.
5. Creará una sesión de juego.
6. Confirmará al cliente que puede comenzar.

La reserva deberá realizarse de forma controlada para impedir que dos jugadores ocupen simultáneamente la misma máquina.

## 4.4. Liberación

La máquina deberá volver a estar disponible cuando:

- Finalice la partida.
- El jugador abandone voluntariamente.
- El jugador se desconecte.
- Se produzca un error que obligue a cancelar la sesión.

La liberación deberá ser segura e idempotente: ejecutarla varias veces no deberá dejar estados inconsistentes.

---

# 5. Arquitectura de minijuegos

## 5.1. Independencia

Cada minijuego tendrá su propia lógica y estado.

Los sistemas generales no deberán conocer los detalles internos de las mecánicas específicas.

La comunicación se realizará mediante contratos comunes definidos por la arquitectura.

## 5.2. Registro de minijuegos

Se utilizará un registro central que permita identificar los minijuegos disponibles.

Cada entrada deberá proporcionar información suficiente para iniciar una partida del tipo correspondiente.

Ejemplos:

- BlockPuzzle
- BubbleShooter
- SpaceShooter
- BrickBreaker

El registro evitará tener que añadir condiciones específicas para cada minijuego en el sistema general de sesiones.

## 5.3. Ciclo de vida

Todos los minijuegos deberán seguir un ciclo de vida común:

1. Preparación.
2. Inicialización.
3. Inicio.
4. Ejecución.
5. Finalización.
6. Limpieza.

La implementación interna podrá variar, pero deberá respetar las responsabilidades y transiciones generales.

## 5.4. Separación de lógica y presentación

La lógica del minijuego y su representación visual estarán separadas.

El cliente se encargará de presentar la experiencia y recoger los controles.

El servidor será responsable de validar las acciones y determinar los resultados.

Para el primer minijuego se estudiará una simulación autoritativa en servidor, manteniendo la interfaz y representación gráfica en cliente.

La estrategia podrá adaptarse a cada minijuego siempre que se mantenga una validación segura de resultados.

---

# 6. Sistema de sesiones

## 6.1. Concepto

Una sesión representa una partida individual de un jugador en una máquina.

Cada sesión tendrá:

- Identificador único.
- Jugador propietario.
- Máquina asociada.
- Tipo de minijuego.
- Estado actual.
- Puntuación.
- Datos específicos de la partida.

## 6.2. Estados de una sesión

| Estado | Descripción |
|---|---|
| Initializing | Preparando la partida |
| Active | Partida en ejecución |
| Completed | Finalizada correctamente |
| Cancelled | Cancelada |
| Failed | Finalizada por un error |

Las transiciones estarán controladas por el servidor.

## 6.3. Independencia de sesiones

Cada sesión mantendrá su propio estado.

No se utilizarán variables globales compartidas para almacenar datos específicos de diferentes partidas.

El sistema deberá permitir que varios jugadores ejecuten el mismo minijuego simultáneamente.

## 6.4. Relación entre máquinas y sesiones

La relación será:

- Una máquina podrá tener como máximo una sesión activa.
- Un jugador podrá tener como máximo una sesión arcade activa inicialmente.
- Una sesión pertenecerá a un único jugador.
- Una sesión estará asociada a una única máquina.

Estas restricciones podrán ampliarse en futuras versiones si el diseño del juego lo requiere.

---

# 7. Comunicación entre cliente y servidor

## 7.1. Principios

La comunicación se realizará mediante los mecanismos de red de Roblox, principalmente RemoteEvents y RemoteFunctions cuando corresponda.

Las solicitudes deberán estar claramente definidas.

No se permitirá que el cliente modifique directamente el estado interno del servidor.

## 7.2. Operaciones previstas

Entre las operaciones iniciales se encuentran:

- Solicitar acceso a una máquina.
- Confirmar el inicio de una sesión.
- Enviar acciones del minijuego.
- Solicitar la finalización de una partida.
- Recibir actualizaciones de estado.
- Recibir resultados.

## 7.3. Seguridad

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

# 8. Sistema de puntuaciones

## 8.1. Responsabilidad

El servidor será responsable de determinar la puntuación válida.

La puntuación no podrá aceptarse únicamente porque el cliente la comunique.

## 8.2. Validaciones

Se comprobará:

- Que exista una sesión válida.
- Que pertenezca al jugador.
- Que el minijuego corresponda a esa sesión.
- Que la partida se encuentre en un estado válido.
- Que el resultado cumpla las reglas del minijuego.

## 8.3. Récords

Cada jugador tendrá un registro independiente por minijuego.

Se conservará el mejor resultado válido.

La actualización de un récord no deberá sustituir un resultado superior por otro inferior.

---

# 9. Persistencia de datos

## 9.1. Tecnología

Se utilizará inicialmente DataStoreService de Roblox para almacenar los datos persistentes de los jugadores.

El acceso a este servicio estará limitado al servidor.

## 9.2. Datos previstos

El modelo inicial podrá incluir:

- Identificador del jugador.
- Récord de cada minijuego.
- Fecha de actualización.
- Versión del esquema de datos.

## 9.3. Requisitos

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

La persistencia no dependerá exclusivamente del evento de salida del jugador.

## 9.4. Separación de responsabilidades

La lógica de juego no accederá directamente a DataStoreService.

Los servicios de juego utilizarán una capa de acceso a datos que centralizará las operaciones de lectura y escritura.

---

# 10. Seguridad y protección frente a trampas

La seguridad será una responsabilidad transversal de la arquitectura.

Se aplicarán los siguientes principios:

- El servidor tendrá autoridad sobre el estado de las partidas.
- El cliente no podrá reservar máquinas directamente.
- Las puntuaciones serán validadas.
- Las solicitudes tendrán límites de frecuencia.
- Se comprobarán los datos recibidos.
- No se confiará en identificadores enviados por el cliente sin validación.
- Los datos persistentes solo se modificarán desde el servidor.

Se evitará exponer información sensible en módulos compartidos o código del cliente.

---

# 11. Gestión de errores y limpieza

Los sistemas deberán contemplar errores sin dejar recursos ocupados indefinidamente.

Se prestará especial atención a:

- Sesiones interrumpidas.
- Jugadores desconectados.
- Errores de inicialización.
- Fallos de comunicación.
- Errores de almacenamiento.
- Finalizaciones duplicadas.
- Referencias a objetos eliminados.

Los recursos asociados a una sesión deberán liberarse al finalizarla.

La limpieza deberá poder ejecutarse de forma segura aunque algunos pasos anteriores hayan fallado.

---

# 12. Pruebas y calidad

Se aplicarán diferentes niveles de pruebas.

## 12.1. Pruebas de módulos

Comprobarán las funciones individuales y sus casos límite.

## 12.2. Pruebas de integración

Comprobarán la interacción entre:

- Máquinas y sesiones.
- Sesiones y minijuegos.
- Minijuegos y puntuaciones.
- Puntuaciones y persistencia.

## 12.3. Pruebas multijugador

Se comprobarán situaciones con varios jugadores y varias máquinas.

## 12.4. Pruebas de errores

Se probarán desconexiones, solicitudes inválidas y fallos de almacenamiento.

Una funcionalidad no se considerará terminada hasta superar las pruebas relevantes para su responsabilidad.

---

# 13. Convenciones de desarrollo

## 13.1. Nomenclatura

Se utilizarán nombres descriptivos y coherentes.

| Elemento | Convención | Ejemplo |
|---|---|---|
| Variables | camelCase | `activeSession` |
| Funciones | camelCase | `startSession()` |
| Módulos | PascalCase | `SessionService` |
| Tipos Luau | PascalCase | `SessionData` |
| Constantes | UPPER_SNAKE_CASE | `MAX_SESSION_TIME` |

## 13.2. Código

- Preferir módulos pequeños y con una responsabilidad clara.
- Evitar duplicación de lógica.
- Utilizar anotaciones de tipos Luau.
- Evitar dependencias circulares.
- Documentar decisiones complejas.
- No introducir abstracciones innecesarias.
- Mantener las funciones fáciles de probar.

## 13.3. Control de versiones

Se utilizará Git para registrar los cambios.

Los commits seguirán la convención:

`tipo: descripción breve en español`

Se evitarán commits que mezclen funcionalidades independientes.

---

# 14. Evolución de la arquitectura

La arquitectura inicial está diseñada para cubrir las necesidades de las primeras versiones.

Se contempla la incorporación futura de:

- Más minijuegos.
- Clasificaciones entre amigos.
- Clasificaciones globales.
- Economía y recompensas.
- Sistemas de personalización.
- Mejoras de localización.
- Compatibilidad con dispositivos móviles y consolas.

Estas ampliaciones no deberán incorporarse antes de que exista una necesidad real.

Se evitará diseñar sistemas complejos para funcionalidades que todavía no forman parte del alcance de desarrollo.

---

# 15. Decisiones técnicas pendientes

Las siguientes decisiones se concretarán durante la implementación:

- Contratos definitivos de los minijuegos.
- Organización final de los RemoteEvents y RemoteFunctions.
- Estrategia de simulación y validación de cada minijuego.
- Modelo definitivo de persistencia.
- Estrategia de pruebas automatizadas.
- Gestión de versiones del esquema de datos.
- Organización de los recursos visuales.
- Estrategia de localización.

Cada decisión importante deberá documentarse cuando se tome.

---

# 16. Estado de la arquitectura

**Estado actual:** diseño inicial documentado.

La arquitectura todavía no está implementada.

El siguiente objetivo será validar la sincronización con Roblox Studio y comenzar la implementación de los fundamentos técnicos, empezando por los sistemas compartidos y la gestión de máquinas y sesiones.
## Requisitos del Cliente

### Creación de Assets
El cliente ha especificado la necesidad de diseñar sprites para el personaje, nivel, cristales y cartas de habilidades, así como la creación de sonidos como música de fondo y efectos de sonido para una experiencia más inmersiva. Esto permitirá a los jugadores interactuar con un entorno visualmente atractivo y auditivamente rico.

- **Personaje**: El personaje debe ser un samurái llamado Ruby. Este debe tener una espada. Además, debe tener animaciones básicas, como caminar, saltar, caer y atacar.
- **Nivel**: Los colores de los segmentos del nivel deben ir a corde con los critales que los contienen, blanco en el caso de varios, combinando así los colores.
- **Cristales**: Los critales deben tener una animación de rotación. El color de los mismos debe ir a corde con las habilidades que proporcionan.
- **Cartas de habilidades**: Las cartas deben contener un icono de su elemento y el color que le corresponde.
- **Música de fondo**: La música de fondo debe ser animada, que se reproduzca en bucle, y no tenga cambios drásticos. En el caso de la música del nivel, debe de causar tensión.
- **Efectos de sonido**: Los efectos de sonido deben ser adecuados, si se usa una carta de fuego, reproducir un sonido de fuego.

### Mecánicas del juego
El juego debe incluir las siguientes mecánicas de juego:

#### Movimiento Básico
- **Movimientos Horizontales**: El jugador debe poder moverse horizontalmente a través del nivel.
- **Saltos**: El jugador debe poder saltar sobre obstáculos y plataformas.
- **Ataques**: El jugador debe poder realizar ataques para romper los cristales.
- **Uso de Habilidades**: El jugador debe poder activar habilidades especiales para modificar su movimiento.

#### Calidad de Vida (QoL)
- **Deslizamiento en el Techo**: El jugador debe poder deslizarse en el techo para evitar movimiento estricto en el aire.
- **Coyote Time**: El jugador debe tener un breve un pequeño margen extra invisible para que los pueda saltar sin caerse, aunque visualmente el personaje estaría fuera de la plataforma, con el fin de facilitar la jugabilidad.
- **Búfer de Salto**: El jugador debe tener un búfer de salto, que le permita saltar al tocar el suelo, pese a que el la tecla haya sido presionada antes de tocar el suelo, facilitando el movimiento vertical.
- **Doble ataque**: El jugador debe tener un breve período de tiempo después de realizar un ataque en el que pueda realizar otro ataque, haciendo así uno doble.

#### Habilidades
- **Doble Salto**: El jugador debe poder realizar un segundo salto en el aire, permitiendo una mayor flexibilidad en el movimiento vertical.
- **Dash**: El jugador debe poder realizar un rápido movimiento en línea recta para superar obstáculos.
- **Caminar por el Aire**: El jugador debe poder caminar en el aire durante un breve período de tiempo, pero solo horizontalmente.
- **Caída Rápida**: El jugador debe poder realizar una caída rápida, esta deberá canalizarse, es decir, deberá detenerse brevemente antes de realizar la caída rápida.

Estas mecánicas proporcionan profundidad al gameplay y permiten al jugador explorar y superar desafíos de manera creativa.

### Diseño de Niveles
El nivel de introducción debe ser complejo y presentar las mecánicas básicas de forma gradual y desafiante. La progresión de dificultad, la distribución de obstáculos y la creatividad en la disposición de plataformas son aspectos clave a considerar. Esto permitirá a los jugadores aprender y mejorar sus habilidades de manera efectiva.

### Datos de Juego
El sistema de identificación del jugador debe ser sencillo y solo requerir el nombre del jugador. Una vez realizada la identificación, este nombre será almacenado en un JSON. Para no permitir al jugador sobrescribir este archivo, se guardará la información del jugador de forma encriptada. Además, se debe implementar un sistema de ranking global para fomentar la competencia entre jugadores y permitir la comparación de puntajes.

### Menús
El juego debe incluir los siguientes menús:

#### Menú de Login
- **Nombre**: El jugador debe poder ingresar su nombre.
- **Atrás**: El jugador puede regresar al menú principal.
- **Salir**: El jugador puede salir del juego.

#### Menú Principal
- **Login**: El jugador podrá identificarse.
- **Empezar**: El jugador puede comenzar el juego.
- **Opciones**: El jugador puede acceder a las opciones del juego.
- **Ranking**: El jugador puede ver la tabla de clasificación.
- **Salir**: El jugador puede salir del juego.

#### Menú de Opciones
- **Volumen General**: El jugador puede ajustar el volumen general del juego.
- **Volumen de Música del Nivel**: El jugador puede ajustar el volumen de la música del nivel.
- **Volumen de Efectos de Sonido**: El jugador puede ajustar el volumen de los efectos de sonido.
- **Atrás**: El jugador puede regresar al menú principal.
- **Salir**: El jugador puede salir del juego.

#### Menú de Ranking
- **Tabla de Clasificación**: El jugador puede ver la tabla de clasificación global.
- **Atrás**: El jugador puede regresar al menú principal.

#### Menús Durante el Juego
- **Pausa**: El jugador puede pausar el juego.
  - **Continuar**: El jugador puede continuar el juego.
  - **Menú Principal**: El jugador puede regresar al menú principal.
  - **Salir**: El jugador puede salir del juego.
- **Victoria**: El jugador ha ganado el nivel.
  - **Reiniciar**: El jugador puede reiniciar el nivel.
  - **Ranking**: El jugador puede ver la tabla de clasificación.
  - **Menú Principal**: El jugador puede regresar al menú principal.
  - **Salir**: El jugador puede salir del juego.

### Pruebas
Es fundamental realizar pruebas exhaustivas de las mecánicas de juego para garantizar su funcionamiento correcto y equilibrado. Además, se debe evaluar el rendimiento del juego para optimizar su fluidez y evitar problemas de carga o lag que puedan afectar la experiencia del jugador.

### Documentación
Es importante mantener el código documentado en todo momento para facilitar su mantenimiento y futuras actualizaciones. Además, se debe crear un manual de usuario que explique las mecánicas, controles y características del juego para orientar a los jugadores y maximizar su disfrute.
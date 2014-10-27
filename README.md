Ruby - Quizzer
=============

Todos los ficheros están en [https://github.com/mvidalgarcia/poo-quizzer-ruby](https://github.com/mvidalgarcia/poo-quizzer-ruby)

## Tareas realizadas.

La clase Evaluator (`lib/quizzer/evaluator.rb`) es la que realiza todas la operaciones, con métodos estaticos. De este modo se consigue el objetivo de modularizar el código y lo hace más legible y fácil de modificar y a su vez facilita el proceso de pruebas.

Para leer los ficheros JSON que se obtienen mediante URL, como son los del fichero `manifest.json`, se emplea la gema `open-uri`.

Se han realizado comprobaciones para que el número de argumentos sea válido y que los tipos de las respuestas de los alumnos sean las adecuadas (Para las preguntas 'Multichoice' las respuestas deben ser enteros y para las 'TrueFalse' deben ser un booleanos).

Las pruebas rspec planteadas están en el directorio spec y se pueden ejecutar con el comando `rspec -c spec\evaluator_spec.rb`

Se ha desplegado la aplicación con en el servidor web Sinatra. Ésta permite al usuario subir un fichero con las preguntas (quiz) y otro con las respuestas (assessment) y se descargará un fichero con las correcciones (scores). En la clase Server (`lib/quizzer/server.rb`) se hace toda la gestión de las operaciones que realiza el servidor. 
Como tecnología de templates se ha utilizado HAML y la única vista de la que consta la aplicación web está en `views/upload.haml`.

## Modo de uso

`ruby -Ilib bin\evaluate -f quiz.json,assessment.json`   -> **OJO! Separado por coma y sin espacio.**  
`ruby -Ilib bin\evaluate -m manifest.json`  
`ruby -Ilib bin\evaluate -h` -> Ayuda sobre el modo de uso.  

Para ejecutar la aplicación en el servidor, lanzar el comando `ruby -Ilib bin\server` y conectarse con un navegador a la dirección [localhost:4567/upload](http://localhost:4567/upload)

## Estimación temporal.

La relización de esta aplicación con Ruby me ha llevado aproximadamente 12 horas, ya que no conocía lenguaje previamente y fue la primera práctica que realicé. Además, el implementar la tarea opcional de desplegar una aplicación web ha sumado un tiempo considerable.

## Valoración del lenguaje y comentarios sobre la asignatura.

Probablemente Ruby sea el lenguaje que más me gustó de los 4 utilizados. Es un lenguaje que no conocía pero sin embargo sencillo de aprender y divertido, como bien dice su autor. Tiene una sintasix atractiva y ciertos toques de programación funcional que le dotan de un lenguaje peculiar. Me quedo con muchas ganas de hacer cosas con Ruby on Rails, espero tener la oportunidad de usarlo en futuras asignaturas.

Respecto a esta parte de la asignatura, he aprendido a utilizar un nuevo lenguaje que me ha gustado mucho, además de una filosofía de trabajo enfocada a realizar pruebas unitarias, "test driven development".
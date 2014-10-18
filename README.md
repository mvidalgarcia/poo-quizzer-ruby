##Ruby - Quizzer

Todos los ficheros están en https://github.com/mvidalgarcia/poo-quizzer-ruby

La clase Evaluator (`lib/quizzer/evaluator.rb`) que es la que realiza todas la operaciones, con métodos estaticos. De este modo se consigue el objetivo de modularizar el código y lo hace más legible y fácil de modificar y a su vez facilita el proceso de pruebas.

Para leer los ficheros JSON que se obtienen mediante URL, como son los del fichero `manifest.json`, se emplea la gema `open-uri`.

Las pruebas rspec planteadas están en el directorio spec y se pueden ejecutar con el comando `rspec -c spec\evaluator_spec.rb`

Modo de uso de la aplicación :

`ruby -Ilib bin\evaluate -f [quiz.json],[assessment.json]`   -> OJO! Separado por coma y sin espacio.  
`ruby -Ilib bin\evaluate -m manifest.json`  
`ruby -Ilib bin\evaluate -h` -> Ayuda sobre el modo de uso.  

Se han realizado comprobaciones para que el número de argumentos sea válido y que los tipos de las respuestas de los alumnos sean las adecuadas (Para las preguntas 'Multichoice' las respuestas deben ser enteros y para las 'TrueFalse' deben ser un booleanos).

Se ha desplegado la aplicación con en el servidor web Sinatra. Ésta permite al usuario subir un fichero con las preguntas (quiz) y otro con las respuestas (assessment) y se descargará un fichero con las correcciones (scores). En la clase Server (`lib/quizzer/server.rb`) se hace toda la gestión de las operaciones que realiza el servidor. 
Como tecnología de templates se ha utilizado HAML y la única vista de la que consta la aplicación web está en views/upload.haml.
Para ejecutar la aplicación en el servidor lanzar el comando `ruby -Ilib bin\server` y conectarse con un navegador a la dirección [localhost:4567/upload](http://localhost:4567/upload)


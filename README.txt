Ruby - Quizzer

La clase Evaluator (lib/quizzer/evaluator.rb) que es la que realiza todas la operaciones, con m�todos estaticos. De este modo se consigue el objetivo de modularizar el c�digo y lo hace m�s legible y f�cil de modificar y a su vez facilita el proceso de pruebas.

Para leer los ficheros JSON que se obtienen mediante URL, como son los del fichero manifest.json, se emplea la gema "open-uri".

Las pruebas rspec planteadas est�n en el directorio spec y se pueden ejecutar con el comando "rspec -c spec\evaluator_spec.rb"

Modo de uso de la aplicaci�n :

ruby -Ilib bin\evaluate -f [quiz.json],[assessment.json]   -> OJO! Separado por coma y sin espacio.
ruby -Ilib bin\evaluate -m manifest.json
ruby -Ilib bin\evaluate -h -> Ayuda sobre el modo de uso.

Se han realizado comprobaciones para que el n�mero de argumentos sea v�lido y que los tipos de las respuestas de los alumnos sean las adecuadas (Para las preguntas 'Multichoice' las respuestas deben ser enteros y para las 'TrueFalse' deben ser un booleanos).

Se ha desplegado la aplicaci�n con en el servidor web Sinatra. �sta permite al usuario subir un fichero con las preguntas (quiz) y otro con las respuestas (assessment) y se descargar� un fichero con las correcciones (scores). En la clase Server (lib/quizzer/server.rb) se hace toda la gesti�n de las operaciones que realiza el servidor. 
Como tecnolog�a de templates se ha utilizado HAML y la �nica vista de la que consta la aplicaci�n web est� en views/upload.haml.
Para ejecutar la aplicaci�n en el servidor lanzar el comando ruby -Ilib bin\server y conectarse con un navegador a la direcci�n localhost:4567/upload


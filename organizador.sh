#!/bin/bash

 # Si tiene algún problema con el codigo o recomendaciones, puedes añadir comentarios a mi publicación
  # de Github para que pueda corregirlo y brindarles un codigo mejorado.


	#0 El script te llamara por tu nombre, te saludara y dira cuando se termine el proceso de codigo.
read name

echo "bienvenido $name, a continuación organizare sus archivos."

	#1 verificación de directorio como argumento.

if [ ! -d "$1" ]; then
	echo "Error $name. directorio $1 invalido o  inexistente..."
	echo "uso del script: bash organizador.sh /ruta/directorio"
 exit 1

fi

	#2 definir fecha actual y establecer subcarpeta backup en el directorio de destino.

fecha=$(date +%Y-%m-%d)

backup_dir="$1/backup_$fecha"
mkdir -p "$backup_dir"

	#3 array y validación de existencias de archivos .txt dentro del directorio.

	   #3.1 Creación de .log.

log_file="$backup_dir/resumen.log"

	   #3.2 Creación del array.

archivos=( "$1"/*.txt )

if [ ! -e "${archivos[0]}" ] && [ "${archivos[0]}" = "$1/*.txt" ]; then
 total=0
else
 total=${#archivos[@]}
fi

	#4 array de guardado del listado de acciones de copiado hechas.

copiados=()

	#5 recorrer y copiar cada .txt añadiendo $fecha .

if [ "$total" -gt 0 ]; then
  for archivo in "${archivos[@]}"; do

if  [ -f "$archivo" ]; then

	#5.1  extraer unicamente el nombre, lo anterior a la extension .txt .

nom=$( basename "$archivo" )

	#5.2  Nuevo nombre con la fecha actual.

nuevo_nom="${fecha}_${nom}"

	#5.3  dirigir archivo a subcarpeta $backup_$fecha con el cambio de nombre.

cp "$archivo" "$backup_dir/$nuevo_nom"

	#5.4  registrar el cambio en el array copiados .

copiados+=( "$nom -> $nuevo_nom" )

fi

   done
fi
	#6 proceso verboso para añadir a .log .

{
echo "<=|=|=|=|=|=|=|=|=|=|=|=|=|=|=|=|=|>"
echo "Resumen de archivo .txt para $fecha."
echo "<=|=|=|=|=|=|=|=|=|=|=|=|=|=|=|=|=|>"

echo "directorio origen: $1"
echo "directorio destino: $backup_dir"
echo "total de archivos .txt detectados: $total"

	#6.1 recorrer los .txt existentes, copiarlos y documentarlos.

if [ "$total" -eq 0 ]; then
	echo " No se encontro ningun .txt para copiar."
fi

if [ "$total" -gt 0 ]; then
for archivo in "${archivos[@]}"; do
	if [ -f "$archivo" ]; then
	nom=$(basename "$archivo")
        nuevo_nom="${fecha}_${nom}"

	#6.2 copiar los archivos.

cp "$archivo" "$backup_dir/$nuevo_nom"

	#6.3 documentación en .log .

echo "[COPIADO] Se procesó correctamente: $nom -> $nuevo_nom"

else

 echo "[INFO] No se encontraron archivos .txt para copiar."

fi
  done

echo "<=|=|=|=|=|=|=|=|=|=|=|=|=|=|=|=|=|=|=|=>"
echo "Resumen compilatorio completado. $fecha"
echo "<=|=|=|=|=|=|=|=|=|=|=|=|=|=|=|=|=|=|=|=>"

fi
	#6.4 cerramos {...} y lo direccionamos al archivo .log .

} > "$backup_dir/resumen.log"

	#7 mensaje de conclusion.
 
echo "¡Felicidades $name! proceso exitoso <(•w•)>."
echo "la documentación se ubica en $log_file"


exit 0

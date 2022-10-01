#!/bin/bash
# Este Script es realizado por digiraldo

# Colores del terminal
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
LIME_YELLOW=$(tput setaf 190)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BRIGHT=$(tput bold)
NORMAL=$(tput sgr0)
BLINK=$(tput blink)
REVERSE=$(tput smso)
UNDERLINE=$(tput smul)

# Imprime una línea con color usando códigos de terminal
Print_Style() {
  printf "%s\n" "${2}$1${NORMAL}"
}

# Función para leer la entrada del usuario con un mensaje
function read_with_prompt {
  variable_name="$1"
  prompt="$2"
  default="${3-}"
  unset $variable_name
  while [[ ! -n ${!variable_name} ]]; do
    read -p "$prompt: " $variable_name < /dev/tty
    if [ ! -n "`which xargs`" ]; then
      declare -g $variable_name=$(echo "${!variable_name}" | xargs)
    fi
    declare -g $variable_name=$(echo "${!variable_name}" | head -n1 | awk '{print $1;}')
    if [[ -z ${!variable_name} ]] && [[ -n "$default" ]] ; then
      declare -g $variable_name=$default
    fi
    echo -n "$prompt : ${!variable_name} -- aceptar? (y/n)"
    read answer < /dev/tty
    if [ "$answer" == "${answer#[Yy]}" ]; then
      unset $variable_name
    else
      echo "$prompt: ${!variable_name}"
    fi
  done
}

### Para acabar con tanta instalación, nos queda como último paso instalar el paquete ffmpeg. Para ello nada más sencillo que poner el comando:
echo "======================================================================================="
hostname -I

### Ver capacidad almacenamiento
echo "======================================================================================="
df -h
sleep 3s

### PASANDO LA INSTALACIÓN A UN DISCO SSD, MUY RECOMENDABLE
echo "======================================================================================="
Print_Style "identificando el SSD..." "$CYAN"
sudo fdisk -l
sleep 2s
echo "======================================================================================="

# Digitar la ip del equipo
echo "========================================================================="
Print_Style "Introduzca la Ruta del SSD Ej: /dev/sda1" "$MAGENTA"
read_with_prompt DevSd "Ruta del disco externo"
echo "========================================================================="

echo "========================================================================="
echo "========================================================================="
Print_Style "NOTA: Se acaba de copiar todo el contenido" "$RED"
Print_Style "de la micro SD al dispositivo externo $DevSd" "$RED"
Print_Style "El ultimo paso es indicarselo al boot" "$RED"
echo "_________________________________________________________________________"
read -n1 -r -p "Presione la tecla Enter para continuar"

#Para tener una copia de seguridad del boot.
echo "======================================================================================="
Print_Style "Creando copia de seguridad del boot..." "$CYAN"
sudo cp /boot/cmdline.txt /boot/cmdline.txt.bak
sleep 2s
echo "======================================================================================="

# Para finalizar, pondremos el comando:
echo "======================================================================================="
Print_Style "Mostrando contenido de cmdline.txt..." "$CYAN"
sudo cat /boot/cmdline.txt
sleep 2s
echo "======================================================================================="

# Digitar la ip del equipo
echo "========================================================================="
Print_Style "Introduzca el root= encontrado" "$MAGENTA"
echo "Ejemplo: root=PARTUUID=738a4d67-02"
read_with_prompt RooT "Nombre Root"
echo "========================================================================="

# Ahora lo editamos con:
echo "======================================================================================="
Print_Style "Editando Boot..." "$CYAN"
sudo sed -n "/$RooT/p" /boot/cmdline.txt
sleep 2s
echo "======================================================================================="
echo "Cambiando: $RooT"
echo "Por:       root=$DevSd"
echo "======================================================================================="
sleep 2s
sudo sed -i "s/$RooT/root=$DevSd/g" /boot/cmdline.txt
sudo sed -n "/root=$DevSd/p" /boot/cmdline.txt
sleep 2s
echo "======================================================================================="

echo "======================================================================================="
Print_Style "Reiniciando Sistema en 6 Segundos para Iniciar desde el SSD $DevSd..." "$RED"
sleep 4s
Print_Style "Reiniciando 3 Segundos" "$RED"
sleep 1s
Print_Style "Reiniciando 2 Segundos" "$RED"
sleep 1s
Print_Style "Reiniciando 1 Segundo" "$RED"
sleep 1s
Print_Style "Reiniciando" "$RED"
sudo reboot

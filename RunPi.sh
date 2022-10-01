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

Print_Style "Configurando Rasperry Pi..." "$MAGENTA"
sleep 4s

# Instale las dependencias necesarias para ejecutar el servidor de Minecraft en segundo plano
Print_Style "Instalando dependencias..." "$CYAN"
if [ ! -n "`which sudo`" ]; then
  apt update && apt install sudo -y
fi
sudo apt update
sudo apt install ffmpeg -y
sudo add-apt-repository universe -y
sudo apt install git -y
#sudo apt-get install ssh -y
#sudo apt install -y software-properties-common
#sudo apt install nginx -y
#sudo apt -y install libapache2-mod-php
#sudo apt update && sudo apt install php-fpm -y
sudo apt -y upgrade

Print_Style "Agregando usuario pi a ssh..." "$GREEN"
sudo adduser pi ssh
sleep 3s

### Configurar teclado es_CO.UTF-8 UTF-8 y zona America-Bogota
Print_Style "Configurar teclado es_CO.UTF-8 UTF-8 y zona America-Bogota..." "$CYAN"
sleep 5s
sudo raspi-config

### Poner ahora el kernel de 64 bits a la Pi
Print_Style "Configurarando kernel de 64 bits a la Pi..." "$MAGENTA"
sleep 2s
sudo rpi-update
sudo sed -i '$a arm_64bit=1' /boot/config.txt
sudo sed -n "/arm_64bit=1/p" /boot/config.txt
sleep 3s
#64 Bit

#sudo reboot
echo "======================================================================================="
uname -a

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

echo "======================================================================================="
Print_Style "Iniciando dsisk en $DevSd..." "$CYAN"
Print_Style  "NOTA: Presione las teclas en el siguiente orden" "$MAGENTA"
Print_Style  "cuando muestre: command (m for help):" "$MAGENTA"
sleep 2s
echo "d = Elimina Partición"
sleep 1s
echo "n = Crea nueva Partición"
sleep 1s
echo "p = Partición Primaria"
sleep 1s
echo "enter y confirmar con (y) hasta: command (m for help)"
sleep 1s
echo "w = Finalizar y aplicar cambios"
sleep 3s
sudo fdisk $DevSd
echo "======================================================================================="

### Ver capacidad almacenamiento
echo "======================================================================================="
echo "Ver Capacidad de Amacenamiento"
df -h
echo "======================================================================================="
sleep 2s

# Una vez fuera del asistente de creación de particiones, pondremos el comando:
echo "======================================================================================="
Print_Style "Aceptar Comando..." "$CYAN"
sudo mkfs.ext4 $DevSd
echo "======================================================================================="

# Ahora crearemos el punto de montaje con el comando:
echo "======================================================================================="
Print_Style "Creando Punto de montaje..." "$CYAN"
sudo mkdir /media/external
sleep 2s
echo "======================================================================================="

# Montaremos el SSD con el comando:
echo "======================================================================================="
Print_Style "Montando Unidad $DevSd..." "$CYAN"
sudo mount $DevSd /media/external

# Terminamos sincronizando todo con:
echo "======================================================================================="
Print_Style "Aceptar Comando..." "$CYAN"
sudo rsync -avx / /media/external
sleep 2s
echo "======================================================================================="

## Con eso habremos copiado todo el contenido de la microSD al nuevo SSD. Nos queda el último paso: indicárselo al boot.

# Configuración del nombre minecraft en la cuenta de la nube
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
echo "Cambiando $RooT por: root=$DevSd"
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

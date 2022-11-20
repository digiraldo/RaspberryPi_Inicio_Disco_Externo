### Poner ahora el kernel de 64 bits a la Pi

sudo nano /boot/config.txt

#
#64 Bit
arm_64bit=1

sudo reboot

uname -a 

* Veréis como os aparecerá una línea de información donde comprobaremos que aparece la palabra aarch64



# Crear y Cambiar de Usuario
sudo adduser di

sudo gpasswd -a di adm

sudo gpasswd -a di sudo

groups di


# Iniciamos SSH con el usuario nuevo y verificamos que tengamos derechos de sudo con
sudo hostname

# Bloquear la cuenta PI
sudo passwd -l pi

# Cambiar puerto SSH predeterminado
sudo nano /etc/ssh/sshd_config

#Port 22
Port 1984

sudo service ssh restart

# Actualizar rpi
sudo apt update -y && sudo apt upgrade -y

# Que el usuario tenga acceso a todos los usuarios para poder entrar en pi
 sudo nano /etc/ssh/sshd_config

#MaxSessions 10
Allowusers di

sudo service ssh restart


## INSTALAR OPENMEDIAVAULT
sudo rm -f /etc/systemd/network/99-default.link

sudo reboot

* podemos hacer un ping

sudo wget -O - https://raw.githubusercontent.com/OpenMediaVault-Plugin-Developers/installScript/master/install | sudo bash


Cambiar Contrasena
Activar Certificado SSL
Cambiar puertos a: 8080 4443
Luego habilitar Forzar SSL

* En red / General, cambiar Nombre de equipo de raspberrypi
SERVERS

Configurar la ip em Estatica en Red / interfaces

Deshabilitar IpV6

servidores DNS: 8.8.8.8


Ver si hay actualizaciones


Verificar que este instalado el plugin: openmediavault-flashmemory

Cambiar el puerto 22 en Servicion / SSH al 1984 para poder aceder via SSH


Pasar por el usuario y restablecer la contrasena y agregar al gupo ssh

Verificar el Disco Externo
Montar Sistema de Archivos
Compartir Carpetas


* Vamos al directorio de trabajo y lo copiamos mostrandolo con pwd
/srv/dev-disk-by-uuid-E0FE6879FE684A3C

* Vamos a OMV-Extras y configuramos el directorio de trabajo e instalamos Docker
/srv/dev-disk-by-uuid-E0FE6879FE684A3C/docker

Guardamos e instalamos

Luego instalamos Portainer

* En S.M.A.R.T. Monitorear el dispositivo externo
* En Tareas programadas 
Crear nueva en short selft-text y 4 hora (hara una prueba a las 4:00 horas para verificar que este funcionando)

* Crear Sistema de Archivos

* Quitar permiso ssh a usuario pi

* Seleccionamos el grupo Docker, sambashare para el usuario creado di

Habilitar SMB/CIFS en Cnfiguracion y Compartir Carpetas que estan habilitadas en Almacenamiento/
Carpetas Compartidas


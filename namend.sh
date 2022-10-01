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

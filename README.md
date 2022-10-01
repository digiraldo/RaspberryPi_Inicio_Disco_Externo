# Inicio desde una unidad externa en la Raspberry Pi

## Iniciar el sistema operativo de la Raspberry Pi desde un dispositivo externo

* Una vez tenga su Raspberry con el sistema operativo instalado, conecte la unidad externa donde se copiará el arranque del sistema operativo, use SSH con un mouse y teclado introduciendo el siguiente comando:
```
wget https://github.com/digiraldo/RaspberryPi_Inicio_Disco_Externo/raw/main/RunPi.sh  
chmod +x RunPi.sh  
./RunPi.sh
```

* Si tiene problemas en el final de la instalacion del nombre root para que inicie desde el almacenamiento externo, usa este codigo, use SSH con un mouse y teclado introduciendo el siguiente comando:
```
wget https://github.com/digiraldo/RaspberryPi_Inicio_Disco_Externo/raw/main/namend.sh  
chmod +x namend.sh  
./namend.sh
```

## Sincronizar la nube en la  Raspberry Pi

* Una vez tenga su Raspberry con el sistema operativo instalado, puede sincronizar con RClone sus cuentas en la nube de drive, onedrive y más:

```
wget https://raw.githubusercontent.com/digiraldo/RaspberryPi_Inicio_Disco_Externo/main/rclone.sh
chmod +x rclone.sh
./rclone.sh
```

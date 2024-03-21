# scanMachines.sh
Script para scanear un rango de Ips mediante el tratameinto de la ttl y visualizar si un equipo es Linux o Windows obteniento el tolal al Final.
Muy ideal para prácticas en plataformas de CTF.

*Nota: Hay que tener en cuenta que la ttl se pueden cambiar para evitar este tipo de escaneos en un entorno real.*
## Modo de Uso
---
    ./scanMachines.sh <dirección-ip-base> | ./scanMachines.sh xxx.xxx.xxx.x
---
## Se obtendrá el siguiente resultado

    Host  xxx.xxx.xxx.x : Linux
    Host  xxx.xxx.xxx.x : Linux
    Host  xxx.xxx.xxx.x : Windows
    Host  xxx.xxx.xxx.x : Windows
    Host  xxx.xxx.xxx.x : Linux
    Host  xxx.xxx.xxx.x : Linux
    Host  xxx.xxx.xxx.x : Windows
    Host  xxx.xxx.xxx.x : Windows
    Host  xxx.xxx.xxx.x : Linux
    Máquinas activas (Linux): 5
    Máquinas activas (Windows): 4
    Total: 9
---
## Si hay un error se desplegará el siguiente msj:
    Error. Formato esperado: xxx.xxx.xxx.x  o xxx.xxx.xxx.xxx

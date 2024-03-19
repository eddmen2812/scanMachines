# scanMachines
Script para scanear un rango de Ips y visualizar si un equipo es Linux o Windows
## Modo de Uso
---
    ./scanMachines.sh <dirección-ip-base> | ./scanMachines.sh xxx.xxx.xxx.x
---
## Se ontendra el siguiente resultado

    Host  xxx.xxx.xxx.x : Linux
    Host  xxx.xxx.xxx.x : Linux
    Host  xxx.xxx.xxx.x : Windows
    Host  xxx.xxx.xxx.x : Windows
    Host  xxx.xxx.xxx.x : Linux
    Host  xxx.xxx.xxx.x : Linux
    Host  xxx.xxx.xxx.x : Windows
    Host  xxx.xxx.xxx.x : Windows
    Host  xxx.xxx.xxx.x : Linux
---
## Si hay un error se desplegará el siguiente msj:
    Error. Formato esperado: xxx.xxx.xxx.x  

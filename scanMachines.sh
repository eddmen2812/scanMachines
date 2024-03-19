#!/bin/bash

# Función para verificar si los tres primeros octetos de una cadena son una dirección IP válida
is_valid_partial_ip() {
    local ip="$1"
    if [[ "$ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[xX]$ ]]; then
        local IFS='.'
        local octets=($ip)
        for ((i=0; i<3; i++)); do
            local octet="${octets[$i]}"
            if ! [[ "$octet" =~ ^[0-9]+$ ]] || ((octet < 0 || octet > 255)); then
                return 1
            fi
        done
        return 0
    else
        return 1
    fi
}

if [ "$#" -ne 1 ]; then
    echo "Uso: $0 <dirección-ip-base>"
    exit 1
fi

# Verificar si los tres primeros octetos de la dirección IP base son válidos
if ! is_valid_partial_ip "$1"; then
    echo "Error. Formato esperado: xxx.xxx.xxx.x"
    exit 1
fi

# Obtener los tres primeros octetos de la dirección IP ingresada
base_ip=$(echo "$1" | cut -d '.' -f 1-3)

# Convertir la "x" a minúsculas
base_ip=$(echo "$base_ip" | tr '[:upper:]' '[:lower:]')

for i in $(seq 2 254); do
    ip_address="$base_ip.$i"
    ttl=$(timeout 1 bash -c "ping -c 1 $ip_address | grep ttl" | grep -oP '(?<=ttl=)\d+')

    if [ -n "$ttl" ]; then
        os_name=$(python3 -c "import re; ttl = $ttl; print('Linux' if ttl <= 64 else 'Windows' if ttl <= 128 else 'No se encuentra')")
        echo "Host $ip_address : $os_name"
    fi
done

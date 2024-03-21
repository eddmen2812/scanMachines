#!/bin/bash

# Función para validar si una cadena es una dirección IP válida completa
is_valid_full_ip() {
    local ip="$1"
    if [[ "$ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        local IFS='.'
        local octets=($ip)
        for octet in "${octets[@]}"; do
            if ! [[ "$octet" =~ ^[0-9]+$ ]] || ((octet < 0 || octet > 255)); then
                return 1
            fi
        done
        return 0
    else
        return 1
    fi
}

# Función para validar si una cadena es una dirección IP válida parcial (con "x" en el último octeto)
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
    echo "Uso: $0 <dirección-ip>"
    exit 1
fi

# Verificar si la dirección IP ingresada es una dirección IP completa o parcial
if is_valid_full_ip "$1"; then
    ip_address="$1"
elif is_valid_partial_ip "$1"; then
    ip_address="$1"
else
    echo "Dirección IP inválida. Formato esperado: xxx.xxx.xxx.xxx o xxx.xxx.xxx.x"
    exit 1
fi

# Si la dirección IP es completa, solo escaneamos esa dirección
if is_valid_full_ip "$ip_address"; then
    ttl=$(timeout 1 bash -c "ping -c 1 $ip_address | grep ttl" | grep -oP '(?<=ttl=)\d+')

    if [ -n "$ttl" ]; then
        os_name=$(python3 -c "import re; ttl = $ttl; print('Linux' if ttl <= 64 else 'Windows' if ttl <= 128 else 'No Localizado')")
        echo "Host $ip_address : $os_name"
        if [[ "$os_name" == "Linux" ]]; then
            ((linux_count++))
        elif [[ "$os_name" == "Windows" ]]; then
            ((windows_count++))
        fi
    else
        echo "Host $ip_address : No disponible"
    fi
# Si la dirección IP es parcial, escaneamos el rango de direcciones del último octeto
else
    base_ip=$(echo "$ip_address" | cut -d '.' -f 1-3)

    # Convertir la "x" a minúsculas
    base_ip=$(echo "$base_ip" | tr '[:upper:]' '[:lower:]')

    found=false

    for i in $(seq 2 254); do
        ip="$base_ip.$i"
        ttl=$(timeout 1 bash -c "ping -c 1 $ip | grep ttl" | grep -oP '(?<=ttl=)\d+')

        if [ -n "$ttl" ]; then
            os_name=$(python3 -c "import re; ttl = $ttl; print('Linux' if ttl <= 64 else 'Windows' if ttl <= 128 else 'No localizado')")
            echo "Host $ip : $os_name"
            if [[ "$os_name" == "Linux" ]]; then
                ((linux_count++))
            elif [[ "$os_name" == "Windows" ]]; then
                ((windows_count++))
            fi
            found=true
        fi
    done

    if ! $found; then
        echo "Host $ip_address : No disponible"
    fi
fi

echo ""
echo "Máquinas activas (Linux): $linux_count"
echo "Máquinas activas (Windows): $windows_count"
echo "Total: $((linux_count + windows_count))"

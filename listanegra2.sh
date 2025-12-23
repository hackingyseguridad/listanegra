#!/bin/sh

# Script simple para verificar IP publica listada
# Verifica si una IP esta en Lista Negra, por SPAM de email
# Las IPv4 suelen ser listadas tras el primer envio SPAM
# Las IPv6 raramente son las listadas en BlackList
# (R) hackingyseguridad.com 2026
# @antonio_taboada

echo "Script simple para verificar IP listada en Spamhaus"
fecha_hora=$(LC_TIME=es_ES.UTF-8 date "+%d de %B de %Y %H:%M")
echo "$fecha_hora"
echo "Verifica si una IP esta en BlackList por SPAM email"
echo ""

# Solicitar IP manualmente
echo "Introduce la IP a verificar (IPv4 o IPv6):"
read IP

# Validar formato básico de IP
if [ -z "$IP" ]; then
    echo "Error: No se ha introducido ninguna IP"
    exit 1
fi

echo ""
echo "Verificando IP: $IP"
echo "------------------------"

# Función para crear IP inversa (solo para IPv4)
es_ipv4() {
    echo "$IP" | grep -Eq '^([0-9]{1,3}\.){3}[0-9]{1,3}$'
}

if es_ipv4; then
    # Resolución IP inversa para IPv4
    REV_IP=$(echo "$IP" | awk -F. '{print $4"."$3"."$2"."$1}')

    # Consultar listas principales para IPv4
    for LIST in zen.spamhaus.org sbl.spamhaus.org xbl.spamhaus.org pbl.spamhaus.org; do
        if host "$REV_IP.$LIST" 2>/dev/null | grep -q "has address"; then
            echo "LISTADA en $LIST"
            host "$REV_IP.$LIST" | grep "has address" | sed 's/has address/  → Razón:/'
        else
            echo "OK en $LIST"
        fi
    done
else
    # Para IPv6, usar formato diferente
    echo "Verificando IP IPv6..."

    # Consultar listas para IPv6 (formato diferente)
    for LIST in zen.spamhaus.org sbl.spamhaus.org xbl.spamhaus.org pbl.spamhaus.org; do
        # Para IPv6 necesitamos un formato de consulta diferente
        # Spamhaus usa formato reversed para IPv6 también
        if host "$IP.$LIST" 2>/dev/null | grep -q "has address"; then
            echo "LISTADA en $LIST"
            host "$IP.$LIST" | grep "has address" | sed 's/has address/  → Razón:/'
        else
            echo "OK en $LIST"
        fi
    done
fi

echo "------------------------"
echo "Enlace para ver detalles en Spamhaus:"
echo "https://check.spamhaus.org/query/ip/$IP"
echo ""
echo "Para más información, consulta también:"
echo "https://mxtoolbox.com/SuperTool.aspx?action=blacklist%3a$IP"
echo "https://multirbl.valli.org/lookup/$IP.html"

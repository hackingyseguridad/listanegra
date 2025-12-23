#!/bin/sh

# Script simple para verificar IP publica listada  en Spamhaus"
# Verifica si una IP esta en Lista Negra, por SAPM de email
# Las IPv4 suelen ser listadas tras el primer envio SPAM
# Las IPv6 raramente son las litadas en BlackList
# (R) hackingyseguridad.com 2026
# @antonio_taboada

echo "Script simple para verificar IP publica listada en Spamhaus "
fecha_hora=$(LC_TIME=es_ES.UTF-8 date "+%d de %B de %Y %H:%M")
echo "$fecha_hora"
echo "Verifica si una IP esta en BlackList por SPAM email"
IP=$(curl -s --max-time 5 ifconfig.me 2>/dev/null)
echo "IPv4 o IPv6 actual publica !!!"
echo $IP
echo "Verificando IP: $IP"
echo "------------------------"
# resolucion IP inversa para consultas DNS
REV_IP=$(echo "$IP" | awk -F. '{print $4"."$3"."$2"."$1}')
# Consultar listas principales
for LIST in zen.spamhaus.org sbl.spamhaus.org xbl.spamhaus.org pbl.spamhaus.org; do
    if host "$REV_IP.$LIST" 2>/dev/null | grep -q "has address"; then
        echo "❌ LISTADA en $LIST"
        host "$REV_IP.$LIST" | grep "has address"
    else
        echo "✓ OK en $LIST"
    fi
done
echo "------------------------"
echo "https://check.spamhaus.org/query/ip/$IP"


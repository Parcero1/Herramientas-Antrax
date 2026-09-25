#!/bin/bash

# Configuración
URL="https://www.bbva.mx"
TIMEOUT=5

# Lista ampliada de rutas sensibles
ROUTES=(
  # Claves y Config Generales
  "/.env"
  "/config.json"
  "/config.js"
  "/configuration.json"
  "/credentials.json"
  "/secrets.json"
  "/token.json"
  "/api-keys.json"
  "/db.json"
  
  # Archivos de Texto/Config clásicos
  "/config.properties"
  "/application.properties"
  "/application.yml"
  "/application.yaml"
  "/config.yaml"
  "/config.yml"
  "/db.properties"
  "/database.yml"
  "/db.yml"
  "/credentials.csv"
  "/credentials.txt"
  "/passwords.txt"
  "/passwords.csv"
  
  # Rutas Específicas de Adobe AEM (que usa BBVA)
  "/libs/granite/security/currentuser.json"
  "/crx/de/index.jsp"
  "/crx/explorer/index.jsp"
  "/content/dam/jcr:content.metadata.json"
  "/etc/clientlibs/granite/security/currentuser.json"
  "/content/dam.jcr:content.json"
  
  # Logs y Backups
  "/logs/error.log"
  "/logs/access.log"
  "/logs/application.log"
  "/backup.zip"
  "/backup.sql"
  "/dump.sql"
  "/database.sql"
  "/db.sql"
  "/dump.tar.gz"
  
  # Git y Versionado
  "/.git/config"
  "/.git/HEAD"
  "/.gitignore"
  "/.gitmodules"
  "/.env.backup"
  "/.env.production"
  "/.env.local"
  
  # Claves API y Tokens Comunes
  "/api/config"
  "/api/settings"
  "/api/tokens"
  "/api/keys"
  "/api/secrets"
  "/api/credentials"
  
  # Archivos de texto plano comunes que pueden tener datos
  "/readme.txt"
  "/changelog.txt"
  "/notes.txt"
  "/todo.txt"
  "/info.txt"
  
  # SSL y Seguridad
  "/.well-known/security.txt"
  "/security.txt"
  "/cert.pem"
  "/server.key"
  "/private.key"
  
  # Logs de Error Específicos
  "/error.log"
  "/debug.log"
  "/trace.log"
)

echo "[*] Iniciando búsqueda de archivos sensibles en $URL ..."
echo "[*] Fecha: $(date '+%Y-%m-%d %H:%M:%S')"
echo "[*] Total rutas a probar: ${#ROUTES[@]}"
echo "----------------------------------------"

FOUND_COUNT=0

for route in "${ROUTES[@]}"; do
  URL_FULL="${URL}${route}"
  
  # Obtener código de estado y tipo de contenido
  # --max-time: límite de tiempo
  RESPONSE=$(curl -s -o /dev/null -w "%{http_code}|%{content_type}" --max-time $TIMEOUT --head "$URL_FULL")
  
  CODE=$(echo "$RESPONSE" | cut -d'|' -f1)
  CONTENT_TYPE=$(echo "$RESPONSE" | cut -d'|' -f2)
  
  if [ "$CODE" == "200" ]; then
    # Obtener tamaño para filtrar falsos positivos
    SIZE=$(curl -s -o /dev/null -w "%{size_download}" "$URL_FULL")
    
    # Lógica de filtro:
    # 1. Si el contenido NO es HTML, es sospechoso (ej. json, txt, yml, properties).
    # 2. Si ES HTML pero es muy pequeño (< 5KB), podría ser una página de error o configuración.
    if [ "$CONTENT_TYPE" != "text/html" ] || [ "$SIZE" -lt 5120 ]; then
      echo "[!] POSIBLE VULNERABILIDAD: $URL_FULL"
      echo "    Status: $CODE | Tipo: $CONTENT_TYPE | Tamaño: $SIZE bytes"
      echo "    Contenido (primeras 10 líneas):"
      curl -s "$URL_FULL" | head -n 10
      echo "----------------------------------------"
      FOUND_COUNT=$((FOUND_COUNT + 1))
    fi
  elif [ "$CODE" == "301" ]; then
    LOCATION=$(curl -s -I "$URL_FULL" | grep -i '^location:' | awk '{print $2}' | tr -d '\r')
    echo "[*] Redirección 301: $URL_FULL -> $LOCATION"
    echo "----------------------------------------"
  elif [ "$CODE" == "403" ]; then
    echo "[*] Acceso Denegado (Posible archivo sensible protegido): $URL_FULL"
    echo "----------------------------------------"
  fi
done

if [ $FOUND_COUNT -eq 0 ]; then
  echo "[*] No se encontraron archivos sensibles expuestos con los criterios actuales."
else
  echo "[*] Se encontraron $FOUND_COUNT posibles vulnerabilidades."
fi

echo "[*] Escaneo completado."

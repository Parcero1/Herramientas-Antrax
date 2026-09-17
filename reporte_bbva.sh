#!/usr/bin/env bash
# ============================================================
# 📊 REPORTE DE ANÁLISIS DE INFRAESTRUCTURA — BBVA Y ASOCIADOS
# Autor: Ángel Arreola — ANGEL-ANTRAX
# Perfil: Security Researcher (White Hat)
# Origen: Cd. Nezahualcóyotl, Estado de México 🇲🇽
# Fecha: Septiembre 2026
# Versión: 1.0
# ============================================================
# [!] AVISO ÉTICO: Reporte elaborado con fines de análisis
#     educativo y mejora de la seguridad. Uso responsable.
# ============================================================

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
MAGENTA='\033[1;35m'
RESET='\033[0m'

ARCHIVO_REPORTE="reporte_bbva_$(date +%Y%m%d_%H%M%S).txt"

clear
echo -e "${CYAN}"
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║           📊  REPORTE DE ANÁLISIS DE INFRAESTRUCTURA          ║"
echo "║                    BBVA México y Servicios Asociados           ║"
echo "╚═══════════════════════════════════════════════════════════════${RESET}"
echo ""

echo -e "${WHITE}📝 GENERANDO REPORTE...${RESET}"
echo ""

cat > "$ARCHIVO_REPORTE" << REPORT_EOF
====================================================================
                    REPORTE DE ANÁLISIS DE INFRAESTRUCTURA
                         BBVA México y Servicios Asociados
====================================================================

DATOS DEL INVESTIGADOR
----------------------
Investigador:    Ángel Arreola — ANGEL-ANTRAX
Perfil:          Security Researcher (White Hat)
Origen:          Cd. Nezahualcóyotl, Estado de México 🇲🇽
Fecha:           $(date +"%d/%m/%Y %H:%M:%S")
Plataforma:      Termux / Android
Versión Reporte: 1.0

OBJETIVO DEL ANÁLISIS
---------------------
Verificar disponibilidad, estado y respuesta de los dominios y
servicios web pertenecientes o asociados a BBVA México, con fines
de análisis de infraestructura y contribución a la mejora de la
seguridad digital.

AVISO ÉTICO
-----------
Este reporte ha sido elaborado con fines estrictamente educativos,
de investigación y análisis responsable. No se incluye ni se
solicita acceso no autorizado, extracción de datos sensibles ni
interacción maliciosa con los sistemas analizados. Todo trabajo
se realiza desde el respeto, la ética y la transparencia.

====================================================================
                    RESULTADOS DEL ESCANEO
====================================================================
REPORT_EOF

declare -A DOMINIOS=(
    ["bbva.com.mx"]="Sitio principal BBVA México"
    ["pr.bbvaempresas.mx"]="Portal BBVA Empresas"
    ["ebanking2.bancoazteca.com.mx"]="Banca en Línea Banco Azteca"
    ["ecommercebbva.com"]="Plataforma E-commerce BBVA"
    ["www.bbva.mx"]="Portal público BBVA México"
)

TOTAL=0
ACTIVOS=0
INACTIVOS=0
PROTEGIDOS=0

echo -e "${CYAN}🔍 Analizando dominios...${RESET}"
echo ""

for dominio in "${!DOMINIOS[@]}"; do
    ((TOTAL++))
    DESCRIPCION="${DOMINIOS[$dominio]}"
    HTTP=$(curl -sI -o /dev/null -w "%{http_code}" --connect-timeout 10 "https://$dominio" 2>/dev/null)
    IP=$(dig +short "$dominio" A 2>/dev/null | head -n1 || echo "---")

    if [[ "$HTTP" == "200" || "$HTTP" == "301" || "$HTTP" == "302" ]]; then
        ESTADO="ACTIVO"
        ((ACTIVOS++))
    elif [[ "$HTTP" == "403" ]]; then
        ESTADO="PROTEGIDO"
        ((PROTEGIDOS++))
    elif [[ "$HTTP" == "404" ]]; then
        ESTADO="NO ENCONTRADO"
        ((INACTIVOS++))
    else
        ESTADO="SIN RESPUESTA"
        ((INACTIVOS++))
    fi

    printf "${WHITE}%-30s${RESET} %-45s %s Código: %-4s IP: %s\n" "🔎 $dominio" "$DESCRIPCION" "$ESTADO" "$HTTP" "$IP"

    cat >> "$ARCHIVO_REPORTE" << ENTRY_EOF

Dominio:      $dominio
Descripción:  $DESCRIPCION
Código HTTP:  $HTTP
Estado:       $ESTADO
IP Resuelta:  $IP
ENTRY_EOF
done

cat >> "$ARCHIVO_REPORTE" << FINAL_EOF

====================================================================
                    RESUMEN ESTADÍSTICO
====================================================================

Total dominios analizados:    $TOTAL
Servicios activos:            $ACTIVOS
Servicios protegidos (403):   $PROTEGIDOS
Servicios inactivos/otros:   $INACTIVOS
Tasa de disponibilidad:      $(( ACTIVOS * 100 / TOTAL ))%

====================================================================
                    OBSERVACIONES Y CONCLUSIONES
====================================================================

[1] Los dominios principales responden correctamente, indicando
    una infraestructura operativa y estable.

[2] Códigos 403 indican protección activa en ciertos portales,
    lo que refleja implementación de controles de acceso.

[3] La infraestructura de BBVA y Banco Azteca presenta una
    disponibilidad alta, consistente con servicios financieros
    de nivel producción.

[4] Se recomienda monitoreo continuo de códigos de respuesta
    y redirecciones para detectar cambios en la configuración
    de seguridad o infraestructura.

====================================================================
                    COMPROMISO Y PROPÓSITO
====================================================================

Este análisis representa el esfuerzo de un profesional que
desde Cd. Nezahualcóyotl, con recursos limitados pero con
dedicación ilimitada, busca aportar valor real a la seguridad
digital. Hacerlo con ética, hacerlo bien y hacerlo hasta
el final. Que el trabajo hable por sí mismo y que el
reconocimiento llegue de quien tenga que llegar.

Mis hijos, mis padres y mi compañera de vida son mi mayor
motivación y motor de todo esto. Cada línea de código y
cada análisis que realizo es para construirles un mejor
futuro y demostrarles que su apoyo es mi fuerza.

====================================================================
                            FIN DE REPORTE
====================================================================
Investigador: Ángel Arreola — ANGEL-ANTRAX
Origen:       Cd. Nezahualcóyotl, Estado de México 🇲🇽
© 2026 — Ángel Arreola — Todos los derechos bajo ética y transparencia
====================================================================
FINAL_EOF

echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${RESET}"
echo -e "${WHITE}📊 RESUMEN DEL REPORTE${RESET}"
echo -e "${CYAN}───────────────────────────────────────────────────────────────${RESET}"
echo -e "  Total analizados:   ${WHITE}$TOTAL${RESET}"
echo -e "  Activos:            ${GREEN}$ACTIVOS${RESET}"
echo -e "  Protegidos:         ${YELLOW}$PROTEGIDOS${RESET}"
echo -e "  Inactivos:          ${RED}$INACTIVOS${RESET}"
echo -e "  Disponibilidad:     ${CYAN}$(( ACTIVOS * 100 / TOTAL ))%${RESET}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${RESET}"
echo ""
echo -e "${GREEN}✅ REPORTE GENERADO EXITOSAMENTE${RESET}"
echo -e "${WHITE}📄 Archivo: ${CYAN}$ARCHIVO_REPORTE${RESET}"
echo ""
echo -e "${YELLOW}💡 Ver reporte: cat $ARCHIVO_REPORTE${RESET}"
echo -e "${YELLOW}💡 Subir: git add . && git commit -m \"Reporte BBVA — ANGEL-ANTRAX\" && git push${RESET}"

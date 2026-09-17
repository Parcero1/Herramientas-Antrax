#!/usr/bin/env bash
# ============================================================
# 🔐 HERRAMIENTAS DE ANÁLISIS Y ESCANEO WEB
# Autor: Ángel Arreola — ANGEL-ANTRAX
# Origen: Cd. Nezahualcóyotl, Estado de México 🇲🇽
# Fecha: Septiembre 2026
# ============================================================
# [!] AVISO ÉTICO: Uso responsable y ético obligatorio.
#     Solo para fines educativos y con autorización previa.
# ============================================================

# Colores
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
MAGENTA='\033[1;35m'
RESET='\033[0m'

# Banner Principal
clear
echo -e "${CYAN}"
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                                                                   ║"
echo "║    🔐  ESCÁNER DE DISPONIBILIDAD DE DOMINIOS Y SERVICIOS        ║"
echo "║                                                                   ║"
echo "║    ▸ DESARROLLADO POR:  Ángel Arreola — ANGEL-ANTRAX            ║"
echo "║    ▸ ORIGEN:            Cd. Nezahualcóyotl, Estado de México    ║"
echo "║    ▸ PLATAFORMA:        Termux / Android — Sin dependencias     ║"
echo "║    ▸ VERSIÓN:           1.0.0 — Septiembre 2026                 ║"
echo "║                                                                   ║"
echo "╚═══════════════════════════════════════════════════════════════${RESET}"
echo ""

# Frase destacada
echo -e "${MAGENTA}  💡 \"La ciberseguridad no se trata de romper,${RESET}"
echo -e "${MAGENTA}      se trata de entender para proteger.\"${RESET}"
echo ""

# Lista de dominios a escanear
TARGETS=(
"walletbot.me"
"pay.wallet.tg"
"wallet.tg"
"wallettg.com"
"wallettg.net"
"p2p.walletbot.me"
"bbva.com.mx"
"ebanking2.bancoazteca.com.mx"
)

# Contadores
TOTAL=0
UP=0
DOWN=0

echo -e "${BLUE}🔍 INICIANDO ESCANEO — ${#TARGETS[@]} OBJETIVOS CARGADOS${RESET}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${RESET}"
echo ""

# Escaneo
for domain in "${TARGETS[@]}"; do
  ((TOTAL++))
  printf "${WHITE}  %-28s${RESET}" "🔎 $domain"
  
  HTTP=$(curl -sI -o /dev/null -w "%{http_code}" --connect-timeout 10 "https://$domain" 2>/dev/null)
  
  if [[ "$HTTP" == "200" || "$HTTP" == "301" || "$HTTP" == "302" ]]; then
    echo -e "${GREEN}✅ EN LÍNEA${RESET}     Código: ${GREEN}$HTTP${RESET}"
    ((UP++))
  elif [[ "$HTTP" == "403" ]]; then
    echo -e "${YELLOW}🔒 PROTEGIDO${RESET}    Código: ${YELLOW}$HTTP${RESET}"
    ((UP++))
  else
    echo -e "${RED}❌ INACTIVO${RESET}     Código: ${RED}$HTTP${RESET}"
    ((DOWN++))
  fi
done

# Línea separadora
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${RESET}"

# 📊 RESUMEN DE RESULTADOS
echo -e "${WHITE}📊 RESUMEN DEL ANÁLISIS${RESET}"
echo -e "${CYAN}───────────────────────────────────────────────────────────────${RESET}"
echo -e "  ${WHITE}Objetivos escaneados:${RESET}    $TOTAL"
echo -e "  ${GREEN}Servicios activos:${RESET}        $UP"
echo -e "  ${RED}Servicios inactivos:${RESET}      $DOWN"
echo -e "  ${CYAN}Tasa de disponibilidad:${RESET}   $(( UP * 100 / TOTAL ))%"
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${RESET}"
echo ""

# 🏆 ALCANCE Y COMPROMISO
echo -e "${MAGENTA}🏆 ALCANCE Y COMPROMISO${RESET}"
echo -e "${CYAN}───────────────────────────────────────────────────────────────${RESET}"
echo -e "  ✅ Herramienta construida 100% desde Termux en Android"
echo -e "  ✅ Sin equipos costosos — solo un celular y dedicación"
echo -e "  ✅ Desde Cd. Nezahualcóyotl — demostrando que el origen no limita"
echo -e ""
echo -e "  ✅ Mis hijos, mis padres y mi compañera de vida son mi mayor"
echo -e "     motivación y motor de todo esto. Cada línea de código que"
echo -e "     escribo es para construirles un mejor futuro y demostrarles"
echo -e "     que su apoyo es mi fuerza.${RESET}"
echo -e ""
echo -e "  ${BLUE}🌐 OBJETIVO: Contribuir con valor real a la seguridad${RESET}"
echo -e "  ${BLUE}     de infraestructuras financieras como BBVA y Banco Azteca,${RESET}"
echo -e "  ${BLUE}     hasta que ese esfuerzo sea reconocido y validado${RESET}"
echo -e "  ${BLUE}     por las propias instituciones.${RESET}"
echo -e ""
echo -e "  ${MAGENTA}🎯 Meta: Hacerlo con ética, hacerlo bien y hacerlo hasta el final.${RESET}"
echo -e "  ${MAGENTA}     Que el trabajo hable por sí mismo y que el reconocimiento${RESET}"
echo -e "  ${MAGENTA}     llegue de quien tenga que llegar.${RESET}"
echo -e ""
echo -e "  ${GREEN}🏙️  Desde Cd. Nezahualcóyotl, Estado de México 🇲🇽 —${RESET}"
echo -e "  ${GREEN}     Donde el esfuerzo vence los límites y la voluntad${RESET}"
echo -e "  ${GREEN}     construye su propio camino.${RESET}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${RESET}"
echo ""

# Mensaje final
echo -e "${GREEN}✅ ESCANEO COMPLETADO CON ÉXITO${RESET}"
echo -e "${GREEN}   ANGEL-ANTRAX — 2026 — Construyendo desde abajo, hacia arriba${RESET}"
echo ""
echo -e "${YELLOW}🚀 \"No importa dónde empiezas, sino hacia dónde vas${RESET}"
echo -e "${YELLOW}    y qué tan lejos estás dispuesto a llegar.\"${RESET}"
echo ""


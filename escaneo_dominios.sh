#!/data/data/com.termux/files/usr/bin/bash
# ==================================================
# 🔍 ESCÁNER DE DISPONIBILIDAD DE DOMINIOS
# Autor: Ángel Arreola — ANGEL-ANTRAX
# Origen: Cd. Nezahualcóyotl, México 🇲🇽
# ==================================================

echo "=================================================="
echo "🔎 ESCÁNER — VERIFICACIÓN DE DOMINIOS"
echo "Autor: Ángel Arreola | ANGEL-ANTRAX"
echo "=================================================="
echo ""

TARGETS=(
"walletbot.me"
"pay.wallet.tg"
"wallet.tg"
"wallettg.com"
"wallettg.net"
"p2p.walletbot.me"
)

for domain in "\${TARGETS[@]}"; do
  echo "🔎 \$domain"
  HTTP=\$(curl -sI -o /dev/null -w "%{http_code}" --connect-timeout 10 "https://\$domain")
  echo "   Código HTTP: \$HTTP"
  echo ""
done

echo "✅ Escaneo completado — ANGEL-ANTRAX 2026"

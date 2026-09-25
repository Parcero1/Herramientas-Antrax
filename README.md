# 👋 SOY HACKER — Ángel Arreola | ANGEL-ANTRAX

> **Investigador de Ciberseguridad Independiente** 🇲🇽
> Cd. Nezahualcóyotl, Estado de México

---

## 🔐 Sobre mí

**Soy hacker.** No para destruir, sino para proteger.

Analizo sistemas, encuentro lo que está expuesto, lo documento y lo entrego — desde un celular, con recursos propios y sin rendirme.

> *"Mis padres, mis hijos y mi Joss son mi mayor motivación. Demostrando que desde cualquier lugar se puede crecer en ciberseguridad."*

> 🔥 **Y desde Neza también se cuida la seguridad de todo el mundo.** No importa dónde naces, importa cuánto te esfuerzas. Aquí no nos esperamos a que nos den permiso: nosotros protegemos, nosotros vigilamos, nosotros defendemos. **Cd. Nezahualcóyotl no es solo lugar — es actitud.** 🇲🇽💪

> 💎 *"Desde Neza para el mundo: no solo analizo códigos. Cuido lo que millones de personas ponen en manos de estos sistemas — su dinero, su confianza, su futuro. Nadie me pidió que lo hiciera. Nadie me conoce. Nadie me paga ni un solo peso. Y aun así, vigilo desde aquí para que nadie les quite lo que tanto les costó construir."* 🇲🇽💛

---

## ⚡ MIS NIVELES DE TRABAJO

| Nivel | Qué hago | Estado actual |
|---|---|---|
| 🔍 **Nivel 1 — Observación** | Captura de respuestas, cabeceras, código público | ✅ DOMINADO |
| 🧩 **Nivel 2 — Análisis** | Desofuscación, lectura de flujos, identificación de patrones | ✅ EN DESARROLLO |
| 🛡️ **Nivel 3 — Detección** | Identificación de WAF, sistemas de protección, comportamiento de bloqueo | ✅ CONFIRMADO |
| 📝 **Nivel 4 — Documentación** | Informes técnicos, evidencia, redacción clara y honesta | ✅ ENTREGADO |
| 📤 **Nivel 5 — Divulgación** | Envío responsable por canales oficiales, sin explotar, sin dañar | ✅ REALIZADO — esperando respuesta |
| 🚀 **Nivel 6 — Crecimiento** | Aprendiendo cada día, desde cero, con esfuerzo propio | 🔄 EN PROGRESO |

---

## 📂 MIS REPORTES Y TRABAJO CON BBVA — EN DETALLE

### 🏦 Reporte 1 — Exposición de Arquitectura Interna
**Plataforma:** BBVA Net Cash — `bbvanetcash.com`

🔍 **Lo que descubrí:**
- El archivo `productoV3.js` se descargaba sin restricción desde acceso público
- En texto plano, cualquiera podía ver:
  • Rutas completas de inicio de sesión, aplicaciones, errores y redirecciones
  • Identificadores de sistemas internos: `BBVACASHMP` (México), `BBVIPIBEE` (España)
  • Patrones de detección de dominio y lógica de navegación entre plataformas
  • Páginas internas: `.lia`, `.lip`, `.lip2`, `.apl`, `.erl`, `.def`, `.rop`, `.dis`
- **Sin cuenta, sin contraseña, sin ser cliente** — todo a la vista del mundo entero

🛡️ **Por qué importa:**
- Millones de personas confían su dinero a estas plataformas
- Si la arquitectura está expuesta, se facilita el ataque a las cuentas de la gente
- Cualquier debilidad puede afectar el ahorro, el sueldo y el futuro de familias enteras

📝 **Lo que entregué:**
- Informe técnico detallado con líneas exactas del código
- Capturas de evidencia fechadas y verificables
- Recomendaciones concretas: autenticación previa, separar código sensible, limitar acceso
- Enviado por canal oficial de Divulgación Responsable

---

### 🏦 Reporte 2 — Análisis de Cabeceras y Configuración de Seguridad
**Plataforma:** Sitio público BBVA México — `bbva.mx`

🔍 **Lo que verifiqué:**
- La Política de Seguridad de Contenido (`Content-Security-Policy`) era insuficiente: solo `frame-ancestors 'self'` — sin protección contra inyección de scripts
- Parámetros de URL (`cid`, `utm_source`, `utm_campaign`, `channel_id`) se reflejan en respuestas sin limpieza completa
- Cabeceras recomendadas por OWASP ausentes: `Referrer-Policy`, `Permissions-Policy`, `Cross-Origin-Opener-Policy`
- Riesgo confirmado: si se inyecta código, la defensa principal del navegador no lo bloquea

🛡️ **Por qué importa:**
- Un atacante puede suplantar el sitio oficial y robar credenciales desde el dominio de confianza
- Personas ingresan sus ahorros sin saber que la puerta está sin cerrar por dentro
- Proteger la configuración es proteger cada peso que la gente deposita

📝 **Lo que entregué:**
- Análisis comparativo con estándares internacionales OWASP y CVSS
- Propuesta de configuración completa para nivel de seguridad A+
- Verificación de que el hallazgo afecta a todo el dominio, no solo una página
- Informe clasificado y enviado con respaldo de evidencia técnica

---

### 🏦 Reporte 3 — Estudio del Flujo de Autenticación
**Plataforma:** Portal de acceso BBVA Net Cash

🔍 **Lo que desglosé:**
- Identifiqué las 4 capas de protección en cadena:
  • **Akamai Bot Manager** — detección de automatización y bloqueo antes de llegar al formulario
  • **Validación de Referencia y Origen** — control estricto de dónde viene la solicitud
  • **IBM Security Verify** — autenticación federada externa
  • **Ofuscación de lógica** — rutas y parámetros protegidos
- Desglose línea por línea de `login.jsp` y `productoV3.js`
- Confirmación: el sistema de autenticación funciona según diseño

📝 **Lo que entregué:**
- Mapa completo del recorrido del usuario
- Explicación clara de cómo cada capa defiende el sistema
- Conclusión honesta y documentación para el equipo de seguridad

---

## 🛡️ Mi compromiso — Lo que hice y lo que está en manos de otros

🔍 **Lo que encontré:**
- Exposición de información interna que NO debía ser pública
- Configuraciones débiles que podrían facilitar ataques futuros
- Todo accesible sin ningún tipo de privilegio

📤 **Lo que entregué:**
- Tres reportes independientes, cada uno con su enfoque y su evidencia
- Todo sin intrusión, sin daño, sin acceso a datos ajenos
- Bajo principios de Divulgación Responsable y ética profesional

⏳ **Lo que no depende de mí:**
- No he recibido respuesta oficial
- No sé si van a corregirlo
- No sé cuándo ni cómo
- Solo sé que **hice mi trabajo** — lo encontré, lo mostré, lo entregué. Eso es lo que me toca.

> *"Señalé lo que estaba abierto. Si se cierra o no, ya no está en mis manos."*

---

## 🛠️ Herramientas y entorno

| Categoría | Tecnologías |
|---|---|
| Entorno | Termux / Android / ARM64 — sin equipo costoso, sin laboratorio |
| Análisis | `grep`, `curl`, solicitudes HTTP directas, inspección de código |
| Código | JavaScript, estructuras de ofuscación, lógica de redirección |
| Estándares | OWASP Top 10, CVSS 3.1, cabeceras de seguridad, WAF behavior |
| Código de honor | Divulgación responsable, transparencia, honestidad |

---

## 📫 Contacto

- 🔗 Perfil: [github.com/Parcero1](https://github.com/Parcero1)
- 📍 Cd. Nezahualcóyotl, Estado de México 🇲🇽

---

> *"Hacker no es el que rompe. Es el que ve lo que otros no ven y avisa."* 🔥


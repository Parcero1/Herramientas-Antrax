# 🔍 INFORME DE RECONOCIMIENTO DE SEGURIDAD

**Entidad:** Banco Azteca / Grupo Salinas
**Investigador:** Angel Arreola — *ANGEL-ANTRAX*
**Origen:** Ciudad Nezahualcóyotl, México 🇲🇽
**Fecha:** 17 de septiembre de 2026
**Alcance:** Reconocimiento pasivo y activo de superficie pública
**Metodología:** Termux · cURL · Análisis de cabeceras y respuestas HTTP
**Estado:** ✅ Completo — Sin alteración de datos ni acceso no autorizado

---

## 1. RESUMEN EJECUTIVO

Se realizó un mapeo completo de la infraestructura pública de Banco Azteca, identificando dominios, sistemas, tecnologías y configuraciones de seguridad. Todo el trabajo se efectuó **desde el exterior, sin credenciales, sin envío de formularios y sin interrumpir servicio alguno**.

> **Hallazgo principal:** La infraestructura presenta **protecciones sólidas en su mayoría**, aunque se exponen nombres de sistemas internos, rutas de servicio y dominios de API que amplían la superficie de ataque visible públicamente.

---

## 2. ACTIVOS IDENTIFICADOS

### 2.1 Plataforma de Banca en Línea
| Activo | Estado | Código |
|---|---|---|
| `ebanking2.bancoazteca.com.mx/ebanking/login` | ✅ Activo | 200 OK |
| `ebanking2.bancoazteca.com.mx/ebanking/redirectLogin` | ✅ Formulario real | 200 OK |
| `www.bancoazteca.com.mx` | ✅ Sitio público | 301 → 200 |
| `www.bancoazteca.com.mx/ayuda/recuperar-contrasena.html` | ✅ Página funcional | 200 OK |

### 2.2 Dominios y Servicios Internos
| Dominio | Propósito Inferido |
|---|---|
| `*.apibaz.com` | API interna |
| `*.s1gateway.com` | Pasarela de servicios |
| `*.baz.app` | Aplicación móvil / portal |
| `servicios.bazdigital.com:8443` | Servicios internos |
| `webhook.facturaciongs.com` | Facturación electrónica |
| `*.bancaempresarialazteca.com.mx` | Plataforma empresas |
| `*.azteca.click` | Enlaces cortos / marketing |
| `auvious.video` | Verificación por video |

### 2.3 Entorno detectado
- **Identificador:** `MX06` — Producción México
- **Servidor:** Apache/2.4.57 (Red Hat Enterprise Linux)
- **Protección:** Imperva + CloudFront
- **Framework:** AEM + Angular SPA
- **Lenguaje:** JSP/2.3

---

## 3. ANÁLISIS DE CABECERAS DE SEGURIDAD

| Medida | Estado |
|---|---|
| HSTS | ✅ Presente — 2 años + preload |
| CSP | ✅ Completa — lista blanca de orígenes |
| X-Frame-Options | ✅ SAMEORIGIN |
| X-Content-Type-Options | ✅ nosniff |
| X-XSS-Protection | ✅ 1; mode=block |
| CSRF Token | ✅ Por sesión individual |
| Encriptación cliente | ✅ Activa antes de enviar |
| Divulgación versión | ⚠️ Parcial |
| Listado de rutas | ✅ Bloqueado |

---

## 4. HALLAZGOS TÉCNICOS

### Flujo de Autenticación
/ebanking/login → redirección → /ebanking/redirectLogin → FORMULARIO      - Requiere `JSESSIONID` + token CSRF válidos
- Datos encriptados en el navegador antes de transmitirse
- No simulable desde herramientas externas sin lógica de cifrado

### Información Expuesta
- CSP revela **más de 15 dominios y servicios internos**
- IPs de red privada (`10.122.x.x`) visibles
- Versiones de bibliotecas y servidor divulgadas
- Puertos no estándar: 8443, 8544, 8545, 8546

### Protección Activa
- Imperva detecta y bloquea automatización
- Sesiones ligadas a comportamiento del cliente
- Requiere navegador real + interacción humana

---

## 5. CONCLUSIONES

| Ítem | Calificación |
|---|---|
| Protección general | 🟢 BUENA |
| Cabeceras de seguridad | 🟢 MUY BUENA |
| Exposición de infraestructura | 🟡 MEDIA |
| Resistencia a escaneo | 🟢 BUENA |
| Cifrado de credenciales | 🟢 EXCELENTE |

> **Recomendación:** Reducir la información de infraestructura interna revelada en políticas públicas. El resto de las defensas se encuentran bien configuradas.

---

## 6. COMPROMISO ÉTICO

- ✅ No se enviaron credenciales ni intentos de acceso
- ✅ No se obtuvo ni modificó dato de usuario
- ✅ No se interrumpió servicio
- ✅ Informe sin divulgación pública sin autorización

---

**Ciudad Nezahualcóyotl, Estado de México**
*Angel Arreola — ANGEL-ANTRAX*
> *"Mis hijos son mi mayor motivación"* ❤️

import requests
from bs4 import BeautifulSoup
import re
import json
import logging

# Configuración
logging.basicConfig(level=logging.INFO, format='%(levelname)s: %(message)s')
logger = logging.getLogger(__name__)

class BBVAAutomator:
    def __init__(self):
        self.session = requests.Session()
        self.base_url = "https://www.bbvanetcash.com"
        self.headers = {
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
            "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
            "Accept-Language": "es-ES,es;q=0.9,en;q=0.8",
            "Connection": "keep-alive",
            "Upgrade-Insecure-Requests": "1"
        }

    def start_session(self):
        """
        Paso 1: Iniciar sesión en el servlet de autenticación inicial.
        """
        logger.info("Iniciando sesión en el servlet DRServlet...")
        url_init = f"{self.base_url}/DFAUTH/slod_mult_mult/DRServlet"
        
        # Datos típicos que se envían, aunque a menudo es vacío o depende del producto
        # Aquí asumimos que la redirección se basa en las cookies y el host
        try:
            response = self.session.post(url_init, headers=self.headers, timeout=10)
            response.raise_for_status()
            logger.info(f"Estado inicial: {response.status_code}")
            
            # Guardar cookies iniciales
            self.save_cookies()
            
            # Analizar la respuesta para ver si hay redirección inmediata o JS clave
            soup = BeautifulSoup(response.text, 'html.parser')
            
            # Buscar el script de producto para saber a dónde ir
            script_tags = soup.find_all('script', src=True)
            for script in script_tags:
                if 'productoV3.js' in script['src']:
                    logger.info(f"Encontrado productoV3.js: {script['src']}")
                    self.get_product_config(script['src'])
                elif '73g8KiWKygVDsg1rC2_l' in script['src']:
                    logger.info(f"Encontrado script ofuscado: {script['src']}")
                    # Este script suele contener la lógica de redirección final
                    
            # Intentar seguir redirecciones si las hubiera
            if response.history:
                logger.info(f"Redirecciones: {[r.url for r in response.history]}")
                
            return True
            
        except Exception as e:
            logger.error(f"Error al iniciar sesión: {e}")
            return False

    def get_product_config(self, script_url):
        """
        Paso 2: Obtener la configuración del producto para saber la URL de login.
        """
        # Resolver URL relativa si es necesaria
        if not script_url.startswith('http'):
            script_url = f"{self.base_url}{script_url}"
            
        try:
            response = self.session.get(script_url, headers=self.headers, timeout=10)
            if response.status_code == 200:
                js_content = response.text
                # Buscar la variable Producto
                match = re.search(r'var Producto\s*=\s*(\[.*?\]);', js_content, re.DOTALL)
                if match:
                    product_data = match.group(1)
                    # Parsear JSON simplificado o evaluar con precaución
                    # Para BBVA, a menudo es un array de objetos
                    try:
                        products = json.loads(product_data.replace("'", '"'))
                        logger.info(f"Configuración de producto obtenida: {len(products)} producto(s)")
                        for p in products:
                            logger.debug(f"Producto: {p}")
                        return products
                    except json.JSONDecodeError:
                        logger.warning("No se pudo parsear JSON, devolviendo texto crudo")
                else:
                    logger.warning("No se encontró variable 'Producto' en el JS")
            else:
                logger.error(f"Error al obtener productoV3.js: {response.status_code}")
        except Exception as e:
            logger.error(f"Error obteniendo configuración: {e}")
        return None

    def find_login_page(self, product_data=None):
        """
        Paso 3: Determinar la URL de login y obtener el formulario.
        """
        # Si tenemos datos de producto, buscar la URL de login
        if product_data:
            for p in product_data:
                if 'lip' in p: # 'lip' suele ser la URL de inicio
                    login_url = p['lip']
                    if not login_url.startswith('http'):
                        login_url = f"{self.base_url}{login_url}"
                    logger.info(f"URL de login encontrada: {login_url}")
                    return self.get_login_form(login_url)
        
        # Si no, intentar la URL por defecto
        default_login = f"{self.base_url}/login_default.html"
        logger.info(f"Probando URL por defecto: {default_login}")
        return self.get_login_form(default_login)

    def get_login_form(self, url):
        """
        Paso 4: Obtener el formulario de login y sus campos.
        """
        try:
            response = self.session.get(url, headers=self.headers, timeout=10)
            response.raise_for_status()
            
            soup = BeautifulSoup(response.text, 'html.parser')
            form = soup.find('form')
            
            if form:
                action = form.get('action', url)
                if not action.startswith('http'):
                    action = f"{self.base_url}{action}"
                    
                logger.info(f"Formulario encontrado. Acción: {action}")
                
                # Extraer campos ocultos
                inputs = form.find_all('input')
                hidden_fields = {}
                visible_fields = {}
                
                for inp in inputs:
                    name = inp.get('name')
                    value = inp.get('value')
                    inp_type = inp.get('type', 'text')
                    
                    if name:
                        if inp_type in ['hidden', 'password', 'text']: # Ajustar según necesidad
                            if inp_type == 'hidden':
                                hidden_fields[name] = value
                            else:
                                visible_fields[name] = value
                                
                logger.info(f"Campos ocultos: {list(hidden_fields.keys())}")
                logger.info(f"Campos visibles: {list(visible_fields.keys())}")
                
                return {
                    'action': action,
                    'method': form.get('method', 'POST').upper(),
                    'hidden_fields': hidden_fields,
                    'visible_fields': visible_fields,
                    'html': soup.prettify() # Para depuración
                }
            else:
                logger.warning("No se encontró formulario en la página")
                return None
                
        except Exception as e:
            logger.error(f"Error obteniendo formulario: {e}")
            return None

    def attempt_login(self, username, password, form_data):
        """
        Paso 5: Enviar credenciales.
        """
        if not form_data:
            logger.error("No hay datos de formulario para enviar")
            return False
            
        payload = form_data['hidden_fields'].copy()
        payload['usuario'] = username # Ajustar nombre del campo si es diferente
        payload['clave'] = password   # Ajustar nombre del campo si es diferente
        
        # Si hay campos visibles que no sean usuario/clave, añadirlos
        for k, v in form_data['visible_fields'].items():
            if k not in ['usuario', 'clave']:
                payload[k] = v
                
        try:
            logger.info(f"Enviando login a {form_data['action']}")
            response = self.session.post(form_data['action'], data=payload, headers=self.headers, timeout=10)
            response.raise_for_status()
            
            logger.info(f"Estado post-login: {response.status_code}")
            logger.info(f"URL final: {response.url}")
            
            # Verificar si estamos en la página de error o de éxito
            soup = BeautifulSoup(response.text, 'html.parser')
            
            # Buscar mensajes de error comunes
            error_msgs = soup.find_all(class_=lambda c: c and 'error' in c.lower())
            if error_msgs:
                logger.warning(f"Posible error detectado: {[m.get_text() for m in error_msgs]}")
                return False
                
            # Buscar elementos típicos de éxito (saldo, menú)
            success_indicators = soup.find_all(id=lambda i: i and ('saldo' in i.lower() or 'menu' in i.lower() or 'home' in i.lower()))
            if success_indicators:
                logger.info("¡Posible login exitoso! Se encontraron indicadores de éxito.")
                return True
            else:
                logger.warning("No se encontraron indicadores claros de éxito ni error. Revisa la URL final.")
                
            return response.status_code == 200
            
        except Exception as e:
            logger.error(f"Error en login: {e}")
            return False

    def save_cookies(self):
        """Guardar cookies para depuración o reutilización"""
        cookies = self.session.cookies
        logger.debug(f"Cookies actuales: {dict(cookies)}")

# Uso del script
if __name__ == "__main__":
    bot = BBVAAutomator()
    
    # 1. Iniciar sesión
    bot.start_session()
    
    # 2. Obtener configuración de producto
    product_data = bot.get_product_config("https://www.bbvanetcash.com/productoV3.js")
    
    # 3. Encontrar y obtener formulario de login
    form_data = bot.find_login_page(product_data)
    
    if form_data:
        # 4. Intentar login con credenciales de prueba
        # Reemplaza con tus credenciales reales
        username = "TU_USUARIO"
        password = "TU_CLAVE"
        bot.attempt_login(username, password, form_data)

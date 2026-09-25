import os
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service

# Configurar el servicio apuntando al chromedriver nativo de Termux
service = Service(executable_path="/data/data/com.termux/files/usr/bin/chromedriver")

# Configurar opciones del navegador
options = Options()
options.add_argument('--headless')          # Ejecutar en segundo plano (sin interfaz)
options.add_argument('--no-sandbox')        # Obligatorio en entornos Android/Termux y proot
options.add_argument('--disable-dev-shm-usage')
options.add_argument('user-agent=Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36')

# Forzar la ruta del binario de Chromium de Termux
options.binary_location = "/data/data/com.termux/files/usr/bin/chromium"

# Iniciar el navegador con las configuraciones explícitas
driver = webdriver.Chrome(service=service, options=options)

try:
    print("Conectando al portal de BBVA...")
    # Prueba abriendo el enlace
    driver.get("https://bbva.com")
    
    print("Título de la página:", driver.title)
    
    # Extraer las cookies generadas por el navegador tras resolver el reto de sesión
    cookies = driver.get_cookies()
    print("\nCookies obtenidas con éxito:")
    for cookie in cookies:
        print(f"{cookie['name']}: {cookie['value']}")

finally:
    driver.quit()

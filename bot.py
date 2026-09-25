import requests

def attempt_login(username, password, form_data):
    # Tu código de login aquí
    response = requests.post('https://example.com/login', data=form_data)
    return response.status_code == 200

# Ejemplo de uso
username = "tu_usuario"
password = "tu_contraseña"
form_data = {
    'username': username,
    'password': password
}

if attempt_login(username, password, form_data):
    print("Login exitoso")
else:
    print("Login fallido")

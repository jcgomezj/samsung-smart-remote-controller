### Samsung Smart Bridge: Flutter + FastAPI IoT Controller
Este proyecto es un ecosistema de control remoto IoT que permite comandar una Smart TV Samsung a través de una interfaz moderna en Flutter, utilizando un bridge de backend desarrollado en FastAPI. El sistema actúa como un middleware que traduce peticiones HTTP en comandos de WebSocket específicos para el protocolo de Samsung.

## Características principales
Interfaz Responsiva: UI construida en Flutter Web optimizada para dispositivos móviles (iPhone/Android).

High-Performance Bridge: Backend asíncrono con FastAPI que garantiza latencia mínima en el envío de comandos.

Protocolo WebSocket: Integración profunda con samsungtvws para control total de hardware (Volumen, Apps, Navegación).

CORS Enabled: Configuración de middleware lista para despliegue en red local.

## Arquitectura del Sistema
El proyecto se divide en dos componentes principales que trabajan de forma sincronizada:

Frontend (Mobile/Web): Captura las interacciones del usuario y dispara peticiones REST hacia el bridge.

Backend (Middleware): Un servidor Python que mantiene el socket activo con la TV y gestiona el handshake de autenticación.

## Instalación y Configuración
# 1. Requisitos previos
Python 3.10+

Flutter SDK

Samsung Smart TV (2016+) conectada a la misma red Wi-Fi.

# 2. Configuración del Backend
Bash
cd backend_bridge
python -m venv venv
source venv/Scripts/activate  # En Windows: .\venv\Scripts\activate
pip install -r requirements.txt
python main.py
# 3. Ejecución del Frontend
Bash
cd flutter_remote_ui
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
## Variables de Entorno
Asegúrate de configurar la IP de tu televisor en el archivo main.py:

Python
TV_IP = '192.168.1.50' # Dirección IP asignada por el router a la TV
## Contribuciones
¡Las PRs son bienvenidas! Si tienes una idea para mejorar el mapeo de teclas o añadir soporte para más marcas de TV, siéntete libre de clonar y proponer tus cambios.

# Proyecto Trackariño

Sistema de gestión y seguimiento logístico para el transporte de carga en el departamento de Nariño, Colombia.

## Descripción

Trackariño es una aplicación integral diseñada para mejorar la eficiencia y seguridad del transporte de carga en Nariño. Conecta a contratistas con camioneros, facilitando la gestión de oportunidades logísticas, seguimiento en tiempo real, y mejorando la seguridad a través de un sistema de alertas.

## Estructura del Proyecto

El proyecto está organizado en dos componentes principales:

- **Backend**: API REST desarrollada con Node.js, Express y MongoDB
- **Frontend/App**: Aplicación móvil desarrollada con Flutter

## Características Principales

- **Autenticación y gestión de roles**: Sistema diferenciado para camioneros y contratistas
- **Gestión de cargas**: Publicación, asignación y seguimiento de oportunidades de transporte
- **Seguimiento GPS en tiempo real**: Monitoreo de ubicación de camioneros y cargas
- **Sistema de alertas de seguridad**: Notificación de incidentes en rutas (trancones, sospechas, robos)
- **Notificaciones push**: Sistema de comunicación en tiempo real
- **Panel para contratistas**: Gestión eficiente de cargas y camioneros

## Tecnologías Utilizadas

### Backend
- Node.js con Express
- MongoDB (base de datos)
- JWT para autenticación
- Firebase para notificaciones push
- APIs de geolocalización

### Aplicación Móvil
- Flutter (desarrollo multiplataforma)
- Provider (gestión de estado)
- Google Maps / Flutter Maps (visualización de mapas)
- Firebase Messaging (notificaciones)
- APIs REST para comunicación con el backend

## Instalación y Configuración

### Backend

1. Requisitos previos:
   - Node.js (v14 o superior)
   - MongoDB (v8.0.8 recomendado)

2. Instalación:
   ```bash
   cd Backend
   npm install
   ```

3. Configuración:
   - Crear archivo `.env` con las variables de entorno necesarias:
     ```
     PORT=4000
     MONGO_URI=mongodb://localhost:27017/tracknarino
     JWT_SECRET=tu_secreto_jwt
     ```

4. Ejecución:
   ```bash
   npm start
   ```
   El servidor se iniciará en http://localhost:4000

### Aplicación Móvil

1. Requisitos previos:
   - Flutter SDK (última versión estable)
   - Android Studio / Xcode para emuladores

2. Instalación:
   ```bash
   cd trackarino_app
   flutter pub get
   ```

3. Configuración:
   - Actualizar los endpoints de la API en el archivo de configuración (si es necesario)

4. Ejecución:
   ```bash
   flutter run
   ```

## Uso

La aplicación permite dos tipos de usuarios:

### Contratistas
- Publicar oportunidades de transporte
- Ver y asignar camioneros a cargas
- Monitorear ubicación de camiones en tiempo real
- Gestionar el proceso logístico completo

### Camioneros
- Ver oportunidades de transporte disponibles
- Aceptar cargas
- Reportar ubicación en tiempo real
- Crear y recibir alertas de seguridad

## Licencia

Este proyecto es de uso privado y está sujeto a los términos y condiciones establecidos por sus desarrolladores.

## Contacto

Para más información, contacte al equipo de desarrollo del proyecto Trackariño. 
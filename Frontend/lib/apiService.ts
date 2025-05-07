import { API_BASE_URL } from "./apiConfig";

export async function fetchUsers() {
  const response = await fetch(`${API_BASE_URL}/users`);
  if (!response.ok) {
    throw new Error("Error al obtener los usuarios");
  }
  return response.json();
}

export async function fetchAlerts() {
  const response = await fetch(`${API_BASE_URL}/alerts`);
  if (!response.ok) {
    throw new Error("Error al obtener las alertas");
  }
  return response.json();
}

interface UserData {
  nombre: string;
  correo: string;
  contraseña: string;
  tipoUsuario: string;
  telefono?: string;
  empresa?: string;
  empresaAfiliada?: string;
  licenciaExpedicion?: string;
  numeroCedula?: string;
  camion?: string;
  metodoPago?: string;
  disponibleParaSolicitarCamioneros?: boolean;
}

export async function createUser(userData: UserData) {
  const response = await fetch(`${API_BASE_URL}/registro`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(userData),
  });
  if (!response.ok) {
    throw new Error("Error al registrar el usuario");
  }
  return response.json();
}

export async function fetchAdminData() {
  const response = await fetch(`${API_BASE_URL}/admin`);
  if (!response.ok) {
    throw new Error("Error al obtener los datos de admin");
  }
  return response.json();
}

export async function loginUser(credentials: { email: string; password: string }) {
  const response = await fetch(`${API_BASE_URL}/auth/login`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(credentials),
  });
  if (!response.ok) {
    throw new Error("Error al iniciar sesión");
  }
  return response.json();
}

export async function fetchCalificaciones() {
  const response = await fetch(`${API_BASE_URL}/calificaciones`);
  if (!response.ok) {
    throw new Error("Error al obtener las calificaciones");
  }
  return response.json();
}

export async function fetchContratistas() {
  const response = await fetch(`${API_BASE_URL}/contratistas`);
  if (!response.ok) {
    throw new Error("Error al obtener los contratistas");
  }
  return response.json();
}

export async function fetchHistorial() {
  const response = await fetch(`${API_BASE_URL}/historial`);
  if (!response.ok) {
    throw new Error("Error al obtener el historial");
  }
  return response.json();
}

export async function fetchNotificaciones() {
  const response = await fetch(`${API_BASE_URL}/notificaciones`);
  if (!response.ok) {
    throw new Error("Error al obtener las notificaciones");
  }
  return response.json();
}

export async function fetchOportunidades() {
  const response = await fetch(`${API_BASE_URL}/oportunidades`);
  if (!response.ok) {
    throw new Error("Error al obtener las oportunidades");
  }
  return response.json();
}

export async function fetchOrs() {
  const response = await fetch(`${API_BASE_URL}/ors`);
  if (!response.ok) {
    throw new Error("Error al obtener los ORS");
  }
  return response.json();
}

export async function fetchUbicaciones() {
  const response = await fetch(`${API_BASE_URL}/ubicaciones`);
  if (!response.ok) {
    throw new Error("Error al obtener las ubicaciones");
  }
  return response.json();
}

export async function fetchVehiculos() {
  const response = await fetch(`${API_BASE_URL}/vehiculos`);
  if (!response.ok) {
    throw new Error("Error al obtener los vehículos");
  }
  return response.json();
}

// Tipos para los datos de las funciones
interface AlertaData {
  tipo: string;
  descripcion?: string;
  usuario: string;
  coords?: { lat: number; lng: number };
}

interface CalificacionData {
  usuario: string;
  tipoServicio: string;
  calificacion: number;
  comentario?: string;
}

interface OportunidadData {
  titulo: string;
  descripcion?: string;
  origen: string;
  destino: string;
  fecha: string;
  precio: number;
  estado?: string;
  contratista: string;
  camioneroAsignado?: string;
}

interface UbicacionData {
  camionero: string;
  coords: { lat: number; lng: number };
}

interface VehiculoData {
  camioneroId: string;
  tipoVehiculo: string;
  capacidadCarga: number;
  marca: string;
  modelo: string;
  placa: string;
  papelesAlDia: boolean;
}

// Función para crear una alerta de seguridad
export async function createAlertaSeguridad(alertaData: AlertaData) {
  const response = await fetch(`${API_BASE_URL}/alertas`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(alertaData),
  });
  if (!response.ok) {
    throw new Error("Error al crear la alerta de seguridad");
  }
  return response.json();
}

// Función para calificar un servicio
export async function createCalificacion(calificacionData: CalificacionData) {
  const response = await fetch(`${API_BASE_URL}/calificaciones`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(calificacionData),
  });
  if (!response.ok) {
    throw new Error("Error al crear la calificación");
  }
  return response.json();
}

// Función para crear una oportunidad
export async function createOportunidad(oportunidadData: OportunidadData) {
  const response = await fetch(`${API_BASE_URL}/oportunidades`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(oportunidadData),
  });
  if (!response.ok) {
    throw new Error("Error al crear la oportunidad");
  }
  return response.json();
}

// Función para registrar una ubicación
export async function createUbicacion(ubicacionData: UbicacionData) {
  const response = await fetch(`${API_BASE_URL}/ubicaciones`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(ubicacionData),
  });
  if (!response.ok) {
    throw new Error("Error al registrar la ubicación");
  }
  return response.json();
}

// Función para registrar un vehículo
export async function createVehiculo(vehiculoData: VehiculoData) {
  const response = await fetch(`${API_BASE_URL}/vehiculos`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(vehiculoData),
  });
  if (!response.ok) {
    throw new Error("Error al registrar el vehículo");
  }
  return response.json();
}
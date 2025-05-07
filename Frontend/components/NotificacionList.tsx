import { useState, useEffect } from "react";
import { fetchNotificaciones } from "../lib/apiService";

interface Notificacion {
  id: string;
  mensaje: string;
}

export default function NotificacionList() {
  const [notificaciones, setNotificaciones] = useState<Notificacion[]>([]);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    const getNotificaciones = async () => {
      try {
        const data = await fetchNotificaciones();
        setNotificaciones(data);
      } catch (err) {
        if (err instanceof Error) {
          setError(err);
        }
      }
    };

    getNotificaciones();
  }, []);

  if (error) {
    return <div>Error al cargar las notificaciones: {error.message}</div>;
  }

  return (
    <div>
      <h1>Lista de Notificaciones</h1>
      <ul>
        {notificaciones.map((notificacion) => (
          <li key={notificacion.id}>{notificacion.mensaje}</li>
        ))}
      </ul>
    </div>
  );
}
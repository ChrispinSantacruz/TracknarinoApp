import { useState, useEffect } from "react";
import { fetchUbicaciones } from "../lib/apiService";

interface Ubicacion {
  id: string;
  nombre: string;
}

export default function UbicacionList() {
  const [ubicaciones, setUbicaciones] = useState<Ubicacion[]>([]);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    const getUbicaciones = async () => {
      try {
        const data = await fetchUbicaciones();
        setUbicaciones(data);
      } catch (err) {
        if (err instanceof Error) {
          setError(err);
        }
      }
    };

    getUbicaciones();
  }, []);

  if (error) {
    return <div>Error al cargar las ubicaciones: {error.message}</div>;
  }

  return (
    <div>
      <h1>Lista de Ubicaciones</h1>
      <ul>
        {ubicaciones.map((ubicacion) => (
          <li key={ubicacion.id}>{ubicacion.nombre}</li>
        ))}
      </ul>
    </div>
  );
}
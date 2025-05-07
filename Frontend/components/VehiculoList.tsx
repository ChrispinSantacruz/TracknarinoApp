import { useState, useEffect } from "react";
import { fetchVehiculos } from "../lib/apiService";

interface Vehiculo {
  id: string;
  nombre: string;
}

export default function VehiculoList() {
  const [vehiculos, setVehiculos] = useState<Vehiculo[]>([]);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    const getVehiculos = async () => {
      try {
        const data = await fetchVehiculos();
        setVehiculos(data);
      } catch (err) {
        if (err instanceof Error) {
          setError(err);
        }
      }
    };

    getVehiculos();
  }, []);

  if (error) {
    return <div>Error al cargar los vehículos: {error.message}</div>;
  }

  return (
    <div>
      <h1>Lista de Vehículos</h1>
      <ul>
        {vehiculos.map((vehiculo) => (
          <li key={vehiculo.id}>{vehiculo.nombre}</li>
        ))}
      </ul>
    </div>
  );
}
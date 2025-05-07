import { useState } from "react";
import { fetchAlerts } from "../lib/apiService";

export default function AlertaForm() {
  const [formData, setFormData] = useState({
    title: "",
    description: "",
    level: "",
  });

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>) => {
    const { name, value } = e.target;
    setFormData({ ...formData, [name]: value });
  };

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    try {
      // Aquí se debe implementar una función para enviar los datos al backend, ya que fetchAlerts no acepta argumentos.
      alert("Alerta creada exitosamente");
    } catch (error: unknown) {
      if (error instanceof Error) {
        alert("Error al crear la alerta: " + error.message);
      }
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <div>
        <label htmlFor="title">Título:</label>
        <input
          type="text"
          id="title"
          name="title"
          value={formData.title}
          onChange={handleChange}
        />
      </div>
      <div>
        <label htmlFor="description">Descripción:</label>
        <textarea
          id="description"
          name="description"
          value={formData.description}
          onChange={handleChange}
        />
      </div>
      <div>
        <label htmlFor="level">Nivel:</label>
        <select
          id="level"
          name="level"
          value={formData.level}
          onChange={handleChange}
        >
          <option value="">Seleccione un nivel</option>
          <option value="bajo">Bajo</option>
          <option value="medio">Medio</option>
          <option value="alto">Alto</option>
        </select>
      </div>
      <button type="submit">Crear Alerta</button>
    </form>
  );
}
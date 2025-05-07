import { useState } from "react";
import { createUser } from "../lib/apiService";

export default function UserForm() {
  const [formData, setFormData] = useState({
    nombre: "",
    correo: "",
    contraseña: "",
    tipoUsuario: "camionero", // Valor predeterminado
    telefono: "",
    empresa: "",
    empresaAfiliada: "",
    licenciaExpedicion: "",
    numeroCedula: "",
    camion: "",
    metodoPago: "",
    disponibleParaSolicitarCamioneros: false,
  });

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement | HTMLTextAreaElement>) => {
    const { name, value, type, checked } = e.target as HTMLInputElement;
    setFormData({
      ...formData,
      [name]: type === "checkbox" ? checked : value,
    });
  };

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    try {
      const response = await createUser({
        nombre: formData.nombre,
        correo: formData.correo,
        contraseña: formData.contraseña,
        tipoUsuario: formData.tipoUsuario,
        telefono: formData.telefono,
        empresa: formData.empresa,
        empresaAfiliada: formData.empresaAfiliada,
        licenciaExpedicion: formData.licenciaExpedicion,
        numeroCedula: formData.numeroCedula,
        camion: formData.camion,
        metodoPago: formData.metodoPago,
        disponibleParaSolicitarCamioneros: formData.disponibleParaSolicitarCamioneros,
      });
      alert("Usuario creado exitosamente: " + JSON.stringify(response));
    } catch (error: unknown) {
      if (error instanceof Error) {
        alert("Error al crear el usuario: " + error.message);
      }
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <div>
        <label htmlFor="nombre">Nombre:</label>
        <input
          type="text"
          id="nombre"
          name="nombre"
          value={formData.nombre}
          onChange={handleChange}
        />
      </div>
      <div>
        <label htmlFor="correo">Correo Electrónico:</label>
        <input
          type="email"
          id="correo"
          name="correo"
          value={formData.correo}
          onChange={handleChange}
        />
      </div>
      <div>
        <label htmlFor="contraseña">Contraseña:</label>
        <input
          type="password"
          id="contraseña"
          name="contraseña"
          value={formData.contraseña}
          onChange={handleChange}
        />
      </div>
      <div>
        <label htmlFor="tipoUsuario">Tipo de Usuario:</label>
        <select
          id="tipoUsuario"
          name="tipoUsuario"
          value={formData.tipoUsuario}
          onChange={handleChange}
        >
          <option value="camionero">Camionero</option>
          <option value="empresa">Empresa</option>
        </select>
      </div>
      <div>
        <label htmlFor="telefono">Teléfono:</label>
        <input
          type="text"
          id="telefono"
          name="telefono"
          value={formData.telefono}
          onChange={handleChange}
        />
      </div>
      <div>
        <label htmlFor="empresa">Empresa:</label>
        <input
          type="text"
          id="empresa"
          name="empresa"
          value={formData.empresa}
          onChange={handleChange}
        />
      </div>
      <div>
        <label htmlFor="empresaAfiliada">Empresa Afiliada:</label>
        <input
          type="text"
          id="empresaAfiliada"
          name="empresaAfiliada"
          value={formData.empresaAfiliada}
          onChange={handleChange}
        />
      </div>
      <div>
        <label htmlFor="licenciaExpedicion">Licencia de Expedición:</label>
        <input
          type="text"
          id="licenciaExpedicion"
          name="licenciaExpedicion"
          value={formData.licenciaExpedicion}
          onChange={handleChange}
        />
      </div>
      <div>
        <label htmlFor="numeroCedula">Número de Cédula:</label>
        <input
          type="text"
          id="numeroCedula"
          name="numeroCedula"
          value={formData.numeroCedula}
          onChange={handleChange}
        />
      </div>
      <div>
        <label htmlFor="camion">Camión:</label>
        <input
          type="text"
          id="camion"
          name="camion"
          value={formData.camion}
          onChange={handleChange}
        />
      </div>
      <div>
        <label htmlFor="metodoPago">Método de Pago:</label>
        <input
          type="text"
          id="metodoPago"
          name="metodoPago"
          value={formData.metodoPago}
          onChange={handleChange}
        />
      </div>
      <div>
        <label htmlFor="disponibleParaSolicitarCamioneros">
          Disponible para Solicitar Camioneros:
        </label>
        <input
          type="checkbox"
          id="disponibleParaSolicitarCamioneros"
          name="disponibleParaSolicitarCamioneros"
          checked={formData.disponibleParaSolicitarCamioneros}
          onChange={handleChange}
        />
      </div>
      <button type="submit">Crear Usuario</button>
    </form>
  );
}
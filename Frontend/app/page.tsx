"use client"

import type React from "react"

import { useState } from "react"
import { useRouter } from "next/navigation"
import { Truck, Building2 } from "lucide-react"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card"
import { Label } from "@/components/ui/label"
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group"

export default function LoginPage() {
  const router = useRouter()
  const [isLoading, setIsLoading] = useState<boolean>(false)
  const [email, setEmail] = useState("")
  const [password, setPassword] = useState("")
  const [userType, setUserType] = useState("camionero")

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);

    try {
      const response = await fetch("http://localhost:4000/api/auth/login", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ correo: email, contraseña: password }),
      });

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.mensaje || "Error al iniciar sesión");
      }

      const { token, usuario } = await response.json();

      // Guardar información del usuario en localStorage
      localStorage.setItem(
        "user",
        JSON.stringify({
          id: usuario._id,
          name: usuario.nombre,
          email: usuario.correo,
          userType: usuario.tipoUsuario,
          showProfileOnLogin: true,
        })
      );

      // Redirigir al dashboard
      router.push("/dashboard");
    } catch (error: any) {
      alert(error.message);
    } finally {
      setIsLoading(false);
    }
  };

  const handleRegister = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);

    const nameInput = document.getElementById("name") as HTMLInputElement;
    const emailInput = document.getElementById("register-email") as HTMLInputElement;
    const phoneInput = document.getElementById("phone") as HTMLInputElement;
    const passwordInput = document.getElementById("register-password") as HTMLInputElement;
    const empresaAfiliadaInput = document.getElementById("empresaAfiliada") as HTMLInputElement;
    const licenciaExpedicionInput = document.getElementById("licenciaExpedicion") as HTMLInputElement;
    const numeroCedulaInput = document.getElementById("numeroCedula") as HTMLInputElement;
    const tipoVehiculoInput = document.getElementById("tipoVehiculo") as HTMLInputElement;
    const capacidadCargaInput = document.getElementById("capacidadCarga") as HTMLInputElement;
    const marcaInput = document.getElementById("marca") as HTMLInputElement;
    const modeloInput = document.getElementById("modelo") as HTMLInputElement;
    const placaInput = document.getElementById("placa") as HTMLInputElement;
    const papelesAlDiaInput = document.getElementById("papelesAlDia") as HTMLInputElement;

    const userData = {
      nombre: nameInput.value,
      correo: emailInput.value,
      contraseña: passwordInput.value,
      tipoUsuario: userType,
      telefono: phoneInput.value,
      empresaAfiliada: empresaAfiliadaInput.value,
      licenciaExpedicion: licenciaExpedicionInput.value,
      numeroCedula: numeroCedulaInput.value,
      camion: {
        tipoVehiculo: tipoVehiculoInput.value,
        capacidadCarga: parseInt(capacidadCargaInput.value, 10),
        marca: marcaInput.value,
        modelo: modeloInput.value,
        placa: placaInput.value,
        papelesAlDia: papelesAlDiaInput.checked,
      },
    };

    try {
      const response = await fetch("http://localhost:4000/api/auth/registro", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(userData),
      });

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.error || "Error al registrar usuario");
      }

      alert("Registro exitoso. Por favor inicia sesión.");
      router.push("/dashboard");
    } catch (error: any) {
      alert(error.message);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex flex-col items-center justify-center bg-gradient-to-b from-green-100 to-green-50 p-4">
      <div className="flex flex-col items-center mb-8">
        <div className="flex items-center gap-2">
          <Truck className="h-10 w-10 text-green-600" />
          <h1 className="text-3xl font-bold text-green-800">TRACKNARIÑO</h1>
        </div>
        <p className="text-green-700 mt-2">Conectando caminos en Nariño y Colombia</p>
      </div>

      <Tabs defaultValue="login" className="w-full max-w-md">
        <TabsList className="grid w-full grid-cols-2 mb-4">
          <TabsTrigger value="login">Iniciar Sesión</TabsTrigger>
          <TabsTrigger value="register">Registrarse</TabsTrigger>
        </TabsList>

        <TabsContent value="login">
          <Card>
            <CardHeader>
              <CardTitle>Iniciar Sesión</CardTitle>
              <CardDescription>Ingresa tus credenciales para acceder a tu cuenta</CardDescription>
            </CardHeader>
            <form onSubmit={handleLogin}>
              <CardContent className="space-y-4">
                <div className="space-y-2">
                  <Label>Tipo de Usuario</Label>
                  <RadioGroup
                    defaultValue="camionero"
                    className="flex gap-4"
                    value={userType}
                    onValueChange={setUserType}
                  >
                    <div className="flex items-center space-x-2">
                      <RadioGroupItem value="camionero" id="camionero" />
                      <Label htmlFor="camionero" className="flex items-center gap-1">
                        <Truck className="h-4 w-4" /> Camionero
                      </Label>
                    </div>
                    <div className="flex items-center space-x-2">
                      <RadioGroupItem value="contratista" id="contratista" />
                      <Label htmlFor="contratista" className="flex items-center gap-1">
                        <Building2 className="h-4 w-4" /> Contratista
                      </Label>
                    </div>
                  </RadioGroup>
                </div>

                <div className="space-y-2">
                  <Label htmlFor="email">Correo Electrónico</Label>
                  <Input
                    id="email"
                    type="email"
                    placeholder="correo@ejemplo.com"
                    required
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                  />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="password">Contraseña</Label>
                  <Input
                    id="password"
                    type="password"
                    required
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                  />
                </div>
                <div className="text-sm text-right">
                  <a href="#" className="text-green-600 hover:text-green-800">
                    ¿Olvidaste tu contraseña?
                  </a>
                </div>
              </CardContent>
              <CardFooter>
                <Button type="submit" className="w-full bg-green-600 hover:bg-green-700" disabled={isLoading}>
                  {isLoading ? "Cargando..." : "Iniciar Sesión"}
                </Button>
              </CardFooter>
            </form>
          </Card>
        </TabsContent>

        <TabsContent value="register">
          <Card>
            <CardHeader>
              <CardTitle>Crear Cuenta</CardTitle>
              <CardDescription>Regístrate para comenzar a usar la aplicación</CardDescription>
            </CardHeader>
            <form onSubmit={handleRegister}>
              <CardContent className="space-y-4">
                <div className="space-y-2">
                  <Label>Tipo de Usuario</Label>
                  <RadioGroup defaultValue="camionero" className="flex gap-4">
                    <div className="flex items-center space-x-2">
                      <RadioGroupItem value="camionero" id="reg-camionero" />
                      <Label htmlFor="reg-camionero" className="flex items-center gap-1">
                        <Truck className="h-4 w-4" /> Camionero
                      </Label>
                    </div>
                    <div className="flex items-center space-x-2">
                      <RadioGroupItem value="contratista" id="reg-contratista" />
                      <Label htmlFor="reg-contratista" className="flex items-center gap-1">
                        <Building2 className="h-4 w-4" /> Contratista
                      </Label>
                    </div>
                  </RadioGroup>
                </div>

                <div className="space-y-2">
                  <Label htmlFor="name">{userType === "camionero" ? "Nombre Completo" : "Nombre de la Empresa"}</Label>
                  <Input
                    id="name"
                    placeholder={userType === "camionero" ? "Juan Pérez" : "Transportes S.A."}
                    required
                  />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="register-email">Correo Electrónico</Label>
                  <Input id="register-email" type="email" placeholder="correo@ejemplo.com" required />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="phone">Teléfono</Label>
                  <Input id="phone" type="tel" placeholder="+57 300 123 4567" required />
                </div>
                {userType === "camionero" && (
                  <>
                    <div className="space-y-2">
                      <Label htmlFor="empresaAfiliada">Empresa Afiliada</Label>
                      <Input id="empresaAfiliada" placeholder="Transportes Nariño S.A." required />
                    </div>
                    <div className="space-y-2">
                      <Label htmlFor="licenciaExpedicion">Fecha de Expedición de Licencia</Label>
                      <Input id="licenciaExpedicion" type="date" required />
                    </div>
                    <div className="space-y-2">
                      <Label htmlFor="numeroCedula">Número de Cédula</Label>
                      <Input id="numeroCedula" placeholder="1234567890" required />
                    </div>
                    <div className="space-y-2">
                      <Label htmlFor="tipoVehiculo">Tipo de Vehículo</Label>
                      <Input id="tipoVehiculo" placeholder="Camión de Carga" required />
                    </div>
                    <div className="space-y-2">
                      <Label htmlFor="capacidadCarga">Capacidad de Carga (kg)</Label>
                      <Input id="capacidadCarga" type="number" placeholder="10000" required />
                    </div>
                    <div className="space-y-2">
                      <Label htmlFor="marca">Marca</Label>
                      <Input id="marca" placeholder="Volvo" required />
                    </div>
                    <div className="space-y-2">
                      <Label htmlFor="modelo">Modelo</Label>
                      <Input id="modelo" placeholder="FH16" required />
                    </div>
                    <div className="space-y-2">
                      <Label htmlFor="placa">Placa</Label>
                      <Input id="placa" placeholder="ABC-123" required />
                    </div>
                    <div className="space-y-2">
                      <Label htmlFor="papelesAlDia">Papeles al Día</Label>
                      <Input id="papelesAlDia" type="checkbox" />
                    </div>
                  </>
                )}
                {userType === "contratista" && (
                  <div className="space-y-2">
                    <Label htmlFor="nit">NIT</Label>
                    <Input id="nit" placeholder="900.123.456-7" required />
                  </div>
                )}
                <div className="space-y-2">
                  <Label htmlFor="register-password">Contraseña</Label>
                  <Input id="register-password" type="password" required />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="confirm-password">Confirmar Contraseña</Label>
                  <Input id="confirm-password" type="password" required />
                </div>
              </CardContent>
              <CardFooter>
                <Button type="submit" className="w-full bg-green-600 hover:bg-green-700" disabled={isLoading}>
                  {isLoading ? "Procesando..." : "Registrarse"}
                </Button>
              </CardFooter>
            </form>
          </Card>
        </TabsContent>
      </Tabs>
    </div>
  )
}

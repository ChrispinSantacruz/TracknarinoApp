"use client"

import { useState, useEffect } from "react"
import {
  Bell,
  Map,
  Package,
  Truck,
  User,
  AlertTriangle,
  Search,
  MapPin,
  Calendar,
  DollarSign,
  Building2,
  Plus,
  CreditCard,
  Banknote,
  Landmark,
  Smartphone,
} from "lucide-react"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
  DialogFooter,
} from "@/components/ui/dialog"
import { Input } from "@/components/ui/input"
import { Badge } from "@/components/ui/badge"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Textarea } from "@/components/ui/textarea"
import { Label } from "@/components/ui/label"
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group"

// Datos de ejemplo para las ofertas de viajes
const tripOffers = [
  {
    id: "1",
    origin: "Pasto",
    destination: "Ipiales",
    date: "15 Mayo, 2023",
    price: 800000,
    distance: 82,
    cargo: "Mercancía general",
    weight: "8 toneladas",
    client: "Transportes Nariño S.A.",
    urgency: "normal",
    paymentMethods: ["Transferencia bancaria", "Nequi", "Efectivo"],
    description:
      "Transporte de mercancía general desde Pasto hasta Ipiales. Se requiere camión con capacidad de 8 toneladas.",
  },
  {
    id: "2",
    origin: "Tumaco",
    destination: "Pasto",
    date: "18 Mayo, 2023",
    price: 1200000,
    distance: 300,
    cargo: "Productos del mar",
    weight: "5 toneladas",
    client: "Mariscos del Pacífico",
    urgency: "alta",
    paymentMethods: ["PSE", "Nequi"],
    description:
      "Transporte urgente de productos del mar refrigerados. Se requiere camión con sistema de refrigeración.",
  },
  {
    id: "3",
    origin: "Pasto",
    destination: "Cali",
    date: "20 Mayo, 2023",
    price: 1500000,
    distance: 380,
    cargo: "Materiales de construcción",
    weight: "10 toneladas",
    client: "Constructora Andina",
    urgency: "normal",
    paymentMethods: ["Transferencia bancaria", "Efectivo"],
    description: "Transporte de materiales de construcción. Carga y descarga por cuenta del contratista.",
  },
  {
    id: "4",
    origin: "Ipiales",
    destination: "Popayán",
    date: "22 Mayo, 2023",
    price: 1350000,
    distance: 410,
    cargo: "Productos electrónicos",
    weight: "3 toneladas",
    client: "Electro Import",
    urgency: "baja",
    paymentMethods: ["Transferencia bancaria", "PSE"],
    description: "Transporte de productos electrónicos importados. Se requiere manejo cuidadoso de la carga.",
  },
  {
    id: "5",
    origin: "Pasto",
    destination: "Popayán",
    date: "25 Mayo, 2023",
    price: 900000,
    distance: 290,
    cargo: "Textiles",
    weight: "6 toneladas",
    client: "Textiles del Sur",
    urgency: "alta",
    paymentMethods: ["Nequi", "Daviplata"],
    description: "Transporte urgente de textiles. Se paga 50% al cargar y 50% al entregar.",
  },
]

export default function Dashboard() {
  const [activeTab, setActiveTab] = useState("map")
  const [showProfileDialog, setShowProfileDialog] = useState(false)
  const [user, setUser] = useState<any>(null)
  const [searchTerm, setSearchTerm] = useState("")
  const [filteredOffers, setFilteredOffers] = useState(tripOffers)
  const [selectedOffer, setSelectedOffer] = useState<any>(null)
  const [showOfferDetails, setShowOfferDetails] = useState(false)
  const [filterType, setFilterType] = useState("all")
  const [showNewOfferDialog, setShowNewOfferDialog] = useState(false)
  const [newOffer, setNewOffer] = useState({
    origin: "",
    destination: "",
    date: "",
    price: "",
    cargo: "",
    weight: "",
    description: "",
    urgency: "normal",
    paymentMethods: ["Transferencia bancaria"],
  })

  useEffect(() => {
    // Verificar si hay un usuario en localStorage
    const storedUser = localStorage.getItem("user");
    if (storedUser) {
      const parsedUser = JSON.parse(storedUser);
      setUser(parsedUser);

      // Mostrar el perfil al iniciar sesión si es la primera vez
      if (parsedUser.showProfileOnLogin) {
        setShowProfileDialog(true);
        // Actualizar el flag para que no se muestre de nuevo
        parsedUser.showProfileOnLogin = false;
        localStorage.setItem("user", JSON.stringify(parsedUser));
      }
    }
  }, []);

  useEffect(() => {
    // Filtrar ofertas según el término de búsqueda y el tipo de filtro
    let filtered = tripOffers

    if (searchTerm) {
      filtered = filtered.filter(
        (offer) =>
          offer.origin.toLowerCase().includes(searchTerm.toLowerCase()) ||
          offer.destination.toLowerCase().includes(searchTerm.toLowerCase()) ||
          offer.cargo.toLowerCase().includes(searchTerm.toLowerCase()),
      )
    }

    if (filterType !== "all") {
      filtered = filtered.filter((offer) => offer.urgency === filterType)
    }

    setFilteredOffers(filtered)
  }, [searchTerm, filterType])

  const handleViewOfferDetails = (offer: any) => {
    setSelectedOffer(offer)
    setShowOfferDetails(true)
  }

  const handleCreateOffer = () => {
    // Aquí iría la lógica para crear una nueva oferta
    alert("Oferta creada con éxito")
    setShowNewOfferDialog(false)
    // Reiniciar el formulario
    setNewOffer({
      origin: "",
      destination: "",
      date: "",
      price: "",
      cargo: "",
      weight: "",
      description: "",
      urgency: "normal",
      paymentMethods: ["Transferencia bancaria"],
    })
  }

  const handlePaymentMethodChange = (method: string) => {
    if (newOffer.paymentMethods.includes(method)) {
      setNewOffer({
        ...newOffer,
        paymentMethods: newOffer.paymentMethods.filter((m) => m !== method),
      })
    } else {
      setNewOffer({
        ...newOffer,
        paymentMethods: [...newOffer.paymentMethods, method],
      })
    }
  }

  const handleLogout = () => {
    localStorage.removeItem("user");
    window.location.href = "/"; // Redirigir a la página de inicio de sesión
  };

  // Determinar si el usuario es camionero o contratista
  const isContratista = user?.userType === "contratista"

  return (
    <div className="flex flex-col h-screen bg-gray-100">
      {/* Header */}
      <header className="bg-green-600 text-white p-4 shadow-md">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <Truck className="h-6 w-6" />
            <h1 className="text-xl font-bold">TRACKNARIÑO</h1>
          </div>
          <div className="flex items-center gap-4">
            {user && <span className="text-sm">Bienvenido, {user.name}</span>}
            <Button
              variant="ghost"
              className="text-white hover:bg-green-700"
              onClick={handleLogout}
            >
              Cerrar Sesión
            </Button>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="flex-1 overflow-auto p-4">
        {activeTab === "map" && (
          <div className="h-full flex flex-col gap-4">
            <Card className="flex-1 min-h-[300px] relative">
              <CardHeader className="p-3">
                <CardTitle className="text-lg">Mapa en Tiempo Real</CardTitle>
              </CardHeader>
              <CardContent className="p-0 h-full">
                <div className="bg-gray-200 h-full flex items-center justify-center">
                  <div className="text-center">
                    <Map className="h-12 w-12 mx-auto text-gray-400 mb-2" />
                    <p>Mapa con rutas y alertas</p>
                    <p className="text-sm text-gray-500">Se mostraría aquí el mapa interactivo de Nariño</p>
                  </div>
                </div>
              </CardContent>
            </Card>

            <div className="grid grid-cols-2 gap-4">
              <Card>
                <CardHeader className="p-3">
                  <CardTitle className="text-sm">Alertas Activas</CardTitle>
                </CardHeader>
                <CardContent className="p-3">
                  <div className="flex items-center gap-2 text-orange-500">
                    <AlertTriangle className="h-5 w-5" />
                    <span className="text-sm">Bloqueo en vía Pasto-Ipiales</span>
                  </div>
                </CardContent>
              </Card>

              <Card>
                <CardHeader className="p-3">
                  <CardTitle className="text-sm">Estado de la Vía</CardTitle>
                </CardHeader>
                <CardContent className="p-3">
                  <Button size="sm" variant="outline" className="w-full text-sm">
                    Reportar Problema
                  </Button>
                </CardContent>
              </Card>
            </div>
          </div>
        )}

        {activeTab === "loads" && (
          <div className="space-y-4">
            <Card>
              <CardHeader className="flex flex-row items-center justify-between">
                <CardTitle>{isContratista ? "Gestión de Viajes" : "Buscar Ofertas de Viajes"}</CardTitle>
                {isContratista && (
                  <Button onClick={() => setShowNewOfferDialog(true)}>
                    <Plus className="h-4 w-4 mr-1" /> Nuevo Viaje
                  </Button>
                )}
              </CardHeader>
              <CardContent>
                <div className="flex flex-col md:flex-row gap-4">
                  <div className="relative flex-1">
                    <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
                    <Input
                      placeholder="Buscar por origen, destino o tipo de carga..."
                      className="pl-8"
                      value={searchTerm}
                      onChange={(e) => setSearchTerm(e.target.value)}
                    />
                  </div>
                  <Select value={filterType} onValueChange={setFilterType}>
                    <SelectTrigger className="w-full md:w-[180px]">
                      <SelectValue placeholder="Filtrar por urgencia" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="all">Todas las ofertas</SelectItem>
                      <SelectItem value="alta">Urgencia alta</SelectItem>
                      <SelectItem value="normal">Urgencia normal</SelectItem>
                      <SelectItem value="baja">Urgencia baja</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
              </CardContent>
            </Card>

            <div className="grid gap-4">
              {filteredOffers.length > 0 ? (
                filteredOffers.map((offer) => (
                  <Card key={offer.id} className="overflow-hidden">
                    <div className="border-l-4 border-green-500 h-full">
                      <CardContent className="p-4">
                        <div className="flex flex-col md:flex-row justify-between">
                          <div className="space-y-2">
                            <div className="flex items-center gap-2">
                              <MapPin className="h-4 w-4 text-green-500" />
                              <span className="font-medium">
                                {offer.origin} → {offer.destination}
                              </span>
                              {offer.urgency === "alta" && <Badge className="bg-red-500">Urgente</Badge>}
                            </div>
                            <div className="flex items-center gap-4 text-sm text-gray-500">
                              <div className="flex items-center gap-1">
                                <Calendar className="h-4 w-4" />
                                <span>{offer.date}</span>
                              </div>
                              <div className="flex items-center gap-1">
                                <Truck className="h-4 w-4" />
                                <span>{offer.weight}</span>
                              </div>
                            </div>
                            <div className="text-sm">
                              <span className="text-gray-500">Carga:</span> {offer.cargo}
                            </div>
                            <div className="text-sm flex flex-wrap gap-1 mt-1">
                              {offer.paymentMethods.map((method, index) => (
                                <Badge key={index} variant="outline" className="bg-gray-100">
                                  {method === "Transferencia bancaria" && <Landmark className="h-3 w-3 mr-1" />}
                                  {method === "Nequi" && <Smartphone className="h-3 w-3 mr-1" />}
                                  {method === "PSE" && <CreditCard className="h-3 w-3 mr-1" />}
                                  {method === "Efectivo" && <Banknote className="h-3 w-3 mr-1" />}
                                  {method === "Daviplata" && <Smartphone className="h-3 w-3 mr-1" />}
                                  {method}
                                </Badge>
                              ))}
                            </div>
                          </div>
                          <div className="mt-4 md:mt-0 text-right">
                            <div className="flex items-center justify-end gap-1 font-bold text-lg">
                              <DollarSign className="h-5 w-5 text-green-500" />
                              <span>${offer.price.toLocaleString()}</span>
                            </div>
                            <div className="text-sm text-gray-500">{offer.distance} km</div>
                            <Button
                              size="sm"
                              className="mt-2 bg-green-600 hover:bg-green-700"
                              onClick={() => handleViewOfferDetails(offer)}
                            >
                              {isContratista ? "Editar" : "Ver Detalles"}
                            </Button>
                          </div>
                        </div>
                      </CardContent>
                    </div>
                  </Card>
                ))
              ) : (
                <div className="text-center p-8 bg-white rounded-lg border">
                  <Package className="h-12 w-12 mx-auto text-gray-300 mb-2" />
                  <h3 className="text-lg font-medium">No se encontraron ofertas</h3>
                  <p className="text-gray-500">Intenta con otros términos de búsqueda o filtros</p>
                </div>
              )}
            </div>
          </div>
        )}

        {activeTab === "profile" && (
          <Card>
            <CardHeader>
              <CardTitle>{isContratista ? "Perfil de la Empresa" : "Perfil del Transportista"}</CardTitle>
            </CardHeader>
            <CardContent>
              {user && (
                <>
                  <div className="flex flex-col items-center mb-6">
                    <div className="w-20 h-20 bg-gray-300 rounded-full flex items-center justify-center mb-2">
                      {isContratista ? (
                        <Building2 className="h-10 w-10 text-gray-500" />
                      ) : (
                        <User className="h-10 w-10 text-gray-500" />
                      )}
                    </div>
                    <h2 className="text-xl font-bold">{user.name}</h2>
                    <p className="text-gray-500">
                      {isContratista ? `Empresa contratista desde ${user.since}` : `Transportista desde ${user.since}`}
                    </p>
                  </div>

                  <div className="space-y-4">
                    <div className="border rounded-lg p-3">
                      <h3 className="font-medium mb-2">Estadísticas</h3>
                      <div className="grid grid-cols-2 gap-2 text-sm">
                        {isContratista ? (
                          <>
                            <div>
                              <p className="text-gray-500">Viajes Publicados</p>
                              <p className="font-bold">{user.tripsPublished}</p>
                            </div>
                            <div>
                              <p className="text-gray-500">Viajes Completados</p>
                              <p className="font-bold">{user.tripsCompleted}</p>
                            </div>
                            <div>
                              <p className="text-gray-500">Calificación</p>
                              <p className="font-bold">{user.rating}/5.0</p>
                            </div>
                            <div>
                              <p className="text-gray-500">Tasa de Éxito</p>
                              <p className="font-bold">
                                {Math.round((user.tripsCompleted / user.tripsPublished) * 100)}%
                              </p>
                            </div>
                          </>
                        ) : (
                          <>
                            <div>
                              <p className="text-gray-500">Viajes Completados</p>
                              <p className="font-bold">{user.trips}</p>
                            </div>
                            <div>
                              <p className="text-gray-500">Calificación</p>
                              <p className="font-bold">{user.rating}/5.0</p>
                            </div>
                            <div>
                              <p className="text-gray-500">Km Recorridos</p>
                              <p className="font-bold">{user.kilometers.toLocaleString()}</p>
                            </div>
                            <div>
                              <p className="text-gray-500">Cargas Entregadas</p>
                              <p className="font-bold">{user.deliveries}</p>
                            </div>
                          </>
                        )}
                      </div>
                    </div>

                    {isContratista ? (
                      <div className="border rounded-lg p-3">
                        <h3 className="font-medium mb-2">Información de la Empresa</h3>
                        <div className="text-sm">
                          <p>
                            <span className="text-gray-500">Nombre:</span> {user.company.name}
                          </p>
                          <p>
                            <span className="text-gray-500">NIT:</span> {user.company.nit}
                          </p>
                          <p>
                            <span className="text-gray-500">Dirección:</span> {user.company.address}
                          </p>
                        </div>
                      </div>
                    ) : (
                      <div className="border rounded-lg p-3">
                        <h3 className="font-medium mb-2">Vehículo</h3>
                        <div className="text-sm">
                          <p>
                            <span className="text-gray-500">Tipo:</span> {user.vehicle.type}
                          </p>
                          <p>
                            <span className="text-gray-500">Placa:</span> {user.vehicle.plate}
                          </p>
                          <p>
                            <span className="text-gray-500">Capacidad:</span> {user.vehicle.capacity}
                          </p>
                        </div>
                      </div>
                    )}

                    <div className="border rounded-lg p-3">
                      <h3 className="font-medium mb-2">Información de Contacto</h3>
                      <div className="text-sm">
                        <p>
                          <span className="text-gray-500">Email:</span> {user.email}
                        </p>
                        <p>
                          <span className="text-gray-500">Teléfono:</span> {user.phone}
                        </p>
                      </div>
                    </div>
                  </div>
                </>
              )}
            </CardContent>
          </Card>
        )}

        {activeTab === "notifications" && (
          <Card>
            <CardHeader>
              <CardTitle>Notificaciones</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                {[1, 2, 3].map((item) => (
                  <div key={item} className="border-b pb-3 last:border-0">
                    <div className="flex gap-3">
                      <div className="bg-orange-100 p-2 rounded-full">
                        <AlertTriangle className="h-5 w-5 text-orange-500" />
                      </div>
                      <div>
                        <h3 className="font-medium">Alerta de Bloqueo</h3>
                        <p className="text-sm text-gray-500">Bloqueo reportado en la vía Pasto-Ipiales km 40</p>
                        <p className="text-xs text-gray-400">Hace 2 horas</p>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>
        )}
      </main>

      {/* Diálogo de Perfil */}
      {user && (
        <Dialog open={showProfileDialog} onOpenChange={setShowProfileDialog}>
          <DialogContent className="sm:max-w-[425px]">
            <DialogHeader>
              <DialogTitle>Bienvenido, {user.name}</DialogTitle>
              <DialogDescription>
                {isContratista ? "Información de tu empresa contratista" : "Información de tu perfil de transportista"}
              </DialogDescription>
            </DialogHeader>
            <div className="flex flex-col items-center py-4">
              <div className="w-24 h-24 bg-gray-200 rounded-full flex items-center justify-center mb-4">
                {isContratista ? (
                  <Building2 className="h-12 w-12 text-gray-500" />
                ) : (
                  <User className="h-12 w-12 text-gray-500" />
                )}
              </div>
              <h2 className="text-xl font-bold">{user.name}</h2>
              <p className="text-gray-500">
                {isContratista ? `Empresa contratista desde ${user.since}` : `Transportista desde ${user.since}`}
              </p>

              <div className="grid grid-cols-2 gap-4 w-full mt-6">
                <div className="text-center p-3 bg-green-50 rounded-lg">
                  <p className="text-sm text-gray-500">Calificación</p>
                  <p className="font-bold text-lg">{user.rating}/5.0</p>
                </div>
                <div className="text-center p-3 bg-green-50 rounded-lg">
                  <p className="text-sm text-gray-500">{isContratista ? "Viajes Publicados" : "Viajes"}</p>
                  <p className="font-bold text-lg">{isContratista ? user.tripsPublished : user.trips}</p>
                </div>
              </div>
            </div>
            <DialogFooter>
              <Button onClick={() => setShowProfileDialog(false)} className="bg-green-600 hover:bg-green-700">
                Cerrar
              </Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>
      )}

      {/* Diálogo de Detalles de Oferta */}
      {selectedOffer && (
        <Dialog open={showOfferDetails} onOpenChange={setShowOfferDetails}>
          <DialogContent className="sm:max-w-[500px]">
            <DialogHeader>
              <DialogTitle>Detalles de la Oferta</DialogTitle>
              <DialogDescription>Información completa sobre la oferta de viaje</DialogDescription>
            </DialogHeader>
            <div className="space-y-4">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <MapPin className="h-5 w-5 text-green-500" />
                  <span className="font-medium text-lg">
                    {selectedOffer.origin} → {selectedOffer.destination}
                  </span>
                </div>
                {selectedOffer.urgency === "alta" && <Badge className="bg-red-500">Urgente</Badge>}
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <p className="text-sm text-gray-500">Fecha de carga</p>
                  <p className="font-medium">{selectedOffer.date}</p>
                </div>
                <div>
                  <p className="text-sm text-gray-500">Distancia</p>
                  <p className="font-medium">{selectedOffer.distance} km</p>
                </div>
                <div>
                  <p className="text-sm text-gray-500">Tipo de carga</p>
                  <p className="font-medium">{selectedOffer.cargo}</p>
                </div>
                <div>
                  <p className="text-sm text-gray-500">Peso</p>
                  <p className="font-medium">{selectedOffer.weight}</p>
                </div>
              </div>

              <div className="border-t pt-4">
                <p className="text-sm text-gray-500">Cliente</p>
                <p className="font-medium">{selectedOffer.client}</p>
              </div>

              <div className="border-t pt-4">
                <p className="text-sm text-gray-500">Descripción</p>
                <p className="text-sm">{selectedOffer.description}</p>
              </div>

              <div className="border-t pt-4">
                <p className="text-sm text-gray-500 mb-2">Métodos de pago aceptados</p>
                <div className="flex flex-wrap gap-2">
                  {selectedOffer.paymentMethods.map((method: string, index: number) => (
                    <Badge key={index} variant="outline" className="bg-gray-100 py-1">
                      {method === "Transferencia bancaria" && <Landmark className="h-3 w-3 mr-1" />}
                      {method === "Nequi" && <Smartphone className="h-3 w-3 mr-1" />}
                      {method === "PSE" && <CreditCard className="h-3 w-3 mr-1" />}
                      {method === "Efectivo" && <Banknote className="h-3 w-3 mr-1" />}
                      {method === "Daviplata" && <Smartphone className="h-3 w-3 mr-1" />}
                      {method}
                    </Badge>
                  ))}
                </div>
              </div>

              <div className="bg-green-50 p-4 rounded-lg">
                <div className="flex items-center justify-between">
                  <p className="text-gray-700">Pago por el viaje</p>
                  <p className="font-bold text-xl">${selectedOffer.price.toLocaleString()}</p>
                </div>
                <p className="text-sm text-gray-500">
                  Aproximadamente ${Math.round(selectedOffer.price / selectedOffer.distance).toLocaleString()} por km
                </p>
              </div>
            </div>
            <DialogFooter className="flex flex-col sm:flex-row gap-2">
              <Button variant="outline" onClick={() => setShowOfferDetails(false)}>
                Cancelar
              </Button>
              {isContratista ? (
                <Button className="bg-green-600 hover:bg-green-700">Editar oferta</Button>
              ) : (
                <Button className="bg-green-600 hover:bg-green-700">Aplicar a esta oferta</Button>
              )}
            </DialogFooter>
          </DialogContent>
        </Dialog>
      )}

      {/* Diálogo para crear nueva oferta (solo para contratistas) */}
      {isContratista && (
        <Dialog open={showNewOfferDialog} onOpenChange={setShowNewOfferDialog}>
          <DialogContent className="sm:max-w-[600px]">
            <DialogHeader>
              <DialogTitle>Crear Nueva Oferta de Viaje</DialogTitle>
              <DialogDescription>Complete los detalles para publicar una nueva oferta</DialogDescription>
            </DialogHeader>
            <div className="grid gap-4 py-4">
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label htmlFor="origin">Origen</Label>
                  <Input
                    id="origin"
                    placeholder="Ej. Pasto"
                    value={newOffer.origin}
                    onChange={(e) => setNewOffer({ ...newOffer, origin: e.target.value })}
                  />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="destination">Destino</Label>
                  <Input
                    id="destination"
                    placeholder="Ej. Ipiales"
                    value={newOffer.destination}
                    onChange={(e) => setNewOffer({ ...newOffer, destination: e.target.value })}
                  />
                </div>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label htmlFor="date">Fecha de Carga</Label>
                  <Input
                    id="date"
                    placeholder="Ej. 15 Mayo, 2023"
                    value={newOffer.date}
                    onChange={(e) => setNewOffer({ ...newOffer, date: e.target.value })}
                  />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="price">Precio (COP)</Label>
                  <Input
                    id="price"
                    placeholder="Ej. 800000"
                    value={newOffer.price}
                    onChange={(e) => setNewOffer({ ...newOffer, price: e.target.value })}
                  />
                </div>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label htmlFor="cargo">Tipo de Carga</Label>
                  <Input
                    id="cargo"
                    placeholder="Ej. Mercancía general"
                    value={newOffer.cargo}
                    onChange={(e) => setNewOffer({ ...newOffer, cargo: e.target.value })}
                  />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="weight">Peso</Label>
                  <Input
                    id="weight"
                    placeholder="Ej. 8 toneladas"
                    value={newOffer.weight}
                    onChange={(e) => setNewOffer({ ...newOffer, weight: e.target.value })}
                  />
                </div>
              </div>

              <div className="space-y-2">
                <Label htmlFor="description">Descripción</Label>
                <Textarea
                  id="description"
                  placeholder="Detalles adicionales sobre la carga y requisitos"
                  value={newOffer.description}
                  onChange={(e) => setNewOffer({ ...newOffer, description: e.target.value })}
                />
              </div>

              <div className="space-y-2">
                <Label>Urgencia</Label>
                <RadioGroup
                  defaultValue="normal"
                  value={newOffer.urgency}
                  onValueChange={(value) => setNewOffer({ ...newOffer, urgency: value })}
                >
                  <div className="flex items-center space-x-2">
                    <RadioGroupItem value="alta" id="urgencia-alta" />
                    <Label htmlFor="urgencia-alta" className="text-red-500">
                      Alta
                    </Label>
                  </div>
                  <div className="flex items-center space-x-2">
                    <RadioGroupItem value="normal" id="urgencia-normal" />
                    <Label htmlFor="urgencia-normal">Normal</Label>
                  </div>
                  <div className="flex items-center space-x-2">
                    <RadioGroupItem value="baja" id="urgencia-baja" />
                    <Label htmlFor="urgencia-baja" className="text-green-500">
                      Baja
                    </Label>
                  </div>
                </RadioGroup>
              </div>

              <div className="space-y-2">
                <Label>Métodos de Pago Aceptados</Label>
                <div className="grid grid-cols-2 gap-2">
                  <div className="flex items-center space-x-2">
                    <input
                      type="checkbox"
                      id="pago-banco"
                      checked={newOffer.paymentMethods.includes("Transferencia bancaria")}
                      onChange={() => handlePaymentMethodChange("Transferencia bancaria")}
                    />
                    <Label htmlFor="pago-banco" className="flex items-center">
                      <Landmark className="h-4 w-4 mr-1" /> Transferencia bancaria
                    </Label>
                  </div>
                  <div className="flex items-center space-x-2">
                    <input
                      type="checkbox"
                      id="pago-nequi"
                      checked={newOffer.paymentMethods.includes("Nequi")}
                      onChange={() => handlePaymentMethodChange("Nequi")}
                    />
                    <Label htmlFor="pago-nequi" className="flex items-center">
                      <Smartphone className="h-4 w-4 mr-1" /> Nequi
                    </Label>
                  </div>
                  <div className="flex items-center space-x-2">
                    <input
                      type="checkbox"
                      id="pago-pse"
                      checked={newOffer.paymentMethods.includes("PSE")}
                      onChange={() => handlePaymentMethodChange("PSE")}
                    />
                    <Label htmlFor="pago-pse" className="flex items-center">
                      <CreditCard className="h-4 w-4 mr-1" /> PSE
                    </Label>
                  </div>
                  <div className="flex items-center space-x-2">
                    <input
                      type="checkbox"
                      id="pago-efectivo"
                      checked={newOffer.paymentMethods.includes("Efectivo")}
                      onChange={() => handlePaymentMethodChange("Efectivo")}
                    />
                    <Label htmlFor="pago-efectivo" className="flex items-center">
                      <Banknote className="h-4 w-4 mr-1" /> Efectivo
                    </Label>
                  </div>
                  <div className="flex items-center space-x-2">
                    <input
                      type="checkbox"
                      id="pago-daviplata"
                      checked={newOffer.paymentMethods.includes("Daviplata")}
                      onChange={() => handlePaymentMethodChange("Daviplata")}
                    />
                    <Label htmlFor="pago-daviplata" className="flex items-center">
                      <Smartphone className="h-4 w-4 mr-1" /> Daviplata
                    </Label>
                  </div>
                </div>
              </div>
            </div>
            <DialogFooter>
              <Button variant="outline" onClick={() => setShowNewOfferDialog(false)}>
                Cancelar
              </Button>
              <Button onClick={handleCreateOffer} className="bg-green-600 hover:bg-green-700">
                Publicar Oferta
              </Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>
      )}
    </div>
  )
}

﻿-- =============================================
-- Post deployment script to add all the correct Industries to the app(Spanish only)
-- =============================================
	
	USE Doppler2011_Local

	update [dbo].[Industry] set DescriptionES = 'Actividades bancarias', DescriptionEN = '' where IdIndustry = 1
	update [dbo].[Industry] set DescriptionES = 'Administración gubernamental', DescriptionEN = '' where IdIndustry = 2
	update [dbo].[Industry] set DescriptionES = 'Aeronáutica/Aviación', DescriptionEN = '' where IdIndustry = 3
	update [dbo].[Industry] set DescriptionES = 'Agricultura', DescriptionEN = '' where IdIndustry = 4

	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Alimentación y bebidas',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Almacenamiento',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Animación',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Apuestas y casinos',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Arquitectura y planificación',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Artesanía',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Artes interpretativas',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Artículos de consumo',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Artículos de lujo y joyas',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Artículos deportivos',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Asuntos internacionales',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Atención a la salud mental',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Atención sanitaria y hospitalaria',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Automación industrial',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Banca de inversiones',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Bellas Artes',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Bibliotecas',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Bienes inmobiliarios',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Bienes inmuebles comerciales',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Biotecnología',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Capital de riesgo',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Construcción',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Construcción naval',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Consultoría de estrategia y operaciones',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Contabilidad',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Cosmética',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Cristal, cerámica y hormigón',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Cumplimiento de la ley',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Departamento de defensa y del espacio exterior',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Deportes',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Derecho',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Desarrollo de programación',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Desarrollo y comercio internacional',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Diseño',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Diseño gráfico',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Dispositivos médicos',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Dotación y selección de personal',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Edición en línea',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Educación primaria/secundaria',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Ejército',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('E-learning',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Electrónica de consumo',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Embalaje y contenedores',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Energía renovable y medio ambiente',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Enseñanza superior',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Entretenimiento',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Envío de paquetes y carga',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Equipo informático',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Filantropía',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Formación profesional',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Fotografía',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Gabinetes estratégicos',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Ganadería',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Gestión de inversiones',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Gestión de organizaciones sin ánimo de lucro',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Gestión educativa',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Hostelería',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Importar y exportar',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Imprenta',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Industria aeroespacial y aviación',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Industria farmacéutica',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Industria textil y moda',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Ingeniería civil',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Ingeniería industrial o mecánica',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Instalaciones y servicios de recreo',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Instituciones religiosas',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Interconexión en red',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Internet',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Investigación',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Investigación de mercado',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Judicial',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Lácteos',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Logística y cadena de suministro',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Manufactura eléctrica y electrónica',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Manufactura ferroviaria',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Maquinaria',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Marketing y publicidad',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Materiales de construcción',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Material y equipo de negocios',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Medicina alternativa',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Medicina práctica',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Medios de difusión',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Mercados capitales',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Minería y metalurgia',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Mobiliario',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Museos e instituciones',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Música',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Nanotecnología',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Naval',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Ocio y viajes',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Oficina ejecutiva',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Oficina legislativa',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Organización cívica y social',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Organización política',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Películas y cine',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Periódicos',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Petróleo y energía',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Piscicultura',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Plásticos',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Política pública',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Producción alimentaria',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Producción multimedia',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Productos de papel y forestales',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Productos químicos',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Programas informáticos',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Protección civil',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Publicaciones',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Recaudación de fondos',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Recursos humanos',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Redacción y revisión',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Relaciones gubernamentales',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Relaciones públicas',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Resolución de conflicto por terceras partes',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Restaurantes',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Sanidad, bienestar y buena condición física',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Sector automovilístico',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Sector textil',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Seguridad del ordenador y de las redes',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Seguridad e investigaciones',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Seguros',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Semiconductores',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Servicio al consumidor',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Servicio de información',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Servicios de eventos',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Servicios financieros',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Servicios infraestructurales',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Servicios jurídicos',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Servicios medioambientales',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Servicios para el individuo y la familia',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Servicios públicos',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Servicios y tecnología de la información',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Subcontrataciones/Offshoring',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Supermercados',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Tabaco',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Tecnología inalámbrica',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Telecomunicaciones',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Traducción y localización',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Transporte por carretera o ferrocarril',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Venta al por mayor',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Venta al por menor',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Veterinaria',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Videojuegos',' ')
	INSERT [dbo].[Industry] ([DescriptionES],[DescriptionEN]) VALUES ('Vino y licor',' ')
SET IDENTITY_INSERT [dbo].[Industry] OFF	

update [dbo].[User] set	IdIndustry = 1
	
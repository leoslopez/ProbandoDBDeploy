-- =============================================
-- Script Template
-- =============================================

CREATE TABLE [dbo].[AdminQuestion]
(
	[IdQuestion] int IDENTITY (1, 1) NOT NULL,
	[QuestionEs] nvarchar(400) NULL,
	[QuestionEn] nvarchar(400) NULL,
	[Type] int NULL,
	[IdGroup] int NULL,
    [Active] BIT DEFAULT ((1)) NOT NULL,	
	[Orden] tinyint NULL
)
GO
ALTER TABLE [dbo].[AdminQuestion]
    ADD CONSTRAINT [PK_AdminQuestion] PRIMARY KEY CLUSTERED ([IdQuestion] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);
GO

CREATE NONCLUSTERED INDEX [IX_AdminQuestion_IdGroup]ON [dbo].[AdminQuestion] 
(
	[IdGroup] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

GO

CREATE TABLE [dbo].[AdminQuestionOption]
(
	[IdOption] int IDENTITY (1, 1) NOT NULL,
	[OptionEs] nvarchar(400) NULL,
	[OptionEn] nvarchar(400) NULL
)
GO
ALTER TABLE [dbo].[AdminQuestionOption]
    ADD CONSTRAINT [PK_AdminQuestionOption] PRIMARY KEY CLUSTERED ([IdOption] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

GO

CREATE TABLE [dbo].[AdminOptionXQuestion]
(
	 [IdOption] INT      NOT NULL,
     [IdQuestion] INT    NOT NULL,
     [Active] BIT DEFAULT ((1)) NOT NULL,
	 [Orden] tinyint NULL
)
GO
ALTER TABLE [dbo].[AdminOptionXQuestion]
    ADD CONSTRAINT [PK_AdminOptionXQuestion] PRIMARY KEY CLUSTERED ([IdOption] ASC, [IdQuestion] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

GO

ALTER TABLE [dbo].[AdminOptionXQuestion]
	ADD CONSTRAINT [FK_AdminOptionXQuestion_AdminQuestion] FOREIGN KEY ([IdQuestion]) REFERENCES [dbo].[AdminQuestion] ([IdQuestion]) ON DELETE NO ACTION ON UPDATE NO ACTION;

GO

ALTER TABLE [dbo].[AdminOptionXQuestion]
	ADD CONSTRAINT [FK_AdminOptionXQuestion_AdminQuestionOption] 
	FOREIGN KEY ([IdOption]) REFERENCES [dbo].[AdminQuestionOption] ([IdOption]) ON DELETE NO ACTION ON UPDATE NO ACTION;
	
GO


SET IDENTITY_INSERT [dbo].[AdminQuestion] ON

    --Hasta 15.000 Suscriptores

	INSERT [dbo].[AdminQuestion] ([IdQuestion], [QuestionEs],[QuestionEn],[Type],[IdGroup],[Orden],[Active]) 
	                      VALUES (1,'Nombre', 'First Name', 1, 1, 1, 1);
	INSERT [dbo].[AdminQuestion] ([IdQuestion], [QuestionEs],[QuestionEn],[Type],[IdGroup],[Orden],[Active]) 
	                      VALUES (2,'Apellido', 'Last Name',1, 1, 2, 1);
	INSERT [dbo].[AdminQuestion] ([IdQuestion], [QuestionEs],[QuestionEn],[Type],[IdGroup],[Orden],[Active]) 
	                      VALUES (3,'Email', 'Email',1, 1, 3, 1);
    INSERT [dbo].[AdminQuestion] ([IdQuestion], [QuestionEs],[QuestionEn],[Type],[IdGroup],[Orden],[Active]) 
	                      VALUES (4,N'Teléfono', 'Phone Number',1, 1, 4, 1);
	INSERT [dbo].[AdminQuestion] ([IdQuestion], [QuestionEs],[QuestionEn],[Type],[IdGroup],[Orden],[Active]) 
	                      VALUES (5,N'¿Cuál es la procedencia de tus Suscriptores?', 
									N'Which of the following can be considered as your Subscribers’ source?',3, 1, 5, 1);
	INSERT [dbo].[AdminQuestion] ([IdQuestion], [QuestionEs],[QuestionEn],[Type],[IdGroup],[Orden],[Active]) 
	                      VALUES (6,N'¿Cómo fue el método de recolección de datos?', 
									N'Which was the subscription method used to create your database?',2, 1, 6, 1);
	INSERT [dbo].[AdminQuestion] ([IdQuestion], [QuestionEs],[QuestionEn],[Type],[IdGroup],[Orden],[Active]) 
	                      VALUES (7,N'URL de registración:', 
									N'Paste the actual registration URL:',6, 1, 7, 1);

	--Hasta 50.000 Suscriptores 

	INSERT [dbo].[AdminQuestion] ([IdQuestion], [QuestionEs],[QuestionEn],[Type],[IdGroup],[Orden],[Active]) 
	                      VALUES (8,N'¿Qué porcentaje aproximado de sus Suscriptores dio autorización para recibir tus comunicaciones?',
								    N'Which is the estimated percentage of your Subscribers that has expressed their will to receive your communications?', 4, 2, 1, 1);
	
	--Hasta 150.000 Suscriptores 

	INSERT [dbo].[AdminQuestion] ([IdQuestion], [QuestionEs],[QuestionEn],[Type],[IdGroup],[Orden],[Active]) 
	                      VALUES (9,N'¿Has realizado campañas de Email Marketing previamente?',
								    N'Have you sent Email Markerting Campaigns before?', 5, 3, 1, 1);

	--Más de 150.000 Suscriptores
	
	INSERT [dbo].[AdminQuestion] ([IdQuestion], [QuestionEs],[QuestionEn],[Type],[IdGroup],[Orden],[Active]) 
	                      VALUES (10,N'¿Cuál es la antigüedad de tu Lista de Suscriptores?',
								     N'How many years has it been since you created your Subscribers list?', 4, 4, 1, 1);
	
	INSERT [dbo].[AdminQuestion] ([IdQuestion], [QuestionEs],[QuestionEn],[Type],[IdGroup],[Orden],[Active]) 
	                      VALUES (11,N'¿Qué cantidad de Campos Personalizados tiene tu Lista de Suscriptores?',
								     N'How many customized fields does your Subscribers list have? ', 4, 4, 2, 1);

	SET IDENTITY_INSERT [dbo].[AdminQuestion] OFF

GO

	SET IDENTITY_INSERT [dbo].[AdminQuestionOption] ON

	INSERT [dbo].[AdminQuestionOption] ([IdOption], [OptionEs], [OptionEn]) 
	                      VALUES (1,N'Sitio Web', 'Website');

	INSERT [dbo].[AdminQuestionOption] ([IdOption], [OptionEs], [OptionEn]) 
	                      VALUES (2,N'Evento', 'Event');
   
   	INSERT [dbo].[AdminQuestionOption] ([IdOption], [OptionEs], [OptionEn]) 
	                      VALUES (3,N'Landing Page', 'Landing Page');
   
   	INSERT [dbo].[AdminQuestionOption] ([IdOption], [OptionEs], [OptionEn]) 
	                      VALUES (4,N'CRM', 'CRM');
 
    INSERT [dbo].[AdminQuestionOption] ([IdOption], [OptionEs], [OptionEn]) 
	                      VALUES (5,N'Agenda personal de contactos', 'Personal Agenda');

    INSERT [dbo].[AdminQuestionOption] ([IdOption], [OptionEs], [OptionEn]) 
	                      VALUES (6,N'Formulario en tienda física/offline', 'Online/Offline Store');

   INSERT [dbo].[AdminQuestionOption] ([IdOption], [OptionEs], [OptionEn]) 
	                      VALUES (7,N'Otros', 'Others');

   INSERT [dbo].[AdminQuestionOption] ([IdOption], [OptionEs], [OptionEn]) 
	                      VALUES (8,N'Opt-in', 'Opt-in');

   INSERT [dbo].[AdminQuestionOption] ([IdOption], [OptionEs], [OptionEn]) 
	                      VALUES (9,N'Doble Opt-in', 'Doble Opt-in');

   INSERT [dbo].[AdminQuestionOption] ([IdOption], [OptionEs], [OptionEn]) 
	                      VALUES (10,N'Manual', 'Manual');

   INSERT [dbo].[AdminQuestionOption] ([IdOption], [OptionEs], [OptionEn]) 
	                      VALUES (11,N'10%', '10%');

   INSERT [dbo].[AdminQuestionOption] ([IdOption], [OptionEs], [OptionEn]) 
	                      VALUES (12,N'Menos del 50%', 'Less than 50%');

   INSERT [dbo].[AdminQuestionOption] ([IdOption], [OptionEs], [OptionEn]) 
	                      VALUES (13,N'Más del 50%', 'Over 50%');

   INSERT [dbo].[AdminQuestionOption] ([IdOption], [OptionEs], [OptionEn]) 
	                      VALUES (14,N'100%', '100%');

   INSERT [dbo].[AdminQuestionOption] ([IdOption], [OptionEs], [OptionEn]) 
	                      VALUES (15,N'Ninguno', 'None of them');

   INSERT [dbo].[AdminQuestionOption] ([IdOption], [OptionEs], [OptionEn]) 
	                      VALUES (16,N'Si', 'Yes');

   INSERT [dbo].[AdminQuestionOption] ([IdOption], [OptionEs], [OptionEn]) 
	                      VALUES (17,N'No', 'No');

   INSERT [dbo].[AdminQuestionOption] ([IdOption], [OptionEs], [OptionEn]) 
	                      VALUES (18,N'Menos de un año', 'Less than a year');

   INSERT [dbo].[AdminQuestionOption] ([IdOption], [OptionEs], [OptionEn]) 
	                      VALUES (19,N'Más de un año', 'Over an year');

   INSERT [dbo].[AdminQuestionOption] ([IdOption], [OptionEs], [OptionEn]) 
	                      VALUES (20,N'Más de 3 años', 'Over 3 years');

   INSERT [dbo].[AdminQuestionOption] ([IdOption], [OptionEs], [OptionEn]) 
	                      VALUES (21,N'1', '1');

   INSERT [dbo].[AdminQuestionOption] ([IdOption], [OptionEs], [OptionEn]) 
	                      VALUES (22,N'2', '2');

   INSERT [dbo].[AdminQuestionOption] ([IdOption], [OptionEs], [OptionEn]) 
	                      VALUES (23,N'3', '3');

   INSERT [dbo].[AdminQuestionOption] ([IdOption], [OptionEs], [OptionEn]) 
	                      VALUES (24,N'4', '4');

   INSERT [dbo].[AdminQuestionOption] ([IdOption], [OptionEs], [OptionEn]) 
	                      VALUES (25,N'5', '5');

   INSERT [dbo].[AdminQuestionOption] ([IdOption], [OptionEs], [OptionEn]) 
	                      VALUES (26,N'Más de 5', 'Over 5');

   SET IDENTITY_INSERT [dbo].[AdminQuestionOption] OFF

GO
    --Insert of all options for each question

	INSERT [dbo].[AdminOptionXQuestion] ([IdOption], [IdQuestion], [Orden], [Active]) VALUES (1,5,1,1);
	INSERT [dbo].[AdminOptionXQuestion] ([IdOption], [IdQuestion], [Orden], [Active]) VALUES (2,5,2,1);
	INSERT [dbo].[AdminOptionXQuestion] ([IdOption], [IdQuestion], [Orden], [Active]) VALUES (3,5,3,1);
	INSERT [dbo].[AdminOptionXQuestion] ([IdOption], [IdQuestion], [Orden], [Active]) VALUES (4,5,4,1);
	INSERT [dbo].[AdminOptionXQuestion] ([IdOption], [IdQuestion], [Orden], [Active]) VALUES (5,5,5,1);
	INSERT [dbo].[AdminOptionXQuestion] ([IdOption], [IdQuestion], [Orden], [Active]) VALUES (6,5,6,1);
	INSERT [dbo].[AdminOptionXQuestion] ([IdOption], [IdQuestion], [Orden], [Active]) VALUES (7,5,7,1);

	INSERT [dbo].[AdminOptionXQuestion] ([IdOption], [IdQuestion], [Orden], [Active]) VALUES (8,6,1,1);
	INSERT [dbo].[AdminOptionXQuestion] ([IdOption], [IdQuestion], [Orden], [Active]) VALUES (9,6,2,1);
	INSERT [dbo].[AdminOptionXQuestion] ([IdOption], [IdQuestion], [Orden], [Active]) VALUES (10,6,3,1);

	INSERT [dbo].[AdminOptionXQuestion] ([IdOption], [IdQuestion], [Orden], [Active]) VALUES (11,8,1,1);
	INSERT [dbo].[AdminOptionXQuestion] ([IdOption], [IdQuestion], [Orden], [Active]) VALUES (12,8,2,1);
	INSERT [dbo].[AdminOptionXQuestion] ([IdOption], [IdQuestion], [Orden], [Active]) VALUES (13,8,3,1);
	INSERT [dbo].[AdminOptionXQuestion] ([IdOption], [IdQuestion], [Orden], [Active]) VALUES (14,8,4,1);
	INSERT [dbo].[AdminOptionXQuestion] ([IdOption], [IdQuestion], [Orden], [Active]) VALUES (15,8,5,1);

	INSERT [dbo].[AdminOptionXQuestion] ([IdOption], [IdQuestion], [Orden], [Active]) VALUES (16,9,1,1);
	INSERT [dbo].[AdminOptionXQuestion] ([IdOption], [IdQuestion], [Orden], [Active]) VALUES (17,9,2,1);

	INSERT [dbo].[AdminOptionXQuestion] ([IdOption], [IdQuestion], [Orden], [Active]) VALUES (18,10,1,1);
	INSERT [dbo].[AdminOptionXQuestion] ([IdOption], [IdQuestion], [Orden], [Active]) VALUES (19,10,2,1);
	INSERT [dbo].[AdminOptionXQuestion] ([IdOption], [IdQuestion], [Orden], [Active]) VALUES (20,10,3,1);

	INSERT [dbo].[AdminOptionXQuestion] ([IdOption], [IdQuestion], [Orden], [Active]) VALUES (21,11,1,1);
	INSERT [dbo].[AdminOptionXQuestion] ([IdOption], [IdQuestion], [Orden], [Active]) VALUES (22,11,2,1);
	INSERT [dbo].[AdminOptionXQuestion] ([IdOption], [IdQuestion], [Orden], [Active]) VALUES (23,11,3,1);
	INSERT [dbo].[AdminOptionXQuestion] ([IdOption], [IdQuestion], [Orden], [Active]) VALUES (24,11,4,1);
	INSERT [dbo].[AdminOptionXQuestion] ([IdOption], [IdQuestion], [Orden], [Active]) VALUES (25,11,5,1);
	INSERT [dbo].[AdminOptionXQuestion] ([IdOption], [IdQuestion], [Orden], [Active]) VALUES (26,11,6,1);
	
GO
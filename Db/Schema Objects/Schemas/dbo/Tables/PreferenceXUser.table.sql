CREATE TABLE [dbo].[PreferenceXUser]
(
    [IdPreferenceUser]						 INT	        IDENTITY (1, 1) NOT NULL,	
	[Id]									 INT	        NOT NULL, 
	[IsPublicTemplate]                       BIT            DEFAULT ((1)) NOT NULL,
	[IdTemplateCategory]                     INT            DEFAULT ((1)) NOT NULL
)

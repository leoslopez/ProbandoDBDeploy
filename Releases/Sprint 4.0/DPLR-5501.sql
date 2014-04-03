-- =============================================
-- Script Template
-- =============================================

CREATE TABLE [dbo].[PreferenceXUser]
(
    [IdPreferenceUser]						 INT	        IDENTITY (1, 1) NOT NULL,	
	[Id]									 INT	        NOT NULL, 
	[IsPublicTemplate]                       BIT            DEFAULT (1) NOT NULL,
	[IdTemplateCategory]                     INT            DEFAULT (1) NOT NULL
)

ALTER TABLE [dbo].[PreferenceXUser]
    ADD CONSTRAINT [PK_PreferenceXUser] PRIMARY KEY CLUSTERED ([IdPreferenceUser] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

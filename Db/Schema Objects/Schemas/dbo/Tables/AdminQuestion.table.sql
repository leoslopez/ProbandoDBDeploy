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

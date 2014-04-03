CREATE TABLE [dbo].[AdminOptionXQuestion]
(
	 [IdOption] INT      NOT NULL,
     [IdQuestion] INT    NOT NULL,
     [Active] BIT DEFAULT ((1)) NOT NULL,
	 [Orden] tinyint NULL
)
CREATE TABLE [dbo].[Downloads] (
    [IdDownload]        INT           IDENTITY (1, 1) NOT NULL,
    [IdUser]            INT           NOT NULL,
	[UTCCreationDate]   DATETIME      NOT NULL,
    [OriginExport]      INT           NOT NULL,
    [Name]              VARCHAR (100) NOT NULL,
    [Status]            INT           NOT NULL,
    [FilePath]          VARCHAR (300) NOT NULL,
    [IdSubscriberList]  INT           NULL,
    [FileTypeExport]    INT           NULL,
    [ConfirmationEmail] VARCHAR (200) NULL,
    [SearchText]        NVARCHAR (100) NULL,
    [IdFilter]          INT           NULL,
    [Sort]              VARCHAR (50)  NULL,
    [SortDir]           VARCHAR (10)  NULL,
	[IdLanguage]		INT			  NOT NULL DEFAULT 1,
	[ItemsQuantity]     INT			  NOT NULL DEFAULT 0
);






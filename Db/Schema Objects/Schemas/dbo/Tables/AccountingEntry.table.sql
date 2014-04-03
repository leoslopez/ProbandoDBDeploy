CREATE TABLE [dbo].[AccountingEntry] (
	[IdAccountingEntry] INT             IDENTITY (1, 1) NOT NULL,
	[IdUser]            INT             NOT NULL,
	[Date]              DATETIME        NOT NULL,
	[Amount]            DECIMAL (18, 2) NOT NULL,
	[Status]            VARCHAR (50)    NULL,
	[ErrorMessage]      VARCHAR (MAX)   NULL,
	[IdInvoice]         INT             NULL,
	[IdBillingSource]   INT             NULL,
	[CCNumber]          VARCHAR (250)   NULL,
	[CCExpMonth]        SMALLINT        NULL,
	[CCExpYear]         SMALLINT        NULL,
	[CCHolderName]      VARCHAR (250)   NULL,
	[CCVerification]    VARCHAR (250)   NULL,
	[Note]              VARCHAR (50)    NULL,
	[AccountEntryType]  CHAR (1)        NOT NULL,
	[PaymentEntryType]  CHAR (1)        NULL,
	[Source]            INT             NULL,
	[AuthorizationNumber]  VARCHAR (250)   NULL,
	[InvoiceNumber]     INT				NULL,
	[AccountingTypeDescription] VARCHAR (250) NULL
);








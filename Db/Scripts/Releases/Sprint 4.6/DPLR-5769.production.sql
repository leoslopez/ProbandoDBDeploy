PRINT N'Altering [dbo].[ClientManager] columns...';
GO

ALTER TABLE [dbo].[ClientManager] ADD [BillingFirstName]	VARCHAR (50)	NULL
GO
ALTER TABLE [dbo].[ClientManager] ADD [BillingLastName]		VARCHAR (50)	NULL
GO
ALTER TABLE [dbo].[ClientManager] ADD [BillingPhone]		VARCHAR (50)	NULL
GO
ALTER TABLE [dbo].[ClientManager] ADD [BillingAddress]		VARCHAR (100)	NULL
GO
ALTER TABLE [dbo].[ClientManager] ADD [BillingFax]			VARCHAR (50)	NULL    
GO
ALTER TABLE [dbo].[ClientManager] ADD [BillingCity]			VARCHAR (50)	NULL
GO
ALTER TABLE [dbo].[ClientManager] ADD [BillingZip]			VARCHAR (10)	NULL
GO
ALTER TABLE [dbo].[ClientManager] ADD [RazonSocial]			VARCHAR (300)	NULL
GO
ALTER TABLE [dbo].[ClientManager] ADD [CUIT]				VARCHAR (30)	NULL
GO        
ALTER TABLE [dbo].[ClientManager] ADD [CCExpMonth]			SMALLINT		NULL
GO
ALTER TABLE [dbo].[ClientManager] ADD [CCExpYear]			SMALLINT		NULL
GO
ALTER TABLE [dbo].[ClientManager] ADD [CCHolderFullName]	VARCHAR (500)	NULL
GO
ALTER TABLE [dbo].[ClientManager] ADD [CCNumber]			VARCHAR (250)	NULL
GO
ALTER TABLE [dbo].[ClientManager] ADD [CCVerification]		VARCHAR (250)	NULL
GO
ALTER TABLE [dbo].[ClientManager] ADD [IdCCType]			INT				NULL
GO
ALTER TABLE [dbo].[ClientManager] ADD [IdConsumerType]		INT				NULL
GO
ALTER TABLE [dbo].[ClientManager] ADD [IdBillingState]		INT				NULL
GO
ALTER TABLE [dbo].[ClientManager] ADD [IdBillingSystem]		INT				NULL
GO
ALTER TABLE [dbo].[ClientManager] ADD [IdVendor]			INT				NULL
GO
ALTER TABLE [dbo].[ClientManager] ADD [IdPaymentMethod]		INT				CONSTRAINT [DF_ClientManager_IdPaymentMethod] DEFAULT((4)) NOT NULL
GO

PRINT N'Creating [FK_ClientManager_CreditCardTypes]...';
GO
ALTER TABLE [dbo].[ClientManager]
    ADD CONSTRAINT [FK_ClientManager_CreditCardTypes] FOREIGN KEY ([IdCCType]) REFERENCES [dbo].[CreditCardTypes] ([IdCCType]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

PRINT N'Creating [FK_ClientManager_ConsumerTypes]...';
GO
ALTER TABLE [dbo].[ClientManager]
    ADD CONSTRAINT [FK_ClientManager_ConsumerTypes] FOREIGN KEY ([IdConsumerType]) REFERENCES [dbo].[ConsumerTypes] ([IdConsumerType]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

PRINT N'Creating [FK_ClientManager_State1]...';
GO
ALTER TABLE [dbo].[ClientManager]
    ADD CONSTRAINT [FK_ClientManager_State1] FOREIGN KEY ([IdBillingState]) REFERENCES [dbo].[State] ([IdState]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

PRINT N'Creating [FK_ClientManager_Vendor]...';
GO
ALTER TABLE [dbo].[ClientManager]
    ADD CONSTRAINT [FK_ClientManager_Vendor] FOREIGN KEY ([IdVendor]) REFERENCES [dbo].[Vendor] ([IdVendor]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

PRINT N'Creating [FK_ClientManager_PaymentMethods]...';
GO
ALTER TABLE [dbo].[ClientManager]
    ADD CONSTRAINT [FK_ClientManager_PaymentMethods] FOREIGN KEY ([IdPaymentMethod]) REFERENCES [dbo].[PaymentMethods] ([IdPaymentMethod]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO
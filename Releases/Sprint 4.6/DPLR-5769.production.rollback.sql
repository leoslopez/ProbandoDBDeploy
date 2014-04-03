PRINT N'Dropping [FK_ClientManager_CreditCardTypes]...';
GO
ALTER TABLE [dbo].[ClientManager] DROP CONSTRAINT [FK_ClientManager_CreditCardTypes]
GO

PRINT N'Dropping [FK_ClientManager_ConsumerTypes]...';
GO
ALTER TABLE [dbo].[ClientManager] DROP CONSTRAINT [FK_ClientManager_ConsumerTypes]
GO

PRINT N'Dropping [FK_ClientManager_State1]...';
GO
ALTER TABLE [dbo].[ClientManager] DROP CONSTRAINT [FK_ClientManager_State1]
GO

PRINT N'Dropping [FK_ClientManager_Vendor]...';
GO
ALTER TABLE [dbo].[ClientManager] DROP CONSTRAINT [FK_ClientManager_Vendor]

PRINT N'Dropping [FK_ClientManager_PaymentMethods]...';
GO
ALTER TABLE [dbo].[ClientManager] DROP CONSTRAINT [FK_ClientManager_PaymentMethods]

PRINT N'Dropping [DF_ClientManager_IdPaymentMethod]...';
GO
ALTER TABLE [dbo].[ClientManager] DROP CONSTRAINT [DF_ClientManager_IdPaymentMethod]


PRINT N'Dropping [dbo].[ClientManager] columns...';
GO
ALTER TABLE [dbo].[ClientManager] DROP COLUMN [BillingFirstName]
GO
ALTER TABLE [dbo].[ClientManager] DROP COLUMN [BillingLastName]
GO
ALTER TABLE [dbo].[ClientManager] DROP COLUMN [BillingPhone]
GO
ALTER TABLE [dbo].[ClientManager] DROP COLUMN [BillingAddress]
GO
ALTER TABLE [dbo].[ClientManager] DROP COLUMN [BillingFax]
GO
ALTER TABLE [dbo].[ClientManager] DROP COLUMN [BillingCity]
GO
ALTER TABLE [dbo].[ClientManager] DROP COLUMN [BillingZip]
GO
ALTER TABLE [dbo].[ClientManager] DROP COLUMN [RazonSocial]
GO
ALTER TABLE [dbo].[ClientManager] DROP COLUMN [CUIT]
GO
ALTER TABLE [dbo].[ClientManager] DROP COLUMN [CCExpMonth]
GO
ALTER TABLE [dbo].[ClientManager] DROP COLUMN [CCExpYear]
GO
ALTER TABLE [dbo].[ClientManager] DROP COLUMN [CCHolderFullName]
GO
ALTER TABLE [dbo].[ClientManager] DROP COLUMN [CCNumber]
GO
ALTER TABLE [dbo].[ClientManager] DROP COLUMN [CCVerification]
GO
ALTER TABLE [dbo].[ClientManager] DROP COLUMN [IdCCType]
GO
ALTER TABLE [dbo].[ClientManager] DROP COLUMN [IdConsumerType]
GO
ALTER TABLE [dbo].[ClientManager] DROP COLUMN [IdBillingState]
GO
ALTER TABLE [dbo].[ClientManager] DROP COLUMN [IdBillingSystem]
GO
ALTER TABLE [dbo].[ClientManager] DROP COLUMN [IdVendor]
GO
ALTER TABLE [dbo].[ClientManager] DROP COLUMN [IdPaymentMethod]
GO
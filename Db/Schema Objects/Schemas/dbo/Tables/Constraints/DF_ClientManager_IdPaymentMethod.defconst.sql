ALTER TABLE [dbo].[ClientManager]
    ADD CONSTRAINT [DF_ClientManager_IdPaymentMethod] DEFAULT ((4)) FOR [IdPaymentMethod];


ALTER TABLE [dbo].[User]
    ADD CONSTRAINT [DF_User_AmountSubscribersToValidateOrigin] DEFAULT ((5000)) FOR [MaxSubscribersToValidate];




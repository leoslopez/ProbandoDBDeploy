ALTER TABLE [dbo].[User]
    ADD CONSTRAINT [DF_User_HasToValidateOrigin] DEFAULT ((0)) FOR [HasToValidateOrigin];


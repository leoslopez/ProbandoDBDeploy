ALTER TABLE [dbo].[User]
    ADD CONSTRAINT [DF_User_DeleteCustomFieldData] DEFAULT ((0)) FOR [DeleteCustomFieldData];


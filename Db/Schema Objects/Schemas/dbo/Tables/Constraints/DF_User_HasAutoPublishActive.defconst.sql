ALTER TABLE [dbo].[User]
    ADD CONSTRAINT [DF_User_IsAutoPublishActive] DEFAULT ((1)) FOR [IsAutoPublishActive];


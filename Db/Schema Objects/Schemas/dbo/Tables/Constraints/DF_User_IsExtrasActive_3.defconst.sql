ALTER TABLE [dbo].[User]
    ADD CONSTRAINT [DF_User_IsExtrasActive] DEFAULT ((1)) FOR [IsExtrasActive];


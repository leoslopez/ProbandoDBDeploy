ALTER TABLE [dbo].[MailConfirmation]
    ADD CONSTRAINT [DF_MailConfirmation_Active] DEFAULT ((1)) FOR [Active];


ALTER TABLE [dbo].[FormPendingConfirmation]
    ADD CONSTRAINT [DF_FormPendingConfirmation_Confirmed] DEFAULT ((0)) FOR [Confirmed];


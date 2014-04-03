ALTER TABLE [dbo].[Promotions]
    ADD CONSTRAINT [FK_Promotions_ClientTypesPlans] FOREIGN KEY ([IdUserTypePlan]) REFERENCES [dbo].[UserTypesPlans] ([IdUserTypePlan]) ON DELETE NO ACTION ON UPDATE NO ACTION;


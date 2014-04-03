ALTER TABLE [dbo].[ClientManagerUpgrade]
    ADD CONSTRAINT [FK_ClientManagerUpgrade_UserTypesPlans] FOREIGN KEY ([IdUserTypePlan]) REFERENCES [dbo].[UserTypesPlans] ([IdUserTypePlan]) ON DELETE NO ACTION ON UPDATE NO ACTION;


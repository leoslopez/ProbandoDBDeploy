ALTER TABLE [dbo].[MovementsCredits]
    ADD CONSTRAINT [FK_Clients_MovementsCredits] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[User] ([IdUser]) ON DELETE NO ACTION ON UPDATE NO ACTION;


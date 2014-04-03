ALTER TABLE [dbo].[UserMailAgents]
    ADD CONSTRAINT [FK_UserMailAgents_IdUserMailAgentType] FOREIGN KEY ([IdUserMailAgentType]) REFERENCES [dbo].[UserMailAgentTypes] ([IdUserMailAgentType]) ON DELETE NO ACTION ON UPDATE NO ACTION;


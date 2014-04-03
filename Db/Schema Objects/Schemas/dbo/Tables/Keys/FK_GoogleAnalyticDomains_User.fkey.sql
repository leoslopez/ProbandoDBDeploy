ALTER TABLE [dbo].[GoogleAnalyticDomain]
    ADD CONSTRAINT [FK_GoogleAnalyticDomains_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[User] ([IdUser]) ON DELETE NO ACTION ON UPDATE NO ACTION;


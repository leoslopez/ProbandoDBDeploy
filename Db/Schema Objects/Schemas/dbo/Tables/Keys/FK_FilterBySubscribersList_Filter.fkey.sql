ALTER TABLE [dbo].[FilterBySubscribersList]
    ADD CONSTRAINT [FK_FilterBySubscribersList_Filter] FOREIGN KEY ([IdFilter]) REFERENCES [dbo].[Filter] ([IdFilter]) ON DELETE CASCADE ON UPDATE NO ACTION;
GO
ALTER TABLE [dbo].[FilterBySubscribersList] CHECK CONSTRAINT [FK_FilterBySubscribersList_Filter];


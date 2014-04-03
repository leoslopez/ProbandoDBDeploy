ALTER TABLE [dbo].[FilterBySubscribersList]  
DROP [FK_FilterBySubscribersList_Filter]
GO

ALTER TABLE [dbo].[FilterBySubscribersList] WITH NOCHECK
ADD CONSTRAINT [FK_FilterBySubscribersList_Filter] FOREIGN KEY ([IdFilter]) 
REFERENCES [dbo].[Filter] ([IdFilter]) ON DELETE CASCADE ON UPDATE NO ACTION;

ALTER TABLE [dbo].[FilterBySubscribersList] CHECK CONSTRAINT [FK_FilterBySubscribersList_Filter];
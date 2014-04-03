ALTER TABLE [dbo].[LinkTracking]
    ADD CONSTRAINT [FK_LinkTracking_Link] FOREIGN KEY ([IdLink]) REFERENCES [dbo].[Link] ([IdLink]) ON DELETE CASCADE ON UPDATE NO ACTION;






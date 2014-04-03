ALTER TABLE [dbo].[ViewerAccessRightXUser]
    ADD CONSTRAINT [FK_ViewerAccessRightXUser_Viewer] FOREIGN KEY ([IdViewer]) REFERENCES [dbo].[Viewer] ([IdViewer]) ON DELETE NO ACTION ON UPDATE NO ACTION;


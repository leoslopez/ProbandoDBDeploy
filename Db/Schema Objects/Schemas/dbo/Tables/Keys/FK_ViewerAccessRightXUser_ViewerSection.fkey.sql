ALTER TABLE [dbo].[ViewerAccessRightXUser]
    ADD CONSTRAINT [FK_ViewerAccessRightXUser_ViewerSection] FOREIGN KEY ([IdSection]) REFERENCES [dbo].[ViewerSection] ([IdSection]) ON DELETE NO ACTION ON UPDATE NO ACTION;


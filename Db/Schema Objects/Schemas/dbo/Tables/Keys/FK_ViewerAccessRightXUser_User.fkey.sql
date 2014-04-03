ALTER TABLE [dbo].[ViewerAccessRightXUser]
    ADD CONSTRAINT [FK_ViewerAccessRightXUser_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[User] ([IdUser]) ON DELETE NO ACTION ON UPDATE NO ACTION;


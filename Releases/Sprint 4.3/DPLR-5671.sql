ALTER TABLE [dbo].[Viewer]  WITH CHECK ADD  CONSTRAINT [FK_Viewer_SecurityQuestion] FOREIGN KEY([IdSecurityQuestion])
REFERENCES [dbo].[SecurityQuestion] ([IdSecurityQuestion])
GO

ALTER TABLE [dbo].[Viewer] CHECK CONSTRAINT [FK_Viewer_SecurityQuestion]
GO
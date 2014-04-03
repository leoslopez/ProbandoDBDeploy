ALTER TABLE [dbo].[AdminOptionXQuestion]
	ADD CONSTRAINT [FK_AdminOptionXQuestion_AdminQuestion] FOREIGN KEY ([IdQuestion]) REFERENCES [dbo].[AdminQuestion] ([IdQuestion]) ON DELETE NO ACTION ON UPDATE NO ACTION;


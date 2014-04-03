ALTER TABLE [dbo].[AdminOptionXQuestion]
	ADD CONSTRAINT [FK_AdminOptionXQuestion_AdminQuestionOption] 
	FOREIGN KEY ([IdOption]) REFERENCES [dbo].[AdminQuestionOption] ([IdOption]) ON DELETE NO ACTION ON UPDATE NO ACTION;
	


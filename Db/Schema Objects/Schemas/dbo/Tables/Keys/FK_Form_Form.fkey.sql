﻿ALTER TABLE [dbo].[Form]
    ADD CONSTRAINT [FK_Form_Form] FOREIGN KEY ([IdForm]) REFERENCES [dbo].[Form] ([IdForm]) ON DELETE NO ACTION ON UPDATE NO ACTION;


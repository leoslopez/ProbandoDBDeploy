﻿ALTER TABLE [dbo].[Filter]
    ADD CONSTRAINT [FK_Filter_Field] FOREIGN KEY ([IdField]) REFERENCES [dbo].[Field] ([IdField]) ON DELETE NO ACTION ON UPDATE NO ACTION;

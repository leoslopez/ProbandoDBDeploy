﻿ALTER TABLE [dbo].[Label]
    ADD CONSTRAINT [FK_Label_Colour] FOREIGN KEY ([IdColour]) REFERENCES [dbo].[Colour] ([IdColour]) ON DELETE NO ACTION ON UPDATE NO ACTION;


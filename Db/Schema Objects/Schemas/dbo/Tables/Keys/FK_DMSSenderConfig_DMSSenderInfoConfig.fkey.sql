﻿ALTER TABLE [dbo].[DMSSenderInfoConfig]
ADD CONSTRAINT [FK_DMSSenderConfig_DMSSenderInfoConfig] FOREIGN KEY ([IdDMSSenderConfig], [Type], [IdDMS]) REFERENCES [dbo].[DMSSenderConfig] ([IdDMSSenderConfig], [Type], [IdDMS]) ON DELETE NO ACTION ON UPDATE NO ACTION;
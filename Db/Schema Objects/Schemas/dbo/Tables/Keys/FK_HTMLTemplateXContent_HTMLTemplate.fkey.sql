﻿ALTER TABLE [dbo].[HTMLTemplateXContent]
    ADD CONSTRAINT [FK_HTMLTemplateXContent_HTMLTemplate] FOREIGN KEY ([IdHTMLTemplate]) REFERENCES [dbo].[HTMLTemplate] ([IdHTMLTemplate]) ON DELETE NO ACTION ON UPDATE NO ACTION;


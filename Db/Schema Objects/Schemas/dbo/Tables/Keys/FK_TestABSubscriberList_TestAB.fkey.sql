﻿ALTER TABLE [dbo].[TestABSubscriberList]
    ADD CONSTRAINT [FK_TestABSubscriberList_TestAB] FOREIGN KEY ([idTestAB]) REFERENCES [dbo].[TestAB] ([IdTestAB]) ON DELETE CASCADE ON UPDATE NO ACTION;


ALTER TABLE [dbo].[Filter]
    ADD CONSTRAINT [FK_Filter_DeliveryStatus] FOREIGN KEY ([IdDeliveryStatus]) REFERENCES [dbo].[DeliveryStatus] ([IdDeliveryStatus]) ON DELETE NO ACTION ON UPDATE NO ACTION;


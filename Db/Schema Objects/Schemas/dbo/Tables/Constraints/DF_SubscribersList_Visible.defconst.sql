ALTER TABLE [dbo].[SubscribersList]
    ADD CONSTRAINT [DF_SubscribersList_Visible] DEFAULT ((1)) FOR [Visible];


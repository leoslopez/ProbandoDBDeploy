ALTER TABLE [dbo].[Campaign]
    ADD CONSTRAINT [DF_Campaign_EnabledSocialNetworkShare] DEFAULT ((1)) FOR [EnabledShareSocialNetwork];


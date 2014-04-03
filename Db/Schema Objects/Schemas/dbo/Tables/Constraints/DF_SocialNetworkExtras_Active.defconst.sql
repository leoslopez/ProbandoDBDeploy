ALTER TABLE [dbo].[SocialNetworkExtras]
    ADD CONSTRAINT [DF_SocialNetworkExtras_Active] DEFAULT ((1)) FOR [Active];


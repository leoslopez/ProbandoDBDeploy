ALTER TABLE [dbo].[User]
    ADD CONSTRAINT [DF_User_IsShareInSocialNetworksActive] DEFAULT ((1)) FOR [IsShareInSocialNetworksActive];


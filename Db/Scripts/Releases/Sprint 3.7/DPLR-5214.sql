CREATE TABLE [dbo].[SocialFanPageAutoPublishXCampaign] (
    [IdCampaign] INT NOT NULL,
    [IdFanPage]  NVARCHAR(50) NOT NULL
);

CREATE TABLE [dbo].[SocialFanPageAutoPublishXUser] (
    [IdUser]    INT NOT NULL,
    [IdFanPage] NVARCHAR(50) NOT NULL
);


ALTER TABLE [dbo].[SocialFanPageAutoPublishXCampaign]
    ADD CONSTRAINT [PK_SocialFanPageAutoPublishXCampaign] PRIMARY KEY CLUSTERED ([IdCampaign] ASC, [IdFanPage] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

ALTER TABLE [dbo].[SocialFanPageAutoPublishXUser]
    ADD CONSTRAINT [PK_SocialFanPageAutoPublishXUser] PRIMARY KEY CLUSTERED ([IdUser] ASC, [IdFanPage] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

ALTER TABLE [dbo].[SocialFanPageAutoPublishXCampaign]
    ADD CONSTRAINT [FK_SocialFanPageAutoPublishXCampaign_Campaign] FOREIGN KEY ([IdCampaign]) REFERENCES [dbo].[Campaign] ([IdCampaign]) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE [dbo].[SocialFanPageAutoPublishXUser]
    ADD CONSTRAINT [FK_SocialFanPageAutoPublishXUser_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[User] ([IdUser]) ON DELETE NO ACTION ON UPDATE NO ACTION;


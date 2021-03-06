﻿CREATE TABLE [dbo].[Campaign] (
    [IdCampaign]                INT            IDENTITY (1000000, 1) NOT NULL,
    [IdSendingTimeZone]         INT            NULL,
    [IdUser]                    INT            NOT NULL,
    [Name]                      VARCHAR (100)  NOT NULL,
    [FromName]                  VARCHAR (100)  NULL,
    [FromEmail]                 VARCHAR (100)  NULL,
    [ReplyTo]                   VARCHAR (100)  NULL,
    [UTCCreationDate]           DATETIME       NULL,
    [UTCSentDate]               DATETIME       NULL,
    [TestMail]                  VARCHAR (100)  NULL,
    [UTCScheduleDate]           DATETIME       NULL,
    [RSSContent]                VARCHAR (150)  NULL,
    [IsOpen]                    BIT            NULL,
    [IsNotOpen]                 BIT            NULL,
    [IsCloneCampaign]           BIT            NULL,
    [UTCCloneCampaign]          DATETIME       NULL,
    [CurrentStep]               SMALLINT       NULL,
    [Active]                    BIT            NULL,
    [UTCLastUpdatedDate]        DATETIME       NULL,
    [Subject]                   NVARCHAR (100) NULL,
    [CampaignType]              VARCHAR (30)   NOT NULL,
    [IdContent]                 INT            NULL,
    [IsSoftBounced]             BIT            NULL,
    [IdParentCampaign]          INT            NULL,
    [TestEmailCount]            INT            NULL,
    [IsProgrammed]              BIT            NULL,
    [ContentType]               SMALLINT       NOT NULL,
    [HtmlSourceType]            SMALLINT       NULL,
    [Status]                    SMALLINT       NOT NULL,
    [DeliveryType]              SMALLINT       NULL,
    [EnabledShareSocialNetwork] BIT            NOT NULL,
    [EnabledRSS]                BIT            NOT NULL,
    [EnabledAutopublish]        BIT            NOT NULL,
    [AmountSentSubscribers]     INT            NULL,
    [TestABCategory]            INT            NULL,
    [IdTestAB]                  INT            NULL,
    [Queued]                    BIT            NOT NULL,
    [DesactiveDate]             DATETIME       NULL,
    [EnabledExtras]             BIT            NOT NULL,
    [AmountSubscribersToSend]   INT            NULL,
    [UTCDMSLastUpdate]          DATETIME       NULL,
    [DMSSplited]                BIT            NULL,
    [TotalSubscribersLists]     INT            NULL,
    [HardBouncedMailCount]      INT            NULL,
    [SoftBouncedMailCount]      INT            NULL,
    [UnopenedMailCount]         INT            NULL,
    [TotalOpenedMailCount]      INT            NULL,
    [DistinctOpenedMailCount]   INT            NULL,
    [UnsubscriptionsCount]      INT            NULL,
    [LastOpenedEmailDate]       DATETIME       NULL,
    [ForwardedEmailsCount]      INT            NULL
) ON [Campaign];





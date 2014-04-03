CREATE TABLE [dbo].[Subscriber] (
    [IdSubscriber]               INT            IDENTITY (40000000, 1) NOT NULL,
    [ConsecutiveUnopendedEmails] INT            NULL,
    [ConsecutiveHardBounced]     INT            NULL,
    [ConsecutiveSoftBounced]     INT            NULL,
    [Email]                      NVARCHAR (100) NULL,
    [Ranking]                    INT            NULL,
    [IdUser]                     INT            NULL,
    [IdSubscribersStatus]        INT            NULL,
    [IdSubscriberSourceType]     INT            NULL,
    [UTCCreationDate]            DATETIME       NULL,
    [Gender]                     CHAR (1)       NULL,
    [UTCBirthday]                DATE           NULL,
    [IdCountry]                  INT            NULL,
    [FirstName]                  NVARCHAR (150)  NULL,
    [LastName]                   NVARCHAR (150)  NULL,
    [IdCampaign]                 INT            NULL,
    [UTCUnsubDate]               DATETIME       NULL,
    [UTCLastOpen]                DATETIME       NULL,
    [IdUnsubscriptionReason]     INT            NULL,
    [UnsubscriptionSubreason]    INT            NULL,
    [UnsubscriptionDescription]  VARCHAR (200)  NULL
) ON [Subscriber];


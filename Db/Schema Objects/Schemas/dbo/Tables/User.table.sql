CREATE TABLE [dbo].[User] (
    [IdUser]                                 INT            IDENTITY (50000, 1) NOT NULL,
    [IdUserTimeZone]                         INT            NULL,
    [IdLanguage]                             INT            NULL,
    [IdIndustry]                             INT            NULL,
    [FirstName]                              VARCHAR (50)   NULL,
    [LastName]                               VARCHAR (50)   NULL,
    [Password]                               VARCHAR (50)   NOT NULL,
    [Email]                                  VARCHAR (550)  NOT NULL,
    [PhoneNumber]                            VARCHAR (25)   NULL,
    [Company]                                VARCHAR (50)   NULL,
    [Address]                                VARCHAR (100)  NULL,
    [PromotionCode]                          VARCHAR (50)   NULL,
    [NewsLetterSubscriptionActive]           BIT            NULL,
    [NonProfitOrganization]                  BIT            NULL,
    [ShowOnlineVersion]                      BIT            NULL,
    [OnlineVersionPosition]                  INT            NULL,
    [ShowForwardEmail]                       BIT            NULL,
    [ForwardEmailPosition]                   INT            NULL,
    [ShowUpdateSubscriberProfile]            BIT            NULL,
    [UpdateSubscriberProfilePosition]        INT            NULL,
    [SocialNetworkShowMode]                  INT            NULL,
    [UseRssFeed]                             BIT            NULL,
    [UseLikeIt]                              BIT            NULL,
    [RssFeedUrl]                             NVARCHAR (50)  NULL,
    [ConsecutiveUnopendedEmails]             INT            NULL,
    [ConsecutiveHardBounced]                 INT            NULL,
    [ConsecutiveSoftBounced]                 INT            NULL,
    [UnsubscriberLinkAct]                    NVARCHAR (MAX) NULL,
    [UnsubscriberConfirmationUrl]            NVARCHAR (MAX) NULL,
    [ApiKey]                                 NVARCHAR (50)  NULL,
    [EnableGoogleAnalytic]                   BIT            NULL,
    [GoogleAnalyticName]                     VARCHAR (300)  NULL,
    [IdViewDefaultCampaign]                  INT            NULL,
    [IdViewDefaultList]                      INT            NULL,
    [AccountValidation]                      BIT            NULL,
    [UTCRegisterDate]                        DATETIME       NULL,
    [VerificationCode]                       VARCHAR (300)  NULL,
    [CityName]                               VARCHAR (200)  NULL,
    [IdState]                                INT            NULL,
    [PasswordResetCode]                      VARCHAR (100)  NULL,
    [ZipCode]                                VARCHAR (100)  NULL,
    [IdAmountMonthlyEmails]                  INT            NULL,
    [Website]                                NVARCHAR (100) NULL,
    [AmountAttemps]                          INT            NULL,
    [PasswordResetCodeDate]                  DATETIME       NULL,
    [UnsubscriberLinkNew]                    NVARCHAR (MAX) NULL,
    [SharedSocialNetworkHeader]              BIT            NULL,
    [SharedSocialNetworkFooter]              BIT            NULL,
    [AnswerSecurityQuestion]                 VARCHAR (MAX)  NULL,
    [IdSecurityQuestion]                     INT            NULL,
    [CCNumber]                               VARCHAR (250)  NULL,
    [CCExpMonth]                             SMALLINT       NULL,
    [CCExpYear]                              SMALLINT       NULL,
    [IdCCType]                               INT            NULL,
    [CCVerification]                         VARCHAR (250)  NULL,
    [BillingFirstName]                       VARCHAR (50)   NULL,
    [BillingLastName]                        VARCHAR (50)   NULL,
    [BillingPhone]                           VARCHAR (50)   NULL,
    [BillingFax]                             VARCHAR (50)   NULL,
    [BillingAddress]                         VARCHAR (100)  NULL,
    [BillingCity]                            VARCHAR (50)   NULL,
    [IdBillingState]                         INT            NULL,
    [BillingZip]                             VARCHAR (10)   NULL,
    [AllowContact]                           BIT            NULL,
    [PaymentMethod]                          INT            NOT NULL,
    [HardBounceLimit]                        INT            NULL,
    [SoftBounceLimit]                        INT            NULL,
    [RazonSocial]                            VARCHAR (300)  NULL,
    [CUIT]                                   VARCHAR (30)   NULL,
    [IdConsumerType]                         INT            NULL,
    [AmountAttempsAnswerSecurity]            INT            NULL,
    [UpgradePending]                         BIT            NULL,
    [MaxCustomFields]                        INT            NULL,
    [MaxSubscribersListAmount]               INT            NULL,
    [MaxSegmentsAmount]                      INT            NULL,
    [MaxFormsAmount]                         INT            NULL,
    [LastApiRequest]                         DATETIME       NULL,
    [ApiRequestsCounter]                     INT            NOT NULL,
    [MaxApiRequestsAllowed]                  INT            NOT NULL,
    [MinutesToResetApiRequestCounter]        INT            NOT NULL,
    [AllowDeleteCustomFieldsData]            BIT            NULL,
    [IdResponsabileBilling]                  INT            NULL,
    [IdVendor]                               INT            NULL,
    [Logo]                                   VARCHAR (200)  NULL,
    [UTCUpgrade]                             DATETIME       NULL,
    [UTCFirstPayment]                        DATETIME       NULL,
    [IsCancelated]                           BIT            NULL,
    [CancelatedDate]                         DATETIME       NULL,
    [CancelatedObservation]                  VARCHAR (200)  NULL,
    [MaxSubscribers]                         INT            NOT NULL,
    [IsSubscribersLimitReached]              BIT            NOT NULL,
    [UnsubscriberLinkSpanishAct]             NVARCHAR (MAX) NULL,
    [UnsubscriberLinkSpanishNew]             NVARCHAR (MAX) NULL,
    [BlockedAccountInvalidPassword]          BIT            NULL,
    [BlockedAccountNotPayed]                 BIT            NULL,
    [IsExchangeAccount]                      BIT            NULL,
    [ExchangeAccountDetail]                  NVARCHAR (MAX) NULL,
    [IdNewFunctionalityPopup]                INT            NULL,
    [IdCurrentBillingCredit]                 INT            NULL,
    [IsAutoPublishActive]                    BIT            NULL,
    [IsExtrasActive]                         BIT            NULL,
    [IsShareInSocialNetworksActive]          BIT            NULL,
    [IsMaxSubscribersReachSentEmailToAdmin]  BIT            NOT NULL,
    [RegistrationIp]                         NVARCHAR (15)  NULL,
    [IsMaxSubscribersExceedSentEmailToAdmin] BIT            NOT NULL,
    [IsSubscribersLimitExceeded]             BIT            NOT NULL,
    [MaxSubscribersToValidate]               INT            NOT NULL,
    [HasToValidateOrigin]                    BIT            NOT NULL,
    [IsValidateOriginSentEmailToAdmin]       BIT            NOT NULL,
    [SignUpOrigin]                           NVARCHAR (50)  NULL,
    [MigrationState]                         INT            NULL,
    [CCHolderFullName]                       VARCHAR (500)  NULL,
    [IdBillingSystem]                        INT            NULL,
    [AmountUsedCompleteUserInfoLink]         INT            DEFAULT ((0)) NOT NULL,
    [IdClientManager]                        INT            NULL,
    [PendingUnsubscriberConfirmationUrl]     NVARCHAR (MAX) NULL,
    [ExternalUseEnabled]                     BIT            NULL,
    [ClientManagerUrl]                       VARCHAR (200)  NULL,
    [ClientManagerStatus]                    INT            NULL,
    [IdDMSFast]                              INT            /*DEFAULT ((0))*/ NOT NULL,
    [IdDMSNormal]                            INT            /*DEFAULT ((0))*/ NOT NULL,
    [WelcomeEmailSent]                       BIT            NULL,
    [UTCCompleteRegistryDate]                DATETIME       NULL,
    [IsAbuseLinkVisible]                     BIT            DEFAULT ((1)) NOT NULL,
    [TotalCampaignsWithAbuseLink]            INT            DEFAULT ((-1)) NOT NULL,
    [TotalSentCampaignsWithoutAbuse]         INT            DEFAULT ((0)) NOT NULL,
    [DeleteCustomFieldData]                  TINYINT        NULL,
	[IsRegistrationCompleted]			     BIT			DEFAULT ((0)) NOT NULL,
	[UTCRegistrationCompleted]				 DATETIME		NULL,
	[IdAccountCancellationReason]			 INT			NULL
);




































































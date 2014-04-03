CREATE TABLE [dbo].[ClientManager] (
    [IdClientManager]               INT            IDENTITY (1, 1) NOT NULL,
    [Username]                      VARCHAR (100)  NOT NULL,
    [Email]                         VARCHAR (100)  NOT NULL,
    [Password]                      VARCHAR (50)   NOT NULL,
    [Phone]                         VARCHAR (100)  NOT NULL,
    [Mobile]                        VARCHAR (100)  NULL,
    [Address]                       VARCHAR (100)  NULL,
    [ZipCode]                       CHAR (10)      NULL,
    [IdCountry]                     INT            NULL,
    [IdState]                       INT            NULL,
    [City]                          VARCHAR (200)  NULL,
    [Url]                           VARCHAR (200)  NULL,
    [Company]                       VARCHAR (50)   NULL,
    [Logo]                          VARCHAR (200)  NULL,
    [IdResponsabileBilling]         INT            NULL,
    [UTCFirstPayment]               DATETIME       NULL,
    [Active]                        BIT            NOT NULL,
    [IdCurrency]                    INT            NULL,
    [UTCRegisterDate]               DATETIME       NOT NULL,
    [UTCUpdateDate]                 DATETIME       NULL,
    [IdSecurityQuestion]            INT            NULL,
    [AnswerSecurityQuestion]        VARCHAR (MAX)  NULL,
    [Website]                       NVARCHAR (100) NULL,
    [FirstName]                     VARCHAR (50)   NULL,
    [LastName]                      VARCHAR (50)   NULL,
    [IdLanguage]                    INT            NULL,
    [IdTimeZone]                    INT            NULL,
    [VerificationCode]              VARCHAR (300)  NULL,
    [AccountValidation]             BIT            NULL,
    [PasswordResetCode]             VARCHAR (100)  NULL,
    [PasswordResetCodeDate]         DATETIME       NULL,
    [AmountAttempsAnswerSecurity]   INT            NULL,
    [AmountAttemps]                 INT            NULL,
    [BillingFirstName]              VARCHAR (50)   NULL,
    [BillingLastName]               VARCHAR (50)   NULL,
    [BillingPhone]                  VARCHAR (50)   NULL,
    [BillingAddress]                VARCHAR (100)  NULL,
    [BillingFax]                    VARCHAR (50)   NULL,
    [BillingCity]                   VARCHAR (50)   NULL,
    [BillingZip]                    VARCHAR (10)   NULL,
    [RazonSocial]                   VARCHAR (300)  NULL,
    [CUIT]                          VARCHAR (30)   NULL,
    [CCExpMonth]                    SMALLINT       NULL,
    [CCExpYear]                     SMALLINT       NULL,
    [CCHolderFullName]              VARCHAR (500)  NULL,
    [CCNumber]                      VARCHAR (250)  NULL,
    [CCVerification]                VARCHAR (250)  NULL,
    [IdCCType]                      INT            NULL,
    [IdConsumerType]                INT            NULL,
    [IdBillingState]                INT            NULL,
    [IdBillingSystem]               INT            NULL,
    [IdVendor]                      INT            NULL,
    [IdPaymentMethod]               INT            NOT NULL,
    [BlockedAccountInvalidPassword] BIT            NULL,
    PRIMARY KEY CLUSTERED ([IdClientManager] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF)
);


















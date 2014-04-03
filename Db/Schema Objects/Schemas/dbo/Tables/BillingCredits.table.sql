CREATE TABLE [dbo].[BillingCredits] (
    [IdBillingCredit]          INT            IDENTITY (10000, 1) NOT NULL,
    [Date]                     DATETIME       NOT NULL,
    [IdUser]                   INT            NOT NULL,
    [IdPaymentMethod]          INT            NOT NULL,
    [PlanFee]                  FLOAT          NULL,
    [PaymentDate]              DATETIME       NULL,
    [Taxes]                    FLOAT          NULL,
    [IdCurrencyType]           INT            NULL,
    [CreditsQty]               INT            NULL,
    [ActivationDate]           DATETIME       NULL,
    [IdPromotion]              INT            NULL,
    [ExtraEmailFee]            FLOAT          NULL,
    [TotalCreditsQty]          INT            NULL,
    [IdBillingCreditType]      INT            NULL,
    [CCNumber]                 VARCHAR (250)  NULL,
    [CCExpMonth]               SMALLINT       NULL,
    [CCExpYear]                SMALLINT       NULL,
    [CCVerification]           VARCHAR (250)  NULL,
    [IdCCType]                 INT            NULL,
    [IdConsumerType]           INT            NULL,
    [RazonSocial]              VARCHAR (250)  NULL,
    [CUIT]                     VARCHAR (100)  NULL,
    [ExclusiveMessage]         NVARCHAR (MAX) NULL,
    [IdUserTypePlan]           INT            NULL,
    [DiscountPlanFeePromotion] INT            NULL,
    [DiscountPlanFeeAdmin]     INT            NULL,
    [ExtraCreditsPromotion]    INT            NULL,
    [SubscribersQty]           INT            NULL,
    [CCHolderFullName]         VARCHAR (500)  NULL,
	[NroFacturacion]		   VARCHAR(250)   NULL	
);


































































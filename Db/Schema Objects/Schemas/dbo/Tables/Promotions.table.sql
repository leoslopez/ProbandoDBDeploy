CREATE TABLE [dbo].[Promotions] (
    [IdPromotion]     INT          IDENTITY (100000, 1) NOT NULL,
    [IdUserTypePlan]  INT          NOT NULL,
    [CreationDate]    DATETIME     NULL,
    [ExpiringDate]    DATETIME     NULL,
    [TimesUsed]       INT          NULL,
    [TimesToUse]      INT          NULL,
    [Code]            VARCHAR (50) NULL,
    [ExtraCredits]    INT          NULL,
    [Active]          BIT          NOT NULL,
    [DiscountPlanFee] INT          NULL
);












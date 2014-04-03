CREATE TABLE [dbo].[UserTypesPlans] (
    [IdUserTypePlan]   INT           IDENTITY (1, 1) NOT NULL,
    [IdUserType]       INT           NULL,
    [Description]      VARCHAR (300) NULL,
    [EmailQty]         INT           NULL,
    [Fee]              FLOAT         NULL,
    [ExtraEmailCost]   FLOAT         NULL,
    [IdUser]           INT           NULL,
    [MessageExclusive] VARCHAR (200) NULL,
    [Active]           BIT           NULL,
    [SubscribersQty]   INT           NULL
);
















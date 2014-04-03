CREATE TABLE [dbo].[Filter] (
    [IdFilter]         INT           IDENTITY (1, 1) NOT NULL,
    [Name]             VARCHAR (150) NULL,
    [Type]             VARCHAR (150) NULL,
    [FilterBy]         VARCHAR (50)  NULL,
    [Value]            VARCHAR (150) NULL,
    [Condition]        VARCHAR (150) NULL,
    [IdField]          INT           NULL,
    [ParentFilter]     INT           NULL,
    [LogicAnd]         VARCHAR (50)  NULL,
    [LogicOr]          VARCHAR (50)  NULL,
    [TypeLogic]        VARCHAR (50)  NULL,
    [IdDeliveryStatus] INT           NULL
) ON [SubscriberList]
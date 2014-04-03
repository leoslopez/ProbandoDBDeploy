-- =============================================
-- Script Template
-- =============================================
CREATE TABLE [dbo].[ClientManager] (
    [IdClientManager]       INT           IDENTITY (1, 1) NOT NULL,
    [Username]              VARCHAR (100) NOT NULL,
    [Email]                 VARCHAR (100) NOT NULL,
    [Password]              VARCHAR (50)  NOT NULL,
    [Phone]                 VARCHAR (100) NOT NULL,
    [Mobile]                VARCHAR (100) NULL,
    [Address]               VARCHAR (100) NULL,
    [ZipCode]               CHAR (10)     NULL,
    [IdCountry]             INT           NULL,
    [IdState]               INT           NULL,
    [City]                  VARCHAR (200) NULL,
    [Website]               VARCHAR (200) NULL,
    [Company]               VARCHAR (50)  NULL,
    [Logo]                  VARCHAR (200) NULL,
    [IdResponsabileBilling] INT           NULL,
    [UTCFirstPayment]       DATETIME      NULL,
    [Active]                BIT           NOT NULL,
    [IdCurrency]            INT           NULL,
    [UTCRegisterDate]       DATETIME      NOT NULL,
    [UTCUpdateDate]         DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([IdClientManager] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF)
);
GO

CREATE TABLE [dbo].[ClientManagerNote] (
    [IdClientManagerNote] INT           IDENTITY (1, 1) NOT NULL,
    [Description]         VARCHAR (500) NOT NULL,
    [UTCCreationDate]     DATETIME      NOT NULL,
    [IdClientManager]     INT           NOT NULL
);
GO

CREATE TABLE [dbo].[ClientManagerUpgrade] (
    [IdUserTypePlan]  INT      NOT NULL,
    [IdClientManager] INT      NOT NULL,
    [UTCUpgradeDate]  DATETIME NOT NULL
);
GO

ALTER TABLE [dbo].[ClientManagerNote]
    ADD CONSTRAINT [PK_ClientManagerNote] PRIMARY KEY CLUSTERED ([IdClientManagerNote] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);
GO

ALTER TABLE [dbo].[ClientManagerUpgrade]
    ADD CONSTRAINT [PK_ClientManagerUpgrade] PRIMARY KEY CLUSTERED ([IdUserTypePlan] ASC, [IdClientManager] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);
GO

ALTER TABLE [dbo].[ClientManager]
    ADD CONSTRAINT [FK_ClientManager_Country] FOREIGN KEY ([IdCountry]) REFERENCES [dbo].[Country] ([IdCountry]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

ALTER TABLE [dbo].[ClientManager]
    ADD CONSTRAINT [FK_ClientManager_ResponsabileBilling] FOREIGN KEY ([IdResponsabileBilling]) REFERENCES [dbo].[ResponsabileBilling] ([IdResponsabileBilling]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

ALTER TABLE [dbo].[ClientManager]
    ADD CONSTRAINT [FK_ClientManager_State] FOREIGN KEY ([IdState]) REFERENCES [dbo].[State] ([IdState]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

ALTER TABLE [dbo].[ClientManagerNote]
    ADD CONSTRAINT [FK_ClientManagerNote_ClientManager] FOREIGN KEY ([IdClientManager]) REFERENCES [dbo].[ClientManager] ([IdClientManager]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

ALTER TABLE [dbo].[ClientManagerUpgrade]
    ADD CONSTRAINT [FK_ClientManagerUpgrade_ClientManager] FOREIGN KEY ([IdClientManager]) REFERENCES [dbo].[ClientManager] ([IdClientManager]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

ALTER TABLE [dbo].[ClientManagerUpgrade]
    ADD CONSTRAINT [FK_ClientManagerUpgrade_UserTypesPlans] FOREIGN KEY ([IdUserTypePlan]) REFERENCES [dbo].[UserTypesPlans] ([IdUserTypePlan]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_ClientManager_Name]
    ON [dbo].[ClientManager]([Username] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [PRIMARY];
















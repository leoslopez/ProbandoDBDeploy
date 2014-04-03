PRINT 'Creating DMSConfig table...'

CREATE TABLE [dbo].[DMSConfig] (
  [IdDMS] int NOT NULL,
  [LogWriteToDisk] bit NOT NULL,
  [LogLevel] int NOT NULL,
  [LogRemotingPort] int NOT NULL,
  [EmailPackageAmount] int NOT NULL,
  [MaxPackageFastCampaign] tinyint NOT NULL,
  [DMSSignature] varchar(50) NOT NULL,
  [LocalSMTPServerIP] varchar(50) NOT NULL,
  [LocalSMTPServerPort] int NOT NULL,
  [SiteURL] varchar(255) NOT NULL,
  [FromNotificationEmail] varchar(550) NOT NULL,
  [ToNotificationEmail] varchar(550) NOT NULL,
  [DefaultSiteURL] varchar(255) NOT NULL,
  [NTPServerHost] varchar(255) NOT NULL,
  [ConsoleListenIP] varchar(50) NOT NULL,
  [ConsoleListenPort] int NOT NULL,
  [WsActionsUrl] varchar(255) NOT NULL,
  [WsModuleKey] varchar(50) NOT NULL,
  [WsEncryptionKey] varchar(50) NOT NULL,
  [MaxPackages] int NOT NULL,
  [ListenerIP_SM] varchar(50) NOT NULL,
  [ListenerPort_SM] int NOT NULL,
  [MaxThreadsSM] tinyint NOT NULL,
  [ListenerIP_TOSM] varchar(50) NOT NULL,
  [ListenerPort_TOSM] int NOT NULL,
  [MaxThreadsTOSM] tinyint NOT NULL,
  [SimultaneousConnections] int NOT NULL,
  [ConnectionPassword] varchar(50) NOT NULL,
  [SendTimeOut] int NOT NULL,
  [ReceiveTimeOut] int NOT NULL,
  [BufferSize] int NOT NULL
);

ALTER TABLE [dbo].[DMSConfig]
ADD CONSTRAINT [PK_DMSConfig] PRIMARY KEY CLUSTERED ([IdDMS] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);
GO

ALTER TABLE [dbo].[DMSConfig]
ADD CONSTRAINT [FK_DMS_DMSConfig] FOREIGN KEY ([IdDMS]) REFERENCES [dbo].[DMSConfig] ([IdDMS]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

PRINT 'DMSConfig table created'

PRINT 'Creating DMSSenderConfig table...'

CREATE TABLE [dbo].[DMSSenderConfig] (
  [IdDMSSenderConfig] int NOT NULL,
  [Type] varchar(4) NOT NULL,
  [IdDMS] int NOT NULL,
  [BufferSize] int NOT NULL,
  [OutboundBindIP] varchar(50) NOT NULL,
  [ListenIP] varchar(50) NOT NULL,
  [ConnectionPassword] varchar(50) NOT NULL,
  [SendTimeOut] int NOT NULL,
  [ReceiveTimeOut] int NOT NULL,
  [IPType] int NOT NULL,
  [SendersType] int NOT NULL,
  [BalancePackets] int NOT NULL,
  [UseStrictBalance] bit NOT NULL,
  [HELODomain] varchar(255) NOT NULL,
  [ReturnPathDomain] varchar(255) NOT NULL
);
GO

ALTER TABLE [dbo].[DMSSenderConfig]
ADD CONSTRAINT [PK_DMSSenderConfig] PRIMARY KEY CLUSTERED ([IdDMSSenderConfig] ASC, [Type] ASC, IdDMS ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);
GO

ALTER TABLE [dbo].[DMSSenderConfig]
ADD CONSTRAINT [FK_DMS_DMSSenderConfig] FOREIGN KEY ([IdDMS]) REFERENCES [dbo].[DMS] ([IdDMS]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

PRINT 'DMSSenderConfig table created'

PRINT 'Creating DMSSenderInfoConfig table...'

CREATE TABLE [dbo].[DMSSenderInfoConfig] (
  [IdDMSSenderInfoConfig] int IDENTITY (1, 1) NOT NULL,
  [IdDMSSenderConfig] int NOT NULL,
  [Type] varchar(4) NOT NULL,
  [IdDMS] int NOT NULL,
  [IsFastSender] bit NOT NULL,
  [ListenPort] int NOT NULL
);
GO

ALTER TABLE [dbo].[DMSSenderInfoConfig]
ADD CONSTRAINT [PK_DMSSenderInfoConfig] PRIMARY KEY CLUSTERED ([IdDMSSenderInfoConfig] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);
GO

ALTER TABLE [dbo].[DMSSenderInfoConfig]
ADD CONSTRAINT [FK_DMSSenderConfig_DMSSenderInfoConfig] FOREIGN KEY ([IdDMSSenderConfig], [Type], [IdDMS]) REFERENCES [dbo].[DMSSenderConfig] ([IdDMSSenderConfig], [Type], [IdDMS]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO 

PRINT 'DMSSenderInfoConfig table created'

PRINT 'Creating Stored Procedures...'
GO

CREATE PROCEDURE [dbo].[DMSConfigById_GX] @IdDMS int
AS
BEGIN
  SELECT * FROM DMSConfig
  WHERE IdDMS = @IdDMS
END
GO

CREATE PROCEDURE [dbo].[DMSSenderConfigById_GX] @IdDMS int
AS
BEGIN
  SELECT * FROM DMSSenderInfoConfig SIC
  JOIN DMSSenderConfig SC 
  ON SC.IdDMSSenderConfig = SIC.IdDMSSenderConfig
  AND SC.Type = SIC.Type
  AND  SC.IdDMS = SIC.IdDMS
  WHERE SIC.IdDMS = @IdDMS
  ORDER BY SC.IdDMSSenderConfig
END
GO

PRINT 'Stored Procedures created'


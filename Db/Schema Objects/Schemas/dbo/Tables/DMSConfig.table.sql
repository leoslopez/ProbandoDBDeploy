﻿CREATE TABLE [dbo].[DMSConfig] (
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
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
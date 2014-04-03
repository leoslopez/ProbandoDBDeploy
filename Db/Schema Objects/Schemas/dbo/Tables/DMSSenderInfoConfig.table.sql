CREATE TABLE [dbo].[DMSSenderInfoConfig] (
  [IdDMSSenderInfoConfig] int IDENTITY (1, 1) NOT NULL,
  [IdDMSSenderConfig] int NOT NULL,
  [Type] varchar(4) NOT NULL,
  [IdDMS] int NOT NULL,
  [IsFastSender] bit NOT NULL,
  [ListenPort] int NOT NULL
);
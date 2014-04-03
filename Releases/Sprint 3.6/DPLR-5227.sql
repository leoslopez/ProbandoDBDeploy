SP_RENAME 'ClientManager.Website', 'Url', 'COLUMN'

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ClientManager]') AND name = N'UQ_Website')
ALTER TABLE [dbo].[ClientManager] DROP CONSTRAINT [UQ_Website]
GO

ALTER TABLE [dbo].[ClientManager]
    ADD CONSTRAINT [UQ_Url] UNIQUE NONCLUSTERED ([Url] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF) ON [PRIMARY];

GO
ALTER TABLE [dbo].[ClientManager]
ADD    [Website]                NVARCHAR(100) NULL

GO

ALTER TABLE [dbo].[ClientManager]
ADD    [FirstName]              VARCHAR(50)   NULL

GO

ALTER TABLE [dbo].[ClientManager]
ADD    [LastName]               VARCHAR(50)   NULL

GO

ALTER TABLE [dbo].[ClientManager]
ADD    [IdLanguage]             INT            NULL

GO

ALTER TABLE [dbo].[ClientManager]
ADD    [IdTimeZone]             INT            NULL

GO

ALTER TABLE [dbo].[ClientManager]
    ADD CONSTRAINT [FK_ClientManager_Language] FOREIGN KEY ([IdLanguage]) REFERENCES [dbo].[Language] ([IdLanguage]) ON DELETE NO ACTION ON UPDATE NO ACTION;

GO
ALTER TABLE [dbo].[ClientManager]
    ADD CONSTRAINT [FK_ClientManager_UserTimeZone] FOREIGN KEY ([IdTimeZone]) REFERENCES [dbo].[UserTimeZone] ([IdUserTimeZone]) ON DELETE NO ACTION ON UPDATE NO ACTION;

GO

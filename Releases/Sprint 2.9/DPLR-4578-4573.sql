CREATE TABLE [dbo].[Viewer] (
    [IdViewer]        INT           IDENTITY (1, 1) NOT NULL,
    [Username]        VARCHAR (20)  NOT NULL,
    [Password]        VARCHAR (50)  NOT NULL,
    [Active]          BIT           NOT NULL,
    [UTCRegisterDate] DATETIME      NOT NULL,
    [Email]           VARCHAR (100) NULL,
    [IdClientManager] INT           NOT NULL
);

CREATE TABLE [dbo].[ViewerAccessRightXUser] (
    [IdViewer]        INT      NOT NULL,
    [IdUser]          INT      NOT NULL,
    [IdSection]       INT      NOT NULL,
    [AccessLevel]     INT      NOT NULL,
    [UTCCreationDate] DATETIME NOT NULL
);

CREATE TABLE [dbo].[ViewerSection] (
    [IdSection] INT          IDENTITY (1, 1) NOT NULL,
    [Name]      VARCHAR (20) NOT NULL,
    [Active]    BIT          NOT NULL
);

ALTER TABLE [dbo].[User]
	ADD  [IdClientManager]  INT  NULL

ALTER TABLE [dbo].[User]
    ADD CONSTRAINT [FK_User_ClientManager] FOREIGN KEY ([IdClientManager]) REFERENCES [dbo].[ClientManager] ([IdClientManager]) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE [dbo].[Viewer]
    ADD CONSTRAINT [PK_Viewer] PRIMARY KEY CLUSTERED ([IdViewer] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

ALTER TABLE [dbo].[Viewer]
    ADD CONSTRAINT [UQ_Viewer] UNIQUE NONCLUSTERED ([Username] ASC, [IdClientManager] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF) ON [PRIMARY];

ALTER TABLE [dbo].[ClientManager]
    ADD CONSTRAINT [UQ_Website] UNIQUE NONCLUSTERED (Website ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF) ON [PRIMARY];

ALTER TABLE [dbo].[ClientManager]
    ADD [IdSecurityQuestion]     INT           NULL

ALTER TABLE [dbo].[ClientManager] ADD [AnswerSecurityQuestion] [varchar](max) NULL

ALTER TABLE [dbo].[ViewerAccessRightXUser]
    ADD CONSTRAINT [PK_ViewerAccessRightXUser] PRIMARY KEY CLUSTERED ([IdViewer] ASC, [IdUser] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

ALTER TABLE [dbo].[ViewerSection]
    ADD CONSTRAINT [PK_ViewerSection] PRIMARY KEY CLUSTERED ([IdSection] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

ALTER TABLE [dbo].[Viewer]
    ADD CONSTRAINT [FK_Viewer_ClientManager] FOREIGN KEY ([IdClientManager]) REFERENCES [dbo].[ClientManager] ([IdClientManager]) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE [dbo].[ViewerAccessRightXUser]
    ADD CONSTRAINT [FK_ViewerAccessRightXUser_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[User] ([IdUser]) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE [dbo].[ViewerAccessRightXUser]
    ADD CONSTRAINT [FK_ViewerAccessRightXUser_Viewer] FOREIGN KEY ([IdViewer]) REFERENCES [dbo].[Viewer] ([IdViewer]) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE [dbo].[ViewerAccessRightXUser]
    ADD CONSTRAINT [FK_ViewerAccessRightXUser_ViewerSection] FOREIGN KEY ([IdSection]) REFERENCES [dbo].[ViewerSection] ([IdSection]) ON DELETE NO ACTION ON UPDATE NO ACTION;

INSERT INTO [dbo].[ViewerSection]([Name],[Active])
VALUES('Reports' ,1)

ALTER TABLE [dbo].[ClientManager]
    ADD CONSTRAINT [FK_ClientManager_SecurityQuestion] FOREIGN KEY ([IdSecurityQuestion]) REFERENCES [dbo].[SecurityQuestion] ([IdSecurityQuestion]) ON DELETE NO ACTION ON UPDATE NO ACTION;


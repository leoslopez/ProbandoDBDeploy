CREATE TABLE [dbo].[ViewerAccessRightXUser] (
    [IdViewer]        INT      NOT NULL,
    [IdUser]          INT      NOT NULL,
    [IdSection]       INT      NOT NULL,
    [AccessLevel]     INT      NOT NULL,
    [UTCCreationDate] DATETIME NOT NULL
);


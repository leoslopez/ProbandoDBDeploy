CREATE TABLE [dbo].[ImportRequest] (
    [IdImportRequest]        INT           IDENTITY (1, 1) NOT NULL,
    [IdUser]                 INT           NOT NULL,
    [IdSubscriberList]       INT           NOT NULL,
    [Filename]               VARCHAR (200) NOT NULL,
    [FileType]               CHAR (4)      NOT NULL,
    [DeleteCustomFieldsData] BIT           NULL
);




CREATE TABLE [dbo].[BlackListDomain] (
    [Domain]          NVARCHAR (200) NOT NULL,
    [UTCCreationDate] DATETIME       NULL,
    [IdSource]        INT            NULL,
    [Marked]          BIT            NOT NULL,
    [MarkedFirstTime] INT            NULL,
    [IsInListProcess] BIT            NOT NULL,
    PRIMARY KEY CLUSTERED ([Domain] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF)
);

 
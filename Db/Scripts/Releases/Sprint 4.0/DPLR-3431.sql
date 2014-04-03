-- =============================================
-- Script Template
-- =============================================
CREATE TABLE [dbo].[FunctionRequestByIp] (
    [SourceIPAddress]   VARCHAR (50) NOT NULL,
    [FunctionRequested] INT          NOT NULL,
    [Quantity]          INT          NOT NULL,
    [LastRequest]       DATETIME     NOT NULL
);

ALTER TABLE [dbo].[FunctionRequestByIp]
    ADD CONSTRAINT [PK_FunctionRequestByIp] PRIMARY KEY CLUSTERED ([SourceIPAddress] ASC, [FunctionRequested] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

ALTER TABLE [dbo].[FunctionRequestByIp]
    ADD CONSTRAINT [DF_FunctionRequestByIp_Quantity] DEFAULT ((0)) FOR [Quantity];


/* Also renamed BlacklistEntry to BlackListEntry*/
/* Run If needed*/
EXEC sp_rename 'BlacklistEntry', 'BlackListEntry'

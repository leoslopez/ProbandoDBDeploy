CREATE TABLE [dbo].[ConsumerTypes] (
    [IdConsumerType] INT           IDENTITY (1, 1) NOT NULL,
    [Name]           VARCHAR (50)  NOT NULL,
    [Description]    VARCHAR (100) NOT NULL,
    [IdCountry]      INT           NULL,
    [RequiredFields] BIT           NOT NULL,
    [Active]         BIT           NULL,
    PRIMARY KEY CLUSTERED ([IdConsumerType] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF)
);








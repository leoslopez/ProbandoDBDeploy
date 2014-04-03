CREATE TABLE [dbo].[SocialNetwork] (
    [IdSocialNetwork]  INT           IDENTITY (1, 1) NOT NULL,
    [Name]             VARCHAR (50)  NOT NULL,
    [Active]           BIT           NOT NULL,
    [IsForShared]      BIT           NULL,
    [IsForAutoPublish] BIT           NULL,
    [Like]             BIT           NULL,
    [ShareUrlTemplate] VARCHAR (150) NULL,
	[SortOrder]		   TINYINT		 NOT NULL
);








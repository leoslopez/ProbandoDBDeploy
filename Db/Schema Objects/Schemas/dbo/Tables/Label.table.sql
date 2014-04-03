CREATE TABLE [dbo].[Label] (
    [IdLabel]   INT          IDENTITY (1, 1) NOT NULL,
    [Name]      VARCHAR (50) NOT NULL,
    [IdColour]  INT          NULL,
    [IdUser]    INT          NULL,
    [LabelType] VARCHAR (20) NULL
);




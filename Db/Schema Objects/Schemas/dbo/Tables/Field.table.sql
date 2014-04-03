CREATE TABLE [dbo].[Field] (
    [IdField]      INT          IDENTITY (30000, 1) NOT NULL,
    [IdUser]       INT          NOT NULL,
    [Name]         VARCHAR (50) NOT NULL,
    [Active]       BIT          NULL,
    [IsBasicField] BIT          NOT NULL,
    [IsPrivate]    BIT          NULL,
    [SampleValue]  VARCHAR (50) NOT NULL,
    [IsReadOnly]   BIT          NULL,
    [DataType]     SMALLINT     NOT NULL
) ON [Field]
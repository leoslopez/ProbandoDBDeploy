CREATE TABLE [dbo].[DomainKeyInformation] (
    [IdUser]                    INT           NOT NULL,
    [OrganizationName]          NVARCHAR (50) NULL,
    [OrganizationUnit]          NVARCHAR (50) NULL,
    [ResponsiblePerson]         NVARCHAR (50) NULL,
    [PersonEmail]               NVARCHAR (50) NULL,
    [AbuseEmail]                NVARCHAR (50) NULL,
    [Domain]                    NVARCHAR (50) NULL,
    [IsDomainKeyActive]         BIT           NOT NULL,
    [RegistryNameToAbuse]       VARCHAR (256) NULL,
    [RegistryNameToVerifyEmail] VARCHAR (256) NULL,
    [ValueNameToAbuse]          VARCHAR (256) NULL,
    [ValueNameToVerifyEmail]    VARCHAR (256) NULL,
    [DomainKeyRequestStatus]    INT           NOT NULL,
    [City]                      VARCHAR (256) NULL,
    [IdState]                   INT           NOT NULL,
    [IdCountry]                 INT           NOT NULL,
    [Date]                      DATETIME      NULL,
    [PublicKey]                 VARCHAR (700) NULL,
    [Verified]                  BIT           NULL
);








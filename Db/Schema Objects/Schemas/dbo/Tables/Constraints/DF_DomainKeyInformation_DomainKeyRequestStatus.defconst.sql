ALTER TABLE [dbo].[DomainKeyInformation]
    ADD CONSTRAINT [DF_DomainKeyInformation_DomainKeyRequestStatus] DEFAULT ((0)) FOR [DomainKeyRequestStatus];


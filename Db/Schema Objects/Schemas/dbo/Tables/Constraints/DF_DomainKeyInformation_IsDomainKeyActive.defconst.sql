ALTER TABLE [dbo].[DomainKeyInformation]
    ADD CONSTRAINT [DF_DomainKeyInformation_IsDomainKeyActive] DEFAULT ((0)) FOR [IsDomainKeyActive];


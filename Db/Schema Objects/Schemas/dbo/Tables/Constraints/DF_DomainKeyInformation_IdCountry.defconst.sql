ALTER TABLE [dbo].[DomainKeyInformation]
    ADD CONSTRAINT [DF_DomainKeyInformation_IdCountry] DEFAULT ((1)) FOR [IdCountry];


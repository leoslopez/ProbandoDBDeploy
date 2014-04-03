ALTER TABLE [dbo].[Field]
    ADD CONSTRAINT [CK_Field_Name] CHECK (NOT ([Name]='firstname' OR [Name]='lastname' OR [Name]='email' OR [Name]='country' OR [Name]='GENDER' OR [Name]='BIRTHDAY'));


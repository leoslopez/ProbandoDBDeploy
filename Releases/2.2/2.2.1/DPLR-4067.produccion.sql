

-- un comentario modificado
ALTER TABLE [user]
ALTER COLUMN PhoneNumber varchar(25) null
GO
ALTER TABLE [user]
ALTER COLUMN Address varchar(100) null
GO
ALTER TABLE [user]
ALTER COLUMN GoogleAnalyticName varchar(300) null
GO
ALTER TABLE [dbo].[User]
    ADD [MigrationState] INT NULL
GO

set identity_insert dbo.Industry on 
INSERT INTO dbo.Industry (IdIndustry,DescriptionES,DescriptionEN)
select 0,'Otros','Others'
set identity_insert dbo.Industry off
GO

set identity_insert [UserTimeZone] on
INSERT INTO [UserTimeZone] ([IdUserTimeZone]
      ,[Name]
      ,[Offset])
      
select 1,'(GMT-12:00) International Date Line West',-720
INSERT INTO [UserTimeZone] ([IdUserTimeZone]
      ,[Name]
      ,[Offset])
      
select 3,'(GMT-10:00) Hawaii',-600
INSERT INTO [UserTimeZone] ([IdUserTimeZone]
      ,[Name]
      ,[Offset])
      
select	26,'(GMT) Greenwich Mean Time : Dublin, Edinburgh, Lisbon, London',0
INSERT INTO [UserTimeZone] ([IdUserTimeZone]
      ,[Name]
      ,[Offset])
      
select 28,'(GMT+01:00) Belgrade, Bratislava, Budapest, Ljubljana, Prague',60
INSERT INTO [UserTimeZone] ([IdUserTimeZone]
      ,[Name]
      ,[Offset])
      
select 31,'(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna',60
INSERT INTO [UserTimeZone] ([IdUserTimeZone]
      ,[Name]
      ,[Offset])
      
select 35,'(GMT+02:00) Helsinki, Kyiv, Riga, Sofia, Tallinn, Vilnius',120
set identity_insert [UserTimeZone] off

GO


  
  CREATE PROCEDURE [dbo].[InsertFieldXSubscriber] @Table TYPEFIELDXSUBSCRIBER READONLY 
AS 
  BEGIN       
	  MERGE [dbo].FieldXSubscriber  WITH (HOLDLOCK) AS [Target]
      USING (SELECT t.IdField, 
                    t.IdSubscriber, 
                    t.Value 
             FROM   @Table t) AS [Source] 
      ON ( [Target].IdField = [Source].IdField 
           AND [Target].IdSubscriber = [Source].IdSubscriber ) 
      WHEN MATCHED THEN 
        UPDATE SET [Target].Value = [Source].Value 
      WHEN NOT MATCHED THEN 
        INSERT (IdField, 
                IdSubscriber, 
                Value) 
        VALUES ([Source].IdField, 
                [Source].IdSubscriber, 
                [Source].Value); 
  END
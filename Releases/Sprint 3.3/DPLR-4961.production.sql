CREATE TYPE TypeSubscriberXList AS TABLE ( IdSubscriber BIGINT ) 
CREATE TYPE TypeFieldXSubscriber AS TABLE ( IdField INT, IdSubscriber BIGINT, Value NVARCHAR(400) )
GO

CREATE PROCEDURE [dbo].[ImportAddSubscriber] @IdUser         INT, 
                                            @Email          VARCHAR(100), 
                                            @FirstName      VARCHAR(150), 
                                            @LastName       VARCHAR(150), 
                                            @Gender         CHAR(1), 
                                            @UTCBirthday    DATE, 
                                            @IdCountry      INT, 
                                            @PlanType       SMALLINT, 
                                            @MaxSubscribers INT 
AS 
  BEGIN 
      DECLARE @AmountSubscribers INT 
      DECLARE @tempTable TABLE 
        ( 
           MergeAction        VARCHAR(20), 
           IDSubscriber       INT, 
           IdSubscriberStatus INT 
        ) 

      SELECT @AmountSubscribers = CASE 
                                    --Free 
                                    WHEN @PlanType = 1 THEN (SELECT COUNT(IdSubscriber) 
                                                             FROM   dbo.Subscriber s 
                                                             WHERE  s.IdUser = @IdUser 
                                                                    AND s.IdSubscribersStatus <> 7)
                                    --Subscriber 
                                    WHEN @PlanType = 4 THEN (SELECT COUNT(IdSubscriber) 
                                                             FROM   dbo.Subscriber s 
                                                             WHERE  s.IdUser = @IdUser 
                                                                    AND s.IdSubscribersStatus IN( 1, 2, 6 ))
                                    ELSE 0 
                                  END 

      -- If a record exists, increment a counter by one; otherwise, insert the record with a value of one. The following MERGE statement wraps this logic and uses the HOLDLOCK hint to avoid race conditions.  
      MERGE [dbo].[Subscriber] WITH (HOLDLOCK) AS [Target]
      USING (SELECT 1 AS One) AS [Source] 
      ON ( [Target].Email = @Email 
           AND [Target].IdUser = @IdUser ) 
      WHEN MATCHED  AND [Target].IdSubscribersStatus IN (1,2,7) THEN 
        UPDATE SET [Target].Gender = @Gender, 
                   [Target].UTCBirthday = @UTCBirthday, 
                   [Target].IdCountry = @IdCountry, 
                   [Target].FirstName = @FirstName, 
                   [Target].LastName = @LastName 
      WHEN NOT MATCHED AND @MaxSubscribers > @AmountSubscribers THEN 
        INSERT ([IdUser], 
                [Email], 
                [Gender], 
                [UTCBirthday], 
                [IdCountry], 
                [FirstName], 
                [LastName], 
                IdSubscribersStatus, 
                IdSubscriberSourceType, 
                UTCCreationDate) 
        VALUES (@IdUser, 
                @Email, 
                @Gender, 
                @UTCBirthday, 
                @IdCountry, 
                @FirstName, 
                @LastName, 
                1, 
                2, 
                GETUTCDATE()) 
      OUTPUT $action, 
             INSERTED.IdSubscriber, 
             INSERTED.IdSubscribersStatus 
      INTO @tempTable; 

      IF @@ROWCOUNT > 0 
        BEGIN 
            SELECT tt.IDSubscriber, 
                   case 
                     WHEN tt.MergeAction = 'UPDATE' then 1 
                     else 0 
                   END as WasUpdate, 
				   case 
                     WHEN tt.MergeAction = 'INSERT' then 1 
                     else 0 
                   END as WasInsert,
                   case 
                     WHEN @AmountSubscribers + 1 < @MaxSubscribers THEN 0 
                     WHEN tt.MergeAction = 'INSERT' 
                          AND @AmountSubscribers + 1 >= @MaxSubscribers then 1 
                     WHEN tt.MergeAction = 'UPDATE' 
                          AND @AmountSubscribers >= @MaxSubscribers then 1 
                     else 0 
                   END as Reached, 
                   tt.IdSubscriberStatus 
            FROM   @tempTable tt 
        END 
      ELSE 
        BEGIN 
			    DECLARE @IdSubscriber BIGINT 
			    DECLARE @IdSubscribersStatus INT 
				SET @IdSubscriber = 0
				SET @IdSubscribersStatus = 0

				SELECT @IdSubscriber = s.IdSubscriber, @IdSubscribersStatus = s.IdSubscribersStatus FROM dbo.Subscriber s WHERE s.Email = @Email AND s.IdSubscribersStatus IN (3,4,5,6,8)
				IF @IdSubscriber > 0
					SELECT @IdSubscriber, 0 WasUpdate, 0 WasInsert, 0 Reached, @IdSubscribersStatus IdSubscriberStatus
				ELSE
					SELECT null IDSubscriber, 0 WasUpdate, 0 WasInsert, 1 Reached, 0 IdSubscriberStatus
        END 
  END 
  GO
  
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
  GO
  
  CREATE PROCEDURE InsertSubscriberXList @Table            TYPESUBSCRIBERXLIST READONLY, 
                                      @IdSubscriberList INT 
AS 
    INSERT INTO SubscriberXList 
    SELECT @IdSubscriberList, 
           IdSubscriber, 
           1, 
           NULL 
    FROM   @Table 
    EXCEPT 
    SELECT @IdSubscriberList, 
           IdSubscriber, 
           1, 
           NULL 
    FROM   SubscriberXList 
    WHERE  IdSubscribersList = @IdSubscriberList 
    GO
    
ALTER TABLE BlackListDomain
	ADD  [UTCCreationDate] DATETIME NULL
GO

ALTER TABLE BlackListDomain
	ADD [IdSource] INT NULL
GO

ALTER TABLE BlackListEmail
	ADD  [UTCCreationDate] DATETIME NULL
GO

ALTER TABLE BlackListEmail
	ADD [IdSource] INT NULL
GO

CREATE TABLE [dbo].[BlackListSource] (
    [IdSource] INT IDENTITY (1, 1) NOT NULL,
	[Description] VARCHAR(max)
);
GO

ALTER TABLE [dbo].[BlackListSource]
    ADD CONSTRAINT [PK_BlackListSource] PRIMARY KEY CLUSTERED ([IdSource] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF)
GO

ALTER TABLE [dbo].[BlackListDomain]
    ADD CONSTRAINT [FK_BlackListSource_BlackListDomain] FOREIGN KEY ([IdSource]) REFERENCES [dbo].[BlackListSource] ([IdSource]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

ALTER TABLE [dbo].[BlackListEmail]
    ADD CONSTRAINT [FK_BlackListSource_BlackListEmail] FOREIGN KEY ([IdSource]) REFERENCES [dbo].[BlackListSource] ([IdSource]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

CREATE PROCEDURE RemoveSubscriberBelongingToBlacklist  @Email VARCHAR(100)
AS
	UPDATE Subscriber
	SET IdSubscribersStatus = 5
	WHERE Email = @Email

	DELETE FROM dbo.SubscriberXList
	FROM dbo.SubscriberXList sxl
	JOIN dbo.Subscriber s on sxl.IdSubscriber = s.IdSubscriber
	WHERE s.Email = @Email
  
	DELETE FROM dbo.FieldXSubscriber
	FROM dbo.FieldXSubscriber fxs
	JOIN dbo.Subscriber s on fxs.IdSubscriber = s.IdSubscriber
	WHERE s.Email = @Email
GO






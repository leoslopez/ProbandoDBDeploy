
ALTER PROCEDURE [dbo].[ImportAddSubscriber] @IdUser         INT, 
                                            @Email          VARCHAR(100), 
                                            @FirstName      NVARCHAR(150), 
                                            @LastName       NVARCHAR(150), 
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

      IF( @PlanType IN ( 1, 4 ) ) 
        BEGIN 
            SELECT @AmountSubscribers = CASE 
                                          --Free  
                                          WHEN @PlanType = 1 THEN (SELECT COUNT(IdSubscriber)
                                                                   FROM   dbo.Subscriber s WITH(NOLOCK)
                                                                   WHERE  s.IdUser = @IdUser 
                                                                          AND s.IdSubscribersStatus <> 7)
                                          --Subscriber  
                                          WHEN @PlanType = 4 THEN (SELECT COUNT(IdSubscriber)
                                                                   FROM   dbo.Subscriber s  WITH(NOLOCK)
                                                                   WHERE  s.IdUser = @IdUser 
                                                                          AND s.IdSubscribersStatus IN( 1, 2, 6 ))
                                          ELSE 0 
                                        END 
        END 
      ELSE 
        SET @AmountSubscribers = 0 

      -- If a record exists, increment a counter by one; otherwise, insert the record with a value of one. The following MERGE statement wraps this logic and uses the HOLDLOCK hint to avoid race conditions.  
      MERGE [dbo].[Subscriber] WITH(HOLDLOCK) AS [Target] 
      USING (SELECT 1 AS One) AS [Source] 
      ON ( [Target].Email = @Email 
           AND [Target].IdUser = @IdUser ) 
      WHEN MATCHED AND [Target].IdSubscribersStatus IN (1, 2, 7) THEN 
        UPDATE SET [Target].Gender = @Gender, 
                   [Target].UTCBirthday = @UTCBirthday, 
                   [Target].IdCountry = @IdCountry, 
                   [Target].FirstName = @FirstName, 
                   [Target].LastName = @LastName,
                   [Target].IdSubscribersStatus = CASE 
													WHEN [Target].IdSubscribersStatus = 2 THEN 1
													ELSE [Target].IdSubscribersStatus
												  END
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

            SELECT @IdSubscriber = s.IdSubscriber, 
                   @IdSubscribersStatus = s.IdSubscribersStatus 
            FROM   dbo.Subscriber s  WITH(NOLOCK)
            WHERE  s.IdUser = @IdUser 
                   and s.Email = @Email 
                   AND s.IdSubscribersStatus IN ( 3, 4, 5, 6, 8 ) 

            IF @IdSubscriber > 0 
              SELECT @IdSubscriber, 
                     0                    WasUpdate, 
                     0                    WasInsert, 
                     0                    Reached, 
                     @IdSubscribersStatus IdSubscriberStatus 
            ELSE 
              SELECT null IDSubscriber, 
                     0    WasUpdate, 
                     0    WasInsert, 
                     1    Reached, 
                     0    IdSubscriberStatus 
        END 
  END 

CREATE PROCEDURE [sp_recorrido] AS

DECLARE    @Codigo INT

-- Recorrido y visualización del código
SET @Codigo=0
DECLARE ElCursor CURSOR STATIC LOCAL FORWARD_ONLY FOR
                    SELECT IdSubscriber                    
                    FROM Subscriber
                    WHERE IdSubscriber >=  5525293

OPEN ElCursor FETCH NEXT FROM ElCursor INTO @Codigo
        WHILE (@@FETCH_STATUS = 0) BEGIN
            UPDATE Subscriber SET IdUser=517 WHERE IdSubscriber=@Codigo;    
            INSERT INTO SubscriberXList(IdSubscribersList,IdSubscriber,Active,UTCDeleteDate) VALUES(6821,@Codigo,1,null);
            print @Codigo
            FETCH NEXT FROM ElCursor INTO @Codigo
        END
CLOSE ElCursor
DEALLOCATE ElCursor
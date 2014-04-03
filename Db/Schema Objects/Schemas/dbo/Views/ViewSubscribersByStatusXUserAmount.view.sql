
CREATE VIEW [dbo].[ViewSubscribersByStatusXUserAmount] 
WITH SCHEMABINDING 
AS 
  SELECT [S].IdUser, 
         [S].IdSubscribersStatus, 
         COUNT_BIG(*) AS Amount 
  FROM   [dbo].[Subscriber] AS s 
  GROUP  BY [S].IdUser, 
            [S].IdSubscribersStatus
print 'Rollback Subscribers_SubscriberRemovedByCampaign_GX'
GO 

ALTER PROCEDURE [dbo].[Subscribers_SubscriberRemovedByCampaign_GX]  
@campaignID int,  
@howMany int  
AS  
SET ROWCOUNT @howMany  
  
SELECT s.email, s.Firstname, s.Lastname, ISNULL ( s.UTCUnsubDate , GetDate() )  
FROM dbo.Subscriber s WITH(NOLOCK)  
WHERE s.UnsubCampaign  IN (SELECT IdCampaign FROM GetTestABSet(@campaignID))  
ORDER BY UTCUnsubDate desc 
GO


print 'Add UnsubCampaign'
ALTER TABLE dbo.Subscriber
ADD UnsubCampaign INT NULL
GO

--------------------------------------------------------------------------------------------------------------------------------------
--------------------------CUIDADO!!!!! LA EJECUCION DE ESTO VA A CREAR UN INDICE LO CUAL VA A COLGAR LA BASE--------------------------
--------------------------------------------------------------------------------------------------------------------------------------
print 'Se esta creando un indice, esto puede tardar!!!!'
CREATE NONCLUSTERED INDEX [IX_Subscriber_IdCampaign] ON [dbo].[Subscriber] 
(
	[IdCampaign] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [Subscriber]
GO


print 'Update Subscribers_SubscriberRemovedByCampaign_GX'
GO 

ALTER PROCEDURE [dbo].[Subscribers_SubscriberRemovedByCampaign_GX]  
@campaignID int,  
@howMany int  
AS  
SET ROWCOUNT @howMany  
  
SELECT s.email, s.Firstname, s.Lastname, ISNULL ( s.UTCUnsubDate , GetDate() )  
FROM dbo.Subscriber s WITH(NOLOCK)  
WHERE s.IdCampaign  IN (SELECT IdCampaign FROM GetTestABSet(@campaignID))  
ORDER BY UTCUnsubDate desc 
GO


print 'Unify IdCampaign and UnsubCampaign'
UPDATE dbo.Subscriber
	SET IdCampaign = UnsubCampaign
WHERE IdCampaign IS NULL AND IdCampaign <>	UnsubCampaign
GO	

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Subscriber]') AND name = N'IX_Subscriber_UnsubCampaign')
DROP INDEX [IX_Subscriber_UnsubCampaign] ON [dbo].[Subscriber] WITH ( ONLINE = OFF )
GO

ALTER TABLE dbo.Subscriber
DROP COLUMN UnsubCampaign
GO

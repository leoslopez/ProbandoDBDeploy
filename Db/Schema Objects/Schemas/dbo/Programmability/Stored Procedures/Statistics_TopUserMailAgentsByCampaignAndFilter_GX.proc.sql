CREATE PROCEDURE [dbo].[Statistics_TopUserMailAgentsByCampaignAndFilter_GX]
@IdCampaign int,
@EmailNameFilter varchar(50),
@firstNameFilter varchar(50),
@LastNameFilter varchar(50)
AS
    DECLARE @t TABLE 
      ( 
         idcampaign INT PRIMARY KEY 
      ); 

    INSERT INTO @t 
    SELECT idcampaign 
    FROM   Gettestabset(@IdCampaign) 

    SELECT u.IdUserMailAgentType, 
           COUNT(c.IdSubscriber) cant 
    FROM   @t t 
           JOIN dbo.CampaignDeliveriesOpenInfo c WITH(NOLOCK) 
             on c.IdCampaign = t.idcampaign 
           JOIN dbo.UserMailAgents u WITH(NOLOCK) 
             ON u.IdUserMailAgent = c.IdUserMailAgent 
           JOIN Subscriber s WITH(NOLOCK) 
             ON c.IdSubscriber = s.IdSubscriber 
    WHERE  s.Email LIKE @EmailNameFilter 
           AND ISNULL(s.Firstname, '') like @FirstNameFilter 
           AND ISNULL(s.lastname, '') like @LastNameFilter 
    GROUP  BY u.IdUserMailAgentType 
    ORDER  BY COUNT(c.IdSubscriber) DESC 
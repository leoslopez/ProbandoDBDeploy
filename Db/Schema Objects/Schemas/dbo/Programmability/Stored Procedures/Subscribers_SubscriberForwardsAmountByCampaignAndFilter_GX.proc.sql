/****** Object:  StoredProcedure [dbo].[Subscribers_SubscriberForwardsAmountByCampaignAndFilter_GX]    Script Date: 08/07/2013 11:43:06 ******/

CREATE PROCEDURE [dbo].[Subscribers_SubscriberForwardsAmountByCampaignAndFilter_GX] 
  --> Devuelve una lista de suscriptores y la cantidad de forwards que hizo cada suscriptor.     
  @Idcampaign      int, 
  @emailFilter     varchar(50), 
  @firstnameFilter varchar(50), 
  @lastnameFilter  varchar(50), 
  @howMany         int 
AS 
    SET ROWCOUNT @howMany 

    DECLARE @t TABLE 
      ( 
         IdCampaign INT PRIMARY KEY 
      ); 

    INSERT INTO @t 
    SELECT IdCampaign 
    FROM   Gettestabset(@IdCampaign) 

    SELECT s.email, 
           s.Firstname, 
           s.Lastname, 
           count(f.email) as ForwardsCount 
    FROM   @t t 
           JOIN dbo.ForwardFriend f WITH(NOLOCK) 
             on t.IdCampaign = f.IdCampaign 
           JOIN dbo.Subscriber s WITH(NOLOCK) 
             ON s.IdSubscriber = f.IdSubscriber 
    WHERE  s.email like @emailFilter 
           AND ISNULL(s.Firstname, '') like @firstnameFilter 
           AND ISNULL(s.lastname, '') like @lastnameFilter 
    GROUP  BY s.email, 
              s.Firstname, 
              s.Lastname 
    ORDER  BY count(f.email) desc 
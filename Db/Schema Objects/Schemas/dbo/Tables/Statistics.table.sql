CREATE TABLE [dbo].[Statistics] 
  ( 
     [StatsId]           [int] IDENTITY(1, 1) NOT FOR REPLICATION NOT NULL, 
     [EmailsQtyByDay]    [bigint] NULL, 
     [CampaignsQtyByDay] [bigint] NULL, 
     [Date]              [datetime] NULL, 
  ) 
ON [PRIMARY] 

GO 

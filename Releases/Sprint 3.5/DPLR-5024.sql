DECLARE @temp TABLE(
 IdFilter INT
)

INSERT INTO @temp (IdFilter) 
select f.IdFilter from dbo.Filter f
EXCEPT
select f.IdFilter from dbo.Filter f 
join dbo.Segment s on (s.IdFilter = f.IdFilter OR s.IdFilter = f.ParentFilter)

DELETE FROM dbo.FilterBySubscribersList
FROM dbo.FilterBySubscribersList fsl
join @temp t on fsl.IdFilter = t.IdFilter

DELETE FROM dbo.FilterByCampaignDeliveries
FROM dbo.FilterByCampaignDeliveries fsl
join @temp t on fsl.IdFilter = t.IdFilter

DELETE From dbo.Filter
FROM dbo.Filter f
JOIN @temp t on (t.IdFilter = f.IdFilter)
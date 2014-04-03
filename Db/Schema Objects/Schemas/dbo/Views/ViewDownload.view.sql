CREATE VIEW [dbo].[ViewDownload]
AS SELECT RR.IdRequest as IdDownload, C.IdUser as IdUser, 'Report' as Type, RR.TimeStamp as UTCCreationDate, 3 as OriginExport, [dbo].[ReportStatusToInt](RR.Status) as Status, (CAST(RR.IdCampaign AS NVARCHAR(50)) + '_' + RR.ReportType + '.zip') as Name, RR.URLPath as FilePath, 1 as FileTypeExport FROM [dbo].[ReportRequest] RR
INNER JOIN [dbo].[Campaign] C ON RR.IdCampaign = C.IdCampaign
WHERE RR.Status != 'Erased' 
AND RR.Active = 1
UNION ALL
SELECT IdDownload, IdUSer, 'Download' as Type, UTCCreationDate, OriginExport, Status, Name, FilePath, FileTypeExport FROM [dbo].[Downloads]
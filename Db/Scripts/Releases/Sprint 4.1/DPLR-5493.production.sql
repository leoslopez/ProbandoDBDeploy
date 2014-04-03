/****** Object:  StoredProcedure [dbo].[ReportExport_Request_GA]    Script Date: 08/07/2013 11:36:46 ******/

ALTER PROCEDURE [dbo].[ReportExport_Request_GA]  
AS  
BEGIN  
   SELECT RR.IdRequest
   , RR.IdCampaign
   , RR.IdCampaignStatus
   , RR.ReportType
   , RR.RequestExportType
   , RR.[Status]
   , RR.[TimeStamp]
   , RR.Progress
   , RR.URLPath
   , RR.[FileName]
   , RR.EmailAlert
   , RR.Filter
   , RR.FirstNameFilter
   , RR.LastNameFilter
   , RR.EMailFilter
   , RR.[Language]
   , UTZ.Offset
   FROM ReportRequest RR WITH(NOLOCK)
	INNER JOIN Campaign C WITH(NOLOCK) ON(RR.IdCampaign = C.IdCampaign)
	INNER JOIN [User] U WITH(NOLOCK) ON(C.IdUser = U.IdUser)
	INNER JOIN UserTimeZone UTZ WITH(NOLOCK) ON(U.IdUserTimeZone = UTZ.IdUserTimeZone)
   WHERE RR.Active = 1
   AND RR.Progress = 0
   ORDER BY RR.[TimeStamp] ASC  
END
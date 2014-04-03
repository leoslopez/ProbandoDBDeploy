/****** Object:  StoredProcedure [dbo].[ReportExport_RequestWithSubscriberFilter_A]    Script Date: 08/07/2013 11:38:01 ******/

CREATE PROCEDURE [dbo].[ReportExport_RequestWithSubscriberFilter_A]
@IdCampaign int,
@IdCampaignStatus int,
@ReportType varchar(100),
@RequestExportType varchar(100),
@Status varchar(50),
@Language varchar(50),
@EmailFilter varchar(50),
@FirstNameFilter varchar(50),
@LastNameFilter varchar(50),
@EmailAlert varchar(250)
AS
BEGIN TRY
BEGIN TRAN
DELETE FROM ReportRequest WITH(ROWLOCK)
WHERE IdCampaign=@IdCampaign AND @ReportType=ReportType

INSERT INTO ReportRequest(IdCampaign, IdCampaignStatus , ReportType, RequestExportType,
[Status], [Language],EmailFilter, FirstNameFilter, LastNameFilter, EmailAlert)
VALUES(@IdCampaign, @IdCampaignStatus, @ReportType, @RequestExportType,
@Status, @Language, @EmailFilter, @FirstNameFilter, @LastNameFilter, @EmailAlert)
SELECT SCOPE_IDENTITY()
COMMIT TRAN
END TRY
BEGIN CATCH
ROLLBACK TRAN
END CATCH
GO
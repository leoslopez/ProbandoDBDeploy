
CREATE PROCEDURE [dbo].[ReportExport_RequestWithFilterAndSubscriberFilter_A]
@IdCampaign int,
@IdCampaignStatus int,
@ReportType varchar(100),
@RequestExportType varchar(100),
@Status varchar(50),
@Language varchar(50),
@Filter varchar(200),
@EmailFilter varchar(50),
@FirstNameFilter  nvarchar(50),
@LastNameFilter nvarchar(50),
@EmailAlert varchar(250)
AS
BEGIN TRY
BEGIN TRAN
DELETE FROM ReportRequest WITH(ROWLOCK)
WHERE IdCampaign=@IdCampaign AND @ReportType=ReportType

INSERT INTO ReportRequest(IdCampaign, IdCampaignStatus, ReportType, RequestExportType,
[Status], [Language], Filter, EmailFilter, FirstNameFilter, LastNameFilter, EmailAlert)
VALUES(@IdCampaign, @IdCampaignStatus, @ReportType, @RequestExportType, @Status,
@Language, @Filter, @EmailFilter, @FirstNameFilter, @LastNameFilter, @EmailAlert)
SELECT SCOPE_IDENTITY()
COMMIT TRAN
END TRY
BEGIN CATCH
ROLLBACK TRAN
END CATCH
GO
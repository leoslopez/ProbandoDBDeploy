/****** Object:  StoredProcedure [dbo].[ReportExport_Request_A]    Script Date: 08/07/2013 11:36:19 ******/

CREATE PROCEDURE [dbo].[ReportExport_Request_A]
@IdCampaign int,
@IdCampaignStatus int,
@ReportType varchar(100),
@RequestExportType varchar(100),
@Status varchar(50),
@Language varchar(50),
@EmailAlert varchar(250)
AS
BEGIN TRY
BEGIN TRAN
DELETE FROM ReportRequest WITH(ROWLOCK)
WHERE IdCampaign=@IdCampaign AND @ReportType=ReportType

INSERT INTO ReportRequest (IdCampaign, IdCampaignStatus, ReportType,
RequestExportType, [Status], [Language], EmailAlert)
VALUES (@IdCampaign, @IdCampaignStatus, @ReportType, @RequestExportType,
@Status, @Language, @EmailAlert)
SELECT SCOPE_IDENTITY()
COMMIT TRAN
END TRY
BEGIN CATCH
ROLLBACK TRAN
END CATCH
GO
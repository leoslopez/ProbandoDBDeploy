/****** Object:  StoredProcedure [dbo].[ReportExport_RequestWithFilter_A]    Script Date: 08/07/2013 11:37:51 ******/

CREATE PROCEDURE [dbo].[ReportExport_RequestWithFilter_A]
@IdCampaign int,
@IdCampaignStatus int,
@ReportType varchar(100),
@RequestExportType varchar(100),
@Status varchar(50),
@Language varchar(50),
@Filter varchar(200),
@EmailAlert varchar(250)
AS
BEGIN TRY
BEGIN TRAN
DELETE FROM ReportRequest WITH(ROWLOCK)
WHERE IdCampaign=@Idcampaign AND @ReportType=ReportType

INSERT INTO ReportRequest(IdCampaign, IdCampaignStatus, ReportType,
RequestExportType, [Status], [Language], Filter, EmailAlert)
VALUES(@IdCampaign, @IdCampaignStatus, @ReportType, @RequestExportType,
@Status, @Language, @Filter, @EmailAlert)
SELECT SCOPE_IDENTITY()
COMMIT TRAN
END TRY
BEGIN CATCH
ROLLBACK TRAN
END CATCH
GO
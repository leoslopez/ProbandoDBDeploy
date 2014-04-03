ALTER TABLE dbo.ReportRequest DROP CONSTRAINT DF_ReportRequest_TimeStamp;

ALTER TABLE dbo.ReportRequest ADD CONSTRAINT DF_ReportRequest_TimeStamp DEFAULT GETUTCDATE() FOR TimeStamp;
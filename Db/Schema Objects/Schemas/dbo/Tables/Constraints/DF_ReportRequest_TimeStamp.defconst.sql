ALTER TABLE [dbo].[ReportRequest]
    ADD CONSTRAINT [DF_ReportRequest_TimeStamp] DEFAULT (getutcdate()) FOR [TimeStamp];




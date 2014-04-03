ALTER TABLE [dbo].[ReportRequest]
	ADD  CONSTRAINT [DF_ReportRequest_Progress]  DEFAULT ((0)) FOR [Progress];
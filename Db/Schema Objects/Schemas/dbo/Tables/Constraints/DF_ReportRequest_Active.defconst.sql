ALTER TABLE [dbo].[ReportRequest]
	ADD  CONSTRAINT [DF_ReportRequest_Active]  DEFAULT ((1)) FOR [Active];
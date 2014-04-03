ALTER TABLE [dbo].[SubscribersListFilter]
	ADD  CONSTRAINT [DF_SubscribersListFilter_Active]  DEFAULT ('1') FOR [Active];
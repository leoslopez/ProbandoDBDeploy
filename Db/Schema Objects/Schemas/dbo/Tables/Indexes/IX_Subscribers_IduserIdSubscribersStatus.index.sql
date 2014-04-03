CREATE NONCLUSTERED INDEX [IX_Subscribers_IduserIdSubscribersStatus]
    ON [dbo].[Subscriber]([IdUser] ASC, [IdSubscribersStatus] ASC)
    INCLUDE([IdSubscriber], [ConsecutiveUnopendedEmails], [ConsecutiveHardBounced], [ConsecutiveSoftBounced], [Email], [Ranking], [IdSubscriberSourceType], [UTCCreationDate], [Gender], [UTCBirthday], [IdCountry], [FirstName], [LastName], [IdCampaign], [UTCUnsubDate], [UTCLastOpen], [IdUnsubscriptionReason]) WITH (FILLFACTOR = 95, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [Subscriber];




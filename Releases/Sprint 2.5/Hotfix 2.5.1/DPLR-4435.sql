 -- UPDATE TO NOT PAY FOR SUBSCRIBERS IN "Unsubscribed by Client" STATUS IN A "MONTHLY SUBSCRIBER PLAN"
  update [SubscriberStatus]
  set IsForMonthlyBySubscriber = 0
  where Name = 'Unsubscribed by Client'
-- If UnsubscriberConfirmationUrl starts with "http://" or "https://" nothing needs to be added. Otherwise, the "http://" string will be added.
update [user]
set UnsubscriberConfirmationUrl = 'http://' + UnsubscriberConfirmationUrl
where PATINDEX('%http://%', UnsubscriberConfirmationUrl) = 0 AND PATINDEX('%https://%', UnsubscriberConfirmationUrl) = 0
GO
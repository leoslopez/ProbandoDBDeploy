-- =============================================
-- Post Deployment Script to change the AmountMonthlyEmails dropwdown options in all app.
-- =============================================

USE	Doppler2011_Local
BEGIN
Update [Doppler2011_Local].[dbo].[AmountMonthlyEmails]	SET	[DescriptionEN] = 'I haven´t sent anything yet'	WHERE	IdAmountMonthlyEmails = 10
END
-- =============================================
-- Post Deployment Script to change the dropwdown options in all app.
-- =============================================

USE	Doppler2011_Local
BEGIN
Update [Doppler2011_Local].[dbo].[AmountMonthlyEmails]	SET	[DescriptionES] = 'Aún no he realizado envíos'	WHERE	IdAmountMonthlyEmails = 10
END
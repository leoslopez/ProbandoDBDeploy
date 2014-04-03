-- =============================================
-- Script Template
-- =============================================
ALTER TABLE AccountingEntry ADD Source INT NULL;

CREATE TABLE SourceTypes( Id int NOT NULL,	Description varchar(50) NOT NULL, PRIMARY KEY (Id) )
ALTER TABLE AccountingEntry ADD  CONSTRAINT FK_AccountingEntry_SourceTypes FOREIGN KEY(Source) REFERENCES SourceTypes(Id)

INSERT INTO SourceTypes(Id,Description)VALUES( 1, 'Monthly Payment')
INSERT INTO SourceTypes(Id,Description)VALUES( 2, 'Upgrade')
INSERT INTO SourceTypes(Id,Description)VALUES( 3, 'Buy Credits')

UPDATE AccountingEntry SET Source = 1;

UPDATE [dbo].[AmountMonthlyEmails]	SET	[DescriptionES] = 'Aún no he realizado envíos'	WHERE	IdAmountMonthlyEmails = 10
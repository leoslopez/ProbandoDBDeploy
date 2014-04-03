-- DELETE THE COLUMNS ADDED
ALTER TABLE AccountingEntry
DROP COLUMN	AuthorizationNumber, InvoiceNumber, AccountingTypeDescription
GO

-- DELETE THE TRIGGER
DROP TRIGGER IncrementInvoiceNumber 
GO

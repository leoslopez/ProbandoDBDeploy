
-- CREATION OF TRIGGER TO AUTO INCREMENT INVOICE NUMBER EVERYTIME 
-- AN ACCOUNTING ENTRY OF TYPE INVOICE IS INSERTED TO THE TABLE

CREATE TRIGGER IncrementInvoiceNumber 
   ON  AccountingEntry
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;
    DECLARE @insertedId INT;
    SELECT TOP(1) @insertedId = IdAccountingEntry FROM AccountingEntry ORDER BY IdAccountingEntry DESC;
	UPDATE AccountingEntry SET InvoiceNumber = ( SELECT TOP(1) InvoiceNumber FROM AccountingEntry
												 ORDER BY InvoiceNumber DESC	
												) + 1
						   WHERE IdAccountingEntry = @insertedId AND AccountingTypeDescription = 'Invoice';

END
GO
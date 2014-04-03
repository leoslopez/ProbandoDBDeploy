-- ALTERS TABLE TO SUPPORT NEW COLUMNS
ALTER TABLE AccountingEntry
ADD	AuthorizationNumber  VARCHAR (250)   NULL,
	InvoiceNumber     INT			  NULL,
	AccountingTypeDescription VARCHAR (250) NULL
GO

-- UPDATES THE ENTRIES TO HAVE A DESCRIPTION
  UPDATE AccountingEntry SET AccountingTypeDescription = 'Invoice' WHERE AccountEntryType = 'I'
  UPDATE AccountingEntry SET AccountingTypeDescription = 'CC Payment' WHERE AccountEntryType = 'P' AND PaymentEntryType = 'P'
  UPDATE AccountingEntry SET AccountingTypeDescription = 'Credit Note' WHERE AccountEntryType = 'P' AND PaymentEntryType = 'N'



-- ALTERS THE CURRENT INVOICES IN THE DATABASE TO HAVE THE 
-- INVOICENUMBER SET CORRECTLY

DECLARE @IdAccountingEntry INT, @InvoiceNumber INT

DECLARE AccountingEntryCursor CURSOR FOR 
SELECT IdAccountingEntry FROM AccountingEntry
WHERE AccountEntryType = 'I' AND AccountingTypeDescription = 'Invoice'

OPEN AccountingEntryCursor

FETCH NEXT FROM AccountingEntryCursor 
INTO @IdAccountingEntry

SET @InvoiceNumber = 1
WHILE @@FETCH_STATUS = 0
BEGIN
    UPDATE AccountingEntry
    SET InvoiceNumber = @InvoiceNumber
    WHERE IdAccountingEntry = @IdAccountingEntry AND AccountingTypeDescription = 'Invoice'
    SET @IdAccountingEntry = @IdAccountingEntry + 1
	SET @InvoiceNumber = @InvoiceNumber +1
	FETCH NEXT FROM AccountingEntryCursor 
	INTO @IdAccountingEntry
END 
CLOSE AccountingEntryCursor;
DEALLOCATE AccountingEntryCursor;
GO

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
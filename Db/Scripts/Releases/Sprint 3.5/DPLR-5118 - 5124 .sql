ALTER TABLE dbo.Vendor
ADD CountryAssigned nvarchar(255) NULL,
	Email varchar(550) NULL
GO	

-- INSERT THE NEW SALESMAN
INSERT INTO dbo.Vendor VALUES ('mdobal', 'United States', 'mdobal@makingsense')
INSERT INTO dbo.Vendor VALUES ('rsilva', 'Portugal, Brazil', 'rsilva@makingsense.com')
GO

-- ADD EMAIL, COUNTRIES ASSIGNED & CHANGED NAME
UPDATE dbo.Vendor SET Fullname = 'dpapatino', Email = 'dpapatino@makingsense.com' WHERE IdVendor = 1
UPDATE dbo.Vendor SET Fullname = 'mlesca', Email = 'mlesca@makingsense.com' WHERE IdVendor = 2
UPDATE dbo.Vendor SET Fullname = 'vgualberto', CountryAssigned = 'default', Email = 'vgualberto@makingsense.com' WHERE IdVendor = 3
UPDATE dbo.Vendor SET Fullname = 'support', Email = 'support@makingsense.com' WHERE IdVendor = 4
UPDATE dbo.Vendor SET Fullname = 'eduran', Email = 'eduran@makingsense.com' WHERE IdVendor = 5
UPDATE dbo.Vendor SET Fullname = 'mtorres', Email = 'mtorres@makingsense.com' WHERE IdVendor = 6
UPDATE dbo.Vendor SET Fullname = 'rbadillo', Email = 'rbadillo@makingsense.com' WHERE IdVendor = 7
UPDATE dbo.Vendor SET Fullname = 'jmiranda', Email = 'jmiranda@makingsense.com' WHERE IdVendor = 8
UPDATE dbo.Vendor SET Fullname = 'andres.jimenez', CountryAssigned = 'Spain', Email = 'andres.jimenez@grupoveleta.com' WHERE IdVendor = 10
UPDATE dbo.Vendor SET Fullname = 'gsolis', CountryAssigned = 'Mexico', Email = 'gsolis@makingsense.com' WHERE IdVendor = 11
UPDATE dbo.Vendor SET Fullname = 'lmontano', Email = 'lmontano@makingsense.com' WHERE IdVendor = 12
UPDATE dbo.Vendor SET Fullname = 'rafael', Email = 'rafael@emarketingchile.com' WHERE IdVendor = 14
UPDATE dbo.Vendor SET Fullname = 'vpizarro', Email = 'vpizarro@makingsense.com' WHERE IdVendor = 15

-- ASSIGN OLD SALEMANS ACCOUNTS TO SUPPORT
UPDATE [dbo].[User] SET IdVendor = 4 WHERE IdVendor IN (9,13)

-- DELETE OLD SALESMAN
DELETE FROM dbo.Vendor WHERE IdVendor = 9
DELETE FROM dbo.Vendor WHERE IdVendor = 13
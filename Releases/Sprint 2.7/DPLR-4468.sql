﻿-- ALTERS TABLE TO SUPPORT NEW COLUMNS
ALTER TABLE  [dbo].[User] 
ADD [AmountUsedCompleteUserInfoLink] INT DEFAULT ((0)) NOT NULL;
GO
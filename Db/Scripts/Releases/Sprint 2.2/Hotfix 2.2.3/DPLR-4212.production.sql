-- =============================================
-- Script Template
-- =============================================
UPDATE Link
SET UrlLink = REPLACE(UrlLink, '&amp;', '&')
WHERE UrlLink LIKE '%&amp;%'
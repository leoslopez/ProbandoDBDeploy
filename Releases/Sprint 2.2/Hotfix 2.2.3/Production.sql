--DPLR-4212
UPDATE Link
SET UrlLink = REPLACE(UrlLink, '&amp;', '&')
WHERE UrlLink LIKE '%&amp;%'
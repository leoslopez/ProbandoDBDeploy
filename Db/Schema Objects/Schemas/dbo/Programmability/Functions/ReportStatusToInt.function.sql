CREATE FUNCTION [dbo].[ReportStatusToInt]
(
	@Status VARCHAR(50)
)
RETURNS int
AS
BEGIN
	IF (@Status = 'Queued') OR (@Status = 'Processing') OR (@Status = 'Unknown')
	BEGIN
		return 1
	END
	IF (@Status = 'Completed')
	BEGIN
		return 2
	END
	IF (@Status = 'Cancelled')
	BEGIN
		return 3
	END
	IF (@Status = 'Failed')
	BEGIN
		return 4
	END
	return 2
END

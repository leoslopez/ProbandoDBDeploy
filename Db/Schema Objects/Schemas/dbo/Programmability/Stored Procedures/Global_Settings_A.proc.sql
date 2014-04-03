
CREATE PROCEDURE [dbo].[Global_Settings_A]
@name varchar(250),
@value varchar(500)
AS
SET NOCOUNT ON

IF ((SELECT count(1) FROM Setting WITH(NOLOCK) WHERE Name = @name) = 1)
BEGIN
UPDATE Setting WITH(ROWLOCK)
SET Setting = @value WHERE Name = @name
END
ELSE
BEGIN
INSERT INTO Setting WITH(ROWLOCK) (Name, Setting)
VALUES (@name, @value)
END
CREATE PROCEDURE [dbo].[Obtener_defragmentacion]  
AS  
BEGIN  
SET NOCOUNT ON;  
DECLARE @tablename varchar(255);  
DECLARE @execstr varchar(400);  
DECLARE @indexname varchar(100);  
DECLARE @indexid int;  
DECLARE @frag decimal;  
DECLARE @maxfrag decimal;  
DECLARE @ScanDensity decimal;  
DECLARE @fecha varchar(10);  
SELECT @fecha=convert(varchar(10),getdate(),103)  
  
-- Decide on the maximum fragmentation to allow for.  
SELECT @maxfrag = 30.0;  
SELECT @ScanDensity = 70.0;  
  
-- Declare a cursor.  
DECLARE tablas CURSOR FOR  
SELECT TABLE_SCHEMA + '.' + TABLE_NAME  
FROM INFORMATION_SCHEMA.TABLES  
WHERE TABLE_TYPE = 'BASE TABLE' --and TABLE_NAME='Campaigns'  
order by TABLE_NAME;  
  
-- Open the cursor.  
OPEN  tablas     
-- Loop through all the tables in the database.  
FETCH NEXT  
FROM tablas  
INTO @tablename;  
  
WHILE  
@@FETCH_STATUS = 0  
BEGIN  ;  
  
-- Do the showcontig of all indexes of the table  
set @execstr='INSERT INTO Estadisticas.dbo.TBL_SHOWCONTIG_Doppler2011 (ObjectName,ObjectId,IndexName,IndexId,Lvl,CountPages,CountRows,MinRecSize,MaxRecSize,AvgRecSize,ForRecCount,Extents,ExtentSwitches,AvgFreeBytes,AvgPageDensity,ScanDensity,BestCount,ActualCount,LogicalFrag,ExtentFrag)'  
  
set @tablename=replace(@tablename,'dbo.','')  
set @execstr=@execstr + 'EXEC('+ CHAR(39) + 'DBCC SHOWCONTIG ([' + @tablename + ']) WITH TABLERESULTS, ALL_INDEXES, NO_INFOMSGS' + CHAR(39) +')'  

exec (@execstr) 

FETCH NEXT  
FROM tablas  
INTO @tablename;  
  
END  ;  
  
-- Close and deallocate the cursor.  
CLOSE tablas;  
DEALLOCATE tablas;  
  
DECLARE indices CURSOR FOR  
SELECT top 5 ObjectName, IndexName, IndexId, LogicalFrag  
FROM Estadisticas.dbo.tbl_ShowContig  
WHERE LogicalFrag >= @maxfrag --OR ScanDensity<@ScanDensity  
AND DateAdd(hh,2,FracDate)>Getdate()  
order by LogicalFrag desc  
--AND INDEXPROPERTY (ObjectId, IndexName, 'IndexDepth') > 0;  
  
-- Open the cursor.  
OPEN indices;  
  
-- Loop through the indexes.  
FETCH NEXT  
FROM indices  
INTO @tablename, @indexname, @indexid, @frag;  
  
WHILE @@FETCH_STATUS = 0  
  
BEGIN ;  
IF(@indexname<>'')  
BEGIN  
SELECT @execstr = 'ALTER INDEX [' + rtrim(@indexname) + '] ON [' + rtrim(@tablename) + '] REBUILD WITH (FILLFACTOR = 80, ONLINE = ON, STATISTICS_NORECOMPUTE = ON);';  
  
INSERT INTO Estadisticas.dbo.Tareas_Ejecutadas_Doppler2011 VALUES(GetDate(), @execstr)  
BEGIN Try  
	EXEC (@execstr);  
END Try  
  
BEGIN Catch  
	INSERT INTO Estadisticas.dbo.Errores_Tareas_Ejecutadas_Doppler2011 VALUES(GetDate(), @execstr)  
END Catch  
  
END  
FETCH NEXT FROM indices  
INTO @tablename, @indexname, @indexid, @frag;  
  
END;  
  
-- Close and deallocate the cursor.  
CLOSE indices;  
DEALLOCATE indices;  
  
END  
   
   
   /*
   SET NOCOUNT ON;
DECLARE @objectid int;
DECLARE @indexid int;
DECLARE @partitioncount bigint;
DECLARE @schemaname nvarchar(130); 
DECLARE @objectname nvarchar(130); 
DECLARE @indexname nvarchar(130); 
DECLARE @partitionnum bigint;
DECLARE @partitions bigint;
DECLARE @frag float;
DECLARE @command nvarchar(4000); 
-- Conditionally select tables and indexes from the sys.dm_db_index_physical_stats function 
-- and convert object and index IDs to names.
SELECT
    object_id AS objectid,
    index_id AS indexid,
    partition_number AS partitionnum,
    avg_fragmentation_in_percent AS frag
INTO #work_to_do
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL , NULL, 'LIMITED')
WHERE avg_fragmentation_in_percent > 10.0 AND index_id > 0;

-- Declare the cursor for the list of partitions to be processed.
DECLARE partitions CURSOR FOR SELECT * FROM #work_to_do;

-- Open the cursor.
OPEN partitions;

-- Loop through the partitions.
WHILE (1=1)
    BEGIN;
        FETCH NEXT
           FROM partitions
           INTO @objectid, @indexid, @partitionnum, @frag;
        IF @@FETCH_STATUS < 0 BREAK;
        SELECT @objectname = QUOTENAME(o.name), @schemaname = QUOTENAME(s.name)
        FROM sys.objects AS o
        JOIN sys.schemas as s ON s.schema_id = o.schema_id
        WHERE o.object_id = @objectid;
        SELECT @indexname = QUOTENAME(name)
        FROM sys.indexes
        WHERE  object_id = @objectid AND index_id = @indexid;
        SELECT @partitioncount = count (*)
        FROM sys.partitions
        WHERE object_id = @objectid AND index_id = @indexid;

-- 30 is an arbitrary decision point at which to switch between reorganizing and rebuilding.
        IF @frag < 30.0
            SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REORGANIZE';
        IF @frag >= 30.0
            SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REBUILD';
        IF @partitioncount > 1
            SET @command = @command + N' PARTITION=' + CAST(@partitionnum AS nvarchar(10));
        EXEC (@command);
        PRINT N'Executed: ' + @command;
    END;

-- Close and deallocate the cursor.
CLOSE partitions;
DEALLOCATE partitions;

-- Drop the temporary table.
DROP TABLE #work_to_do;
GO

*/
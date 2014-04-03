ALTER DATABASE [$(DatabaseName)]
    ADD FILE (NAME = [Doppler_Field], FILENAME = '$(DefaultDataPath)Doppler2011_FIELD.NDF', SIZE = 5120 KB, FILEGROWTH = 10240 KB) TO FILEGROUP [Field];


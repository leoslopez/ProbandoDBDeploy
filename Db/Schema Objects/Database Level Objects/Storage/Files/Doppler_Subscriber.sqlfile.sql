ALTER DATABASE [$(DatabaseName)]
    ADD FILE (NAME = [Doppler_Subscriber], FILENAME = '$(DefaultDataPath)Doppler2011_SUBSCRIBER.NDF', SIZE = 10240 KB, FILEGROWTH = 10240 KB) TO FILEGROUP [Subscriber];


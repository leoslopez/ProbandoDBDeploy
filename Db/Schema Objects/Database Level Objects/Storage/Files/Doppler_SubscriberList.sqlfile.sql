ALTER DATABASE [$(DatabaseName)]
    ADD FILE (NAME = [Doppler_SubscriberList], FILENAME = '$(DefaultDataPath)Doppler2011_SUBSCRIBERLIST.NDF', SIZE = 5120 KB, FILEGROWTH = 10240 KB) TO FILEGROUP [SubscriberList];


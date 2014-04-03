ALTER DATABASE [$(DatabaseName)]
    ADD LOG FILE (NAME = [Doppler_Log], FILENAME = '$(DefaultDataPath)Doppler2011_Log.ldf', SIZE = 10240 KB, MAXSIZE = 104857600 KB, FILEGROWTH = 10 %);


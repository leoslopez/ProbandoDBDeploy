﻿ALTER DATABASE [$(DatabaseName)]
    ADD FILE (NAME = [Doppler_Campaign], FILENAME = '$(DefaultDataPath)Doppler2011_CAMPAIGNDELIVERIES.NDF', SIZE = 10240 KB, FILEGROWTH = 10240 KB) TO FILEGROUP [Campaign];

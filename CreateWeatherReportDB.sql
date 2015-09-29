/*
Deployment script for WeatherReport
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "WeatherReport"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\"

GO
:on error exit
GO
USE [master]
GO
IF (DB_ID(N'$(DatabaseName)') IS NOT NULL
    AND DATABASEPROPERTYEX(N'$(DatabaseName)','Status') <> N'ONLINE')
BEGIN
    RAISERROR(N'The state of the target database, %s, is not set to ONLINE. To deploy to this database, its state must be set to ONLINE.', 16, 127,N'$(DatabaseName)') WITH NOWAIT
    RETURN
END

GO
IF (DB_ID(N'$(DatabaseName)') IS NOT NULL) 
BEGIN
    ALTER DATABASE [$(DatabaseName)]
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [$(DatabaseName)];
END

GO
PRINT N'Creating $(DatabaseName)...'
GO
CREATE DATABASE [$(DatabaseName)]
    ON 
    PRIMARY(NAME = [WeatherReport], FILENAME = N'$(DefaultDataPath)WeatherReport.mdf')
    LOG ON (NAME = [WeatherReport_log], FILENAME = N'$(DefaultLogPath)WeatherReport_log.ldf') COLLATE SQL_Latin1_General_CP1_CI_AS
GO
EXECUTE sp_dbcmptlevel [$(DatabaseName)], 100;


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ANSI_NULLS ON,
                ANSI_PADDING ON,
                ANSI_WARNINGS ON,
                ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                NUMERIC_ROUNDABORT OFF,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON,
                CURSOR_DEFAULT LOCAL,
                RECOVERY FULL,
                CURSOR_CLOSE_ON_COMMIT OFF,
                AUTO_CREATE_STATISTICS ON,
                AUTO_SHRINK OFF,
                AUTO_UPDATE_STATISTICS ON,
                RECURSIVE_TRIGGERS OFF 
            WITH ROLLBACK IMMEDIATE;
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_CLOSE OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ALLOW_SNAPSHOT_ISOLATION OFF;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET READ_COMMITTED_SNAPSHOT OFF;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_UPDATE_STATISTICS_ASYNC OFF,
                PAGE_VERIFY NONE,
                DATE_CORRELATION_OPTIMIZATION OFF,
                DISABLE_BROKER,
                PARAMETERIZATION SIMPLE,
                SUPPLEMENTAL_LOGGING OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET TRUSTWORTHY OFF,
        DB_CHAINING OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'The database settings cannot be modified. You must be a SysAdmin to apply these settings.';
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET HONOR_BROKER_PRIORITY OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'The database settings cannot be modified. You must be a SysAdmin to apply these settings.';
    END


GO
USE [$(DatabaseName)]
GO
IF fulltextserviceproperty(N'IsFulltextInstalled') = 1
    EXECUTE sp_fulltext_database 'enable';


GO

PRINT N'Creating [dbo].[City]...';


GO
CREATE TABLE [dbo].[City] (
    [cityId]   INT           IDENTITY (1, 1) NOT NULL,
    [cityName] VARCHAR (100) NOT NULL,
    PRIMARY KEY CLUSTERED ([cityId] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF)
);


GO
PRINT N'Creating [dbo].[Weather]...';


GO
CREATE TABLE [dbo].[Weather] (
    [Id]               INT            IDENTITY (1, 1) NOT NULL,
    [cityId]           INT            NOT NULL,
    [clothingLayers]   NVARCHAR (100) NULL,
    [issued]           DATETIME       NOT NULL,
    [location]         INT            NOT NULL,
    [past]             NVARCHAR (50)  NOT NULL,
    [pressure]         FLOAT          NULL,
    [rainfall]         FLOAT          NULL,
    [relativeHumidity] FLOAT          NOT NULL,
    [status]           VARCHAR (100)  NOT NULL,
    [temperature]      FLOAT          NULL,
    [time]             DATETIME       NULL,
    [windChill]        FLOAT          NULL,
    [windDirection]    FLOAT          NULL,
    [windGustSpeed]    FLOAT          NULL,
    [windProofLayers]  NVARCHAR (50)  NULL,
    [windSpeed]        FLOAT          NULL,
    [windSpeedDesc]    VARCHAR (100)  NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF)
);


GO
PRINT N'Creating FK_Weather_City_cityID...';


GO
ALTER TABLE [dbo].[Weather] WITH NOCHECK
    ADD CONSTRAINT [FK_Weather_City_cityID] FOREIGN KEY ([cityId]) REFERENCES [dbo].[City] ([cityId]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
-- Refactoring step to update target server with deployed transaction logs
CREATE TABLE  [dbo].[__RefactorLog] (OperationKey UNIQUEIDENTIFIER NOT NULL PRIMARY KEY)
GO
sp_addextendedproperty N'microsoft_database_tools_support', N'refactoring log', N'schema', N'dbo', N'table', N'__RefactorLog'
GO

GO
/*Create user and login to access database*/
IF  not EXISTS (SELECT * FROM sys.database_principals WHERE name = N'wradmin')
Begin

CREATE LOGIN [wradmin] WITH PASSWORD=N'wradmin', DEFAULT_DATABASE=[WeatherReport], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF

Create User [wradmin] for login [wradmin]

ALTER LOGIN [wradmin] Enable

EXEC sp_addrolemember N'db_owner', N'wradmin'

END

/*Load City information if it doesn't exist*/
If not exists (Select top 1 * from city)
Begin
	Insert into City(cityName) values ('Ashburton')
	Insert into City(cityName) values ('Auckland')                       
	Insert into City(cityName) values ('Blenheim')	
	Insert into City(cityName) values ('ChristChurch')                       	
	Insert into City(cityName) values ('Dunedin')
	Insert into City(cityName) values ('Gisborne')
	Insert into City(cityName) values ('Gore')
	Insert into City(cityName) values ('Hamilton')
	Insert into City(cityName) values ('Hastings')
	Insert into City(cityName) values ('Hokitika')
	Insert into City(cityName) values ('Invercargill')
	Insert into City(cityName) values ('Kaikoura')
	Insert into City(cityName) values ('Kaitaia')
	Insert into City(cityName) values ('Kerikeri')
	Insert into City(cityName) values ('Levin')
	Insert into City(cityName) values ('Masterton')
	Insert into City(cityName) values ('Napier')
	Insert into City(cityName) values ('Nelson')
	Insert into City(cityName) values ('New-Plymouth')
	Insert into City(cityName) values ('Palmerston-North')
	Insert into City(cityName) values ('Paraparaumu')
	Insert into City(cityName) values ('Queenstown')
	Insert into City(cityName) values ('Rotorua')
	Insert into City(cityName) values ('Taumarunui')
	Insert into City(cityName) values ('Taupo')
	Insert into City(cityName) values ('Tauranga')
	Insert into City(cityName) values ('Timaru')	
	Insert into City(cityName) values ('Wanaka')
	Insert into City(cityName) values ('Wanganui')	
	Insert into City(cityName) values ('Wellington')                       
	Insert into City(cityName) values ('Westport')
	Insert into City(cityName) values ('Whakatane')
	Insert into City(cityName) values ('Whangarei')
End

GO
PRINT N'Checking existing data against newly created constraints';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[Weather] WITH CHECK CHECK CONSTRAINT [FK_Weather_City_cityID];


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        DECLARE @VarDecimalSupported AS BIT;
        SELECT @VarDecimalSupported = 0;
        IF ((ServerProperty(N'EngineEdition') = 3)
            AND (((@@microsoftversion / power(2, 24) = 9)
                  AND (@@microsoftversion & 0xffff >= 3024))
                 OR ((@@microsoftversion / power(2, 24) = 10)
                     AND (@@microsoftversion & 0xffff >= 1600))))
            SELECT @VarDecimalSupported = 1;
        IF (@VarDecimalSupported > 0)
            BEGIN
                EXECUTE sp_db_vardecimal_storage_format N'$(DatabaseName)', 'ON';
            END
    END


GO

﻿/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------


*/
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

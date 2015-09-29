CREATE TABLE [dbo].[Weather]
(
	[Id] INT  IDENTITY(1,1) PRIMARY KEY, 
    [cityId] INT NOT NULL, 
    [clothingLayers] NVARCHAR(100) NULL, 
    [issued] DATETIME NOT NULL, 
    [location] INT NOT NULL, 
    [past] NVARCHAR(50) NOT NULL, 
	[pressure] FLOAT NULL, 
    [rainfall] FLOAT  NULL, 
    [relativeHumidity] FLOAT NOT NULL, 
    [status] VARCHAR(100) NOT NULL, 
    [temperature] FLOAT  NULL, 
    [time] DATETIME  NULL, 
	[windChill] FLOAT  NULL, 
    [windDirection] FLOAT  NULL, 
    [windGustSpeed] FLOAT  NULL, 
    [windProofLayers] NVARCHAR(50)  NULL, 
    [windSpeed] FLOAT  NULL, 
    [windSpeedDesc] VARCHAR(100)  NULL, 
    CONSTRAINT [FK_Weather_City_cityID] FOREIGN KEY ([cityID]) REFERENCES [City]([cityID])
)

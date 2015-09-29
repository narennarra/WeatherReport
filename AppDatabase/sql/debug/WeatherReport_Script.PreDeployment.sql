/*
 Pre-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be executed before the build script.	
 Use SQLCMD syntax to include a file in the pre-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the pre-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/



CREATE LOGIN [admin] WITH PASSWORD = '!@#$%^&*()' , CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
CREATE USER [admin] FOR LOGIN [admin] WITH DEFAULT_SCHEMA = dbo;

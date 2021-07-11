USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_FA_Vehicle_Purchase_Agreement]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--  select * from Fa_Buyer

create procedure [dbo].[RP_SP_FA_Vehicle_Purchase_Agreement] -- '*', '2008-01-01', '2009-02-28'     
	@Buyer Varchar(30),
	@StartingProcessDate Varchar(24),
	@EndingProcessDate Varchar(24)

As

Declare @dStartingProcessDate Datetime
Declare @dEndingProcessDate Datetime
Select @dStartingProcessDate=Convert(Datetime, NULLIF(@StartingProcessDate,''))
Select @dEndingProcessDate=Convert(Datetime, NULLIF(@EndingProcessDate,''))

Declare @GSTRegNo Varchar(30)
Declare @CompanyName Varchar(50)
Declare @CompanyAddress varchar(100)

 
SELECT   @GSTRegNo=  dbo.SystemSettingValues.SettingValue
FROM         dbo.SystemSetting INNER JOIN
                      dbo.SystemSettingValues ON dbo.SystemSetting.SettingID = dbo.SystemSettingValues.SettingID
WHERE     (dbo.SystemSetting.SettingName = 'CompanyInfo') AND (dbo.SystemSettingValues.ValueName = 'GSTRegNo')
 
 
SELECT     @CompanyName=dbo.SystemSettingValues.SettingValue
FROM         dbo.SystemSetting INNER JOIN
                      dbo.SystemSettingValues ON dbo.SystemSetting.SettingID = dbo.SystemSettingValues.SettingID
WHERE     (dbo.SystemSetting.SettingName = 'CompanyInfo') AND (dbo.SystemSettingValues.ValueName = 'CompanyName')
 


SELECT     @CompanyAddress=dbo.SystemSettingValues.SettingValue
FROM         dbo.SystemSetting INNER JOIN
                      dbo.SystemSettingValues ON dbo.SystemSetting.SettingID = dbo.SystemSettingValues.SettingID
WHERE     (dbo.SystemSetting.SettingName = 'CompanyInfo') AND (dbo.SystemSettingValues.ValueName = 'Address')

SELECT     dbo.Vehicle.Unit_Number, dbo.FA_Buyer.Buyer_Name, dbo.FA_Buyer.Address, dbo.FA_Buyer.City, dbo.FA_Buyer.Province, 
                   dbo.FA_Buyer.Postal_Code, dbo.FA_Buyer.Phone_Number, dbo.FA_Buyer.Fax_Number, dbo.Vehicle_Model_Year.Model_Name, 
                   dbo.Vehicle_Model_Year.Model_Year, dbo.Vehicle_Model_Year.Manufacturer_ID, Manufacturer.[Value] AS Manufacturer, dbo.Vehicle.KM_Reading, 
                   dbo.Vehicle.Serial_Number, (CASE WHEN dbo.Vehicle.Private_Lease = 1 THEN 'Lease Vehicle' ELSE 'Rental Vehicle' END) AS VehicleUse, 
                   dbo.Vehicle.Selling_Price, dbo.Vehicle.Sales_GST, dbo.Vehicle.Sales_PST, dbo.Vehicle.OSD, dbo.Vehicle.Sales_Processed_date,(Case When dbo.Vehicle.Declaration_Amount>= 2000 then dbo.Vehicle.Declaration_Amount  Else NULL End) Declaration_Amount ,
					@GSTRegNo GSTRegNo,
					@CompanyName CompanyName,
					@CompanyAddress CompanyAddress

					  
FROM         dbo.Vehicle INNER JOIN
                      dbo.FA_Buyer ON dbo.Vehicle.Sell_To = dbo.FA_Buyer.Customer_Code INNER JOIN
                      dbo.Vehicle_Model_Year ON dbo.Vehicle.Vehicle_Model_ID = dbo.Vehicle_Model_Year.Vehicle_Model_ID INNER JOIN
                          (SELECT     *
                            FROM          lookup_table
                            WHERE      category = 'Manufacturer') Manufacturer ON dbo.Vehicle_Model_Year.Manufacturer_ID = Manufacturer.Code
					
WHERE     (dbo.Vehicle.Sales_Processed_date BETWEEN @dStartingProcessDate AND @dEndingProcessDate) And
				  (Vehicle.Sell_To=@Buyer or @Buyer='*')
GO

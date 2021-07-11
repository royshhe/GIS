USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_FA_Car_Sales]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  select * from Fa_Buyer

CREATE procedure [dbo].[RP_SP_FA_Car_Sales]  --'*', '2008-01-01', '2009-02-28'     
	@Buyer Varchar(30),
	@StartingProcessDate Varchar(24),
	@EndingProcessDate Varchar(24)

As

Declare @dStartingProcessDate Datetime
Declare @dEndingProcessDate Datetime
Select @dStartingProcessDate=Convert(Datetime, NULLIF(@StartingProcessDate,''))
Select @dEndingProcessDate=Convert(Datetime, NULLIF(@EndingProcessDate,''))

Declare @valueName Varchar(30)
Declare @settingValue Varchar(30)

Declare @GSTRegNo Varchar(30)
Declare @CompanyName Varchar(50)
Declare @CompanyAddress varchar(100)
Declare @CompanyCity varchar(50)
Declare @CompanyProvince varchar(50)
Declare @CompanyPostalCode varchar(30)
Declare @CompanyPhone Varchar(30)
Declare @DirRegNo varchar(30)


DECLARE Company_Info_Cursor CURSOR FOR
SELECT	dbo.SystemSettingValues.ValueName, dbo.SystemSettingValues.SettingValue
FROM         dbo.SystemSetting INNER JOIN
                      dbo.SystemSettingValues ON dbo.SystemSetting.SettingID = dbo.SystemSettingValues.SettingID
WHERE     (dbo.SystemSetting.SettingName = 'CompanyInfo')
	
OPEN Company_Info_Cursor

-- Perform the first fetch and store the values in variables.
-- Note: The variables are in the same order as the columns
-- in the SELECT statement. 

FETCH NEXT FROM Company_Info_Cursor
INTO @valueName,@settingValue
			Begin
					If @valueName='CompanyName'
						 Select @CompanyName=@settingValue
					Else
							If  @valueName='Address'
									Select @CompanyAddress=@settingValue
							Else
									If  @valueName='City'
											Select @companyCity=@settingValue
									Else
												If  @valueName='Province'
														Select @companyProvince=@settingValue
												Else
														If  @valueName='PhoneNumber'
																Select @companyPhone=@settingValue			
														Else
																If  @valueName='PostalCode'
																		Select @companyPostalCode=@settingValue		
																Else
																		If  @valueName='GSTRegNo'
																					Select @GSTRegNo=@settingValue		
																				Else
																						If  @valueName='DirRegNo'
																									Select @DirRegNo=@settingValue			
																					
			End



-- Check @@FETCH_STATUS to see if there are any more rows to fetch.
WHILE @@FETCH_STATUS = 0
BEGIN
		    
		   FETCH NEXT FROM Company_Info_Cursor
		   INTO @valueName,@settingValue
			Begin
					If @valueName='CompanyName'
						 Select @CompanyName=@settingValue
					Else
							If  @valueName='Address'
									Select @CompanyAddress=@settingValue
							Else
									If  @valueName='City'
											Select @companyCity=@settingValue
									Else
												If  @valueName='Province'
														Select @companyProvince=@settingValue
												Else
														If  @valueName='PhoneNumber'
																Select @companyPhone=@settingValue			
														Else
																If  @valueName='PostalCode'
																		Select @companyPostalCode=@settingValue		
																Else
																		If  @valueName='GSTRegNo'
																					Select @GSTRegNo=@settingValue		
																				Else
																						If  @valueName='DirRegNo'
																									Select @DirRegNo=@settingValue			
																					
			End
END

CLOSE Company_Info_Cursor
DEALLOCATE Company_Info_Cursor



SELECT     dbo.Vehicle.Unit_Number, dbo.FA_Buyer.Buyer_Name, dbo.FA_Buyer.Address,
 dbo.FA_Buyer.City, dbo.FA_Buyer.Province, 
                      dbo.FA_Buyer.Postal_Code, dbo.FA_Buyer.Phone_Number, dbo.FA_Buyer.Fax_Number, dbo.Vehicle_Model_Year.Model_Name, 
                      dbo.Vehicle_Model_Year.Model_Year, dbo.Vehicle_Model_Year.Manufacturer_ID, Manufacturer.[Value] AS Manufacturer, dbo.Vehicle.KM_Reading, 
                      dbo.Vehicle.Serial_Number, (CASE WHEN dbo.Vehicle.Private_Lease = 1 THEN 'Lease Vehicle' ELSE 'Rental Vehicle' END) AS VehicleUse, 
                      (CASE WHEN dbo.Vehicle.Selling_Price IS NULL THEN 0 ELSE dbo.Vehicle.Selling_Price END) as Selling_Price,
					  (CASE WHEN dbo.Vehicle.Sales_GST IS NULL THEN 0 ELSE dbo.Vehicle.Sales_GST END) as Sales_GST, 
					  (case when dbo.Vehicle.Sales_PST is null then 0 else dbo.Vehicle.Sales_PST end) as Sales_PST,
					  dbo.Vehicle.Sales_Processed_date, 
                      (CASE WHEN dbo.Vehicle.Declaration_Amount >= 2000 THEN dbo.Vehicle.Declaration_Amount ELSE NULL END) AS Declaration_Amount, 
                      dbo.Vehicle.ISD, dbo.Vehicle.OSD, dbo.Vehicle.Idle_Days, dbo.Vehicle.Depreciation_Periods, dbo.Vehicle.Selling_Monthly_AMO, 
                      dbo.Vehicle.Depreciation_Type, dbo.Vehicle.Sales_Acc_Dep, dbo.Vehicle.Cap_Cost, dbo.Vehicle.Deduction, dbo.Vehicle.Damage_Amount, 
                      dbo.Vehicle.KM_Charge,
					  @GSTRegNo GSTRegNo,
					  @CompanyName CompanyName,
					  @CompanyAddress CompanyAddress,
					  @CompanyCity CompanyCity,
					  @CompanyProvince CompanyProvince,
					  @CompanyPostalCode CompanyPostalCode,
					  @CompanyPhone CompanyPhone,
					  @DirRegNo DirRegNo


FROM         dbo.Vehicle INNER JOIN
                      dbo.FA_Buyer ON dbo.Vehicle.Sell_To = dbo.FA_Buyer.Customer_Code INNER JOIN
                      dbo.Vehicle_Model_Year ON dbo.Vehicle.Vehicle_Model_ID = dbo.Vehicle_Model_Year.Vehicle_Model_ID INNER JOIN
                          (SELECT     *
                            FROM          lookup_table
                            WHERE      category = 'Manufacturer') Manufacturer ON dbo.Vehicle_Model_Year.Manufacturer_ID = Manufacturer.Code
					
WHERE     (dbo.Vehicle.Sales_Processed_date BETWEEN @dStartingProcessDate AND @dEndingProcessDate) And
				  (Vehicle.Sell_To=@Buyer or @Buyer='*')

order by dbo.FA_Buyer.Buyer_Name,dbo.Vehicle.Unit_Number
GO

USE [GISData]
GO
/****** Object:  View [dbo].[Local_Location_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Local_Location_vw]
AS
Select 
(Case When Location_ID=195 Then 20 When Location_ID=194 Then 16 Else Location_ID End)  Location_ID , Location, Owning_Company_ID, Hub_ID, Address_1, Address_2, City, Province, Postal_Code, Fax_Number, Phone_Number, Grace_Period, Manager, 
                      Remarks, Address_Description, Hours_of_Service_Description, Corporate_Location_ID, Percentage_Fee, Flat_Fee, GIS_Member, Fuel_Price_Per_Liter, 
                      Fuel_Price_Per_Liter_Diesel, FPO_Fuel_Price_Per_Liter, FPO_Fuel_Price_Per_Liter_Dsel, Default_Unauthorized_charge, Rental_Location, ResNet, Delete_Flag, 
                      Fee_Type, Mnemonic_Code, Platinum_Territory_Code, AR_Forced_Charge_Account, GL_Fees_Payable_Clear_Account, Version, Last_Updated_By, Last_Updated_On, 
                      TruckInv_Last_Updated_By, TruckInv_Last_Updated_On, LicenseFeePerDay, LicenseFeePercentage, LicenseFeeFlat, AllowResForOther, BroadcastMssg, 
                      LocationName, SearchKeyWord, IsAirportLocation, LocationDescription, Country, StationNumber, CounterCode, GDSCode, LocalHubOnly, LocalCompanyOnly, 
                      DBRCode, IB_Zone, Merchant_ID, Sell_Online, CSA
From Location

WHERE (Owning_Company_ID in (select  code from lookup_table where category='BudgetBC Company')) AND delete_Flag <> 1 --AND     Rental_location = 1
GO

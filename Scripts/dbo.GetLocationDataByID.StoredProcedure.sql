USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLocationDataByID]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.GetLocationDataByID    Script Date: 2/18/99 12:11:54 PM ******/
/****** Object:  Stored Procedure dbo.GetLocationDataByID    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetLocationDataByID    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetLocationDataByID    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetLocationDataByID]  
	@Location VarChar(25)
AS
	/* 6/10/99 - added mnemonic code to the end */

	Set Rowcount 2000
   	SELECT	Location.Location_ID,
		Location.Location,
		Owning_Company.Name,
		Location.City,
		Location.Owning_Company_ID,

		Location.Manager,
		Location.Corporate_Location_ID,
		Hub_ID,
		CONVERT(VarChar(1), Rental_Location) Rental_Location,
		CONVERT(VarChar(1), ResNet) ResNet,

		CONVERT(VarChar(1), GIS_Member) GIS_Member,
		Location.Grace_Period,
		Location.Fuel_Price_Per_Liter,
		Location.Fuel_Price_Per_Liter_Diesel,
		Location.FPO_Fuel_Price_Per_Liter,

		Location.FPO_Fuel_Price_Per_Liter_Dsel,
		Location.Percentage_Fee,
		Location.Flat_Fee,
		
		Location.LicenseFeePerDay,
		Location.LicenseFeePercentage,
                           Location.LicenseFeeFlat,
			
		Location.Remarks,
		Location.Address_1,

		Location.Address_2,
		Location.Province,
		Location.Postal_Code,
		Location.Phone_Number,
		Location.Fax_Number,

		Location.Address_Description,
		Location.Hours_Of_Service_Description,
		Location.Default_Unauthorized_Charge,
		Location.Mnemonic_Code,
		Location.BroadcastMssg, 
		CONVERT(VarChar(1), AllowResForOther) AllowResForOther,
		location.StationNumber,
		location.CounterCode,
		Location.GDSCode,
		Location.DBRCode,
		Location.IB_Zone,
		Location.Acctg_Segment,
		Location.LocationName,
		Location.Email_Hour_Description,
		(Case When Location.Owning_Company_ID in (select code from lookup_table where category ='BudgetBC Company')
					and Rental_Location='1'
				then 1
				Else 0
        End) DBR_Code_Required,
		Location.Payment_Processing
   	FROM   	Location,
		Owning_Company
	WHERE	Location.Location_Id = CONVERT(SmallInt, @Location)
	AND	Location.Delete_Flag = 0
	AND	Location.Owning_Company_ID = Owning_Company.Owning_Company_ID
   	ORDER BY 	
		Location
   	RETURN 1

--select * from lookup_table where category ='BudgetBC Company'
GO

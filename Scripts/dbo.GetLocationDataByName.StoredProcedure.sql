USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLocationDataByName]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.GetLocationDataByName    Script Date: 2/18/99 12:11:54 PM ******/
/****** Object:  Stored Procedure dbo.GetLocationDataByName    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetLocationDataByName    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetLocationDataByName    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetLocationDataByName]
	@Location VarChar(25)
AS
	/* 6/10/99 - added mnemonic code  */

	Set Rowcount 2000
	Select @Location = LTRIM(@Location) + '%'
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
		CONVERT(VarChar(1), Location.AllowResForOther)  AllowResForOther,
		location.StationNumber,
		location.CounterCode,
		Location.GDSCode,
		Location.DBRCode,
		Location.IB_Zone


   	FROM   	Location,
		Owning_Company
		WHERE	Location.Location Like @Location
		AND	Location.Delete_Flag = 0
		AND	Location.Owning_Company_ID = Owning_Company.Owning_Company_ID
   	ORDER BY 	
		Location.Location
   	RETURN 1
GO

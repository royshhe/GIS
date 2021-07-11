USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctChange]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetCtrctChange    Script Date: 2/18/99 12:12:07 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctChange    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctChange    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctChange    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: 	To retrieve the contract information for the given contract.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctChange]
	@CtrctNum	VarChar(11)
AS

	SELECT	CON.Contract_Number,
		CON.Status,
		CON.Customer_ID,
		LOC_P.Location,
		CONVERT(VarChar, CON.Pick_Up_On, 111) Pick_Up_Date,
		CONVERT(VarChar, CON.Pick_Up_On, 108) Pick_Up_Time,
		LOC_D.Location,
		CONVERT(VarChar, CON.Drop_Off_On, 111) Drop_Off_Date,
		CONVERT(VarChar, CON.Drop_Off_On, 108) Drop_Off_Time,
		VC.Vehicle_Class_Name,
		CONVERT(VarChar, CON.Do_Not_Extend_Rental) Do_Not_Extend_Rental,
		CON.Do_Not_Extend_Reason,
		CON.Pick_Up_Location_ID,
		CON.Drop_Off_Location_ID,
		CON.Vehicle_Class_Code,
		VC.Vehicle_Type_ID,
		CON.Rate_ID,
		CON.Rate_Level,
		CON.BCD_Rate_Organization_ID,
		CON.LDW_Declined_Reason,
		CON.LDW_Declined_Details,
		CONVERT(VarChar, CON.Renter_Driving) Renter_Driving,
		CON.Birth_Date,
		CON.Last_Name,
		CON.First_Name,
		CON.Gender,
		CON.Phone_Number,
		CON.Address_1,
		CON.Address_2,
		CON.City,
		CON.Province_State,
		CON.Country,
		CON.Postal_Code,
		CON.Fax_Number,
		CON.Email_Address,
		CONVERT(VarChar, CON.Smoking_Non_Smoking) Smoking,
		CON.Company_Name,
		CON.Company_Phone_Number,
		CON.Local_Phone_Number,
		CON.Local_Address_1,
		CON.Local_Address_2,
		CON.Local_City,

		CON.Print_Comment
		
	FROM	Contract CON WITH(NOLOCK),
		Location LOC_P WITH(NOLOCK),
		Location LOC_D WITH(NOLOCK),
		Vehicle_Class VC WITH(NOLOCK)
	WHERE	Contract_Number = CONVERT(Int, @CtrctNum)
	AND	CON.Pick_Up_Location_ID = LOC_P.Location_ID
	AND	CON.Drop_Off_Location_ID = LOC_D.Location_ID

	AND	CON.Vehicle_Class_Code = VC.Vehicle_Class_Code
RETURN @@ROWCOUNT














GO

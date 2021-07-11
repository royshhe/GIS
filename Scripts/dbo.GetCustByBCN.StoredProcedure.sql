USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCustByBCN]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.GetCustByBCN    Script Date: 2/18/99 12:11:53 PM ******/
/****** Object:  Stored Procedure dbo.GetCustByBCN    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCustByBCN    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCustByBCN    Script Date: 11/23/98 3:55:33 PM ******/
/*  PURPOSE:		To retrieve the customer information for the given BCN.
     MOD HISTORY:
     Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCustByBCN]
	@BCN Varchar(15)
AS
	/* 981019 - cpy - removed DL Province, Country,
			  added DL Jurisdiction */
	/* get active customers by BCN */
	Select 	Customer_ID, Last_Name, First_Name, Address_1,
		Phone_Number, Driver_Licence_Number,
		Convert(Char(11),Birth_Date, 13),
		Program_Number, Organization_ID, Gender,
		Convert(Char(1), Do_Not_Rent),
		Remarks, Address_2, City, Province,
		Postal_Code, Country, Email_Address,
		Convert(Char(11),Driver_Licence_Expiry,13),
		Jurisdiction, Payment_Method,
		B.Vehicle_Class_Name,
		Smoking_Non_Smoking,
		Convert(Char(1), Add_LDW),
		Convert(Char(1), Add_PAI),
		Convert(Char(1), Add_PEC),
		'',-- Preferred_FF_Plan_ID,
		'',-- Preferred_FF_Member_number,
		'',--CC.Credit_Card_Type_Id,
		'',--CC.Credit_Card_Number,
		'',--CC.Expiry,
		Company_Name,
		Company_Phone_Number
	From   Customer A Left Join 
	       Vehicle_Class B
	 ON A.Vehicle_Class_Code = B.Vehicle_Class_Code
	Where  --A.Vehicle_Class_Code *= B.Vehicle_Class_Code	And    
       Inactive = 0	And    Program_Number = @BCN

	Return 1
GO

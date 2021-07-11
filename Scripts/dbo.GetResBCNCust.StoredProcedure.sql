USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResBCNCust]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.GetResBCNCust    Script Date: 2/18/99 12:11:56 PM ******/
/****** Object:  Stored Procedure dbo.GetResBCNCust    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetResBCNCust    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetResBCNCust    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetResBCNCust] -- 'A162000'
	@BCN Varchar(15)
AS
	/* 3/10/99 - cpy modified - added CC LastName, FirstName, Sequence */
	/* 10/13/99 - do type conversion and nullif outside of SQL statements */
	SELECT	@BCN = NULLIF(@BCN, "")
	
	SELECT	A.Customer_ID,
		A.Program_Number,
		A.Vehicle_Class_Code,
		Convert(Char(1), A.Smoking_Non_Smoking),
		A.Last_Name,
		A.First_Name,
		A.Phone_Number,
		A.Address_1,
		A.Address_2,
		A.City,
		A.Province,
		A.Country,
		Convert(Char(11), A.Birth_Date, 13),
		A.Email_Address,
		A.Payment_Method,
		B.Credit_Card_Type_ID,
		B.Credit_Card_Type_ID,
		B.Credit_Card_Number,
		B.Short_Token,
		B.Last_Name,
		B.First_Name,
		B.Expiry,
		B.Sequence_Num,
		C.Organization_ID,
		C.BCD_Number,
		C.Organization,
		Convert(Char(1), A.Do_Not_Rent),
		A.Remarks
	FROM	
		Customer A
		Left Join 
		Credit_Card B
		On A.Customer_ID = B.Customer_ID
		Left Join 	Organization C
		On A.Organization_ID = C.Organization_ID
		
		
	WHERE	
--	A.Organization_ID *= C.Organization_ID
--	AND	A.Customer_ID *= B.Customer_ID	AND	
	A.Program_Number = @BCN
	RETURN @@ROWCOUNT
GO

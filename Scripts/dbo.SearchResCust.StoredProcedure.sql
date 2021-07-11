USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SearchResCust]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










--SearchResCust '','l'



/****** Object:  Stored Procedure dbo.SearchResCust    Script Date: 2/18/99 12:11:48 PM ******/
/****** Object:  Stored Procedure dbo.SearchResCust    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.SearchResCust    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.SearchResCust    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[SearchResCust]
	@FirstName Varchar(25),
	@LastName Varchar(25)
AS
	SELECT	Top 100 Customer_ID, First_Name, Last_Name, Birth_Date, Address_1 + ISNULL(Address_2,''), City, Phone_Number,
		Program_Number, Do_Not_Rent, Remarks
	FROM	Customer
	WHERE	Inactive = 0
	AND	First_Name LIKE LTRIM(@FirstName + '%')
	AND	Last_Name LIKE LTRIM(@LastName + '%')
	RETURN 1















GO

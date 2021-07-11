USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SearchResBCNCust]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO













/****** Object:  Stored Procedure dbo.SearchResBCNCust    Script Date: 2/18/99 12:11:48 PM ******/
CREATE PROCEDURE [dbo].[SearchResBCNCust]
	@LastName Varchar(25),
	@FirstName Varchar(25),
	@City Varchar(25),
	@Phone Varchar(35)
AS
	SELECT	top 100 Customer_ID, First_Name, Last_Name, Program_Number, Address_1,
		Address_2, City, Phone_Number, Do_Not_Rent, Remarks
	FROM	Customer
	WHERE	Inactive = 0
	AND	Last_Name LIKE LTRIM(@LastName + '%')
	AND	First_Name LIKE LTRIM(@FirstName + '%')
	AND	City LIKE LTRIM(@City + '%')
	AND	Phone_Number LIKE LTRIM(@Phone + '%')
	AND	NOT Program_Number IS NULL
	AND	NOT Program_Number = ''
	ORDER BY First_Name, Last_Name, City
	RETURN @@ROWCOUNT











GO

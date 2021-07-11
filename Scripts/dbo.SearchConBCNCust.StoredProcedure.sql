USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SearchConBCNCust]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.SearchConBCNCust    Script Date: 2/18/99 12:11:48 PM ******/
/****** Object:  Stored Procedure dbo.SearchConBCNCust    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.SearchConBCNCust    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.SearchConBCNCust    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[SearchConBCNCust]
	@BCN Varchar(15)
AS
	/* 3/17/99 - cpy modified - added OrgId and BCD Number fields */
	-- May 21 1999 - Don K - change format of Do_Not_Rent

	SELECT top 100	C.Customer_ID,
		C.First_Name,
		C.Last_Name,
		C.Program_Number,
		C.Address_1,

		C.Address_2,
		C.City,
		C.Phone_Number,
		CASE WHEN C.Do_Not_Rent = 1 THEN 'Do Not Rent' END,
		C.Remarks,

		C.Organization_Id,
		O.BCD_Number

	FROM	Customer C
		LEFT JOIN Organization O
		  ON C.Organization_Id = O.Organization_Id

	WHERE	C.Inactive = 0
	AND	C.Program_Number = @BCN
	ORDER BY C.First_Name, C.Last_Name, C.City

	RETURN @@ROWCOUNT
GO

USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLocationPrintData]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.GetLocationPrintData    Script Date: 2/18/99 12:11:54 PM ******/
/****** Object:  Stored Procedure dbo.GetLocationPrintData    Script Date: 2/16/99 2:05:41 PM ******/
CREATE PROCEDURE [dbo].[GetLocationPrintData] --17
	@Location VarChar(5)
AS
	/* 10/18/99 - do type conversion and nullif outside of SQL statements */
  --Roy He	 2011-03-16 MS SQL 2008

DECLARE	@iLocId Int
	SELECT @iLocId = CONVERT(SmallInt, NULLIF(@Location,''))

	/* Feb 10,99 - cpy - return print contract location data */
   	SELECT	Location,
		Address_1,
		Address_2,
		City,
		Province,
		Postal_Code,
		Phone_Number,
		CASE 
			WHEN LT.Code is null THEN 'F'
			ELSE null
		END,
		StationNumber,
		LocationName 
   	FROM   Location L WITH(NOLOCK) Left Join 
	Lookup_Table LT WITH(NOLOCK)
	On L.Owning_Company_Id = Convert(SmallInt, LT.Code) And LT.Category = 'BudgetBC Company'
		
	WHERE	
--	LT.Category = 'BudgetBC Company'
--	AND	L.Owning_Company_Id *= Convert(SmallInt, LT.Code)	AND	
    Location_Id = @iLocId
	AND	Delete_Flag = 0
   	RETURN @@ROWCOUNT
GO

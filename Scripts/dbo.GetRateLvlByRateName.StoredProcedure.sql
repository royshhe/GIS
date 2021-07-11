USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRateLvlByRateName]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetRateLvlByRateName    Script Date: 2/18/99 12:11:55 PM ******/
/****** Object:  Stored Procedure dbo.GetRateLvlByRateName    Script Date: 2/16/99 2:05:42 PM ******/
/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetRateLvlByRateName]
@RateName Varchar(25),
@RateLevel Varchar(1)
AS
SELECT @RateName = NULLIF(@RateName,"")
SELECT @RateLevel = NULLIF(@RateLevel,"")

SELECT DISTINCT
	R.Rate_Id, L.Rate_Level
FROM
	Vehicle_Rate R, Rate_Level L
WHERE
	R.Rate_Id = L.Rate_Id
	AND	R.Rate_Name = @RateName
	AND	L.Rate_Level = @RateLevel
	AND	L.Termination_Date = '31 Dec 2078 23:59'
	AND	R.Termination_Date = '31 Dec 2078 23:59'
	
RETURN @@ROWCOUNT













GO

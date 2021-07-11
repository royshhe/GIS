USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[FA_GetVehAMOByUnitNum]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










CREATE PROCEDURE [dbo].[FA_GetVehAMOByUnitNum]
	@UnitNum Varchar(10)
AS
	/* 3/27/99 - rhe created - Get Vehicle Monthly AMO for given unit num	*/
	DECLARE	@nUnitNum Integer
	SELECT	@nUnitNum = Convert(Int, NULLIF(@UnitNum,''))

    SELECT     CONVERT(VarChar, AMO_Month, 111) AMO_Month, AMO_Amount, Dep_Credit, InService_Months, Balance, Last_Updated_On
    FROM         dbo.FA_Vehicle_Amortization
	WHERE	Unit_Number = @nUnitNum And ((AMO_Amount is not null or  Dep_Credit is not null) And (AMO_Amount <>0or  Dep_Credit <>0))

	RETURN @@ROWCOUNT




















GO

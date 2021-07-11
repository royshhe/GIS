USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[FA_GetLeaseAMOByUnitNum]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[FA_GetLeaseAMOByUnitNum] -- '164994'
	@UnitNum Varchar(10)
AS
	/* 3/27/99 - rhe created - Get Vehicle Monthly AMO for given unit num	*/
	DECLARE	@nUnitNum Integer
	SELECT	@nUnitNum = Convert(Int, NULLIF(@UnitNum,''))
SELECT     CONVERT(VarChar, dbo.FA_Lease_Amortization.AMO_Month, 111) AMO_Month, dbo.FA_Lessee.Lessee_Name, dbo.FA_Lease_Amortization.Principle, dbo.FA_Lease_Amortization.Interest, 
                      dbo.FA_Lease_Amortization.Last_Updated_On
FROM         dbo.FA_Lease_Amortization INNER JOIN
                      dbo.FA_Lessee ON dbo.FA_Lease_Amortization.Lessee_ID = dbo.FA_Lessee.Lessee_ID
	WHERE	Unit_Number = @nUnitNum and (( dbo.FA_Lease_Amortization.Principle is not Null or dbo.FA_Lease_Amortization.Interest is not null)  And ( dbo.FA_Lease_Amortization.Principle<>0 or dbo.FA_Lease_Amortization.Interest <>0) )

	RETURN @@ROWCOUNT




















GO

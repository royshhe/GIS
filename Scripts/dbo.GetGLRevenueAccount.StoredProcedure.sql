USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetGLRevenueAccount]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.GetGLRevenueAccount    Script Date: 2/18/99 12:11:53 PM ******/
/****** Object:  Stored Procedure dbo.GetGLRevenueAccount    Script Date: 2/16/99 2:05:41 PM ******/
CREATE PROCEDURE [dbo].[GetGLRevenueAccount] --'A', '10', '16'
	@VehicleClassCode	VarChar(1),
	@ChargeTypeID		Varchar(10),
	@LocationID	VarChar(10)='0'
AS
	Declare @VehicleType	VarChar(10)
	Declare @LocatonAcctgSeg VarChar(15)
    Declare @VCAcctgSeg VarChar(15)

SELECT	@VehicleType =	(	SELECT	DISTINCT Vehicle_Type_ID
					FROM	Vehicle_Class
					WHERE	Vehicle_Class_Code = @VehicleClassCode
				)

 
 SELECT	@LocatonAcctgSeg =	 (	SELECT	DISTINCT Acctg_Segment
					FROM	Location 
					WHERE	Location_ID = convert(smallint, @LocationID)
				) 

 SELECT	@VCAcctgSeg = ( SELECT	DISTINCT Acctg_Segment
					FROM	Vehicle_Class
					WHERE	Vehicle_Class_Code = @VehicleClassCode
				) 



	SELECT   dbo.LocVCGLAccount( GL_Revenue_Account,  @LocatonAcctgSeg, @VCAcctgSeg)  
					--Replace(Replace(GL_Revenue_Account,'XX', @LocatonAcctgSeg), 'YY',@VCAcctgSeg)
	FROM	Charge_GL
	WHERE	Vehicle_Type_ID	= @VehicleType
	AND	Charge_Type_ID = Convert(int, @ChargeTypeID)


--	SELECT	@VehicleType =	(	SELECT	DISTINCT Vehicle_Type_ID
--					FROM	Vehicle_Class
--					WHERE	Vehicle_Class_Code = @VehicleClassCode
--				)
--	SELECT	GL_Revenue_Account
--	FROM	Charge_GL
--	WHERE	Vehicle_Type_ID	= @VehicleType
--	AND	Charge_Type_ID = Convert(int, @ChargeTypeID)
RETURN 1
GO

USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetGLDiscountAccount]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.GetGLDiscountAccount    Script Date: 2/18/99 12:11:53 PM ******/
/****** Object:  Stored Procedure dbo.GetGLDiscountAccount    Script Date: 2/16/99 2:05:41 PM ******/
/*  PURPOSE:		To retrieve the GL Discount acount for the given vehicle class code.
     MOD HISTORY:
     Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetGLDiscountAccount]
	@VehicleClassCode	VarChar(1),
    @LocationID	VarChar(10)='0'
AS
	Declare @VehicleType	VarChar(10)
    Declare @LocatonAcctgSeg VarChar(15)
    Declare @VCAcctgSeg VarChar(15)

SELECT	@VehicleType =	(	SELECT	DISTINCT Vehicle_Type_ID
					FROM	Vehicle_Class
					WHERE	Vehicle_Class_Code = @VehicleClassCode
				)

 
 SELECT	@LocatonAcctgSeg =	ISNULL((	SELECT	DISTINCT Acctg_Segment
					FROM	Location 
					WHERE	Location_ID = convert(smallint, @LocationID)
				), '00')

 SELECT	@VCAcctgSeg =	ISNULL((	SELECT	DISTINCT Acctg_Segment
					FROM	Vehicle_Class
					WHERE	Vehicle_Class_Code = @VehicleClassCode
				), '00')

SELECT  dbo.LocVCGLAccount( GL_Discount_Account,  @LocatonAcctgSeg, @VCAcctgSeg)  --Replace(Replace(GL_Discount_Account,'XX', @LocatonAcctgSeg), 'YY',@VCAcctgSeg)	
FROM
	Vehicle_Type
WHERE
	Vehicle_Type_ID	= @VehicleType
RETURN 1
GO

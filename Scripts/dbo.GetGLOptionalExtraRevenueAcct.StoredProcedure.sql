USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetGLOptionalExtraRevenueAcct]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.GetGLOptionalExtraRevenueAcct    Script Date: 2/18/99 12:11:53 PM ******/
/****** Object:  Stored Procedure dbo.GetGLOptionalExtraRevenueAcct    Script Date: 2/16/99 2:05:41 PM ******/
/*  PURPOSE:		To retrieve the GL_Revenue_Account for the given parameters.
     MOD HISTORY:
     Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetGLOptionalExtraRevenueAcct]
	@OptionalExtraId	Varchar(10),
	@VehicleClassCode	Varchar(1),
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
	--GL_Revenue_Account
FROM
	Optional_Extra_GL
WHERE
	Vehicle_Type_ID	= @VehicleType
	AND Optional_Extra_ID = Convert(smallint, @OptionalExtraID)
RETURN 1
GO

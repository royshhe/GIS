USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateOrgCorpQRate]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create  procedure [dbo].[CreateOrgCorpQRate]
@BCDNumber Varchar(20),
@VehicleClassCode char(1),
@QuotedRateID varchar(20)
as

Declare @intQID int
Declare @iCount int
	Select @intQID=CONVERT(int, @QuotedRateID)
	Select @iCount=count(*) from Quoted_Organization_Rate where BCD_Number=@BCDNumber and Vehicle_Class_Code=@VehicleClassCode
           
	IF @iCount>0  
		Update Quoted_Organization_Rate set Quoted_Rate_ID=@QuotedRateID where BCD_Number=@BCDNumber and Vehicle_Class_Code=@VehicleClassCode
	ELSE
			Begin
					Insert Quoted_Organization_Rate  
					 (
						BCD_Number,
						Vehicle_Class_Code,
						Quoted_Rate_ID,
						LDWID
					)

					Values
					(  @BCDNumber, 
					   @VehicleClassCode,
					   @QuotedRateID,
					   Null
					)
	END
GO

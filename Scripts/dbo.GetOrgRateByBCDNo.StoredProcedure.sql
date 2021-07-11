USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetOrgRateByBCDNo]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetOrgRateByBCDNo    Script Date: 2/18/99 12:12:02 PM ******/
/****** Object:  Stored Procedure dbo.GetOrgRateByBCDNo    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetOrgRateByBCDNo    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetOrgRateByBCDNo    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetOrgRateByBCDNo]
@BCDNum    char(10),
@PickupDate varchar(20),
@VehClassCode char(1)
AS
Select Distinct
	B.Rate_ID,B.Rate_Level,E.Vehicle_Class_Name
From
	Organization A,Organization_Rate B,Rate_Level C,
	Rate_Vehicle_Class D, Vehicle_Class E
Where
	A.BCD_Number = @BCDNum
	And B.Rate_ID=C.Rate_ID
	And B.Rate_ID=D.Rate_ID
	And B.Rate_Level=C.Rate_Level
	And D.Vehicle_Class_Code=@VehClassCode
	And E.Vehicle_Class_Code=@VehClassCode
	And A.Organization_ID=B.Organization_ID
	And B.Termination_Date="Dec 31 2078 11:59PM"
	And C.Termination_Date="Dec 31 2078 11:59PM"
	And D.Termination_Date="Dec 31 2078 11:59PM"
	And B.Valid_From<=Convert(datetime, @PickupDate)
	And B.Valid_To>=Convert(datetime, @PickupDate)
Return 1












GO

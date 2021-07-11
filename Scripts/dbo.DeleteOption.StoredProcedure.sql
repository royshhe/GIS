USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteOption]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.DeleteOption    Script Date: 2/18/99 12:12:00 PM ******/
/****** Object:  Stored Procedure dbo.DeleteOption    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DeleteOption    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.DeleteOption    Script Date: 11/23/98 3:55:32 PM ******/
CREATE PROCEDURE [dbo].[DeleteOption]
@VehicleClassCode char(1), @SelectedOption char(18)
AS
Insert Into Optional_Extra_Restriction
	(Vehicle_Class_Code,Optional_Extra_ID)
Values
	(@VehicleClassCode,Convert(smallint,@SelectedOption))
Return 1












GO

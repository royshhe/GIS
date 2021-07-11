USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateOption]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateOption    Script Date: 2/18/99 12:11:59 PM ******/
/****** Object:  Stored Procedure dbo.CreateOption    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateOption    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateOption    Script Date: 11/23/98 3:55:31 PM ******/  

/* Nov. 19 1999 - This stored procedure is only called by FleetControl.clsDataUpdate.Create_Option which is not being used. */

CREATE PROCEDURE [dbo].[CreateOption]
@VehicleClassCode char(1),@SelectedOption varchar(18)
AS
Delete From Optional_Extra_Restriction
Where
	Vehicle_Class_Code=@VehicleClassCode
	And Optional_Extra_ID=Convert(smallint,@SelectedOption)
Return 1













GO

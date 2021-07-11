USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRptVehClass]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO













/****** Object:  Stored Procedure dbo.GetRptVehClass    Script Date: 2/18/99 12:11:57 PM ******/
/****** Object:  Stored Procedure dbo.GetRptVehClass    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetRptVehClass    Script Date: 1/11/99 1:03:17 PM ******/
/*
PROCEDURE NAME: GetRptVehClass
PURPOSE: To retrieve a list of vehicle classes for a vehicle type
AUTHOR: Don Kirkby
DATE CREATED: Jan 5, 1999
CALLED BY: ReportParams
MOD HISTORY:
Name    Date        Comments
*/
/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetRptVehClass]
	@VehTypeId	varchar(18)
AS
	SELECT	@VehTypeId = NULLIF(@VehTypeId, '')
	if @VehTypeId<>'*'
        begin 

	SELECT	vehicle_class_name,
		vehicle_class_code
	  FROM	vehicle_class
	 WHERE	vehicle_type_id = @VehTypeId
	 ORDER
	    BY	vehicle_class_name
	end 
	else

        begin 
	
	SELECT	vehicle_class_name,
		vehicle_class_code
	  FROM	vehicle_class
	 --WHERE	vehicle_type_id = @VehTypeId
	 ORDER
	    BY	vehicle_class_name
	end 
















GO

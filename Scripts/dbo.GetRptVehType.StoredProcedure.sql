USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRptVehType]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO













/****** Object:  Stored Procedure dbo.GetRptVehType    Script Date: 2/18/99 12:11:47 PM ******/
/****** Object:  Stored Procedure dbo.GetRptVehType    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetRptVehType    Script Date: 1/11/99 1:03:17 PM ******/
/*
PROCEDURE NAME: GetRptVehType
PURPOSE: To retrieve a list of vehicle types
AUTHOR: Don Kirkby
DATE CREATED: Jan 5, 1999
CALLED BY: ReportParams
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetRptVehType]
AS
 	

          SELECT	vehicle_type_id
	  FROM	vehicle_type
	 ORDER
	    BY	vehicle_type_id
       
          
         













GO

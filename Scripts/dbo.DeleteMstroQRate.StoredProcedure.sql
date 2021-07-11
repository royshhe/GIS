USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteMstroQRate]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.DeleteMstroQRate    Script Date: 2/18/99 12:11:42 PM ******/
/****** Object:  Stored Procedure dbo.DeleteMstroQRate    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DeleteMstroQRate    Script Date: 1/11/99 1:03:15 PM ******/
/*
PROCEDURE NAME: DeleteMstroQRate
PURPOSE: To delete a record from the Quoted_Vehicle_Rate table
AUTHOR: Don Kirkby
DATE CREATED: Nov 25, 1998
CALLED BY: MaestroBatch
REQUIRES:
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[DeleteMstroQRate]
	@QRateId varchar(10)
AS
	/* 10/08/99 - do type conversion and nullif outside of select */

DECLARE @iQRateId Int

	SELECT	@iQRateId = CONVERT(Int, NULLIF(@QRateId,''))

	DELETE	
	  FROM	quoted_vehicle_rate
	 WHERE	quoted_rate_id = @iQRateId













GO

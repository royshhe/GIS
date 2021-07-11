USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateChargeGL]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.UpdateTruckAvail    Script Date: 2/18/99 12:12:05 PM ******/
/****** Object:  Stored Procedure dbo.UpdateTruckAvail    Script Date: 2/16/99 2:05:44 PM ******/
/****** Object:  Stored Procedure dbo.UpdateTruckAvail    Script Date: 1/11/99 1:03:18 PM ******/
/****** Object:  Stored Procedure dbo.UpdateTruckAvail    Script Date: 11/23/98 3:55:35 PM ******/
/*
PURPOSE: To update a record in Truck_Inventory table .
MOD HISTORY:
Name    Date        Comments
*/

/* Oct 27 - Moved data conversion code out of the where clause */ 

create PROCEDURE [dbo].[UpdateChargeGL]
	@ChargeCode Varchar(10),
	@VehType Varchar(10),
	@GL_Account varchar(32)
AS

	UPDATE	Charge_GL

	SET	GL_Revenue_Account = @GL_Account

	WHERE	Charge_Type_ID = @ChargeCode
	AND	Vehicle_Type_ID = @VehType

	RETURN @@ROWCOUNT
GO

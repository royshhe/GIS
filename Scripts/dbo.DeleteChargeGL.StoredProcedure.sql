USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteChargeGL]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create PROCEDURE [dbo].[DeleteChargeGL]
	@Code Varchar(10),
	@Vehicle_Type_ID Varchar(18)
AS
	Delete Charge_GL
		where	
		  Vehicle_Type_ID = @Vehicle_Type_ID
	and    Charge_Type_ID= Convert(int, NULLIF(@Code,""))
GO

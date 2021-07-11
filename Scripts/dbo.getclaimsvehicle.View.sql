USE [GISData]
GO
/****** Object:  View [dbo].[getclaimsvehicle]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
VIEW NAME: getclaimsvehicle
PURPOSE: Select vehicle information based on contract number for CARS program

AUTHOR:	Junaid Ahmed
DATE CREATED: 2002 Feb 26
USED BY: Enter Vehicle Accident Screen

MOD HISTORY:
Name 		Date		Comments

*/


CREATE VIEW [dbo].[getclaimsvehicle]
AS
SELECT     vehicle.Unit_Number,vehicle_model_year.model_name,vehicle_model_year.model_year,vehicle_licence_history.licence_plate_number

FROM         dbo.Vehicle,vehicle_model_year,vehicle_licence_history

where vehicle_model_year.vehicle_model_id=vehicle.vehicle_model_id
and vehicle_licence_history.unit_number=vehicle.unit_number







GO

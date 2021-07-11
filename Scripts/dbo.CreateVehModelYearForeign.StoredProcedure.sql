USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateVehModelYearForeign]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateVehModelYearForeign    Script Date: 2/18/99 12:12:07 PM ******/
/****** Object:  Stored Procedure dbo.CreateVehModelYearForeign    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.CreateVehModelYearForeign    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateVehModelYearForeign    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To insert a record into Vehicle_Model_Year table.
MOD HISTORY:
Name    Date        	Comments
NP	Jan/19/2000	Add Audit Info.
 */

CREATE PROCEDURE [dbo].[CreateVehModelYearForeign]
	@Model			VarChar(25),
	@ClassCode		Char(1),
	@ForeignModelOnly 	Char(1),
	@LastUpdatedBy	VarChar(20)
AS
	DECLARE @thisVehicleModelID	SmallInt
	INSERT INTO Vehicle_Model_Year
	(	Model_Name,
		Foreign_Model_Only,
		Last_Updated_By,
		Last_Updated_On
	)
	
	VALUES
	(	@Model,
		Convert(bit,@ForeignModelOnly),
		@LastUpdatedBy,
		GetDate()
	)
	Select @thisVehicleModelID = @@IDENTITY

	-- insert a record into vehicle class vehicle model yr	
	INSERT INTO Vehicle_Class_Vehicle_Model_Yr
	(	Vehicle_Model_ID,
		Vehicle_Class_Code
	)
	VALUES
	(	@thisVehicleModelID,
		@ClassCode
	)
				
Return @thisVehicleModelID














GO

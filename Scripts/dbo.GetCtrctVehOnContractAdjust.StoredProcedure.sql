USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctVehOnContractAdjust]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
















/****** Object:  Stored Procedure dbo.GetCtrctVehOnContractAdjust    Script Date: 2/18/99 12:12:16 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctVehOnContractAdjust    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctVehOnContractAdjust    Script Date: 1/11/99 1:03:15 PM ******/
/*  
PURPOSE: To retrieve vehicle on contract for the given contract number.
MOD HISTORY:
Name    Date        	Comments
CPY	Jan 26 2000	Changed order by to use Business_Transaction_Id desc
*/
CREATE PROCEDURE [dbo].[GetCtrctVehOnContractAdjust] --'802064'
	@ContractNum	Varchar(10)
AS
	DECLARE @dEndDate Datetime
	DECLARE @nContractNum Integer

	/* 4/20/99 - cpy bug fix - added order by Actual_Check_In Desc in case there are
				   2 rows with the same Checked_Out datetime */
	/* 8/04/99 - converted to use inner joins and add left outer join with
			vehicle_licence_history to get licence plate that was
			attached during check_out date */
	/* Nov 01 - Moved data conversion code with NULLIF out of the where clause */

	SELECT @dEndDate = Convert(Datetime, '31 Dec 2078 23:59')
	SELECT @nContractNum = Convert(Int, NULLIF(@ContractNum,""))

	SELECT
		VOC.Unit_Number,
		V.Foreign_Vehicle_Unit_Number,
		V.MVA_Number,
		VMY.Model_Name,
		Licence_Plate = ISNULL(VLH.Licence_Plate_Number, V.Current_Licence_Plate),
		OC.Name,
		CONVERT(Varchar(24), Checked_Out, 113) Original_Checked_Out,
		CONVERT(VarChar(11), Checked_Out, 113) Checked_Out_Date,
		CONVERT(VarChar(5), Checked_Out, 108) Checked_Out_Time,
		CONVERT(VarChar(11), Actual_Check_In, 13) Actual_Check_In_Date,
		CONVERT(VarChar(5), Actual_Check_In, 108) Actual_Check_In_Time,
		Pick_Up_Location_ID,
		Actual_Drop_Off_Location_ID,
		Km_Out,
		Km_In
	FROM	Vehicle_On_Contract VOC
		JOIN Vehicle V
		  ON VOC.Unit_Number = V.Unit_Number
		JOIN Owning_Company OC
		  ON V.Owning_Company_Id = OC.Owning_Company_Id
		JOIN Vehicle_Model_Year VMY
		  ON V.Vehicle_Model_Id = VMY.Vehicle_Model_Id
		LEFT JOIN Vehicle_Licence_History VLH
		  ON V.Unit_Number = VLH.Unit_Number
		 AND VOC.Checked_Out BETWEEN VLH.Attached_On AND
					ISNULL(VLH.Removed_On, @dEndDate)
		
	WHERE	VOC.Contract_Number = @nContractNum
	ORDER BY
		--Checked_Out Desc, Actual_Check_In Desc
		Business_Transaction_Id DESC
	RETURN @@ROWCOUNT





















GO

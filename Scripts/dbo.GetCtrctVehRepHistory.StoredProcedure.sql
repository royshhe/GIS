USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctVehRepHistory]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*  
PURPOSE: To return list of vehicle on contract for the given contract number.
MOD HISTORY:
Name    Date        	Comments
CPY	Jan 26 2000	Changed order by to use Business_Transaction_Id Desc
NP	Apr 14 2000	Return foreign vehicle unit number if it is not null; otherwise, return GIS unit number
NP	May 01 200	Convert Unit_Number to VarChar before returning the resultset.
*/
CREATE PROCEDURE [dbo].[GetCtrctVehRepHistory] --'3033609'
	@CtrctNum	VarChar(10)
AS
DECLARE @dEndDate Datetime, 
	@iCtrctNum Int

	/* Mar 5 99 - cpy bug fix - showing duplicate lines for the same unit
					if there is > 1 veh support incident */
	/* 8/04/99  - add left join with vehicle_licence_history to get licence
			plate that was attached during checked_out date */
	/* 10/1/99  - do type conversion and nullif outside of select */

	SELECT	@dEndDate = Convert(Datetime, '31 Dec 2078 23:59'), 
		@iCtrctNum = CONVERT(Int, NULLIF(@CtrctNum,''))

	SELECT	
		'Unit_Number' =
		Case
			When V.Foreign_Vehicle_Unit_Number IS NULL Then
				CONVERT(VarChar, V.Unit_Number)
			Else
				V.Foreign_Vehicle_Unit_Number
		End,
--		VOC.Unit_Number,
		VMY.Model_Name,
		Licence_Plate = ISNULL(VLH.Licence_Plate_Number, V.Current_Licence_Plate),
		VOC.KM_Out,
		VOC.KM_In,
		VOC.Fuel_Added_Litres,
		VOC.Fuel_Price_Per_Litre,
		VOC.Fuel_Added_Dollar_Amt,
		VOC.Calculated_Fuel_Litre,
		VOC.Calculated_Fuel_Charge,
		CONVERT(VarChar(1), VOC.FPO_Purchased),
		VOC.Upgrade_Charge,
		'Vehicle_Incident' =
		Case
			When VSI.Contract_Number IS NULL Then
				'No'
			Else
				'Yes'
		End,
		LT2.Value,
		LT.Value,
		VOC.Checked_In_By,
		VOC.Actual_Check_In,
		VOC.Checked_Out,
		VOC.Expected_Check_In,
		VOC.Calculated_Upgrade_Charge,
		l.location
		
	FROM	Vehicle_On_Contract VOC
		JOIN Vehicle V
		  ON VOC.Unit_Number = V.Unit_Number

		JOIN Vehicle_Model_Year VMY
		  ON V.Vehicle_Model_ID = VMY.Vehicle_Model_ID

		LEFT JOIN Lookup_Table LT
		  ON VOC.Check_In_Reason = LT.Code
		 AND LT.Category = 'Vehicle Check In Reason'

		LEFT JOIN
			Vehicle_Support_Incident VSI
			JOIN Lookup_Table LT2
			  ON VSI.Incident_Status = LT2.Code
			 AND LT2.Category = 'Vehicle Incident Status'
		  ON VOC.Contract_Number = VSI.Contract_Number
		 AND VOC.Unit_Number = VSI.Unit_Number
		 AND VSI.Vehicle_Support_Incident_Seq =
			(SELECT MAX(VSI2.Vehicle_Support_Incident_Seq)
			 FROM	Vehicle_Support_Incident VSI2
			 WHERE  VSI2.Contract_Number = VOC.Contract_number
			 AND	VSI2.Unit_Number = VOC.Unit_Number)
	
		LEFT JOIN Vehicle_Licence_History VLH
		  ON VOC.Unit_Number = VLH.Unit_Number
		 AND VOC.Checked_Out BETWEEN VLH.Attached_On AND
					ISNULL(VLH.Removed_On, @dEndDate)
		--left join Business_Transaction BT 
		--	on voc.Business_Transaction_ID=bt.Business_Transaction_ID
		left join location l
			on VOC.Pick_Up_Location_ID=l.Location_ID 	
			
		
	WHERE	VOC.Contract_Number = @iCtrctNum
	ORDER BY
		--ISNULL(VOC.Actual_Check_In, @dEndDate) DESC
		voc.Business_Transaction_ID Desc

	RETURN @@ROWCOUNT
GO

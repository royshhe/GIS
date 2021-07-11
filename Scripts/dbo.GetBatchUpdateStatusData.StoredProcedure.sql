USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetBatchUpdateStatusData]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.GetUpdateStatusSearchData    Script Date: 2/18/99 12:12:09 PM ******/
/****** Object:  Stored Procedure dbo.GetUpdateStatusSearchData    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetUpdateStatusSearchData    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetUpdateStatusSearchData    Script Date: 11/23/98 3:55:34 PM ******/
/*
PROCEDURE NAME: GetUpdateStatusSearchData
PURPOSE: To retrieve vehicle info that matches certain search criteria.
AUTHOR: ?
DATE CREATED: ?
CALLED BY: Fleet Control
MOD HISTORY:
Name    Date        Comments
Don K	Feb 10 1999 Removed outer join to Vehicle_Model_Year.
		I couldn't see why it was used.

*/
/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
/* MAR25 - MSSQL SERVER 2008 UPGRADE ROYHE */


--exec GetUpdateStatusSearchData '168998', '169500', '', '', '', '1'
--330
--169


CREATE  PROCEDURE [dbo].[GetBatchUpdateStatusData]
AS

Set RowCount 500
 
		Select Distinct top 100
			V.Unit_Number, V.Unit_Number, V.Serial_Number,
			VMY.Model_Year, VMY.Model_Name,
			VI.Status_Date,
			LT1.Value, LT2.Value, LT3.Value,
			V.Current_Km, V.Ownership_Date, L.Location,
			V.Current_Licence_Plate,
			VLM.Last_Move_Time
			
 

			From 	Vehicle V 
			INNER JOIN Vehicle_Status_Input VI
			On V.Unit_Number=VI.Unit_number
			INNER JOIN Vehicle_Model_Year VMY
			ON V.Vehicle_Model_ID = VMY.Vehicle_Model_ID
			INNER JOIN  Location L
			ON V.Current_Location_ID = L.Location_ID
			INNER JOIN Vehicle_Last_Movement VLM
			ON VLM.Unit_Number = V.Unit_Number
			LEFT JOIN 	Lookup_Table LT1
			ON  V.Current_Vehicle_Status= LT1.Code And LT1.Category = 'Vehicle Status'
			LEFT JOIN Lookup_Table LT2
			ON V.Current_Rental_Status = LT2.Code And LT2.Category = 'Vehicle Rental Status'
			LEFT JOIN  Lookup_Table LT3
			ON  V.Current_Condition_Status = LT3.Code And LT3.Category = 'Vehicle Condition Status'
		Where
			
			V.Deleted=0

			And V.Current_Vehicle_Status <> 'a' /* Ignore Drop Ship Status */
			And (Foreign_Vehicle_Unit_Number = ''
				Or Foreign_Vehicle_Unit_Number IS NULL)
			
		Order By V.Unit_Number

Return 1
GO

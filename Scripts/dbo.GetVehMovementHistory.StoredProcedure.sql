USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehMovementHistory]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
PURPOSE: To retrieve the history for a unit (show all movements and contracts)
MOD HISTORY:
Name	Date        	Comments
CPY	Jan 11 2000	Added join to override_check_in to display the override 
			check in KM_In
*/
CREATE PROCEDURE [dbo].[GetVehMovementHistory] --'8011','2000','1'
	@UnitNumber		VarChar(10),
	@Limit			VarChar(10) = Null,
	@MovementOnly	varchar(1)='0'
AS
	Declare  @I Int
	If @Limit <> '' and @Limit<>'4'
	  Begin
		Select @I = CONVERT(Int, @Limit)
		Set RowCount @I
	  End
	Else
		Set RowCount 2000

	IF @MovementOnly='0'
		SELECT	
			CONVERT(VarChar, VM.Movement_Out, 111) Date_Out,
			CONVERT(VarChar, VM.Movement_Out, 108) Time_Out,
			CONVERT(Varchar, ISNULL(VM.Movement_In, OMC.Movement_In), 111) Date_In,
			CONVERT(Varchar, ISNULL(VM.Movement_In, OMC.Movement_In), 108) Time_In, 
			VM.KM_Out KM_Out,
			ISNULL(VM.KM_In, OMC.KM_In) KM_In,
			LocOut.Location Location_Out,
			LocIn.Location Location_In,
			VM.Movement_Type Movement_Type,
			VM.Remarks_out + ' -- ' + VM.Remarks_In Comments
		FROM	Vehicle_Movement VM WITH(NOLOCK)
			JOIN Location LocOut
			  ON VM.Sending_Location_ID = LocOut.Location_ID
			JOIN Location LocIn
			  ON VM.Receiving_Location_ID = LocIn.Location_ID
			LEFT JOIN Override_Movement_Completion OMC
			  ON VM.Unit_Number = OMC.Unit_Number
			 AND VM.Movement_Out = OMC.Movement_Out
		WHERE	VM.Unit_Number = CONVERT(Int, @UnitNumber)
	UNION
		SELECT	
			CONVERT(VarChar, VOC.Checked_Out, 111) Date_Out,
			CONVERT(VarChar, VOC.Checked_Out, 108) Time_Out,

			'Date_In' =
			CASE
				WHEN VOC.Actual_Check_In IS NULL THEN
					CONVERT(Varchar, VOC.Expected_Check_In, 111)
				
					/* Jan 11 2000 - not sure if this logic is supposed to apply
					(SELECT	CASE 
						WHEN OCI.Check_In IS NULL THEN
							CONVERT(Varchar, VOC.Expected_Check_In, 111)
						ELSE
							CONVERT(VarChar, OCI.Check_In, 111)
				 		END) */
				ELSE
					CONVERT(VarChar, VOC.Actual_Check_In, 111)
				END,
			'Time_In' =
			CASE
				WHEN VOC.Actual_Check_In IS NULL THEN
					CONVERT(Varchar, VOC.Expected_Check_In, 108)

					/* Jan 11 2000 - not sure if this logic is supposed to apply
					(SELECT	CASE 
						WHEN OCI.Check_In IS NULL THEN
							CONVERT(Varchar, VOC.Expected_Check_In, 108)
						ELSE
							CONVERT(VarChar, OCI.Check_In, 108)
				 		END) */
				ELSE
					CONVERT(VarChar, VOC.Actual_Check_In, 108)
				END,
			VOC.KM_Out KM_Out,
			ISNULL(VOC.KM_In, OCI.KM_In),
			LocOut.Location Location_Out,
			LocIn.Location Location_In,
			CONVERT(VarChar, VOC.Contract_Number) Movement_Type,
			' ' Comments
		FROM	Vehicle_On_Contract VOC WITH(NOLOCK)
			JOIN Location LocOut
			  ON VOC.Pick_Up_Location_ID = LocOut.Location_ID
			JOIN Location LocIn
			  ON ((VOC.Expected_Drop_Off_Location_ID = LocIn.Location_ID 
					AND VOC.Actual_Drop_Off_Location_ID IS NULL)
				OR
				  (VOC.Actual_Drop_Off_Location_ID = LocIn.Location_ID 
					AND NOT VOC.Actual_Drop_Off_Location_ID IS NULL))
			LEFT JOIN Override_Check_In OCI
			  ON VOC.Unit_Number = OCI.Unit_Number
			 AND VOC.Checked_Out = OCI.Checked_Out
		WHERE	
			VOC.Unit_Number = CONVERT(Int, @UnitNumber)

		Order By Date_Out Desc, Time_Out Desc
	ELSE
		SELECT	
			vm.unit_number,
			CONVERT(Varchar, VM.Movement_Out) Movement_Out,
			CONVERT(VarChar, VM.Movement_Out, 111) Date_Out,
			CONVERT(VarChar, VM.Movement_Out, 108) Time_Out,
			CONVERT(Varchar, ISNULL(VM.Movement_In, OMC.Movement_In), 111) Date_In,
			CONVERT(Varchar, ISNULL(VM.Movement_In, OMC.Movement_In), 108) Time_In, 
			VM.KM_Out KM_Out,
			ISNULL(VM.KM_In, OMC.KM_In) KM_In,
			LocOut.Location Location_Out,
			LocIn.Location Location_In,
			VM.Movement_Type Movement_Type,
			convert(VarChar(1),VM.Billable) ,
			VM.Remarks_out Remarks_out,
			VM.Remarks_In Remarks_In
		FROM	Vehicle_Movement VM WITH(NOLOCK)
			JOIN Location LocOut
			  ON VM.Sending_Location_ID = LocOut.Location_ID
			JOIN Location LocIn
			  ON VM.Receiving_Location_ID = LocIn.Location_ID
			LEFT JOIN Override_Movement_Completion OMC
			  ON VM.Unit_Number = OMC.Unit_Number
			 AND VM.Movement_Out = OMC.Movement_Out
		WHERE	VM.Unit_Number = CONVERT(Int, @UnitNumber)		

		Order By Date_Out Desc, Time_Out Desc

RETURN 1
GO

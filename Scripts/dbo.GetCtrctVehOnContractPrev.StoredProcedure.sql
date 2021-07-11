USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctVehOnContractPrev]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO









/*  
PURPOSE: To return list of units, foreign indicator,
	 and licence plates excluding current vehicle
MOD HISTORY:
Name    Date        	Comments
CPY	Jan 25 2000	Changed order by to use Business_Transaction_id desc
*/
CREATE PROCEDURE [dbo].[GetCtrctVehOnContractPrev]
	@ContractNum Varchar(10)
AS
DECLARE @iContractNum Int
DECLARE	@dEndDate Datetime

	/* 2/18/99 - cpy created - return list of units, foreign indicator,
			and licence plates excluding current vehicle */
	/* 8/03/99 - convert to use inner join and left outer join with
			vehicle_licence_history to get licence plate
			that was current during check out */
	/* 12/13/99 - added Km_Driven as km_in - km_out */

	SELECT 	@iContractNum = Convert(Int, NULLIF(@ContractNum,'')),
		@dEndDate = Convert(Datetime, '31 Dec 2078 23:59')

	SELECT	Unit_Number = CASE
			WHEN V.Foreign_Vehicle_Unit_Number IS NULL THEN
				Convert(Varchar(20), V.Unit_Number)
			WHEN V.Foreign_Vehicle_Unit_Number = '' THEN
				Convert(Varchar(20), V.Unit_Number)
			ELSE
				V.Foreign_Vehicle_Unit_Number
		END,
		Is_Foreign = CASE
			WHEN V.Foreign_Vehicle_Unit_Number IS NULL THEN NULL
			WHEN V.Foreign_Vehicle_Unit_Number = '' THEN NULL
			ELSE 'F'
		END,
		Licence_Plate = ISNULL(VLH.Licence_Plate_Number, V.Current_Licence_Plate), 
		Km_Driven = ISNULL(Convert(Varchar(11), Km_In - Km_Out), 'Unknown')
	FROM	Vehicle V
		JOIN Vehicle_On_Contract VOC
		  ON VOC.Unit_Number = V.Unit_Number
		LEFT JOIN Vehicle_Licence_History VLH
		  ON VOC.Unit_Number = VLH.Unit_Number
		 AND VOC.Checked_Out BETWEEN VLH.Attached_On AND
					ISNULL(VLH.Removed_On, @dEndDate)
	WHERE	VOC.Business_Transaction_Id < 
				  (SELECT MAX(VOC2.Business_Transaction_Id)
				   FROM   Vehicle_On_Contract VOC2
				   WHERE  VOC2.Contract_Number = @iContractNum)
	AND	VOC.Contract_Number = @iContractNum
	ORDER BY VOC.Business_Transaction_Id DESC

	RETURN @@ROWCOUNT





















GO

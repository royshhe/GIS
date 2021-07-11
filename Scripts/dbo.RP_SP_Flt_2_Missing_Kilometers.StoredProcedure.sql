USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Flt_2_Missing_Kilometers]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO













/*
PROCEDURE NAME: RP_SP_Flt_2_Missing_Kilometers
PURPOSE: Select all information needed for all configurations in Missing Kilometers Report

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY: CMissing Kilometers Report
MOD HISTORY:
Name 		Date		Comments
*/


CREATE PROCEDURE [dbo].[RP_SP_Flt_2_Missing_Kilometers] --'*','15 Mar 2007','26 Mar 2007','280'
(
		@Vehicle_Type		CHAR(5)  = '*',	
		@Start_Date 		varchar(25) = '1 January 2000',
		@End_Date 		varchar(25) = '1 December 2000',
		@MissingKmLimit      	CHAR(4)  = '0'
		
)
	
AS
DECLARE @dStart datetime,
	@dEnd datetime,
	@iMissingKmLimit int


SELECT	@dStart = Convert(datetime,'00:00:00 ' + @Start_Date),
	@dEnd = Convert(datetime,'23:59:59 ' + @End_Date),
	@iMissingKmLimit = Convert(int, @MissingKmLimit)

SELECT 	
	Prev.Unit_Number,
	Vehicle.Foreign_Vehicle_Unit_Number,
	Vehicle_Class.Vehicle_Type_ID,
    	Vehicle.Owning_Company_ID AS Vehicle_Owning_Company_ID,
    	Prev.Drop_Off_Location_ID AS Prev_Drop_Off_Location_ID,
    	Location1.Location AS Prev_Drop_Off_Location_Name,
    	Prev.MTCN AS Prev_MTCN,
    	Prev.Date_In AS Prev_Drop_Off_Date,
    	Prev.Km_In AS Prev_Drop_Off_Km,
    	Cur.Pick_Up_Location_ID AS Cur_Pick_Up_Location_ID,
    	Location.Location AS Cur_Pick_Up_Location_Name,
    	Cur.MTCN AS Cur_MTCN,
    	Cur.Date_Out AS Cur_Pick_Up_Date,
    	Cur.Km_Out AS Cur_Pick_Up_Km,
    	ABS(Cur.Km_Out - Prev.Km_In) AS Missing_KM
FROM 	RP_Flt_2_Missing_Kilometers_L1_Base Prev with(nolock)
	INNER JOIN
    	RP_Flt_2_Missing_Kilometers_L1_Base Cur
		ON Prev.Unit_Number = Cur.Unit_Number
	INNER JOIN
    	Vehicle
		ON Prev.Unit_Number = Vehicle.Unit_Number
	LEFT JOIN
    	Location
		ON Cur.Pick_Up_Location_ID = Location.Location_ID
	LEFT JOIN
    	Location Location1
		ON  Prev.Drop_Off_Location_ID = Location1.Location_ID
	INNER JOIN
    	Vehicle_Class
		ON Vehicle.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
WHERE 	(Prev.Date_Out =  (SELECT MAX(Prev2.Date_Out)
			  FROM RP_Flt_2_Missing_Kilometers_L1_Base Prev2 with(nolock)
			  WHERE Prev2.Unit_Number = Cur.Unit_Number
				  AND
			   	 Prev2.Date_Out < Cur.Date_Out))
	 AND
    	(Vehicle.Current_Vehicle_Status = 'b' OR
	 Vehicle.Current_Vehicle_Status = 'd' OR
	 Vehicle.Current_Vehicle_Status = 'f' OR
	 Vehicle.Current_Vehicle_Status = 'j' OR
	 Vehicle.Current_Vehicle_Status = 'k')
	 AND
	 ABS(Cur.Km_Out - Prev.Km_In) <> 0

	AND

	(Cur.Date_Out BETWEEN @dStart AND @dEnd)
   		
	 AND

 	(ABS(Cur.Km_Out - Prev.Km_In)  > @iMissingKmLimit)

	AND

	(@Vehicle_Type = '*'
	 OR
	 Vehicle_Type_ID = @Vehicle_Type
	)

Return @@ROWCOUNT


























GO

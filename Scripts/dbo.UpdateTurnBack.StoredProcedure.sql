USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateTurnBack]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO




/****** Object:  Stored Procedure dbo.UpdateTurnBack    Script Date: 2/18/99 12:12:11 PM ******/
/****** Object:  Stored Procedure dbo.UpdateTurnBack    Script Date: 2/16/99 2:05:44 PM ******/
/****** Object:  Stored Procedure dbo.UpdateTurnBack    Script Date: 1/11/99 1:03:18 PM ******/
/****** Object:  Stored Procedure dbo.UpdateTurnBack    Script Date: 11/23/98 3:55:35 PM ******/
/*
PURPOSE: To update a record in Vehicle table .
MOD HISTORY:
Name    Date        Comments
*/
/* Oct 27 - Moved data conversion code out of the where clause */ 

CREATE PROCEDURE [dbo].[UpdateTurnBack]
@UnitNumber varchar(20),@TurnBackKm varchar(20),@DontRentPastKm varchar(20),
@ReconDays varchar(20),@MinimumDays varchar(20),@MaximumDays varchar(20),
@DontRentPastDays varchar(20),@Program char(1),@UserName varchar(30)
AS
Declare @thisProgrambit bit
Declare @nUnitNumber Integer

Select @nUnitNumber = Convert(int, NULLIF(@UnitNumber, ''))

If @Program = 'p'
	Select @thisProgramBit = 1
Else If @Program = 'r'
	Select @thisProgramBit = 0
Else
	Select @thisProgramBit =
		(Select
			Program
		From
			Vehicle
		Where
			Unit_Number=@nUnitNumber)
Update
	Vehicle
Set
	Maximum_Km=ISNULL(Convert(int,NULLIF(@TurnBackKm,'')),Maximum_Km),
	Do_Not_Rent_Past_Km=ISNULL(Convert(int,NULLIF(@DontRentPastKm,'')),Do_Not_Rent_Past_Km),
	Reconditioning_Days_Allowed=ISNULL(Convert(int,NULLIF(@ReconDays,'')),Reconditioning_Days_Allowed),
	Minimum_Days=ISNULL(Convert(int,NULLIF(@MinimumDays,'')),Minimum_Days),
	Maximum_Days=ISNULL(Convert(int,NULLIF(@MaximumDays,'')),Maximum_Days),
	Do_Not_Rent_Past_Days=ISNULL(Convert(int,NULLIF(@DontRentPastDays,'')),Do_Not_Rent_Past_Days),
	Program=@thisProgramBit,
	Last_Update_By=@UserName,
	Last_Update_On=getDate()
Where
	Unit_Number=@nUnitNumber
Return 1
GO

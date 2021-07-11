USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetConAddnlDrivers]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetConAddnlDrivers    Script Date: 2/18/99 12:12:14 PM ******/
/****** Object:  Stored Procedure dbo.GetConAddnlDrivers    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.GetConAddnlDrivers    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetConAddnlDrivers    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: 	To retrieve the additional driver for the given contract.
MOD HISTORY:
Name    Date        Comments
*/
/*
modified:
	NP - Aug 4, 1999 - Add No_Charge column at the end.
*/
CREATE PROCEDURE [dbo].[GetConAddnlDrivers]
	@ContractNum Varchar(10),
	@AddDriverId Varchar(10) = NULL
AS
DECLARE @iAddDriverId Int,
	@iCtrctNum Int

	SELECT	@iAddDriverId = Convert(Int, NULLIF(@AddDriverId,"")),
		@iCtrctNum = Convert(Int, NULLIF(@ContractNum,""))

	SELECT 	
		Additional_Driver_ID,
		Customer_Id,
		Addition_Type,
		Driver_Licence_Number,
		Driver_Licence_Jurisdiction,
		Birth_Date,
		Driver_Licence_Expiry,
		Driver_Licence_Class,
		Last_Name,
		First_Name,
		Address_1,
		Address_2,
		City,
		Province_State,
		Country,
		Postal_Code,
		Convert(Varchar(11), Valid_From, 13),	-- Valid From Date
		Convert(Varchar(5), Valid_From, 114), 	-- Valid From Time
		Convert(Varchar(11), Valid_To, 13),	-- Valid To Date
		Convert(Varchar(5), Valid_To, 114), 	-- Valid To Time
		Convert(Char(1), No_Charge)
	FROM	Contract_Additional_Driver
	WHERE	Contract_Number = @iCtrctNum
	AND	Additional_Driver_Id = ISNULL(@iAddDriverId, Additional_Driver_Id)
	AND	Termination_Date = '31 Dec 2078 23:59'

	RETURN @@ROWCOUNT






















GO

USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateInterimBillKm]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdateInterimBillKm    Script Date: 2/18/99 12:12:21 PM ******/
/****** Object:  Stored Procedure dbo.UpdateInterimBillKm    Script Date: 2/16/99 2:05:44 PM ******/
/****** Object:  Stored Procedure dbo.UpdateInterimBillKm    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.UpdateInterimBillKm    Script Date: 11/23/98 3:55:35 PM ******/
/*
PURPOSE: To update a list of records in Interim_Bill table .
MOD HISTORY:
Name    Date        Comments
*/
/* Oct 28 - Moved data conversion code out of the where clause */
CREATE PROCEDURE [dbo].[UpdateInterimBillKm]
@ContractNumber varchar(20), @OrgID varchar(20),
@Km varchar(20)
AS
Declare	@nContractNumber Integer
Select		@nContractNumber = Convert(int, NULLIF(@ContractNumber, ''))
Update
	Interim_Bill
Set
	Current_Km = Convert(int, @Km)
Where
	Contract_Number = @nContractNumber
	And Contract_Billing_Party_ID = -1
	And Interim_Bill_Date > getDate()
Return 1














GO

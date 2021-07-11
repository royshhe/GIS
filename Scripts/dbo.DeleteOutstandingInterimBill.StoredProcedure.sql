USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteOutstandingInterimBill]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.DeleteOutstandingInterimBill    Script Date: 2/18/99 12:12:21 PM ******/
/****** Object:  Stored Procedure dbo.DeleteOutstandingInterimBill    Script Date: 2/16/99 2:05:40 PM ******/
/*
PURPOSE: To delete record(s) from Interim_Bill table.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[DeleteOutstandingInterimBill]
@ContractNumber varchar(20)
AS
Delete From
	Interim_Bill
Where
	Contract_Number = Convert(int, @ContractNumber)
	And Interim_Bill_Date > getDate()
	
Return 1













GO

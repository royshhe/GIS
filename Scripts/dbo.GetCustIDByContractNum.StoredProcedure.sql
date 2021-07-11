USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCustIDByContractNum]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO













/****** Object:  Stored Procedure dbo.GetCustIDByContractNum    Script Date: 2/18/99 12:12:19 PM ******/
/****** Object:  Stored Procedure dbo.GetCustIDByContractNum    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.GetCustIDByContractNum    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCustIDByContractNum    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: 	To retrieve Custer ID for the given contract number.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCustIDByContractNum]
@ContractNumber varchar(35)
AS
-- DK 19990309 added Sequence_num

Select
	Customer_ID
From
	Contract
Where
	Contract_Number = Convert(int, @ContractNumber)
	
Return 1

GO

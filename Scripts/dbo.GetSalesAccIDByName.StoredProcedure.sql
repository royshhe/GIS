USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetSalesAccIDByName]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
create PROCEDURE [dbo].[GetSalesAccIDByName] --''
@SalesAccName varchar(20)
AS
declare @SalesAccID int

select @SalesAccID=(Select Sales_Accessory_ID
--select *
					From
						Sales_Accessory
					Where	Sales_Accessory =  @SalesAccName
					)
	
if @salesaccid is null
	Return 0
else
	Return @SalesAccID
GO

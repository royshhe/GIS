USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteCalculatedChargeItem]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.DeleteCalculatedChargeItem    Script Date: 2/18/99 12:12:22 PM ******/
/****** Object:  Stored Procedure dbo.DeleteCalculatedChargeItem    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DeleteCalculatedChargeItem    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.DeleteCalculatedChargeItem    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To delete record(s) from Contract_Charge_Item table.
MOD HISTORY:
Name    Date        Comments
 */

CREATE PROCEDURE [dbo].[DeleteCalculatedChargeItem]
@ContractNumber Varchar(35)
AS
Delete From
	Contract_Charge_Item
Where
	Contract_Number = Convert(Int, @ContractNumber)
	And Charge_Item_Type = 'c'
RETURN 1














GO
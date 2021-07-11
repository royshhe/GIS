USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteDiscount]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.DeleteDiscount    Script Date: 2/18/99 12:12:22 PM ******/
/****** Object:  Stored Procedure dbo.DeleteDiscount    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DeleteDiscount    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.DeleteDiscount    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To delete record(s) from Contract_Reimbur_And_Discount table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[DeleteDiscount]
@ContractNumber varchar(20)
AS
	/* 4/14/99 - cpy modified - removed params @EnteredOn and @DiscountType
				- delete all discounts/reimbursements when voiding contract
				- there is no need to delete discounts on a per row basis */

	Delete From	Contract_Reimbur_And_Discount
	Where		Contract_Number = Convert(int, @ContractNumber)
/*	And Entered_On = Convert(datetime, @EnteredOn)
	And Type = @DiscountType */

	Return @@ROWCOUNT














GO

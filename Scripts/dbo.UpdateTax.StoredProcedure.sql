USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateTax]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.CreateQTPR    Script Date: 2/18/99 12:11:50 PM ******/
/****** Object:  Stored Procedure dbo.CreateQTPR    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateQTPR    Script Date: 1/11/99 1:03:14 PM ******/
/*
PROCEDURE NAME: CreateQTPR
PURPOSE: To add a Time Period to a Quoted Vehicle Rate
AUTHOR: Don Kirkby
DATE CREATED: Dec 3, 1998
CALLED BY: Maestro
REQUIRES:
MOD HISTORY:
Name    Date        Comments
*/

--exec CreateTax N'1/1/2011 12:00:00 AM', N'1/1/2012 12:00:00 AM', N'teT', N'4.5', N'Percentage', N'Andy Z', N'20110711', N'5656565'

CREATE PROCEDURE [dbo].[UpdateTax]
	@Valid_From	varchar(30),
	@Valid_To	varchar(30),
	@Tax_Type	varchar(5),
	@Tax_Rate   varchar(15),
    @Rate_Type varchar(10),
	@Payables_Clearing_Account varchar(20)
AS
	UPDATE [Tax_Rate]
   SET [Payables_Clearing_Account] = @Payables_Clearing_Account , [Rate_Type] = @Rate_Type, [Tax_Rate] = convert(decimal(7,4), @Tax_Rate)
 WHERE [Valid_From] = convert(datetime, @Valid_From) and [Valid_To] = convert(datetime, @Valid_To) and [Tax_Type] = @Tax_Type
GO

USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[ITB_UpdateCoverageCharge]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO














/****** Object:  Stored Procedure dbo.CreateInterimBill    Script Date: 2/18/99 12:12:20 PM ******/
/****** Object:  Stored Procedure dbo.CreateInterimBill    Script Date: 2/16/99 2:05:39 PM ******/
/*
PURPOSE: To insert a list of records into Interim_Bill table.
MOD HISTORY:
Name    Date        Comments
*/

create PROCEDURE [dbo].[ITB_UpdateCoverageCharge]
@ContractNumber varchar(20),@BillingDate varchar(24),
@Amount varchar(20)
AS
/* Don K - Mar 15 1999 - Won't create an interim bill on the drop off date anymore.
select * from Interim_Bill
 */
 
 Update Interim_Bill
		set  Coverage_Amount=@Amount	
	 WHERE	contract_number = @ContractNumber
	   AND	Interim_Bill_Date = convert(datetime,@BillingDate)
			
 RETURN @@ROWCOUNT
 


GO

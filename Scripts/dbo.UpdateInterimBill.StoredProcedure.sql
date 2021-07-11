USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateInterimBill]    Script Date: 2021-07-10 1:50:50 PM ******/
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

CREATE PROCEDURE [dbo].[UpdateInterimBill]
@ContractNumber varchar(20), @OldBillingDate varchar(24),@BillingDate varchar(24),
@Amount varchar(20),@Km varchar(20)
AS
/* Don K - Mar 15 1999 - Won't create an interim bill on the drop off date anymore.
select * from Interim_Bill
 */
 
 Update Interim_Bill
		set  Interim_Bill_Date=@BillingDate,
			 Current_KM=@Km	
	 WHERE	contract_number = @ContractNumber
	   AND	Interim_Bill_Date = convert(datetime,@OldBillingDate)
	   and  @BillingDate not in (select Interim_Bill_Date from Interim_Bill where contract_number = @ContractNumber  )
			
 RETURN @@ROWCOUNT
 
 
--Declare @thisInterimBillDate datetime
--Declare @Done int
--If Convert(datetime,@oldDropOffDate) > Convert(datetime,@newDropOffDate) /* Contract length is being reduced */
--	Begin
--		Delete From
--			Interim_Bill
--		Where
--			Contract_Number = Convert(int, @ContractNumber)
--			And Contract_Billing_Party_ID = -1
--			And Interim_Bill_Date >= Convert(datetime,@newDropOffDate)
--	End
--Else
--	Begin
--		-- get the largest interim bill date, so the next one will be 30 days from it
--		Select @thisInterimBillDate =
--			(Select
--				Max(Interim_Bill_Date)
--			From
--				Interim_Bill
--			Where
--				Contract_Number = Convert(int, @ContractNumber)
--				And Contract_Billing_Party_ID = -1)
--		If @thisInterimBillDate is null
--			Select @thisInterimBillDate = Convert(datetime,@PickUpDate)
--		Select @Done = 0
--		While @Done = 0
--			If DateDiff(day, @thisInterimBillDate, Convert(datetime,@newDropOffDate)) > 30
--				Begin
--					Insert Into Interim_Bill Values
--						(Convert(int, @ContractNumber),
--						-1,
--						DateAdd(day, 30, @thisInterimBillDate),
--						Convert(int,@Km))
--					Select @thisInterimBillDate =
--						(Select DateAdd(day, 30, @thisInterimBillDate))
--				End
--			Else
--				Select @Done = 1
--	End							
--Return 1




GO

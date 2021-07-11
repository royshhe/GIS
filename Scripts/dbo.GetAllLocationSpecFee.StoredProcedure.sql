USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAllLocationSpecFee]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





Create Procedure [dbo].[GetAllLocationSpecFee]
	@LocID As varchar(5)
AS
Select 	Fee_Description,
	Fee_Type, 
          Type = Case when Flat_Fee is not null 
		Then 'Flat'
		Else Case when percentage_fee is not null 
			Then 'Percent'
			Else 'Per Day'
			End
		End,
	Amount = Case when Flat_Fee is not null 
		Then Flat_Fee
		Else Case when percentage_fee is not null 
			Then Percentage_fee
			Else Per_Day_Fee
			End
		End,
	Valid_From,
	Valid_To,
	Location_ID,
	Spec_Fee_ID
From Location_Specific_Fees
Where Location_ID = @LocID



GO

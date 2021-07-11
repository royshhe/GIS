USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAllMemberDiscount]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.GetAllMemberDiscount    Script Date: 2/18/99 12:11:43 PM ******/
/****** Object:  Stored Procedure dbo.GetAllMemberDiscount    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.GetAllMemberDiscount    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetAllMemberDiscount    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: 	To retrieve a list of discounts' info.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetAllMemberDiscount]
@EffDate varchar(25)= NULL
AS
  /* if @EffDate=''    --this is for all records without a specified date
	  begin
	
		SELECT	Discount, Discount_ID, Percentage
	FROM	Discount
	where Discount_ID not in ('D', 'E')
	ORDER BY Discount
	
	end 

else  --with date specified or Null (current date)
*/
begin

	declare @Eff_date datetime
	set @Eff_date = convert(datetime, isnull(@Effdate, cast(getdate() as varchar(25))) )
	 if @Effdate='' select @Eff_date=getdate()
	
	SELECT Discount,
		Discount_ID,
		Percentage
	  FROM	Discount
	where --Discount_ID not in ('D', 'E')   and 
	Effective_date<=@Eff_Date and termination_date>=@Eff_Date
	 ORDER
	    BY	Discount
end 

	RETURN @@ROWCOUNT
GO

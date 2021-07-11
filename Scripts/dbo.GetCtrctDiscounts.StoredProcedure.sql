USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctDiscounts]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.GetCtrctDiscounts    Script Date: 2/18/99 12:11:45 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctDiscounts    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctDiscounts    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctDiscounts    Script Date: 11/23/98 3:55:33 PM ******/
/*
PROCEDURE NAME: GetCtrctDiscounts
PURPOSE: To retrieve a list of membership discounts
AUTHOR: Don Kirkby
DATE CREATED: Aug 12, 1998
CALLED BY: Contract
REQUIRES:
ENSURES: returns the name, id, and percentage of each discount
MOD HISTORY:
Name    Date        Comments

modified on Oct 8, 2004
*/
CREATE PROCEDURE [dbo].[GetCtrctDiscounts]
@EffDate varchar(25)= NULL
AS
   /*if @EffDate='' or @EffDate is null    --this is for all records without a specified date
	  begin
	
		SELECT Discount,
			Discount_ID,
			Percentage
		  FROM	Discount
		where Discount_ID not in ('E')
		 ORDER
		    BY	Discount
	
	end 

else  --with date specified or Null (current date)
*/
begin

	declare @Eff_date datetime
	select @Eff_date = convert(datetime, isnull(@Effdate, cast(getdate() as varchar(25))) )
        if @Effdate='' select @Eff_date=getdate()
	
	SELECT Discount,
		Discount_ID,
		Percentage
	  FROM	Discount
	   where Discount_ID not in ('E')
	    and Effective_date<=@Eff_Date 
             and termination_date>=@Eff_Date
	 order bY	Discount
end 

	RETURN @@ROWCOUNT
GO

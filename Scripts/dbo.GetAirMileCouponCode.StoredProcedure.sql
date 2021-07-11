USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAirMileCouponCode]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO














/****** Object:  Stored Procedure dbo.GetAirMileCouponCode    Script Date: 2/18/99 12:11:45 PM ******/
/****** Object:  Stored Procedure dbo.GetAirMileCouponCode    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetAirMileCouponCode    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetAirMileCouponCode    Script Date: 11/23/98 3:55:33 PM ******/
/*
PROCEDURE NAME: GetAirMileCouponCode
PURPOSE: To retrieve all Coupon Code
AUTHOR: Roy He
DATE CREATED: Aug 11, 2007
CALLED BY: Contract
REQUIRES:
ENSURES: returns each coupon code.
MOD HISTORY:
Name    Date        Comments

changed on Oct 8,2004

*/

CREATE PROCEDURE [dbo].[GetAirMileCouponCode]
@EffDate varchar(25)=NULL
AS


		begin
		
		declare @Eff_date datetime
		
		select @Eff_date= convert(datetime, isnull(@Effdate, cast(getdate() as varchar(25))) )
                if @Effdate='' select @Eff_date=getdate()
		
			SELECT	Coupon_Code
				
			  FROM	Air_Miles_Coupon
		     where Effective_date<=@Eff_Date and termination_date>=@Eff_Date
		          
			 ORDER
			    BY	Coupon_Code
		end 

	RETURN  @@ROWCOUNT

GO

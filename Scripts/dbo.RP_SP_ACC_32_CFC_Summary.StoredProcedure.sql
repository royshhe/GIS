USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_ACC_32_CFC_Summary]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
   Create PROCEDURE [dbo].[RP_SP_ACC_32_CFC_Summary] -- '2010-08-01', '2010-08-10'
      @paramStartDate varchar(20) = '15 April 1999',
	@paramEndDate varchar(20) = '15 April 1999'
AS

-- convert strings to datetime
DECLARE 	@startDate datetime,
		@endDate datetime 
		 


SELECT	@startDate	= CONVERT(datetime, @paramStartDate),
		@endDate	= CONVERT(datetime, @paramEndDate)	


   Select  RentalDays ,   
   count(*) NumTrans,    
   (Case When RentalDays<=7 Then RentalDays*5 
        WHen RentalDays>7 Then 35
   End) RateCharged,   
     Sum(CFCAmount)as TotalCharge
   From 
   Contract_CFC_Charge_vw ConCFC
   where rbr_date >=@startDate and rbr_date<=@endDate
    Group by RentalDays
    order by RentalDays
GO

USE [GISData]
GO
/****** Object:  View [dbo].[ViewContractRateBaseAmount]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--Create By Roy He
-- May 12, 2004
CREATE View [dbo].[ViewContractRateBaseAmount]
as 
SELECT     Contract_Number, Pick_Up_On, Actual_Check_In, RentalHours, 
	BaseRate = CASE 
		  	WHEN DATENAME(dw, Pick_Up_On) = 'Saturday' OR DATENAME(dw, Pick_Up_On) = 'Friday'  or DATENAME(dw, Pick_Up_On) = 'Thursday' 
			THEN WeekendBaseRateAmount
                  		ELSE 
			WeekDayBaseRateAmount 
		  	END, 
        WeeklyBaseRateAmount as WeeklyRate,
	BaseAmount = CASE 
		  --WHEN master.dbo.GetRentalDays(RentalHours) 
	  WHEN  DATENAME(dw, Pick_Up_On) = 'Saturday' OR DATENAME(dw, Pick_Up_On) = 'Friday'  or DATENAME(dw, Pick_Up_On) = 'Thursday' 
	  THEN WeeklyBaseRateAmount* CONVERT(INT,master.dbo.GetRentalDays(RentalHours)/7)+
		    WeekendBaseRateAmount 
		     *(
				   master.dbo.GetRentalDays(RentalHours)-7*CONVERT(INT,master.dbo.GetRentalDays(RentalHours)/7)
                  	      )
                  ELSE             
		   --WeeklyBaseRateAmount* CONVERT(INT,RentalHours/168)+  this logic is inconsistent with the other.
                   WeeklyBaseRateAmount* CONVERT(INT,master.dbo.GetRentalDays(RentalHours)/7)+
		   WeekDayBaseRateAmount 
		      *(
			   master.dbo.GetRentalDays(RentalHours)-7*CONVERT(INT,master.dbo.GetRentalDays(RentalHours)/7)
                  	      )

   		  --WeekDayBaseRateAmount * master.dbo.GetRentalDays(RentalHours) 
		  END, 
		  master.dbo.GetRentalDays(RentalHours) AS rentaldays
FROM         dbo.ViewContractBaseRate



GO

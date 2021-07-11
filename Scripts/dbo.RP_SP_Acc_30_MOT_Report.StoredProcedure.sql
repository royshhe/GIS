USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_30_MOT_Report]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[RP_SP_Acc_30_MOT_Report] --'01 Feb 2017','31 Mar 2017'
(
	@paramStartDate varchar(20) = '15 April 1999',
	@paramEndDate varchar(20) = '15 April 1999'
)
AS
-- convert strings to datetime
DECLARE 	@startDate datetime,
		@endDate datetime

SELECT	@startDate	= CONVERT(datetime, @paramStartDate),
		@endDate	= CONVERT(datetime, @paramEndDate)	

if 	@startDate<convert(datetime,'01 Jun 2016' )
	SELECT TOP 100 PERCENT RevSum.RBR_Date, RevSum.Contract_Number,
		RevSum.First_name,
		RevSum.Last_name,
		RevSum.Address_1, 
		RevSum.Address_2, 
		RevSum.City, 
		RevSum.Province_State, 
		RevSum.Postal_Code,
		RevSum.Phone_Number,
		RevSum.Company_Name, 
		RevSum.Company_Phone_Number, 
		RevSum.Local_Phone_Number, 
		RevSum.Local_Address_1, 
		RevSum.Local_Address_2, 
		RevSum.Local_City,
	    
	 RevSum.Pick_Up_On, 
	 RevSum.Actual_Check_in, 
				   RevSum.PU_Location, 
				   RevSum.DO_Location, 
				   Round(RevSum.Contract_Rental_Days,2) Contract_Rental_Days, 
				   RevSum.TimeCharge, 
				   RevSum.Upgrade, 
				   RevSum.KMCharge, 
				   RevSum.DropOff_Charge, 
				   RevSum.FPO,
				   RevSum.KPO, 
				   RevSum.Additional_Driver_Charge, 
				   RevSum.All_Seats, 
				   RevSum.Driver_Under_Age, 
				   RevSum.All_Level_LDW, 
				   RevSum.PAI+RevSum.PEC+revsum.pae as PAE,
				   RevSum.RSN,	
				   RevSum.Ski_Rack, 
				   RevSum.All_Dolly, 
				   RevSum.All_Gates, 
				   RevSum.Blanket, 
				   RevSum.OutOfArea, 
				   RevSum.License_Recovery_fee, 
				   RevSum.Energy_Recovery_fee, 
				   RevSum.GPS,  
				   RevSum.Snow_Tire, 
				   RevSum.Fuel, 
				   RevSum.ELI, 
				   RevSum.Seat_Storage, 
				   RevSum.Location_Fee, 
				   RevSum.USB_Connector, 
				   RevSum.Sales_Accessory, 
				   RevSum.LossOfUse,
				   RevSum.TollAdmin,
				   RevSum.TrafficAdmin,
				   RevSum.DamageAdmin,
				   RevSum.Other,
				   NonApFeeItem, 
				   RevSum.TaxAmount, 
				   RAPay.PaymentAmount,
	               
				   RevSum.TimeCharge+ RevSum.Upgrade+ RevSum.KMCharge+ 
				   RevSum.DropOff_Charge+ RevSum.FPO+RevSum.KPO+ RevSum.Additional_Driver_Charge+ RevSum.All_Seats+ RevSum.Driver_Under_Age+ RevSum.All_Level_LDW+ RevSum.PAI+ 
				   RevSum.PEC+RevSum.PAE+RevSum.RSN+ RevSum.Ski_Rack+ RevSum.All_Dolly+ RevSum.All_Gates+ RevSum.Blanket+ RevSum.OutOfArea+ RevSum.License_Recovery_fee+ 
				   RevSum.Energy_Recovery_fee+ RevSum.GPS+  RevSum.Snow_Tire+ RevSum.Fuel+ RevSum.ELI+ RevSum.Seat_Storage+ 
				   RevSum.Location_Fee+ RevSum.USB_Connector+ RevSum.Sales_Accessory+ RevSum.Other+
				   RevSum.LossOfUse+RevSum.TollAdmin+RevSum.TrafficAdmin+RevSum.DamageAdmin+NonApFeeItem+ RevSum.TaxAmount as TotalCharge
	FROM  dbo.Contract_Revenue_Sum_vw AS RevSum INNER JOIN
				   dbo.Contract_Payment_Amount_vw AS RAPay ON RevSum.Contract_Number = RAPay.Contract_Number
	WHERE (RevSum.PU_Location like 'B-03 Downtown%' and Revsum.DO_Location in ('B-01 YVR Airport','B-02 YVR South Terminal')
				or RevSum.PU_Location like 'B-35 Richmond%' and Revsum.DO_Location in ('B-01 YVR Airport','B-02 YVR South Terminal')) AND (RevSum.RBR_Date BETWEEN @startDate AND @endDate)
	ORDER BY RevSum.RBR_Date

else
	SELECT TOP 100 PERCENT RevSum.RBR_Date, RevSum.Contract_Number,
		RevSum.First_name,
		RevSum.Last_name,
		RevSum.Address_1, 
		RevSum.Address_2, 
		RevSum.City, 
		RevSum.Province_State, 
		RevSum.Postal_Code,
		RevSum.Phone_Number,
		RevSum.Company_Name, 
		RevSum.Company_Phone_Number, 
		RevSum.Local_Phone_Number, 
		RevSum.Local_Address_1, 
		RevSum.Local_Address_2, 
		RevSum.Local_City,
	    
	 RevSum.Pick_Up_On, 
	 RevSum.Actual_Check_in, 
				   RevSum.PU_Location, 
				   RevSum.DO_Location, 
				   Round(RevSum.Contract_Rental_Days,2) Contract_Rental_Days, 
				   RevSum.TimeCharge, 
				   RevSum.Upgrade, 
				   RevSum.KMCharge, 
				   RevSum.DropOff_Charge, 
				   RevSum.FPO,
				   RevSum.KPO, 
				   RevSum.Additional_Driver_Charge, 
				   RevSum.All_Seats, 
				   RevSum.Driver_Under_Age, 
				   RevSum.All_Level_LDW, 
				   RevSum.PAI+RevSum.PEC+revsum.pae as PAE,
				   RevSum.RSN,	
				   RevSum.Ski_Rack, 
				   RevSum.All_Dolly, 
				   RevSum.All_Gates, 
				   RevSum.Blanket, 
				   RevSum.OutOfArea, 
				   RevSum.License_Recovery_fee, 
				   RevSum.Energy_Recovery_fee, 
				   RevSum.GPS,  
				   RevSum.Snow_Tire, 
				   RevSum.Fuel, 
				   RevSum.ELI, 
				   RevSum.Seat_Storage, 
				   RevSum.Location_Fee, 
				   RevSum.USB_Connector, 
				   RevSum.Sales_Accessory, 
				   RevSum.LossOfUse,
				   RevSum.TollAdmin,
				   RevSum.TrafficAdmin,
				   RevSum.DamageAdmin,
				   RevSum.Other,
				   NonApFeeItem, 
				   RevSum.TaxAmount, 
				   RAPay.PaymentAmount,
	               
				   RevSum.TimeCharge+ RevSum.Upgrade+ RevSum.KMCharge+ 
				   RevSum.DropOff_Charge+ RevSum.FPO+RevSum.KPO+ RevSum.Additional_Driver_Charge+ RevSum.All_Seats+ RevSum.Driver_Under_Age+ RevSum.All_Level_LDW+ RevSum.PAI+ 
				   RevSum.PEC+RevSum.PAE+RevSum.RSN+ RevSum.Ski_Rack+ RevSum.All_Dolly+ RevSum.All_Gates+ RevSum.Blanket+ RevSum.OutOfArea+ RevSum.License_Recovery_fee+ 
				   RevSum.Energy_Recovery_fee+ RevSum.GPS+  RevSum.Snow_Tire+ RevSum.Fuel+ RevSum.ELI+ RevSum.Seat_Storage+ 
				   RevSum.Location_Fee+ RevSum.USB_Connector+ RevSum.Sales_Accessory+ RevSum.Other+
				   RevSum.LossOfUse+RevSum.TollAdmin+RevSum.TrafficAdmin+RevSum.DamageAdmin+NonApFeeItem+ RevSum.TaxAmount as TotalCharge

	FROM  dbo.Contract INNER JOIN
				   dbo.Contract_Revenue_Sum_vw AS RevSum ON dbo.Contract.Contract_Number = RevSum.Contract_Number
			INNER JOIN
				   dbo.Contract_Payment_Amount_vw AS RAPay ON RevSum.Contract_Number = RAPay.Contract_Number
				   				   
			--INNER JOIN   	RP__Last_Vehicle_On_Contract rlv
			--ON dbo.Contract.Contract_Number = rlv.Contract_Number
			--left join [Contract_Reimbur_Total_vw] CRT 
			--	on dbo.Contract.Contract_number=crt.contract_number
	               
	WHERE (dbo.Contract.Arrived_Through_AP = 1) AND (RevSum.RBR_Date BETWEEN @startDate AND @endDate) AND 
				   (RevSum.PU_Location NOT IN ('B-40 Abbotsford Airport', 'B-01 YVR Airport'))
	--ORDER BY RevSum.PU_Location, dbo.Contract.contract_number
	
	Union
	
	SELECT TOP 100 PERCENT RevSum.RBR_Date, RevSum.Contract_Number,
		RevSum.First_name,
		RevSum.Last_name,
		RevSum.Address_1, 
		RevSum.Address_2, 
		RevSum.City, 
		RevSum.Province_State, 
		RevSum.Postal_Code,
		RevSum.Phone_Number,
		RevSum.Company_Name, 
		RevSum.Company_Phone_Number, 
		RevSum.Local_Phone_Number, 
		RevSum.Local_Address_1, 
		RevSum.Local_Address_2, 
		RevSum.Local_City,
	    
	 RevSum.Pick_Up_On, 
	 RevSum.Actual_Check_in, 
				   RevSum.PU_Location, 
				   RevSum.DO_Location, 
				   Round(RevSum.Contract_Rental_Days,2) Contract_Rental_Days, 
				   RevSum.TimeCharge, 
				   RevSum.Upgrade, 
				   RevSum.KMCharge, 
				   RevSum.DropOff_Charge, 
				   RevSum.FPO,
				   RevSum.KPO, 
				   RevSum.Additional_Driver_Charge, 
				   RevSum.All_Seats, 
				   RevSum.Driver_Under_Age, 
				   RevSum.All_Level_LDW, 
				   RevSum.PAI+RevSum.PEC+revsum.pae as PAE,
				   RevSum.RSN,	
				   RevSum.Ski_Rack, 
				   RevSum.All_Dolly, 
				   RevSum.All_Gates, 
				   RevSum.Blanket, 
				   RevSum.OutOfArea, 
				   RevSum.License_Recovery_fee, 
				   RevSum.Energy_Recovery_fee, 
				   RevSum.GPS,  
				   RevSum.Snow_Tire, 
				   RevSum.Fuel, 
				   RevSum.ELI, 
				   RevSum.Seat_Storage, 
				   RevSum.Location_Fee, 
				   RevSum.USB_Connector, 
				   RevSum.Sales_Accessory, 
				   RevSum.LossOfUse,
				   RevSum.TollAdmin,
				   RevSum.TrafficAdmin,
				   RevSum.DamageAdmin,
				   RevSum.Other,
				   NonApFeeItem, 
				   RevSum.TaxAmount, 
				   RAPay.PaymentAmount,
	               
				   RevSum.TimeCharge+ RevSum.Upgrade+ RevSum.KMCharge+ 
				   RevSum.DropOff_Charge+ RevSum.FPO+RevSum.KPO+ RevSum.Additional_Driver_Charge+ RevSum.All_Seats+ RevSum.Driver_Under_Age+ RevSum.All_Level_LDW+ RevSum.PAI+ 
				   RevSum.PEC+RevSum.PAE+RevSum.RSN+ RevSum.Ski_Rack+ RevSum.All_Dolly+ RevSum.All_Gates+ RevSum.Blanket+ RevSum.OutOfArea+ RevSum.License_Recovery_fee+ 
				   RevSum.Energy_Recovery_fee+ RevSum.GPS+  RevSum.Snow_Tire+ RevSum.Fuel+ RevSum.ELI+ RevSum.Seat_Storage+ 
				   RevSum.Location_Fee+ RevSum.USB_Connector+ RevSum.Sales_Accessory+ RevSum.Other+
				   RevSum.LossOfUse+RevSum.TollAdmin+RevSum.TrafficAdmin+RevSum.DamageAdmin+NonApFeeItem+ RevSum.TaxAmount as TotalCharge
	FROM  dbo.Contract_Revenue_Sum_vw AS RevSum INNER JOIN
				   dbo.Contract_Payment_Amount_vw AS RAPay ON RevSum.Contract_Number = RAPay.Contract_Number
	WHERE (RevSum.PU_Location like 'B-03 Downtown%' and Revsum.DO_Location in ('B-01 YVR Airport','B-02 YVR South Terminal')
				or RevSum.PU_Location like 'B-35 Richmond%' and Revsum.DO_Location in ('B-01 YVR Airport','B-02 YVR South Terminal')) 
				AND (RevSum.RBR_Date BETWEEN @startDate AND @endDate)
				And (RevSum.Pick_Up_On<'2017/02/01' and Actual_Check_in>='2017/03/31')
	ORDER BY RevSum.RBR_Date
	
 


--select * from vehicle_class	 where maestro_code='c'

--select * from reser



--select * from location where owning_company_id=7425 and rental_location=1
	 





GO

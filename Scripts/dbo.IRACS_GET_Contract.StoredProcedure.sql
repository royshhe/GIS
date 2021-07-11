USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[IRACS_GET_Contract]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--------------------------------------------------------------------------------------------------------------------
--	Programmer:	Roy He
--	Date:		2008-01-10
--	Details		IRACS Submission
--	Modification:		Name:		Date:		Detail:
--
---------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[IRACS_GET_Contract] --1068775
(
	@CtrctNumber varchar(20)
)
AS
DECLARE @RenterDriving bit
DECLARE @PickupDate DateTime
DECLARE @LicNumber Varchar(19)
DECLARE @LicState Varchar(5)
DECLARE @LicCountry Varchar(10)
DECLARE @LicExpire Datetime
DECLARE @AdditionalDriverID Integer

--Additional Driver
DECLARE @AddtionalDriverCount Integer
DECLARE @ADDFirstName Varchar(15)
DECLARE @ADDLastName Varchar(15)
DECLARE @ADDLicNumber Varchar(19)
DECLARE @ADDLicState Varchar(5)
DECLARE @AddLicCountry Varchar(10)
DECLARE @AddLicExpire Datetime
DECLARE @AddDOB Datetime

DECLARE @GSTRate Decimal(7,4)
DECLARE @PSTRate Decimal(7,4)

DECLARE @LocIn Integer
DECLARE @LocInCounterCode Char(10)
DECLARE @Actual_Check_In DateTime
DECLARE @RentalDays Decimal(9,5)


--Using RP__Last_Vehicle_On_Contract Caused Internal SQL Error

--Removed RP__Last_Vehicle_On_Contract



Select @Actual_Check_In=Actual_Check_In, 
       @LocIn=Actual_Drop_Off_Location_ID 
from RP__Last_Vehicle_On_Contract 
where contract_number=Convert(int, @CtrctNumber)

Select @LocInCounterCode=CounterCode 
from Location 
where Location_ID=@LocIn


Select @RentalDays=Rental_Day from Contract_Rental_Days_vw where Contract_number=Convert(int, @CtrctNumber)


select @RenterDriving=Contract.Renter_Driving, 
	@PickupDate=Pick_Up_On 
from Contract 
where Contract_number=Convert(int, @CtrctNumber)

SELECT @GSTRate=Tax_Rate
FROM Tax_Rate where @PickupDate between Valid_From  and Valid_To   and (Tax_Type='GST' or Tax_Type='HST')

SELECT @PSTRate=Tax_Rate
FROM Tax_Rate where @PickupDate between Valid_From  and Valid_To   and Tax_Type='PST'

Select @AddtionalDriverCount=count(*) from Contract_Additional_Driver where Contract_number=Convert(int, @CtrctNumber)


if @RenterDriving=1 
	Begin
	
		SELECT   @LicNumber=   dbo.Renter_Driver_Licence.Licence_Number, @LicState=dbo.Lookup_Table.Code, @LicCountry=dbo.Lookup_Table.Alias, @LicExpire=dbo.Renter_Driver_Licence.Expiry
		
		FROM         dbo.Renter_Driver_Licence LEFT OUTER JOIN
		                      dbo.Lookup_Table ON dbo.Renter_Driver_Licence.Jurisdiction = dbo.Lookup_Table.[Value]
		where category='Province' and Contract_number=Convert(int, @CtrctNumber)
	
	
	    -- Additional Driver
	    	SELECT     TOP 1 @ADDFirstName=First_Name,@ADDLastName=Last_Name, 
			@ADDLicNumber=Contract_Additional_Driver.Driver_Licence_Number, 
			@ADDLicState=Lookup_Table.Code, 
			@AddLicCountry=Contract_Additional_Driver.Country, 
			@AddLicExpire=dbo.Contract_Additional_Driver.Driver_Licence_Expiry,
			@AddDOB=Contract_Additional_Driver.Birth_Date
		FROM        Contract_Additional_Driver LEFT OUTER JOIN
		            Lookup_Table ON Contract_Additional_Driver.Province_State = Lookup_Table.[Value]
		WHERE     (Lookup_Table.Category = 'Province')and Contract_number=Convert(int, @CtrctNumber) --and Contract_Additional_Driver.No_Charge=1
		order by No_Charge,First_Name

	End
          

Else
       Begin
	
		SELECT     TOP 1 @LicNumber=Contract_Additional_Driver.Driver_Licence_Number, @LicState=Lookup_Table.Code, 
				@LicCountry=Contract_Additional_Driver.Country, 
		                @LicExpire=Contract_Additional_Driver.Driver_Licence_Expiry,
				@AdditionalDriverID=Additional_Driver_ID
		FROM         Contract_Additional_Driver LEFT OUTER JOIN
		                      Lookup_Table ON Contract_Additional_Driver.Province_State = Lookup_Table.[Value]
		WHERE     (Lookup_Table.Category = 'Province')and Contract_number=Convert(int, @CtrctNumber) and Contract_Additional_Driver.No_Charge=1
	        Order by Additional_Driver_ID
		
		If @AddtionalDriverCount>1 
			SELECT     TOP 1 @ADDFirstName=First_Name,@ADDLastName=Last_Name, 
			@ADDLicNumber=Contract_Additional_Driver.Driver_Licence_Number, 
			@ADDLicState=Lookup_Table.Code, 
			@AddLicCountry=Contract_Additional_Driver.Country, 
			@AddLicExpire=Contract_Additional_Driver.Driver_Licence_Expiry,
			@AddDOB=Contract_Additional_Driver.Birth_Date
			FROM        Contract_Additional_Driver LEFT OUTER JOIN
			            Lookup_Table ON Contract_Additional_Driver.Province_State = Lookup_Table.[Value]
			WHERE     (Lookup_Table.Category = 'Province')and Contract_number=Convert(int, @CtrctNumber) and Additional_Driver_ID<>@AdditionalDriverID  --and Contract_Additional_Driver.No_Charge=1
			order by No_Charge,Additional_Driver_ID

	End



	
Select 
c.First_Name, c.Last_Name, c.Address_1, c.Address_2, c.City, c.Province_State, c.Postal_Code, c.Phone_Number, c.Gender, c.DateofBirth, c.CustNum, c.LicNumber, c.LicState, c.LicCountry, c.LicExpire, c.CorpID, c.BusName, c.BusPhone, c.EmpOut, c.locOut, c.Pick_Up_On, c.locDue, c.Drop_Off_On, c.empIn, c.LocIn, c.Actual_Check_In, c.RAStat, c.Segment, c.Contract, c.DBRDays, c.Remarks, c.RAType, c.AddlFirst, c.AddlLast, c.AddlLicNum, c.AddlLicState, c.AddlLicCountry, c.AddlLicExp, c.AddlDOB, c.TotalDays, c.TotalTime, c.TotalMileage, c.Discount, c.FuelAmt, c.LDWCharegs, c.EPSCharge, c.PAI_PEC, c.DropCharge, c.Equipcharges, 
c.OCCCharegs + (Case 
			When Reimbursement.ReimbursementAmount is not Null Then Reimbursement.ReimbursementAmount 
			Else 0 
		End ) as OCCCharegs, c.TotalTaxes, 
c.TotalRental+ (Case 
			When Reimbursement.ReimbursementAmount is not Null Then Reimbursement.ReimbursementAmount 
			Else 0 
		End ) as  TotalRental, c.LDWID, c.LDWCov, c.ESPID, c.PAEID, c.PAEType, c.REfuleing, c.TimeTaxable, c.MileTaxable, c.DiscTaxable, c.FuleTaxable, c.LDWTaxable, c.ESPTaxable, c.PAETaxable, c.DROPTaxable, c.SalesTaxRate, c.Foreign_Confirm_Number, c.IATANum, c.FTN
From

(
	SELECT    -- Contract.Contract_Number, 
	replace(Contract.First_Name,'"','''') as First_Name, 
	replace(Contract.Last_Name,'"','''') as Last_Name, 
	replace(Contract.Address_1,'"','''') as Address_1, 
	replace(Contract.Address_2,'"','''') as Address_2, 
	Contract.City, 
	Contract.Province_State,
	Contract.Postal_Code, 
	Contract.Phone_Number, 
	
	Case 
		when Contract.Gender=1 Then 'M'
		when Contract.Gender=2 Then 'F'
	End as Gender,
	Contract.Birth_Date DateofBirth, 
	Contract.Customer_Program_Number CustNum,                       
	@LicNumber AS LicNumber, 
	@LicState AS LicState, 
	@LicCountry AS LicCountry,
	@LicExpire AS LicExpire,

    (CASE WHEN Contract.BCD_Rate_Organization_ID IS NOT NULL THEN BCD_Rate_Organization.BCD_number 
				WHEN Reservation.BCD_Number IS NOT NULL THEN Reservation.BCD_Number 
                ELSE NULL 
     END) AS  CorpID, 

	--Reservation.BCD_Number as CorpID, 
	replace(Contract.Company_Name,'"','''') BusName, 
	Contract.Company_Phone_Number BusPhone, 
	'8888' AS EmpOut, 
	LocationOut.CounterCode AS locOut, 
	Contract.Pick_Up_On, 
	LocationDue.CounterCode AS locDue, 
	Contract.Drop_Off_On, 
	'8888' AS empIn, 
	@LocInCounterCode AS LocIn, 
	@Actual_Check_In Actual_Check_In, 
	'C' AS RAStat, 
	'BG' AS Segment, 
	Contract.Contract_Number AS Contract, 
	@RentalDays AS DBRDays,
	replace(substring(Contract.Print_Comment,1,40),'"','''') AS Remarks,
	Case When Contract.Foreign_Contract_Number is Null then 'A'
	     Else 'F'
	End As RAType,
	
	@ADDFirstName As AddlFirst,
	@ADDLastName As AddlLast,
	@ADDLicNumber As AddlLicNum,
	@ADDLicState As AddlLicState,
	@AddLicCountry AddlLicCountry,
	@AddLicExpire AddlLicExp,
	@AddDOB AddlDOB, 
	@RentalDays AS TotalDays, 
	
	SUM(
		CASE 
			WHEN Contract_Charge_Item.Charge_Type IN (10) 
			THEN Contract_Charge_Item.Amount-(GST_Amount_Included+PST_Amount_Included+PVRT_Amount_Included)  ELSE 0 
		END) 
	AS TotalTime, 
	
	SUM(CASE WHEN Charge_Type IN (11) THEN Amount-(GST_Amount_Included+PST_Amount_Included+PVRT_Amount_Included) ELSE 0 END) AS TotalMileage, 
	
	SUM(CASE WHEN Charge_Type IN (50, 51, 52) THEN Amount-(GST_Amount_Included+PST_Amount_Included+PVRT_Amount_Included) ELSE 0 END) AS Discount, 
	
	SUM(CASE WHEN Charge_Type IN (14, 18) Then Amount-(GST_Amount_Included+PST_Amount_Included+PVRT_Amount_Included) 
		ELSE 0 
	END) AS FuelAmt, 
	
	
	SUM(CASE WHEN Optional_Extra.Type IN ('LDW', 'BUYDOWN') OR (Charge_Type = 61 AND Charge_Item_Type = 'a')  OR (Charge_Type = 91)   OR (dbo.Contract_Charge_Item.Charge_Type = 98)  
	THEN Amount-(GST_Amount_Included+PST_Amount_Included+PVRT_Amount_Included) ELSE 0 END) AS LDWCharegs, 
	
	0 as EPSCharge,
	
	SUM(CASE WHEN  Optional_Extra.Type IN ('PAI', 'PEC', 'Cargo','PAE','RSN')  OR
	               (Charge_Type = 62 AND Charge_Item_Type = 'a') OR
	               (Charge_Type = 63 AND Charge_Item_Type = 'a') OR
	               (Charge_Type in (90,92,93))
	
		THEN Amount-(GST_Amount_Included+PST_Amount_Included+PVRT_Amount_Included) ELSE 0 
	    END) AS PAI_PEC, 
	
	SUM(CASE WHEN Charge_Type = 33 THEN Amount-(GST_Amount_Included+PST_Amount_Included+PVRT_Amount_Included) ELSE 0 END) AS DropCharge, 
	
	
	SUM(CASE WHEN Charge_Type IN (23, 34, 37, 39, 96, 97, 20, 34, 36,67,68) OR Optional_Extra.Type in ('Other', 'GPS', 'ELI') THEN Amount-(GST_Amount_Included+PST_Amount_Included+PVRT_Amount_Included)
		ELSE 0
	END)
	
	+Sum(PVRT_Amount+PVRT_Amount_Included)
	
	as Equipcharges,
	
	
	--SUM(CASE	WHEN Charge_Type in (13,15,16,17,19,21,22,24,25,26,27,28,29,31,32,38,40,41,42,43,44,46,47,48,49, 60,64,65,66,70,71,94,95,99) THEN Amount-(GST_Amount_Included+PST_Amount_Included+PVRT_Amount_Included) 
	--	ELSE 0
	--    END)
	
	
	SUM(CASE	WHEN Charge_Type in (13,15,16,17,19,21,22,24,25,26,27,28,29,31,32,38,40,41,42,43,44,46,47,48,49, 60,64,65,66,70,94,95,99) THEN Amount-(GST_Amount_Included+PST_Amount_Included+PVRT_Amount_Included) 
		ELSE 0
	    END)
	    
	    
	/*+SUM(Case 
		When Reimbursement.Contract_number is not null Then ReimbursementAmount
		Else 0
	     End)
	*/
	 AS OCCCharegs,
	
	sum(GST_Amount)+sum(PST_Amount)+sum(GST_Amount_Included) +sum(PST_Amount_Included)
	+
	SUM(CASE	WHEN Charge_Type in (71,72,73) THEN Amount 
		ELSE 0
	    END)
	+
	sum(
		CASE	WHEN Charge_Type in (30,35,45) THEN Amount-(GST_Amount_Included+PST_Amount_Included+PVRT_Amount_Included) 
			ELSE 0
	    	END
	    )
	
	
	
	 as TotalTaxes,
	
	-- Total Rental Should include tax According to Doug Stuart
	--sum(amount)-(sum(GST_Amount_Included) +sum(PST_Amount_Included)+sum(PVRT_Amount_Included)) as TotalRental,
	sum(amount)+sum(GST_Amount)+sum(PST_Amount)+sum(PVRT_Amount)  as TotalRental,
	
	(
	Case when 
	       SUM(CASE WHEN Optional_Extra.Type IN ('LDW', 'BUYDOWN') OR (Charge_Type = 61 AND Charge_Item_Type = 'a') OR (Charge_Type = 91)   
		THEN Amount ELSE 0 END)
		>0 then 'Y'
		Else 'N'
		End
	) as LDWID,
	
	SUM(CASE WHEN Optional_Extra.Type IN ('LDW', 'BUYDOWN') OR (Charge_Type = 61 AND Charge_Item_Type = 'a') 
	THEN Amount ELSE 0 END) AS LDWCov,
	'N' as ESPID,
	(
	Case when
	
	                SUM(CASE WHEN  Optional_Extra.Type IN ('PAI','PEC','Cargo','PAE','RSN')  OR
	                      (Charge_Type = 62 AND Charge_Item_Type = 'a') OR
	                      (Charge_Type = 63 AND Charge_Item_Type = 'a') OR
			      (Charge_Type in (90,92,93))
	
	
	THEN Amount ELSE 0 END)>0
		Then 'Y'
		Else 'N'
	 End) as PAEID,
	
	
	(
	
	Case 	when
	        SUM(
			CASE 
				WHEN  Optional_Extra.Type IN ('PAI','PAE') or  (Charge_Type = 62 AND Charge_Item_Type = 'a') or Charge_Type in (90,92) Then Amount
				Else 0
			End
		    )>0	
	
	
	    THEN 'P' 
		when
		SUM(
			CASE 
				WHEN  Optional_Extra.Type IN ('PEC','Cargo','RSN') or  (Charge_Type = 63 AND Charge_Item_Type = 'a') or Charge_Type = 93  Then Amount
				Else 0
			End
		    )>0	
	    Then 'C' 
		Else ''
	
	End
	) as PAEType,
	
	LocationOut.FPO_Fuel_Price_Per_Liter as REfuleing,
	'Y' TimeTaxable,
	'Y' MileTaxable,
	'Y' DiscTaxable,
	'Y' FuleTaxable,
	'Y' LDWTaxable,
	'Y' ESPTaxable,
	'Y' PAETaxable,
	'Y' DROPTaxable,
	(Case When Percentage_Tax1 is not null Then Percentage_Tax1 +Percentage_Tax2
	      Else @GSTRate+@PSTRate
	End) SalesTaxRate,
	
	Reservation.Foreign_Confirm_Number,
	dbo.Contract.IATA_Number IATANum,
	dbo.Frequent_Flyer_Plan.Maestro_Code +'/'+ dbo.Contract.FF_Member_Number as FTN
	
	FROM         Contract INNER JOIN
	                      Location LocationOut ON Contract.Pick_Up_Location_ID = LocationOut.Location_ID 
			INNER JOIN
	                      Location LocationDue ON Contract.Drop_Off_Location_ID = LocationDue.Location_ID 
			
			INNER JOIN
	                      Contract_Charge_Item ON Contract.Contract_Number = Contract_Charge_Item.Contract_Number 	
	
			LEFT OUTER JOIN
	                      Optional_Extra ON Contract_Charge_Item.Optional_Extra_ID = Optional_Extra.Optional_Extra_ID AND Optional_Extra.Delete_Flag = 0 
			LEFT OUTER JOIN
	                      Reservation ON Contract.Confirmation_Number = Reservation.Confirmation_Number 
            LEFT OUTER JOIN
	                      Renter_Driver_Licence ON Contract.Contract_Number = Renter_Driver_Licence.Contract_Number
			LEFT OUTER JOIN
	                      dbo.Frequent_Flyer_Plan ON Contract.Frequent_Flyer_Plan_ID = dbo.Frequent_Flyer_Plan.Frequent_Flyer_Plan_ID
            LEFT OUTER JOIN
							  dbo.Organization AS BCD_Rate_Organization ON BCD_Rate_Organization.Organization_ID = Contract.BCD_Rate_Organization_ID 
	Where Contract.Contract_Number=Convert(int, @CtrctNumber)
	
	Group by 	
	Contract.Contract_Number, Contract.First_Name, 
	Contract.Last_Name, Contract.Address_1, 
        Contract.Address_2, 
        Contract.City, Contract.Province_State,                     	
	Contract.Postal_Code, 
	Contract.Phone_Number, 
	Contract.Gender, 
	Contract.Birth_Date, 
	Contract.Customer_Program_Number, 
	Contract.Renter_Driving,
	Renter_Driver_Licence.Licence_Number, 
	Renter_Driver_Licence.Jurisdiction, 
	Renter_Driver_Licence.Expiry, 
	Reservation.BCD_Number, 
	Contract.Company_Name, 
	Contract.Company_Phone_Number,  
	LocationOut.CounterCode, 
	Contract.Pick_Up_On, 
	LocationDue.CounterCode, 
	Contract.Drop_Off_On,  
	--LocationIn.CounterCode, 
	--RP__Last_Vehicle_On_Contract.Actual_Check_In, 
	Contract.Contract_Number, 
	Contract.Print_Comment,
	LocationOut.FPO_Fuel_Price_Per_Liter,
	Percentage_Tax1,Percentage_Tax2,
	Reservation.Foreign_Confirm_Number ,
	Contract.Foreign_Contract_Number,
	dbo.Contract.IATA_Number,
	dbo.Frequent_Flyer_Plan.Maestro_Code,
	dbo.Contract.FF_Member_Number,
	BCD_Rate_Organization.BCD_Number,
	Contract.BCD_Rate_Organization_ID
) c

 LEFT OUTER JOIN		       
	(	SELECT    Sum(Flat_Amount * - 1) AS ReimbursementAmount, Contract_Number
			FROM         Contract_Reimbur_and_Discount
			WHERE     (Type = 'Reimbursement') and  Contract_Number=Convert(int, @CtrctNumber)
		Group by Contract_Number

	) Reimbursement
	On c.Contract=Reimbursement.Contract_Number
GO

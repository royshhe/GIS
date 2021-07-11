USE [GISData]
GO
/****** Object:  View [dbo].[ViewCCRSMain]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [dbo].[ViewCCRSMain]
AS
SELECT DISTINCT 
                      substring(dbo.Contract.Company_Name,1,40) as CompanyName, '' AS department, substring(dbo.Organization.Address_1,1,50)  AS corpaddress1, substring(dbo.Organization.Address_2,1,50) AS corpaddress2, 
                      dbo.Organization.City AS corpcity, 
			--dbo.Organization.Province,--
                       CorpProvinceLookup.code AS corpProv, 
			dbo.Organization.Postal_Code AS corppostalcode, 
                      dbo.Organization.Country AS corpcountry, '' AS corpphonumber, dbo.Organization.Contact_Fax_Number AS corpfax,  dbo.Reservation.BCD_Number,
                      dbo.Contract.Customer_Program_Number AS BCN, dbo.Contract.First_Name, 
                      dbo.Contract.Last_Name, dbo.Contract.Address_1 AS Address1, dbo.Contract.Address_2 AS Adress2, dbo.Contract.City, 
                      --dbo.Contract.Province_State AS Prov,
		     ContractProvinceLookup.code as Prov, 
			'' AS PostalCode, dbo.Contract.Country, dbo.Customer.Phone_Number AS Phone1, '' AS Phone2, 
                      Gender= (case
				when dbo.Contract.Gender=1 then
				'M'
				when dbo.Contract.Gender=2 then
				'F'
				end )
			, dbo.Contract.Birth_Date AS DateOfBirth, dbo.Renter_Driver_Licence.Licence_Number, 
		    --dbo.Renter_Driver_Licence.Jurisdiction AS LicenseProvince, 
                      LicenseProvLookup.Code AS LicenseProvince, 
                      
			'' AS DriversLicenseCountry, 
                      dbo.Renter_Driver_Licence.Expiry AS DriverLicenseExpiryDate, '' as passportnumber, dbo.Contract.Email_Address AS emailAddress, 
                      dbo.Contract.Contract_Number AS ContractNum, dbo.Contract.Status AS ContractStatus,''as GovermentIDNumber,
		      dbo.Contract.FF_Member_Number AS FrequencyFlyernumber, '' as FlightNumber, '' as ArrivalAirline,
                      dbo.Location.Mnemonic_Code AS departCity, '' AS bonusMiles, '' AS BonusDaily, dbo.Reservation.Foreign_Confirm_Number AS ReservatinNumber, 
                      '' AS ReferalCode, '' AS EmpIn, '' AS EmpOut, dbo.Contract.Pick_Up_On AS dateOut, dbo.Contract.Drop_Off_On AS DateIN, dbo.Contract.Drop_Off_On AS DateDue, 
                      dbo.Contract.Pick_Up_On AS TimeOut, dbo.Contract.Drop_Off_On AS TimeIn, dbo.Contract.Drop_Off_On AS TimeDue, dbo.Contract.Pick_Up_On AS RBRDateOut, 
		      dbo.Contract.Drop_Off_On AS RBRDateIN, dbo.ViewContractKmDriven.KmDriven AS MilesDriven, 
		      RateCode=
		     substring(
			 (case
			 when dbo.Vehicle_Rate.Rate_Name is not null then dbo.Vehicle_Rate.Rate_Name
			 else dbo.Quoted_Vehicle_Rate.Rate_Name
			end 
                      		), 
                                        1,8)
		      , 
		      '' AS enddate, 
                      '' AS endtime, '' AS ulimited, '' AS dropflag, dbo.Location.Grace_Period, '' AS retreoGrace, '' AS CalcType, '' AS RateOverRide, '' AS CommBasis, 
                      '' AS CommRate, '' AS MinUnits, '' AS MinReq, '' AS MinRule, '' AS Calendar, '' AS RateQuoted, '' AS LocalContract,
 		      DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.Contract.Drop_Off_On)/1440.0 AS RBRDays, 	
		      '' AS Remarks, dbo.ViewContractTnM.Amount AS TnM, '' AS BatchNumber, 
                      '' as FTNMilesCode, dbo.Location.CounterCode AS PickupLocation, DropOffLocation.CounterCode AS DropOffLocation, '' AS ContractBCD, dbo.Contract.IATA_Number, 
                      dbo.Vehicle_Class.SIPP AS VehicleSIPPCode, '' AS CreditCardNumber, '' AS CardType, '' AS CreditCardExpiry, 
                      dbo.Business_Transaction.RBR_Date
FROM         dbo.Lookup_Table LicenseProvLookup RIGHT OUTER JOIN
                      dbo.Renter_Driver_Licence ON LicenseProvLookup.[Value] = dbo.Renter_Driver_Licence.Jurisdiction AND 
                      LicenseProvLookup.Category = 'Province' RIGHT OUTER JOIN
                      dbo.Contract INNER JOIN
                      dbo.Location ON dbo.Contract.Pick_Up_Location_ID = dbo.Location.Location_ID INNER JOIN
                      dbo.ViewContractKmDriven ON dbo.Contract.Contract_Number = dbo.ViewContractKmDriven.Contract_Number INNER JOIN
                      dbo.ViewContractTnM ON dbo.Contract.Contract_Number = dbo.ViewContractTnM.Contract_Number INNER JOIN
                      dbo.Vehicle_Class ON dbo.Contract.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code INNER JOIN
                      dbo.Business_Transaction ON dbo.Contract.Contract_Number = dbo.Business_Transaction.Contract_Number INNER JOIN
                      dbo.Location DropOffLocation ON dbo.Contract.Drop_Off_Location_ID = DropOffLocation.Location_ID LEFT OUTER JOIN
                      dbo.Lookup_Table ContractProvinceLookup ON dbo.Contract.Province_State = ContractProvinceLookup.[Value] AND 
                      ContractProvinceLookup.Category = 'Province' LEFT OUTER JOIN
                      dbo.Quoted_Vehicle_Rate ON dbo.Contract.Quoted_Rate_ID = dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID LEFT OUTER JOIN
                      dbo.Reservation ON dbo.Contract.Confirmation_Number = dbo.Reservation.Confirmation_Number LEFT OUTER JOIN
                      dbo.Vehicle_Rate ON dbo.Contract.Rate_ID = dbo.Vehicle_Rate.Rate_ID LEFT OUTER JOIN
                      dbo.Customer ON dbo.Contract.Customer_ID = dbo.Customer.Customer_ID ON 
                      dbo.Renter_Driver_Licence.Contract_Number = dbo.Contract.Contract_Number LEFT OUTER JOIN
                      dbo.Organization ON dbo.Contract.BCD_Rate_Organization_ID = dbo.Organization.Organization_ID LEFT OUTER JOIN
                      dbo.Lookup_Table CorpProvinceLookup ON dbo.Organization.Province = CorpProvinceLookup.[Value] AND 
                      CorpProvinceLookup.Category = 'Province'
WHERE     (dbo.Business_Transaction.Transaction_Type = 'con') AND (dbo.Business_Transaction.Transaction_Description = 'check in')


GO

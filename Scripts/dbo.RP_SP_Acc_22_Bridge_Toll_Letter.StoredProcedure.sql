USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_22_Bridge_Toll_Letter]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[RP_SP_Acc_22_Bridge_Toll_Letter] -- '2013-01-01','2013-01-10'
(
	@paramStartBusDate varchar(20) = '22 Apr 2001',
	@paramEndBusDate varchar(20) = '23 Apr 2001'
)
	
AS
--convert strings to datetime
DECLARE 	@startBusDate datetime,
		@endBusDate datetime

DECLARE 	@companyName Varchar(80), @contactPerson Varchar(50), @contactPhone Varchar(50), @CompanyAddress Varchar(100), 
		@companyCity Varchar(30), @companyProvince Varchar(30), @companyPostalCode Varchar(30),@CompanyCountry varchar(50)


--, @companyLogo Image


SELECT	@startBusDate	= CONVERT(datetime, '00:00:00 ' + @paramStartBusDate),
	@endBusDate	= CONVERT(datetime, '23:59:59 ' + @paramEndBusDate)	


SELECT   @companyName=  SystemSettingValues.SettingValue
FROM         SystemSettingValues INNER JOIN
                      SystemSetting ON SystemSettingValues.SettingID = SystemSetting.SettingID 
WHERE     (SystemSettingValues.ValueName = 'CompanyName') AND (SystemSetting.SettingName = 'CompanyInfo')

SELECT   @contactPerson=  SystemSettingValues.SettingValue
FROM         SystemSettingValues INNER JOIN
                      SystemSetting ON SystemSettingValues.SettingID = SystemSetting.SettingID 
WHERE     (SystemSettingValues.ValueName = 'PTicketContact') AND (SystemSetting.SettingName = 'CompanyInfo')



SELECT   @contactPhone=  SystemSettingValues.SettingValue
FROM         SystemSettingValues INNER JOIN
                      SystemSetting ON SystemSettingValues.SettingID = SystemSetting.SettingID 
WHERE     (SystemSettingValues.ValueName = 'PTicketPhone') AND (SystemSetting.SettingName = 'CompanyInfo')


--

SELECT   @CompanyAddress=  SystemSettingValues.SettingValue
FROM         SystemSettingValues INNER JOIN
                      SystemSetting ON SystemSettingValues.SettingID = SystemSetting.SettingID 
WHERE     (SystemSettingValues.ValueName = 'Address') AND (SystemSetting.SettingName = 'CompanyInfo')


SELECT   @companyCity=  SystemSettingValues.SettingValue
FROM         SystemSettingValues INNER JOIN
                      SystemSetting ON SystemSettingValues.SettingID = SystemSetting.SettingID 
WHERE     (SystemSettingValues.ValueName = 'City') AND (SystemSetting.SettingName = 'CompanyInfo')



SELECT   @companyProvince=  SystemSettingValues.SettingValue
FROM         SystemSettingValues INNER JOIN
                      SystemSetting ON SystemSettingValues.SettingID = SystemSetting.SettingID 
WHERE     (SystemSettingValues.ValueName = 'Province') AND (SystemSetting.SettingName = 'CompanyInfo')



SELECT   @companyPostalCode=  SystemSettingValues.SettingValue
FROM         SystemSettingValues INNER JOIN
                      SystemSetting ON SystemSettingValues.SettingID = SystemSetting.SettingID 
WHERE     (SystemSettingValues.ValueName = 'PostalCode') AND (SystemSetting.SettingName = 'CompanyInfo')

SELECT   @CompanyCountry=  SystemSettingValues.SettingValue
FROM         SystemSettingValues INNER JOIN
                      SystemSetting ON SystemSettingValues.SettingID = SystemSetting.SettingID 
WHERE     (SystemSettingValues.ValueName = 'Country') AND (SystemSetting.SettingName = 'CompanyInfo')


/*
SELECT   @companyLogo=  SystemSettingValues.ImageValue
FROM         SystemSettingValues INNER JOIN
                      SystemSetting ON SystemSettingValues.SettingID = SystemSetting.SettingID 
WHERE     (SystemSettingValues.ValueName = 'CompanyLogo') AND (SystemSetting.SettingName = 'CompanyInfo')
*/


SELECT  --@companyLogo as CompanyLogo, 
		@companyName as CompanyName,  	
		@CompanyAddress as CompanyAddress,
                @companyCity+ ' '+ @companyProvince +' '+@companyPostalCode as CompanyCityProvincePostalCode,
		@CompanyCountry as CompanyCountry,
		
                'Contract# '+Convert(Varchar(10),dbo.Bridge_Toll_vw.Contract_Number) +' '+ 
		(Case 
			When dbo.Bridge_Toll_vw.License_Number is not Null
			Then 'Licence# '+upper(dbo.Bridge_Toll_vw.License_Number)
			Else ''
		End) Reference,


	--UPPER(SUBSTRING(dbo.Bridge_Toll_vw.First_Name, 1, 1))  + SUBSTRING(dbo.Bridge_Toll_vw.First_Name, 2, LEN(dbo.Bridge_Toll_vw.First_Name ) - 1)
	--+' '+ 
    --UPPER(SUBSTRING(dbo.Bridge_Toll_vw.Last_Name, 1, 1))  + SUBSTRING(dbo.Bridge_Toll_vw.Last_Name, 2, LEN(dbo.Bridge_Toll_vw.Last_Name) - 1)  
	
    dbo.ToProperCase(dbo.Bridge_Toll_vw.First_Name)	+' '+ 	dbo.ToProperCase(dbo.Bridge_Toll_vw.Last_Name) as RenterName, 

	dbo.ToProperCase(dbo.Bridge_Toll_vw.Address_1 +
		(Case When dbo.Bridge_Toll_vw.Address_2 is not Null and dbo.Bridge_Toll_vw.Address_2<>'' then ' '+dbo.Bridge_Toll_vw.Address_2
		     Else ''
		End)) as Address,
		
		
	/*UPPER(SUBSTRING(dbo.Bridge_Toll_vw.City, 1, 1))  + SUBSTRING(dbo.Bridge_Toll_vw.City, 2, LEN(dbo.Bridge_Toll_vw.City ) - 1) */
	ISNULL(dbo.ToProperCase (dbo.Bridge_Toll_vw.City),'')+ ISNULL(', '+dbo.Bridge_Toll_vw.Province_State ,'')+ ISNULL(' '+dbo.Bridge_Toll_vw.Postal_Code,'') as CityProvincePostalCode, 
		--dbo.Bridge_Toll_vw.Postal_Code, 
		dbo.Bridge_Toll_vw.Country, 
		dbo.Bridge_Toll_vw.ViolationCharge, dbo.Bridge_Toll_vw.AdminCharge, -- Pticket_Issuer.Issuer, 
		dbo.Bridge_Toll_vw.Issue_Date, dbo.Bridge_Toll_vw.RBR_Date, 
		'Dear ' + 
				(Case When dbo.Bridge_Toll_vw.Gender=1 then 'Mr. '+dbo.ToProperCase(dbo.Bridge_Toll_vw.Last_Name)--UPPER(SUBSTRING(dbo.Bridge_Toll_vw.Last_Name, 1, 1))  + SUBSTRING(dbo.Bridge_Toll_vw.Last_Name, 2, LEN(dbo.Bridge_Toll_vw.Last_Name) - 1) 
					  When dbo.Bridge_Toll_vw.Gender=2 then 'Ms. '+dbo.ToProperCase(dbo.Bridge_Toll_vw.Last_Name)--UPPER(SUBSTRING(dbo.Bridge_Toll_vw.Last_Name, 1, 1))  + SUBSTRING(dbo.Bridge_Toll_vw.Last_Name, 2, LEN(dbo.Bridge_Toll_vw.Last_Name) - 1) 
				End)
		as Title,	
	Replace(
		Replace(
			Replace(
				Replace(
					Replace(
						Replace(
							Replace(
								Replace( 
										Replace(
												replace(dbo.Parking_Ticket_Letter_Template.Lettter_Body,
														'[TollBridgeName]',
														rtrim(isnull(Issuer,''))
												), 
											'[PickupDate]',
											isnull(convert(varchar(24),dbo.bridge_toll_vw.Pickup_Date),'___ __ ____')
										),
									'[CompanyName]',
									 @companyName
									), 
								'[TotalAmount]', 
								Convert(Varchar(10),Convert(Decimal(9,2),(dbo.Bridge_Toll_vw.ViolationCharge+dbo.Bridge_Toll_vw.AdminCharge)))
								),
							'[DropoffDate]',
							isnull(convert(varchar(24),dbo.bridge_toll_vw.Dropoff_Date),'___ __ ____')
							),
			                          
						'[AdminCharge]',
						Convert(Varchar(10),Convert(Decimal(9,2),(dbo.Bridge_Toll_vw.AdminCharge)))
						),
					 '[Sender]',
					  @contactPerson),
					'[ContactPhone]',
					@contactPhone),
					'[Today]',
					 convert(varchar(24),GetDate(),107)
					 ),	
			  '[TollAmount]',
			  Convert(Varchar(10),Convert(Decimal(9,2),(dbo.Bridge_Toll_vw.ViolationCharge)))  
			  ) as LetterBody,
		License_Number,
		dbo.Bridge_Toll_vw.Billing_Method,
		dbo.Bridge_Toll_vw.Contract_Number,
		dbo.Bridge_Toll_vw.Status,
		dbo.bridge_toll_vw.Issuer
			
		

--dbo.Bridge_Toll_Letter_Template.Sender
--select *
FROM         dbo.Bridge_Toll_vw INNER JOIN
                      dbo.Parking_Ticket_Letter_Template ON dbo.Bridge_Toll_vw.Billing_Method = dbo.Parking_Ticket_Letter_Template.Billing_Method
				inner join (select Transaction_Date,Contract_number 
								from business_transaction
								 where Transaction_Type='Con' and
										 Transaction_Description='Check In' ) ConCloseDate
					on  dbo.Bridge_Toll_vw.contract_Number=ConCloseDate.contract_Number
			LEFT JOIN 
				(	Select   Business_transaction_ID, Email_Sent from dbo.Toll_Charge
					where	 Business_transaction_ID is not  null
					Group by Business_transaction_ID,Email_Sent	 
			
				) TC 
				on dbo.Bridge_Toll_vw.Business_Transaction_ID = TC.Business_Transaction_ID 
			 
	
Where     dbo.Bridge_Toll_vw.Status='CI'
		And RBR_Date between @startBusDate and @endBusDate and dbo.Bridge_Toll_vw.ViolationCharge>=0
		and dbo.Parking_Ticket_Letter_Template.Type='Toll'
		And dbo.Parking_Ticket_Letter_Template.Contract_Status='CI'
		--and  dbo.Bridge_Toll_vw.Billing_Method<>'Direct Bill'
		And  datediff(hh,ConCloseDate.Transaction_Date,dbo.Bridge_Toll_vw.Transaction_Date)>=4  --Toll fee charge print after contract close 4 hours
		And (TC.Email_Sent=0 or  TC.Email_Sent is Null)	
--order by dbo.Bridge_Toll_vw.Issue_Date--,PTicket_Issuer.Issuer
  
Union 

SELECT  --@companyLogo as CompanyLogo, 
		@companyName as CompanyName,  	
		@CompanyAddress as CompanyAddress,
                @companyCity+ ' '+ @companyProvince +' '+@companyPostalCode as CompanyCityProvincePostalCode,
		@CompanyCountry as CompanyCountry,
		
                'Contract# '+Convert(Varchar(10),dbo.Bridge_Toll_vw.Contract_Number) +' '+ 
		(Case 
			When dbo.Bridge_Toll_vw.License_Number is not Null
			Then 'Licence# '+upper(dbo.Bridge_Toll_vw.License_Number)
			Else ''
		End) Reference,


	--UPPER(SUBSTRING(dbo.Bridge_Toll_vw.First_Name, 1, 1))  + SUBSTRING(dbo.Bridge_Toll_vw.First_Name, 2, LEN(dbo.Bridge_Toll_vw.First_Name ) - 1)
	--+' '+ 
    --UPPER(SUBSTRING(dbo.Bridge_Toll_vw.Last_Name, 1, 1))  + SUBSTRING(dbo.Bridge_Toll_vw.Last_Name, 2, LEN(dbo.Bridge_Toll_vw.Last_Name) - 1)  
	
    dbo.ToProperCase(dbo.Bridge_Toll_vw.First_Name)	+' '+ 	dbo.ToProperCase(dbo.Bridge_Toll_vw.Last_Name) as RenterName, 

	dbo.ToProperCase(dbo.Bridge_Toll_vw.Address_1 +
		(Case When dbo.Bridge_Toll_vw.Address_2 is not Null and dbo.Bridge_Toll_vw.Address_2<>'' then ' '+dbo.Bridge_Toll_vw.Address_2
		     Else ''
		End)) as Address,
		
		
	/*UPPER(SUBSTRING(dbo.Bridge_Toll_vw.City, 1, 1))  + SUBSTRING(dbo.Bridge_Toll_vw.City, 2, LEN(dbo.Bridge_Toll_vw.City ) - 1) */
	ISNULL(dbo.ToProperCase (dbo.Bridge_Toll_vw.City),'')+ ISNULL(', '+dbo.Bridge_Toll_vw.Province_State ,'')+ ISNULL(' '+dbo.Bridge_Toll_vw.Postal_Code,'') as CityProvincePostalCode, 
		--dbo.Bridge_Toll_vw.Postal_Code, 
		dbo.Bridge_Toll_vw.Country, 
		dbo.Bridge_Toll_vw.ViolationCharge, dbo.Bridge_Toll_vw.AdminCharge, -- Pticket_Issuer.Issuer, 
		dbo.Bridge_Toll_vw.Issue_Date, dbo.Bridge_Toll_vw.RBR_Date, 
		'Dear ' + 
				(Case When dbo.Bridge_Toll_vw.Gender=1 then 'Mr. '+dbo.ToProperCase(dbo.Bridge_Toll_vw.Last_Name)--UPPER(SUBSTRING(dbo.Bridge_Toll_vw.Last_Name, 1, 1))  + SUBSTRING(dbo.Bridge_Toll_vw.Last_Name, 2, LEN(dbo.Bridge_Toll_vw.Last_Name) - 1) 
					  When dbo.Bridge_Toll_vw.Gender=2 then 'Ms. '+dbo.ToProperCase(dbo.Bridge_Toll_vw.Last_Name)--UPPER(SUBSTRING(dbo.Bridge_Toll_vw.Last_Name, 1, 1))  + SUBSTRING(dbo.Bridge_Toll_vw.Last_Name, 2, LEN(dbo.Bridge_Toll_vw.Last_Name) - 1) 
				End)
		as Title,
	Replace(	
		Replace(
			Replace(
				Replace(
					Replace(
						Replace(
							Replace(
								Replace( 
										Replace(
												replace(dbo.Parking_Ticket_Letter_Template.Lettter_Body,
														'[TollBridgeName]',
														rtrim(isnull(Issuer,''))
												), 
											'[PickupDate]',
											isnull(convert(varchar(24),dbo.bridge_toll_vw.Pickup_Date),'___ __ ____')
										),
									'[CompanyName]',
									 @companyName
									), 
								'[TotalAmount]', 
								Convert(Varchar(10),Convert(Decimal(9,2),(dbo.Bridge_Toll_vw.ViolationCharge+dbo.Bridge_Toll_vw.AdminCharge)))
								),
							'[DropoffDate]',
							isnull(convert(varchar(24),dbo.bridge_toll_vw.Dropoff_Date),'___ __ ____')
							),
			                          
						'[AdminCharge]',
						Convert(Varchar(10),Convert(Decimal(9,2),(dbo.Bridge_Toll_vw.AdminCharge)))
						),
					 '[Sender]',
					@contactPerson),
					'[ContactPhone]',					
					@contactPhone),
				'[Today]',
				 convert(varchar(24),GetDate(),107)
				 ),	
			  '[TollAmount]',
			  Convert(Varchar(10),Convert(Decimal(9,2),(dbo.Bridge_Toll_vw.ViolationCharge)))  
			  ) as LetterBody,
		License_Number,
		dbo.Bridge_Toll_vw.Billing_Method,
		dbo.Bridge_Toll_vw.Contract_Number,
		dbo.Bridge_Toll_vw.Status,
		dbo.bridge_toll_vw.Issuer
			
		

--dbo.Bridge_Toll_Letter_Template.Sender
--select *
FROM         dbo.Bridge_Toll_vw 
			 INNER JOIN dbo.Parking_Ticket_Letter_Template 
				ON dbo.Bridge_Toll_vw.Billing_Method = dbo.Parking_Ticket_Letter_Template.Billing_Method
             LEFT JOIN 
				(	Select   Business_transaction_ID, Email_Sent from dbo.Toll_Charge
					where	 Business_transaction_ID is not  null
					Group by Business_transaction_ID,Email_Sent	 
			
				) TC 
				on dbo.Bridge_Toll_vw.Business_Transaction_ID = TC.Business_Transaction_ID 
			         
			
	
Where     dbo.Bridge_Toll_vw.Status='CO'	
		And RBR_Date between @startBusDate and @endBusDate and dbo.Bridge_Toll_vw.ViolationCharge>=0
		and dbo.Parking_Ticket_Letter_Template.Type='Toll'
		And dbo.Parking_Ticket_Letter_Template.Contract_Status='CO'
		-- Only Print for Short Term Rental
		And DATEDIFF(mi, dbo.Bridge_Toll_vw.Pickup_Date, dbo.Bridge_Toll_vw.Return_Date) / 1440.000>=7.0
		And (TC.Email_Sent=0 or  TC.Email_Sent is Null)
		
		 
		
		--and  dbo.Bridge_Toll_vw.Billing_Method<>'Direct Bill'
		--and  datediff(hh,ConCloseDate.Transaction_Date,dbo.Bridge_Toll_vw.Transaction_Date)>=4  --Toll fee charge print after contract close 4 hours
order by dbo.Bridge_Toll_vw.Contract_Number

GO

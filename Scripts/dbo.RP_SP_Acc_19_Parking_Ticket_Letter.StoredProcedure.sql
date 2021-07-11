USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_19_Parking_Ticket_Letter]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE PROCEDURE [dbo].[RP_SP_Acc_19_Parking_Ticket_Letter] --'2011-07-01','2011-07-31'
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
		
                'Contract# '+Convert(Varchar(10),dbo.Parking_Ticket_vw.Contract_Number) +' '+ 
		(Case 
			When dbo.Parking_Ticket_vw.TicketNumber is not Null
			Then 'Ticket# '+dbo.Parking_Ticket_vw.TicketNumber 
			Else ''
		End) Reference,


	--UPPER(SUBSTRING(dbo.Parking_Ticket_vw.First_Name, 1, 1))  + SUBSTRING(dbo.Parking_Ticket_vw.First_Name, 2, LEN(dbo.Parking_Ticket_vw.First_Name ) - 1)
	--+' '+ 
    --UPPER(SUBSTRING(dbo.Parking_Ticket_vw.Last_Name, 1, 1))  + SUBSTRING(dbo.Parking_Ticket_vw.Last_Name, 2, LEN(dbo.Parking_Ticket_vw.Last_Name) - 1)  
	
    dbo.ToProperCase(dbo.Parking_Ticket_vw.First_Name)	+' '+ 	dbo.ToProperCase(dbo.Parking_Ticket_vw.Last_Name) as RenterName, 

	dbo.ToProperCase(dbo.Parking_Ticket_vw.Address_1 +
		(Case When dbo.Parking_Ticket_vw.Address_2 is not Null and dbo.Parking_Ticket_vw.Address_2<>'' then ' '+dbo.Parking_Ticket_vw.Address_2
		     Else ''
		End)) as Address,
		
		
	/*UPPER(SUBSTRING(dbo.Parking_Ticket_vw.City, 1, 1))  + SUBSTRING(dbo.Parking_Ticket_vw.City, 2, LEN(dbo.Parking_Ticket_vw.City ) - 1) */
	ISNULL(dbo.ToProperCase (dbo.Parking_Ticket_vw.City),'')+ ISNULL(', '+dbo.Parking_Ticket_vw.Province_State ,'')+ ISNULL(' '+dbo.Parking_Ticket_vw.Postal_Code,'') as CityProvincePostalCode, 
		--dbo.Parking_Ticket_vw.Postal_Code, 
		dbo.Parking_Ticket_vw.Country, 
		dbo.Parking_Ticket_vw.ViolationCharge, dbo.Parking_Ticket_vw.AdminCharge,  Pticket_Issuer.Issuer, 
		dbo.Parking_Ticket_vw.Issue_Date, dbo.Parking_Ticket_vw.RBR_Date, 
		'Dear ' + 
				(Case When dbo.Parking_Ticket_vw.Gender=1 then 'Mr. '+dbo.ToProperCase(dbo.Parking_Ticket_vw.Last_Name)--UPPER(SUBSTRING(dbo.Parking_Ticket_vw.Last_Name, 1, 1))  + SUBSTRING(dbo.Parking_Ticket_vw.Last_Name, 2, LEN(dbo.Parking_Ticket_vw.Last_Name) - 1) 
					  When dbo.Parking_Ticket_vw.Gender=2 then 'Ms. '+dbo.ToProperCase(dbo.Parking_Ticket_vw.Last_Name)--UPPER(SUBSTRING(dbo.Parking_Ticket_vw.Last_Name, 1, 1))  + SUBSTRING(dbo.Parking_Ticket_vw.Last_Name, 2, LEN(dbo.Parking_Ticket_vw.Last_Name) - 1) 
				End)
		as Title,	
		Replace(
			Replace(
				Replace(
					Replace(
						Replace(
							Replace(dbo.Parking_Ticket_Letter_Template.Lettter_Body, 
								'[CompanyName]',
								 @companyName
								), 
							'[TotalAmount]', 
							Convert(Varchar(10),Convert(Decimal(9,2),(dbo.Parking_Ticket_vw.ViolationCharge+dbo.Parking_Ticket_vw.AdminCharge)))
							),
						'[ViolationCharge]',
						Convert(Varchar(10),Convert(Decimal(9,2),(dbo.Parking_Ticket_vw.ViolationCharge)))
						),
		                          
					'[AdminCharge]',
					Convert(Varchar(10),Convert(Decimal(9,2),(dbo.Parking_Ticket_vw.AdminCharge)))
					),
				 '[Sender]',
	                         @contactPerson),
			    '[ContactPhone]',
			    @contactPhone) as LetterBody,
		License_Number
			
		

--dbo.Parking_Ticket_Letter_Template.Sender
--select *
FROM         dbo.Parking_Ticket_vw INNER JOIN
                      dbo.Parking_Ticket_Letter_Template ON dbo.Parking_Ticket_vw.Billing_Method = dbo.Parking_Ticket_Letter_Template.Billing_Method
					left outer join (select Code as Issuer_ID, Value as Issuer from Lookup_Table where category ='Parking Ticket Issuer') PTicket_Issuer     
					On dbo.Parking_Ticket_vw.Issuer=Pticket_Issuer.Issuer_ID
	
Where RBR_Date between @startBusDate and @endBusDate and dbo.Parking_Ticket_vw.ViolationCharge>0
		and dbo.Parking_Ticket_Letter_Template.Type='Parking'
order by dbo.Parking_Ticket_vw.Contract_Number --PTicket_Issuer.Issuer, dbo.Parking_Ticket_vw.Issue_Date






GO

USE [GISData]
GO
/****** Object:  View [dbo].[RP_Adhoc_Customer_Profile_On_Checkout]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE VIEW [dbo].[RP_Adhoc_Customer_Profile_On_Checkout]
AS
-----Renter
SELECT  dbo.Contract.Contract_Number, 
		case when dbo.Reservation.Foreign_Confirm_Number is not null
				then dbo.Reservation.Foreign_Confirm_Number
				else convert(varchar(20),dbo.Contract.Confirmation_Number)
			end  as Confirmation_Number,	
		dbo.contract.pick_up_location_id,
		dbo.Location.Location as Pick_up_location, 
		dbo.Contract.Pick_Up_On, 
		Location_1.Location AS Drop_off_Location, 
		dbo.Contract.Drop_Off_On, 
		dbo.Contract.Last_Name, 
		dbo.Contract.First_Name, 
		'*' as Addition_type,
		case when dbo.Contract.Gender=1
				then 'Male'
			 when dbo.Contract.Gender=2
			 	then 'Female'
				else ''
			end as Gender, 
		convert(int,DATEDIFF ( day ,  convert(datetime,dbo.Contract.Birth_Date),getdate() )/365.25) age, 
		case when dbo.Contract.Renter_Driving=1 
				then dbo.Renter_Driver_Licence.Jurisdiction 
				else dbo.Non_Driving_Renter_ID.Type
			end  as Jurisdiction,	 
        dbo.Contract.Phone_Number, 
        dbo.Contract.Address_1, 
        dbo.Contract.Address_2, 
        dbo.Contract.City, 
        dbo.Contract.Province_State, 
        dbo.Contract.Country, 
        dbo.Contract.Postal_Code, 
        dbo.Contract.Email_Address, 
        dbo.Contract.Company_Name, 
        dbo.Contract.Company_Phone_Number, 
        dbo.Contract.Local_Phone_Number, 
        dbo.Contract.Local_Address_1, 
        dbo.RP__Last_Vehicle_On_Contract.Actual_Vehicle_Class_Code Vehicle_Class_Code,
        case when ccu.Swiped_Flag=0 
				then 'M'
				else 'S'
			end as Swiped_Flag, 
        comment.Comments,
		comment.Logged_On,
        dbo.Contract.status
FROM         dbo.Contract INNER JOIN
                      dbo.RP__Last_Vehicle_On_Contract ON dbo.Contract.Contract_Number = dbo.RP__Last_Vehicle_On_Contract.Contract_Number INNER JOIN
                      dbo.Location ON dbo.Contract.Pick_Up_Location_ID = dbo.Location.Location_ID INNER JOIN
                      dbo.Location AS Location_1 ON dbo.Contract.Drop_Off_Location_ID = Location_1.Location_ID LEFT OUTER JOIN
                      dbo.Reservation ON dbo.Contract.Confirmation_Number = dbo.Reservation.Confirmation_Number LEFT OUTER JOIN
                      dbo.Non_Driving_Renter_ID ON dbo.Contract.Contract_Number = dbo.Non_Driving_Renter_ID.Contract_Number LEFT OUTER JOIN
                      dbo.Renter_Driver_Licence ON dbo.Contract.Contract_Number = dbo.Renter_Driver_Licence.Contract_Number  LEFT OUTER JOIN
                      RP__First_Contract_Credit_card_Using CCU ON dbo.Contract.Contract_Number = CCU.Contract_Number left outer join
                      (   SELECT	contract_number,
									MAX( CASE seq WHEN 1 THEN comments ELSE '' END ) Comments,
									min( case seq when 1 then logged_on else '' end) Logged_On

							FROM ( SELECT p1.contract_number, p1.comments,logged_on,

										( SELECT COUNT(*) 
											FROM Contract_Internal_Comment p2

											 WHERE p2.contract_number = p1.contract_number

													AND p2.logged_on <= p1.logged_on )

									FROM Contract_Internal_Comment p1 ) D ( contract_number, comments, logged_on,seq )

							GROUP BY contract_number  ) comment on comment.contract_number=dbo.contract.contract_number
                      
                      
where dbo.Location.owning_company_id in (select code
											from lookup_table 
											where category='BudgetBC Company' ) and 
		dbo.Contract.status in ('CO')                          


union

-----Additional Driver

SELECT  dbo.Contract.Contract_Number, 
		case when dbo.Reservation.Foreign_Confirm_Number is not null
				then dbo.Reservation.Foreign_Confirm_Number
				else convert(varchar(20),dbo.Contract.Confirmation_Number)
			end  as Confirmation_Number,	
		dbo.contract.pick_up_location_id,
		dbo.Location.Location as Pick_up_location, 
		dbo.Contract.Pick_Up_On, 
		Location_1.Location AS Drop_off_Location, 
		dbo.Contract.Drop_Off_On, 
		dbo.Contract_Additional_Driver.Last_Name, 
		dbo.Contract_Additional_Driver.First_Name, 
		dbo.Contract_Additional_Driver.addition_type,
		'' as Gender, 
		convert(int,DATEDIFF ( day ,  convert(datetime,dbo.Contract_Additional_Driver.Birth_Date),getdate() )/365.25) age, 
		dbo.Contract_Additional_Driver.Driver_Licence_Jurisdiction as Jurisdiction,	 
        '' as Phone_Number, 
        dbo.Contract_Additional_Driver.Address_1, 
        dbo.Contract_Additional_Driver.Address_2, 
        dbo.Contract_Additional_Driver.City, 
        dbo.Contract_Additional_Driver.Province_State, 
        dbo.Contract_Additional_Driver.Country, 
        dbo.Contract_Additional_Driver.Postal_Code, 
        dbo.Contract.Email_Address, 
        dbo.Contract.Company_Name, 
        dbo.Contract.Company_Phone_Number, 
        dbo.Contract.Local_Phone_Number, 
        dbo.Contract.Local_Address_1, 
        dbo.RP__Last_Vehicle_On_Contract.Actual_Vehicle_Class_Code Vehicle_Class_Code,
        case when ccu.Swiped_Flag=0 
				then 'M'
				else 'S'
			end as Swiped_Flag, 
        comment.comments,
		comment.Logged_On,
        dbo.Contract.status
FROM         dbo.Contract INNER JOIN
                      dbo.RP__Last_Vehicle_On_Contract ON dbo.Contract.Contract_Number = dbo.RP__Last_Vehicle_On_Contract.Contract_Number INNER JOIN
                      dbo.Location ON dbo.Contract.Pick_Up_Location_ID = dbo.Location.Location_ID INNER JOIN
                      dbo.Location AS Location_1 ON dbo.Contract.Drop_Off_Location_ID = Location_1.Location_ID INNER JOiN
                      dbo.Contract_Additional_Driver on dbo.contract.contract_number=dbo.Contract_Additional_Driver.contract_number LEFT OUTER JOIN
                      dbo.Reservation ON dbo.Contract.Confirmation_Number = dbo.Reservation.Confirmation_Number LEFT OUTER JOIN
                      dbo.Non_Driving_Renter_ID ON dbo.Contract.Contract_Number = dbo.Non_Driving_Renter_ID.Contract_Number LEFT OUTER JOIN
                      dbo.Renter_Driver_Licence ON dbo.Contract.Contract_Number = dbo.Renter_Driver_Licence.Contract_Number  LEFT OUTER JOIN
                      RP__First_Contract_Credit_card_Using CCU ON dbo.Contract.Contract_Number = CCU.Contract_Number left outer join
                      (SELECT	contract_number,
									MAX( CASE seq WHEN 1 THEN comments ELSE '' END ) Comments,
									min( case seq when 1 then logged_on else '' end) Logged_On

							FROM ( SELECT p1.contract_number, p1.comments,logged_on,

										( SELECT COUNT(*) 
											FROM Contract_Internal_Comment p2

											 WHERE p2.contract_number = p1.contract_number

													AND p2.logged_on <= p1.logged_on )

									FROM Contract_Internal_Comment p1 ) D ( contract_number, comments, logged_on,seq )

							GROUP BY contract_number  ) comment on comment.contract_number=dbo.contract.contract_number
                      
                      
where dbo.Location.owning_company_id in (select code
											from lookup_table 
											where category='BudgetBC Company' ) and 
		dbo.Contract.status in ('CO')
GO

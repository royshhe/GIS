USE [GISData]
GO
/****** Object:  View [dbo].[Tarp_Transactions]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO





/****** Object:  View dbo.Tarp_Transactions    Script Date: 2/18/99 12:11:39 PM ******/
/****** Object:  View dbo.Tarp_Transactions    Script Date: 2/16/99 2:05:38 PM ******/
/*
VIEW NAME: Tarp_Transactions
PURPOSE: To combine the reservations and contracts that should be
	sent to the TARP interface.
AUTHOR: Don Kirkby
DATE CREATED: Feb 3, 1999
CALLED BY: Tarp
MOD HISTORY:
Name    Date        Comments
Roy He 2004-06-25   Add BCD Number
*/
CREATE VIEW [dbo].[Tarp_Transactions]
AS
/*SELECT	ctrct.contract_number,
	ctrct.confirmation_number,
	pick_up_location_id,
	pick_up_on,
	last_name,
	first_name,
	rate_id,
	rate_assigned_date,
	quoted_rate_id,
	te.total_charges,
	te.code,
	iata_number,
	vehicle_class_code
  FROM	contract ctrct
  JOIN	tarp_export te
    ON	ctrct.contract_number = te.contract_number
*/




SELECT     ctrct.Contract_Number, 
	   ctrct.Confirmation_Number,
          /*When there is no DBRCode for the Location, use Reservation Pickup Location instead*/
          
	   case 
		when CtrctPickupLoc.DBRCode is not null then
			ctrct.Pick_Up_Location_ID
	        else
	                 dbo.Reservation.Pick_Up_Location_ID
	   End Pick_Up_Location_ID,
            
           --ctrct.Pick_Up_Location_ID, 
           ctrct.Pick_Up_On, 
           ctrct.Last_Name, 
           ctrct.First_Name, 
           ctrct.Rate_ID, 
           ctrct.Rate_Assigned_Date, 
           ctrct.Quoted_Rate_ID, 
           te.Total_Charges, te.Code, 
           ctrct.IATA_Number, ctrct.Vehicle_Class_Code, 
        case 
		when dbo.Organization.BCD_Number is not null then
			dbo.Organization.BCD_Number
	        else
	                dbo.Reservation.BCD_Number
	End BCD_Number
--FROM       dbo.Contract ctrct INNER JOIN
--           dbo.TARP_Export te ON ctrct.Contract_Number = te.Contract_Number  LEFT OUTER JOIN
--           dbo.Organization ON ctrct.BCD_Rate_Organization_ID = dbo.Organization.Organization_ID
--           LEFT OUTER JOIN
--           dbo.Reservation ON ctrct.Confirmation_number = dbo.Reservation.Confirmation_number


FROM         dbo.Contract ctrct INNER JOIN
              dbo.TARP_Export te ON ctrct.Contract_Number = te.Contract_Number INNER JOIN
              dbo.Location CtrctPickupLoc ON ctrct.Pick_Up_Location_ID = CtrctPickupLoc.Location_ID LEFT OUTER JOIN
              dbo.Reservation ON ctrct.Confirmation_Number = dbo.Reservation.Confirmation_Number LEFT OUTER JOIN
              dbo.Organization ON ctrct.BCD_Rate_Organization_ID = dbo.Organization.Organization_ID



 UNION
   ALL

/*SELECT	NULL x,
	res.confirmation_number,
	pick_up_location_id,
	pick_up_on,
	last_name,
	first_name,
	rate_id,
	date_rate_assigned,
	quoted_rate_id,
	NULL y,
	te.code,

	iata_number,
	vehicle_class_code
  FROM	reservation res
  JOIN	tarp_export te
    ON	te.contract_number IS NULL 
   AND	te.confirmation_number = res.confirmation_number
*/

SELECT	NULL x,
	res.confirmation_number,
	pick_up_location_id,
	pick_up_on,
	last_name,
	first_name,
	rate_id,
	date_rate_assigned,
	quoted_rate_id,
	NULL y,
	te.code,
	iata_number,
	vehicle_class_code,
	case 
		when dbo.Organization.BCD_Number is not null then
			dbo.Organization.BCD_Number
                else
                        res.BCD_Number
	End BCD_Number
                    
              
FROM    dbo.Reservation res INNER JOIN
        dbo.TARP_Export te ON te.Contract_Number IS NULL AND te.Confirmation_Number = res.Confirmation_Number LEFT OUTER JOIN
        dbo.Organization ON res.BCD_Rate_Org_ID = dbo.Organization.Organization_ID




GO

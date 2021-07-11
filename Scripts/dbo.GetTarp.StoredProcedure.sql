USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetTarp]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO









/*
PROCEDURE NAME: GetTarp
PURPOSE: To select and format the reservations and contracts that should
        be exported to TARP
AUTHOR: Roy He
DATE CREATED: Jun 21 2004 
	     Modified to have new Tarp new report
             Will be called by Online report instead of Tarp Program
*/
CREATE PROCEDURE [dbo].[GetTarp] -- '2010-08-01', '2010-08-10'
        @StartDate varchar(24),
        @EndDate varchar(24)
AS
	/* Use a SQL transaction because the MTS transaction doesn't commit 
	 * until after the result string is built.
	 */
	BEGIN TRANSACTION

	/* Clear table in case something got left behind. Also locks the table so 
	 * that two people can't screw each other up by running tarp at the same
	 * time.
	 */
	DELETE
	  FROM	tarp_export

        DECLARE @dStart datetime,
                @dEnd datetime
        -- Truncate StartDate to midnight, and move EndDate to the next day
        SELECT  @dStart = CAST(FLOOR(CAST(CAST(NULLIF(@StartDate, '') AS datetime) AS float)) AS datetime),
                @dEnd = CAST(FLOOR(CAST(CAST(NULLIF(@EndDate, '') AS datetime) AS float) + 1) AS datetime)


        /* Select appropriate contracts & reservations into tarp_export */

        /* first do checked in contracts */
        INSERT
          INTO  tarp_export
                (
                contract_number,
                total_charges,
		code
                )
        SELECT  distinct ctrct.contract_number,
         CASE WHEN cci.total_charges >= 10000
		THEN NULL
		ELSE cci.total_charges
	END total_charges,
        CASE WHEN cci.total_charges >= 10000
	THEN 'O'
	ELSE NULL
	END code
  FROM  contract ctrct
          JOIN  location loc
            ON  ctrct.pick_up_location_id = loc.location_id
          JOIN  lookup_table lt
            ON  lt.category = 'BudgetBC Company'
           AND  CONVERT(smallint, lt.code) = loc.owning_company_id
	   INNER JOIN
    		Business_Transaction bt 
		ON bt.Contract_Number =ctrct.Contract_Number
          JOIN  (SELECT contract_number, SUM(amount) total_charges
                   FROM contract_charge_item
                  WHERE charge_type IN ('10', '11', '50', '51','52')
                  GROUP
                     BY contract_number
                ) cci
            ON  cci.contract_number = ctrct.contract_number

         WHERE  iata_number IS NOT NULL
           AND  status = 'CI'
           --AND  @dStart <= voc.last_check_in
           --AND  voc.last_check_in < @dEnd
	   And 	bt.RBR_date>= @dStart
           And bt.RBR_date< @dEnd
           And 	(bt.Transaction_Type = 'con') 
	   AND	(bt.Transaction_Description = 'check in') 

        /* update code and charges */
        UPDATE  tarp_export
           SET  code =
                (
                SELECT  CASE WHEN vab.contract_number IS NOT NULL  OR rate.Rate_Purpose_ID IN (15,17)  THEN
                                /* Contract has a Contract Billing Party
                                 * with Billing Method = Voucher
                                 */
                                'P'
                        WHEN qrc.maestro_rate_category_code IS NOT NULL THEN 'T'
                        WHEN COALESCE(rate.commission_paid, qrate.commission_paid) = 0  
			or rate.Rate_id
			in
                          (
			    SELECT    Rate_ID
                            FROM          Vehicle_Rate
                            WHERE      (Rate_Name LIKE '%kTII%' or Rate_Name LIKE  'ktoi%' or Rate_Name LIKE 'ktli%' or Rate_Name LIKE 'ktsi%' or Rate_Name LIKE 'krgi%' ) AND (Termination_Date = '12/31/2078 11:59:00 PM')
			   ) 


			THEN 'A'
                        ELSE tarp_export.code
                        END
                  FROM  contract ctrct
                  LEFT

                  JOIN  (SELECT DISTINCT contract_number
                           FROM voucher_alternate_billing
                        ) vab
                    ON  ctrct.contract_number = vab.contract_number
                  LEFT
                  JOIN          vehicle_rate rate
                    ON  ctrct.rate_id = rate.rate_id
                   AND  ctrct.rate_assigned_date
                        BETWEEN rate.effective_date AND rate.termination_date
                  LEFT
                  JOIN          quoted_vehicle_rate qrate
                          LEFT
                          JOIN  quoted_rate_category qrc
                            ON  qrate.quoted_rate_id = qrc.quoted_rate_id
                           AND  qrc.maestro_rate_category_code = '08'
                    ON  ctrct.quoted_rate_id = qrate.quoted_rate_id
                 WHERE  ctrct.contract_number = tarp_export.contract_number
                )

          -- Add By Roy He on Aug 15, 2010
			Update TARP_Export Set Code='P'
			FROM         dbo.Contract ctrct INNER JOIN
						  dbo.TARP_Export te ON ctrct.Contract_Number = te.Contract_Number INNER JOIN
						  dbo.Location CtrctPickupLoc ON ctrct.Pick_Up_Location_ID = CtrctPickupLoc.Location_ID LEFT OUTER JOIN
						  dbo.Reservation ON ctrct.Confirmation_Number = dbo.Reservation.Confirmation_Number LEFT OUTER JOIN
						  dbo.Organization ON (ctrct.BCD_Rate_Organization_ID = dbo.Organization.Organization_ID  or  dbo.Reservation.BCD_Number=  dbo.Organization.BCD_Number)
			where dbo.Organization .Tour_Rate_Account=1

        UPDATE  tarp_export
           SET  total_charges = NULL
         WHERE  code IS NOT NULL


       /* For Reservation or Void Contract we don't have to do RBR Date*/

       /* next do void and cancelled contracts */
       
        INSERT
          INTO  tarp_export
                (
                contract_number,
                code
                )
        SELECT distinct  ctrct.contract_number,
                CASE ctrct.status
                        WHEN 'VD' THEN 'C' /* Cancelled */
                        ELSE 'N'           /* No Show */
                        END
          FROM  contract ctrct

          JOIN  location loc
            ON  ctrct.pick_up_location_id = loc.location_id
          JOIN  lookup_table lt
            ON  lt.category = 'BudgetBC Company'
           AND  CONVERT(smallint, lt.code) = loc.owning_company_id
         WHERE  iata_number IS NOT NULL
           AND  status IN ('VD', 'CA')
           AND  @dStart <= ctrct.last_update_on
           AND  ctrct.last_update_on < @dEnd

        /* now do reservations */
        INSERT
          INTO  tarp_export
                (
                confirmation_number,
                code
                )
        SELECT  distinct resv.confirmation_number,
                resv.status
          FROM  reservation resv
          JOIN  location loc
            ON  resv.pick_up_location_id = loc.location_id
          JOIN  lookup_table lt
            ON  lt.category = 'BudgetBC Company'
           AND  CONVERT(smallint, lt.code) = loc.owning_company_id
          LEFT
          JOIN  reservation_change_history rch
            ON  resv.confirmation_number = rch.confirmation_number
           AND  rch.status = 'N'

         WHERE  iata_number IS NOT NULL
           AND  (  (   resv.status = 'C'
                   AND @dStart <= resv.pick_up_on
                   AND resv.pick_up_on < @dEnd
                   )
                OR (   resv.status = 'N'
                   AND @dStart <= rch.changed_on
                   AND rch.changed_on < @dEnd
                   )
                )
				And resv.confirmation_number not in 
				(select Reservation.confirmation_number from Contract inner join Reservation on Contract.confirmation_number=Reservation.Confirmation_number)


    SELECT  'AA' as Batch,
        loc.DBRCode,
        --month( tt.pick_up_on)as PickupMonth,
		loc.StationNumber,
        case 
	     when  month( tt.pick_up_on)<10 then
		'0'+convert(varchar(1), month( tt.pick_up_on))
	     else
		convert(varchar(2), month( tt.pick_up_on))
        end PickupMonth,


        case 
	     when day( tt.pick_up_on)<10 then
		'0'+convert(varchar(1),day( tt.pick_up_on))
	     else
		convert(varchar(2),day( tt.pick_up_on))
        end PickupDay,

        substring(convert(varchar(4),year( tt.pick_up_on)),3,2) as PickupYear,
--select len('va'+convert(varchar(10),12342)+'0')
        case when tt.contract_number is not null then
	          rtrim(ltrim(dbo.Lookup_Table.Code))+convert(varchar(10), tt.contract_number)               
	        else
	          ''
	end ContractNumber,
        '' as commissionRate,
       
        case when tt.BCD_Number is not null then
	           tt.BCD_Number
	       else
	          ''
	end BCDNumber,
	--tt.total_charges,
  	case when tt.total_charges is not null and (tt.code<>'P' or  tt.code is  null)   then
                  tt.total_charges    
	      else
	          0
	end TnM,

	'' as CommissionAmt,               
        tt.iata_number,
        CONVERT(varchar(15), tt.last_name + ' ' + tt.first_name) renter_name,	
        --COALESCE(rp.maestro_rate_indicator, qrp.maestro_rate_indicator) rate_type,                                
        CASE resv.source_code
                WHEN 'Internet' THEN
                        RIGHT(resv.foreign_confirm_number, 8)
                WHEN 'Maestro' THEN
                        resv.foreign_confirm_number
                ELSE
                        CONVERT(varchar, resv.confirmation_number % 100000000) -- last 8 digits
                END confirmation_number,
	                
	Case	tt.code
		When 'C' then
		     'CX'
		When 'N' then
		     'NS'
                When 'P' then
		     tt.code	
		When 'T' then
		     tt.code	
		When  'A' then			
		     tt.code                    
                else
		     CONVERT(varchar(3), COALESCE(rate.rate_name, qrate.rate_name)) 
		End rate_code

                --vc.maestro_code car_class
          FROM  tarp_transactions tt
          JOIN  location loc
            ON  tt.pick_up_location_id = loc.location_id
          JOIN  vehicle_class vc
            ON  tt.vehicle_class_code = vc.vehicle_class_code
          LEFT OUTER JOIN
               dbo.Lookup_Table ON loc.Province = dbo.Lookup_Table.[Value] 
          LEFT
          JOIN          vehicle_rate rate
                  JOIN  rate_purpose rp
                    ON  rate.rate_purpose_id = rp.rate_purpose_id
            ON  tt.rate_id = rate.rate_id
           AND  tt.rate_assigned_date
                BETWEEN rate.effective_date AND rate.termination_date
          LEFT
          JOIN          quoted_vehicle_rate qrate
                  LEFT

                  JOIN  rate_purpose qrp
                    ON  qrate.rate_purpose_id = qrp.rate_purpose_id
            ON  tt.quoted_rate_id = qrate.quoted_rate_id
          LEFT
          JOIN  reservation resv
            ON  resv.confirmation_number = tt.confirmation_number
          Order by DBRCode
        --DELETE
        --  FROM  tarp_export

	-- Now release locks immediately.
	COMMIT TRANSACTION








GO

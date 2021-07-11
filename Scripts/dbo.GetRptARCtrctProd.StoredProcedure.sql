USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRptARCtrctProd]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*
PURPOSE: To retrieve any contracts that generated direct bill payments in a
	given date range.
AUTHOR: Don Kirkby
DATE CREATED: Jul 7 1999
CALLED BY: Accounting
MOD HISTORY:
Name    Date        Comments
*/CREATE PROCEDURE [dbo].[GetRptARCtrctProd]  -- '2016-08-17',1
	@ToDate	  varchar(24),
	@Days  varchar(4)
AS
	/* 8/25/99 - added contract status */

	DECLARE	@cntDays int,
		@dFrom datetime,
		@dTo datetime
	SELECT	@cntDays = CAST(NULLIF(@Days, '') as int),
		@dTo = CAST(NULLIF(@ToDate, '') as datetime)
	SELECT	@dFrom = DATEADD(day, 1-@cntDays, @dTo)

print @dFrom
print @dTo
Select v.* from 
(	
	 
	SELECT	CBP.Customer_Code,
		ARP.Contract_Number,
		C.Status

	  FROM 	AR_Payment ARP
	  	JOIN Contract_Payment_Item CPI
	    	  ON ARP.Contract_Number = CPI.Contract_Number
	   	 AND ARP.Sequence = CPI.Sequence

	  	JOIN Contract_Billing_Party CBP
		  ON ARP.Contract_Number = CBP.Contract_Number
	 	 AND ARP.Contract_Billing_Party_ID = CBP.Contract_Billing_Party_ID

		JOIN Contract C
		  ON CBP.Contract_Number = C.Contract_Number
	    INNER JOIN dbo.Business_Transaction AS BU 
		  ON C.Contract_Number = BU.Contract_Number

	 WHERE	BU.RBR_Date >= @dFrom
	   AND	BU.RBR_Date <= @dTo

		and user_id not in ('5 Litre Refund')
		and C.Status='CI'
		and C.Pick_up_location_id in (Select Location_ID from Location_Production_vw)

	 --WHERE	CPI.RBR_Date >= @dFrom
	 --  AND	CPI.RBR_Date <= @dTo
	 GROUP
	    BY	CBP.Customer_Code, ARP.Contract_Number, C.Status
 
 
Union

SELECT	PP.issuer_id Customer_Code,
		PP.Contract_Number,
		C.Status

	  FROM 	Prepayment PP
	  	JOIN Contract_Payment_Item CPI
	    	  ON PP.Contract_Number = CPI.Contract_Number
	   	 AND PP.Sequence = CPI.Sequence
		JOIN Contract C
		  ON PP.Contract_Number = C.Contract_Number
		INNER JOIN dbo.Business_Transaction AS BU 
		  ON C.Contract_Number = BU.Contract_Number

	 WHERE	BU.RBR_Date >= @dFrom
	   AND	BU.RBR_Date <= @dTo
		and user_id not in ('5 Litre Refund')
		and C.Status='CI'
		and C.Pick_up_location_id in (Select Location_ID from Location_Production_vw)
	 --WHERE	CPI.RBR_Date >= @dFrom
	 --  AND	CPI.RBR_Date <= @dTo
	 GROUP
	    BY	PP.issuer_id, PP.Contract_Number, C.Status
) v

ORDER BY Customer_Code, Contract_Number,  Status

-- This is for the Batch Print for the Toll Charge
/*SELECT  distinct 'TollCharge' Customer_Code, RA.Contract_Number, RA.status

FROM  (SELECT     VLH.Licence_Plate_Number, CON.Contract_Number, VOC.Checked_Out, VOC.Actual_Check_In, VLH.Attached_On, VLH.Removed_On, CON.First_Name, 
                      CON.Last_Name,CON.status, LOC.Location
FROM         dbo.Vehicle_On_Contract VOC INNER JOIN
                      dbo.Vehicle_Licence_History VLH ON VOC.Unit_Number = VLH.Unit_Number AND VOC.Checked_Out BETWEEN VLH.Attached_On AND 
                      ISNULL(VLH.Removed_On, CONVERT(Datetime, '31 Dec 2078 23:59')) INNER JOIN
                      dbo.Contract CON ON VOC.Contract_Number = CON.Contract_Number INNER JOIN
                      dbo.Location LOC ON CON.Pick_Up_Location_ID = LOC.Location_ID) AS RA INNER JOIN
               dbo.Toll_Charge AS TC ON -- TC.Toll_Charge_Date BETWEEN RA.Attached_On AND ISNULL(RA.Removed_On, '2012-12-31 23:59') AND 
               TC.Toll_Charge_Date BETWEEN RA.Checked_Out AND ISNULL(RA.Actual_Check_In, '2012-12-31 23:59') AND RA.Licence_Plate_Number = TC.Licence_Plate
               
               order by RA.Contract_Number, RA.status
 */
       
--SELECT 'CCTrans' Customer_code, bt.Contract_Number, c.Status
--FROM  dbo.Business_Transaction AS bt INNER JOIN
--               dbo.Contract AS c ON bt.Contract_Number = c.Contract_Number
--WHERE (bt.Entered_On_Handheld = 1) AND (bt.Transaction_Date >= '2013-03-12 07:00') AND (bt.Transaction_Date <= '2013-03-18 10:10')             
--and  bt.Location_ID=16 and 	bt.RBR_Date='2013-03-18'	 
--order by   bt.RBR_DAte

RETURN @@ROWCOUNT














GO

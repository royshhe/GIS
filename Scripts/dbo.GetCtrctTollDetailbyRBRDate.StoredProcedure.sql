USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctTollDetailbyRBRDate]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetCtrctTollDetailbyRBRDate] --'2017-01-01','2017-01-10'
(
	@paramStartBusDate varchar(20) = '22 Apr 2001',
	@paramEndBusDate varchar(20) = '23 Apr 2001'
)
	
AS

DECLARE 	@startBusDate datetime,
		@endBusDate datetime
SELECT	@startBusDate	= CONVERT(datetime, '00:00:00 ' + @paramStartBusDate),
	@endBusDate	= CONVERT(datetime, '23:59:59 ' + @paramEndBusDate)	


SELECT  --RA.Unit_Number, 
tc.Licence_Plate,convert(varchar,tc.Toll_Charge_Date, 100) as [Date/Time],  tc.Charge_Amount [Toll Charge], tc.Direction, lt.Value Issuer, bt.Contract_Number, bt.RBR_Date --, tc.Toll_Type as [Toll Type]
FROM  dbo.Toll_Charge AS tc 
INNER JOIN dbo.Business_Transaction AS bt 
      ON tc.Business_Transaction_ID = bt.Business_Transaction_ID
INNER JOIN
	(SELECT		VLH.Licence_Plate_Number,  						 				
				VOC.UNIT_NUMBER,
				VOC.Checked_Out, 
				VOC.Actual_Check_In, 
				VLH.Attached_On, 
				VLH.Removed_On						
	FROM        dbo.Vehicle_On_Contract VOC 
	INNER JOIN	dbo.Vehicle_Licence_History VLH 
			ON VOC.Unit_Number = VLH.Unit_Number AND VOC.Checked_Out BETWEEN VLH.Attached_On 
			AND  ISNULL(VLH.Removed_On, CONVERT(Datetime, '31 Dec 2078 23:59')) 
	) AS RA 
	On TC.Toll_Charge_Date BETWEEN RA.Checked_Out AND ISNULL(RA.Actual_Check_In, '2078-12-31 23:59')
		   AND RA.Licence_Plate_Number = TC.Licence_Plate	
    LEFT JOIN lookup_table lt 
				on lt.category='Toll Charge Issuer' and tc.Issuer =  lt.code
				
Where --bt.Contract_Number=Convert(int, @ContractNumber)
bt.RBR_Date between @startBusDate and @endBusDate
GO

USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Con_23_Rebates_Detail]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[RP_SP_Con_23_Rebates_Detail] --'02 jul 2015', '03 jul 2015', 'A0336'
(
    @paramStartRBRDate varchar(20) = '01 Jun 2018',
    @paramEndRBRDate varchar(20) = '30 Jun 2018',
    @paramParentBCD varchar(20) = 'A0176'
)

AS

DECLARE @RBRStart varchar(20),
        @RBREnd varchar(20),
        @ParentBCD varchar(20)


SELECT	@RBRStart	=  convert(varchar(20),CONVERT(datetime,@paramStartRBRDate),0),
	@RBREnd	= convert(varchar(20), CONVERT(datetime, @paramEndRBRDate)+1),
	@ParentBCD = @paramParentBCD

BEGIN

    SELECT
        voc.Contract_number AS 'Contract Number',
        CASE WHEN Organization.BCD_Number IS NOT NULL
	   THEN Organization.BCD_Number
	   ELSE
	       res.BCD_Number END  AS 'BCD Number',
        voc.Actual_Check_In AS 'Check In',
        Checked_Out AS 'Check Out',
        SUM( CASE 	WHEN (Charge_Type IN (10, 50, 51, 52)  or Optional_Extra_ID IN (216, 212))
		THEN cci.Amount
		ELSE 0
	   END)  
            								as 'Net T&K',
        SUM( CASE 	WHEN (Charge_Type IN (10)  or Optional_Extra_ID IN (216, 212))
		THEN cci.Amount + CCi.PST_Amount + CCI.GST_Amount + PVRT_Amount
		ELSE 0
	   END) AS 'Gross T&K'

        

    FROM
        Vehicle_On_Contract voc
    LEFT JOIN
        Contract c ON voc.Contract_Number = c.Contract_Number
    LEFT JOIN
        Reservation res ON c.Confirmation_Number = res.Confirmation_Number
    LEFT JOIN
        Contract_Charge_Item cci ON voc.Contract_number = cci.Contract_Number
    LEFT JOIN
        Organization ON c.BCD_Rate_Organization_ID = Organization.Organization_ID
    --LEFT JOIN Contract_Revenue_Sum_vw RevSum on c.Contract_Number = RevSum.Contract_number
    WHERE
        (voc.business_transaction_id = 
	(select max(voc1.business_transaction_id)
	from vehicle_on_contract voc1 WITH(NOLOCK)
	where voc1.contract_number = voc.Contract_Number))

    and
        (Organization.BCD_Number LIKE @ParentBCD + '%'
    or Res.BCD_Number LIKE @ParentBCD + '%')
        --LIKE 'A0176%'
    and 
        voc.Actual_Check_In between @RBRStart and @RBREnd

    GROUP BY
        voc.Contract_number,
        Organization.BCD_Number,
        Res.BCD_Number,
        voc.Actual_Check_In,
        Checked_Out
    Order By
        voc.Actual_Check_In

END
GO

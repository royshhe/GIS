USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_5_CSR_Summary_Contract_Check_In_SB]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO









-----------------------------------------------------------------------------------------------------
-----    Programmer:   Jack Jian
-----    Date:              May 17, 2001
----     Details:	     Create sub report for acc_csr_summay report
-----------------------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[RP_SP_Acc_5_CSR_Summary_Contract_Check_In_SB] 

	@paramStartBusDate varchar(20) = '01 Dec 2000' ,
	@paramEndBusDate varchar(20) = '31 Dec 2000' ,
	@paramVehicleTypeID varchar(18) = 'Car',
	@paramLocationID varchar(20) = '259'

as

DECLARE 	@startBusDate datetime ,
		@endBusDate datetime

SELECT	@startBusDate	= CONVERT(datetime, '00:00:00 ' + @paramStartBusDate),
		@endBusDate	= CONVERT(datetime, '23:59:59 ' + @paramEndBusDate)	

-- fix upgrading problem (SQL7->SQL2000)

DECLARE  @tmpLocID varchar(20)

if @paramLocationID = '*'
	BEGIN
		SELECT @tmpLocID='0'
        END
else
	BEGIN
		SELECT @tmpLocID = @paramLocationID
	END 

-- end of fixing the problem

SELECT
    RP_Acc_5_CSR_Summary_Contract_Check_In_L1_SB_Base_1.RBR_Date, 
    RP_Acc_5_CSR_Summary_Contract_Check_In_L1_SB_Base_1.Pick_Up_Location_ID, 
    RP_Acc_5_CSR_Summary_Contract_Check_In_L1_SB_Base_1.CSR_Name, 
    RP_Acc_5_CSR_Summary_Contract_Check_In_L1_SB_Base_1.Vehicle_Type_ID, 
    RP_Acc_5_CSR_Summary_Contract_Check_In_L1_SB_Base_1.Contract_Number, 
    RP_Acc_5_CSR_Summary_Contract_Check_In_L1_SB_Base_1.Reservation_Revenue, 
    RP_Acc_5_CSR_Summary_Contract_Check_In_L1_SB_Base_1.Contract_Rental_Days, 
    RP_Acc_5_CSR_Summary_Contract_Check_In_L1_SB_Base_1.Contract_Revenue

FROM
    RP_Acc_5_CSR_Summary_Contract_Check_In_L1_SB_Base_1 with(nolock)

WHERE
    RP_Acc_5_CSR_Summary_Contract_Check_In_L1_SB_Base_1.RBR_Date >= @startBusDate
    AND  RP_Acc_5_CSR_Summary_Contract_Check_In_L1_SB_Base_1.RBR_Date < @endBusDate
    AND  ( RP_Acc_5_CSR_Summary_Contract_Check_In_L1_SB_Base_1.Vehicle_Type_ID = @paramVehicleTypeID or @paramVehicleTypeID = '*' )
    AND  ( @paramLocationID = '*' or RP_Acc_5_CSR_Summary_Contract_Check_In_L1_SB_Base_1.Pick_Up_Location_ID = convert( int , @tmpLocID ) )


--    AND    RP_Acc_5_CSR_Summary_Contract_Check_In_L1_SB_Base_1.CSR_Name = 'Megan Risk' AND

ORDER BY
    RP_Acc_5_CSR_Summary_Contract_Check_In_L1_SB_Base_1.Pick_Up_Location_ID ASC

if @@rowcount = 0 
    select ''

GO

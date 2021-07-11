USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetDueBackData]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetDueBackData]

AS
BEGIN
    SELECT
        DATEPART(hh, voc.Expected_Check_In) AS 'Due_Hour',
        --VOC.Unit_Number,
        --VOC.Contract_Number,


        CASE WHEN COUNT(CASE WHEN v.Vehicle_Class_Code IN ('B', 'L', 'A') THEN voc.Contract_Number END) = 0 THEN NULL
        ELSE COUNT(CASE WHEN v.Vehicle_Class_Code IN ('B', 'L', 'A') THEN voc.Contract_Number END) END AS 'Compact',

        CASE WHEN COUNT(CASE WHEN v.Vehicle_Class_Code IN ('C', '1') THEN voc.Contract_Number END) = 0 THEN NULL
        ELSE COUNT(CASE WHEN v.Vehicle_Class_Code IN ('C', '1') THEN voc.Contract_Number END) END AS 'Mid_Size',

        CASE WHEN COUNT(CASE WHEN v.Vehicle_Class_Code IN ('F', 'D', 'E') THEN voc.Contract_Number END) = 0 THEN NULL
        ELSE COUNT(CASE WHEN v.Vehicle_Class_Code IN ('F', 'D', 'E') THEN voc.Contract_Number END) END AS 'Full_Size',

        CASE WHEN COUNT(CASE WHEN v.Vehicle_Class_Code IN ('G', '{') THEN voc.Contract_Number END) = 0 THEN NULL
        ELSE COUNT(CASE WHEN v.Vehicle_Class_Code IN ('G', '{') THEN voc.Contract_Number END) END AS 'Premium',

        CASE WHEN COUNT(CASE WHEN v.Vehicle_Class_Code IN ('H') THEN voc.Contract_Number END) = 0 THEN NULL
        ELSE COUNT(CASE WHEN v.Vehicle_Class_Code IN ('H') THEN voc.Contract_Number END) END AS 'Luxury',

        CASE WHEN COUNT(CASE WHEN v.Vehicle_Class_Code IN ('X', '_') THEN voc.Contract_Number END) = 0 THEN NULL
        ELSE COUNT(CASE WHEN v.Vehicle_Class_Code IN ('X', '_') THEN voc.Contract_Number END) END AS 'Mid_SUV',

        CASE WHEN COUNT(CASE WHEN v.Vehicle_Class_Code IN ('W', '`') THEN voc.Contract_Number END) = 0 THEN NULL
        ELSE COUNT(CASE WHEN v.Vehicle_Class_Code IN ('W', '`') THEN voc.Contract_Number END) END AS 'Stand_SUV',

        CASE WHEN COUNT(CASE WHEN v.Vehicle_Class_Code IN ('9', '-', '}') THEN voc.Contract_Number END) = 0 THEN NULL
        ELSE COUNT(CASE WHEN v.Vehicle_Class_Code IN ('9', '-', '}') THEN voc.Contract_Number END) END AS 'Full_SUV',

        CASE WHEN COUNT(CASE WHEN v.Vehicle_Class_Code IN ('V', '0', 'O', '+', '5') THEN voc.Contract_Number END) = 0 THEN NULL
        ELSE COUNT(CASE WHEN v.Vehicle_Class_Code IN ('V', '0', 'O', '+', '5') THEN voc.Contract_Number END) END AS 'Van',

        CASE WHEN COUNT(CASE WHEN v.Vehicle_Class_Code IN ('^', 'P') THEN voc.Contract_Number END) = 0 THEN NULL
        ELSE COUNT(CASE WHEN v.Vehicle_Class_Code IN ('^', 'P') THEN voc.Contract_Number END) END AS 'Prestige',

        CASE WHEN COUNT(CASE WHEN v.Vehicle_Class_Code IN ('U','6') THEN voc.Contract_Number END) = 0 THEN NULL
        ELSE COUNT(CASE WHEN v.Vehicle_Class_Code IN ('U','6') THEN voc.Contract_Number END) END AS 'Sport_Conv',

        COUNT(CASE WHEN v.Vehicle_Class_Code IN ('B', 'L', 'A') THEN voc.Contract_Number END) +
        COUNT(CASE WHEN v.Vehicle_Class_Code IN ('C', '1') THEN voc.Contract_Number END) + 
        COUNT(CASE WHEN v.Vehicle_Class_Code IN ('F', 'D', 'E') THEN voc.Contract_Number END) +
        COUNT(CASE WHEN v.Vehicle_Class_Code IN ('G', '{') THEN voc.Contract_Number END) + 
        COUNT(CASE WHEN v.Vehicle_Class_Code IN ('H') THEN voc.Contract_Number END) + 
        COUNT(CASE WHEN v.Vehicle_Class_Code IN ('X', '_') THEN voc.Contract_Number END) + 
        COUNT(CASE WHEN v.Vehicle_Class_Code IN ('W', '`') THEN voc.Contract_Number END) +
        COUNT(CASE WHEN v.Vehicle_Class_Code IN ('9', '-', '}') THEN voc.Contract_Number END) + 
        COUNT(CASE WHEN v.Vehicle_Class_Code IN ('V', '0', 'O', '+', '5') THEN voc.Contract_Number END) + 
        COUNT(CASE WHEN v.Vehicle_Class_Code IN ('^', 'P') THEN voc.Contract_Number END) + 
        COUNT(CASE WHEN v.Vehicle_Class_Code IN ('U','6') THEN voc.Contract_Number END) AS Total

    FROM
        Contract c
    LEFT JOIN
        Vehicle_On_Contract VOC ON c.Contract_Number = VOC.Contract_Number
    LEFT JOIN
        Vehicle v ON VOC.Unit_Number = v.Unit_Number
    WHERE
       (c.Status = 'CO')
    AND
        (voc.Actual_Check_In IS NULL)
    AND
        v.Deleted = 0
   AND
	DATEDIFF(dd, getdate(), voc.Expected_Check_In) = 0
        --DATEDIFF(dd, CONVERT(date, CONVERT(varchar(12), GetDate(), 112)), CONVERT(date, CONVERT(varchar(12), VOC.Expected_Check_In, 112))) = 0
        --CONVERT(date, CONVERT(varchar(12), c.Pick_Up_On, 112)) >= CONVERT(date, CONVERT(varchar(12), GetDate(), 112))
    AND
    (business_transaction_id = 
	(select max(voc1.business_transaction_id)
	from vehicle_on_contract voc1 WITH(NOLOCK)
	where voc1.contract_number = voc.Contract_Number))
    GROUP BY
        DATEPART(hh, voc.Expected_Check_In)
        --VOC.Expected_Check_In
        --VOC.Unit_Number,
        --VOC.Contract_Number

        --CONVERT(date, CONVERT(varchar(12), VOC.Expected_Check_In, 112))
    ORDER BY
        DATEPART(hh, voc.Expected_Check_In)
END


--SELECT * FROM vehicle_On_Contract voc left join vehicle v ON voc.unit_number = v.unit_number where Expected_Check_In between '2018/08/02 13:00:00.000' and '2018/08/02 13:59:59.000' and v.vehicle_Class_Code in ('G', '-', '{')
GO

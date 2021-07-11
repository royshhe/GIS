USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResHourlyData]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetResHourlyData]

AS
BEGIN

--SELECT * FROM Vehicle_Class order by Vehicle_Class_Name

    SELECT
        DATEPART(hh, res.Pick_Up_On) AS Pickup_hour,
        --CONVERT(datetime, CONVERT(varchar(12), res.Pick_Up_On, 112)) 	AS Pick_up_date,
        --CONVERT(datetime,CONVERT(varchar(12), GETDATE(), 112)),
        --CASE WHEN COUNT(CASE WHEN res.status = 'A' and res.Vehicle_Class_Code IN ('B', 'L', 'A') THEN res.status END) = 0 THEN NULL
        --ELSE COUNT(CASE WHEN res.status = 'A' and res.Vehicle_Class_Code IN ('B', 'L', 'A') THEN res.status END) END AS 'Res_Cnt_Compact',

        CASE WHEN COUNT(CASE 
		    WHEN res.status = 'A' and res.Vehicle_Class_Code IN ('B', 'L', 'A')
		    --CONVERT(datetime, CONVERT(varchar(12), res.Pick_Up_On, 112)) = CONVERT(datetime,CONVERT(varchar(12), GETDATE(), 112))
		    THEN res.Confirmation_Number
		    --WHEN res.status = 'O' and con.status = 'OP' and res.Vehicle_Class_Code IN ('B', 'L', 'A') and CONVERT(datetime, CONVERT(varchar(12), res.Pick_Up_On, 112)) = CONVERT(datetime,CONVERT(varchar(12), GETDATE(), 112))
		    --THEN con.Status
		END
	         ) = 0
        THEN NULL
        ELSE COUNT(CASE 
		   WHEN res.status = 'A' and res.Vehicle_Class_Code IN ('B', 'L', 'A')
		   THEN res.Confirmation_Number
		   --WHEN res.status = 'O' and con.status = 'OP' and res.Vehicle_Class_Code IN ('B', 'L', 'A')  and CONVERT(datetime, CONVERT(varchar(12), res.Pick_Up_On, 112)) = CONVERT(datetime,CONVERT(varchar(12), GETDATE(), 112))
		   --THEN con.Status
	         END
	        )
        --END AS 'Res_Cnt_Compact',
        END AS 'Compact',
     --   CASE WHEN COUNT(CASE 
		   --     WHEN res.status = 'A' and res.Vehicle_Class_Code IN ('B', 'L', 'A')
		   --     THEN res.Confirmation_Number
		   --     --WHEN con.status = 'CO' and Con.Vehicle_Class_Code IN ('B', 'L', 'A')  and CONVERT(datetime, CONVERT(varchar(12), res.Drop_off_On, 112)) = CONVERT(datetime,CONVERT(varchar(12), GETDATE(), 112))
		   --     --THEN res.status
		   -- END
	    --     ) = 0
     --   THEN NULL
     --   ELSE COUNT(CASE 
		   --WHEN res.status = 'A' and res.Vehicle_Class_Code IN ('B', 'L', 'A') and res.Vehicle_Class_Code IN ('B', 'L', 'A') and CONVERT(datetime, CONVERT(varchar(12), res.Drop_Off_On, 112)) <= GETDATE()
		   --THEN res.Confirmation_Number
		   ----WHEN con.status = 'CO' and res.Vehicle_Class_Code IN ('B', 'L', 'A')  and CONVERT(datetime, CONVERT(varchar(12), res.Drop_off_On, 112)) = CONVERT(datetime,CONVERT(varchar(12), GETDATE(), 112))
		   ----THEN res.status
	    --     END
	    --    )
     --   END AS 'Due_Cnt_Compact'

    --    --CASE WHEN COUNT(CASE WHEN res.status = 'O' and res.Vehicle_Class_Code IN ('B', 'L', 'A') and CONVERT(datetime, CONVERT(varchar(12), res.Drop_Off_On, 112)) = CONVERT(datetime,CONVERT(varchar(12), GETDATE(), 112)) THEN res.status END) = 0 THEN NULL
    --    --ELSE COUNT(CASE WHEN res.status = 'O' and res.Vehicle_Class_Code IN ('B', 'L', 'A') and CONVERT(datetime, CONVERT(varchar(12), res.Drop_Off_On, 112)) = CONVERT(datetime,CONVERT(varchar(12), GETDATE(), 112)) THEN res.status END) END AS 'Due_Cnt_Compact',

    --    --CASE WHEN COUNT(CASE WHEN con.Status = 'CO' and Vehicle_On_con.Actual_Check_In = NULL and )

        CASE WHEN COUNT(CASE WHEN res.status = 'A' and res.Vehicle_Class_Code IN ('C', '1') THEN res.status END) = 0 THEN NULL
        ELSE COUNT(CASE WHEN res.status = 'A' and res.Vehicle_Class_Code IN ('C', '1') THEN res.status END) END AS 'Mid_Size', --'Res_Cnt_IC',
    --    --CASE WHEN COUNT(CASE WHEN res.status = 'O' and res.Vehicle_Class_Code IN ('C', '1') THEN res.status END) = 0 THEN NULL
    --    --ELSE COUNT(CASE WHEN res.status = 'O' and res.Vehicle_Class_Code IN ('C', '1') THEN res.status END) END AS 'Due_Cnt_IC',

        CASE WHEN COUNT(CASE WHEN res.status = 'A' and res.Vehicle_Class_Code IN ('F', 'D', 'E') THEN res.status END) = 0 THEN NULL
        ELSE COUNT(CASE WHEN res.status = 'A' and res.Vehicle_Class_Code IN ('F', 'D', 'E') THEN res.status END) END AS 'Full_Size',
    --    --CASE WHEN COUNT(CASE WHEN res.status = 'O' and res.Vehicle_Class_Code IN ('F', 'D', 'E') THEN res.status END) = 0 THEN NULL
    --    --ELSE COUNT(CASE WHEN res.status = 'O' and res.Vehicle_Class_Code IN ('F', 'D', 'E') THEN res.status END) END AS 'Due_Cnt_Full_Size',

        CASE WHEN COUNT(CASE WHEN res.status = 'A' and res.Vehicle_Class_Code IN ('G', '{') THEN res.status END) = 0 THEN NULL
        ELSE COUNT(CASE WHEN res.status = 'A' and res.Vehicle_Class_Code IN ('G', '{') THEN res.status END) END AS 'Premium',
    --    --CASE WHEN COUNT(CASE WHEN res.status = 'O' and res.Vehicle_Class_Code IN ('G', '-', '{') THEN res.status END) = 0 THEN NULL
    --    --ELSE COUNT(CASE WHEN res.status = 'O' and res.Vehicle_Class_Code IN ('G', '-', '{') THEN res.status END) END AS 'Due_Cnt_Premium',

        CASE WHEN COUNT(CASE WHEN res.status = 'A' and res.Vehicle_Class_Code IN ('H') THEN res.status END) = 0 THEN NULL
        ELSE COUNT(CASE WHEN res.status = 'A' and res.Vehicle_Class_Code IN ('H') THEN res.status END) END AS 'Luxury',
    --    --CASE WHEN COUNT(CASE WHEN res.status = 'O' and res.Vehicle_Class_Code IN ('H') THEN res.status END) = 0 THEN NULL
    --    --ELSE COUNT(CASE WHEN res.status = 'O' and res.Vehicle_Class_Code IN ('H') THEN res.status END) END AS 'Res_Cnt_Luxury',

        CASE WHEN COUNT(CASE WHEN res.status = 'A' and res.Vehicle_Class_Code IN ('X', '_') THEN res.status END) = 0 THEN NULL
        ELSE COUNT(CASE WHEN res.status = 'A' and res.Vehicle_Class_Code IN ('X', '_') THEN res.status END) END AS 'Mid_SUV',
    --    --CASE WHEN COUNT(CASE WHEN res.status = 'O' and res.Vehicle_Class_Code IN ('X', '_') THEN res.status END) = 0 THEN NULL
    --    --ELSE COUNT(CASE WHEN res.status = 'O' and res.Vehicle_Class_Code IN ('X', '_') THEN res.status END) END AS 'Due_Cnt_Mid_SUV',

        CASE WHEN COUNT(CASE WHEN res.status = 'A' and res.Vehicle_Class_Code IN ('W', '`') THEN res.status END) = 0 THEN NULL
        ELSE COUNT(CASE WHEN res.status = 'A' and res.Vehicle_Class_Code IN ('W', '`') THEN res.status END) END AS 'Stand_SUV',
    --    --CASE WHEN COUNT(CASE WHEN res.status = 'O' and res.Vehicle_Class_Code IN ('W', '`') THEN res.status END) = 0 THEN NULL
    --    --ELSE COUNT(CASE WHEN res.status = 'O' and res.Vehicle_Class_Code IN ('W', '`') THEN res.status END) END AS 'Due_Cnt_SUV',

        CASE WHEN COUNT(CASE WHEN res.status = 'A' and res.Vehicle_Class_Code IN ('9','-', '}') THEN res.status END) = 0 THEN NULL
        ELSE COUNT(CASE WHEN res.status = 'A' and res.Vehicle_Class_Code IN ('9','-', '}') THEN res.status END) END AS 'Full_SUV',
    --    --CASE WHEN COUNT(CASE WHEN res.status = 'O' and res.Vehicle_Class_Code IN ('9', '}') THEN res.status END) = 0 THEN NULL
    --    --ELSE COUNT(CASE WHEN res.status = 'O' and res.Vehicle_Class_Code IN ('9', '}') THEN res.status END) END AS 'Due_Cnt_Full_SUV',

        CASE WHEN COUNT(CASE WHEN res.status = 'A' and res.Vehicle_Class_Code IN ('V', '0', 'O', '+', '5') THEN res.status END) = 0 THEN NULL
        ELSE COUNT(CASE WHEN res.status = 'A' and res.Vehicle_Class_Code IN ('V', '0', 'O', '+', '5') THEN res.status END) END AS 'Van',
    --    --CASE WHEN COUNT(CASE WHEN res.status = 'O' and res.Vehicle_Class_Code IN ('V', '0', 'O', '+', '5') THEN res.status END) = 0 THEN NULL
    --    --ELSE COUNT(CASE WHEN res.status = 'O' and res.Vehicle_Class_Code IN ('V', '0', 'O', '+', '5') THEN res.status END) END AS 'Due_Cnt_Van',

        CASE WHEN COUNT(CASE WHEN res.status = 'A' and res.Vehicle_Class_Code IN ('^', 'P') THEN res.status END) = 0 THEN NULL
        ELSE COUNT(CASE WHEN res.status = 'A' and res.Vehicle_Class_Code IN ('^', 'P') THEN res.status END) END AS 'Prestige',
    --    --CASE WHEN COUNT(CASE WHEN res.status = 'O' and res.Vehicle_Class_Code IN ('^', 'P') THEN res.status END) = 0 THEN NULL
    --    --ELSE COUNT(CASE WHEN res.status = 'O' and res.Vehicle_Class_Code IN ('^', 'P') THEN res.status END) END AS 'Due_Cnt_Prestige',
        CASE WHEN COUNT(CASE WHEN res.status = 'A' and res.Vehicle_Class_Code IN ('U','6') THEN res.status END) = 0 THEN NULL
        ELSE COUNT(CASE WHEN res.status = 'A' and res.Vehicle_Class_Code IN ('U','6') THEN res.status END) END AS 'Sport_Conv',


        (COUNT(CASE WHEN res.status = 'A' and res.Vehicle_Class_Code IN ('B', 'L', 'A') THEN res.status END)) +
        --(COUNT(CASE WHEN res.status = 'O' and res.Vehicle_Class_Code IN ('B', 'L', 'A') THEN res.status END)) +
        (COUNT(CASE WHEN res.status = 'A' and res.Vehicle_Class_Code IN ('C', '1') THEN res.status END)) +
    --    --(COUNT(CASE WHEN res.status = 'O' and res.Vehicle_Class_Code IN ('C', '1') THEN res.status END)) +
        (COUNT(CASE WHEN res.status = 'A' and res.Vehicle_Class_Code IN ('F', 'D', 'E') THEN res.status END)) +
    ----(COUNT(CASE WHEN res.status = 'O' and res.Vehicle_Class_Code IN ('F', 'D', 'E') THEN res.status END)) +
        (COUNT(CASE WHEN res.status = 'A' and res.Vehicle_Class_Code IN ('G', '-', '{') THEN res.status END)) +
    --    --(COUNT(CASE WHEN res.status = 'O' and res.Vehicle_Class_Code IN ('G', '-', '{') THEN res.status END)) +
        (COUNT(CASE WHEN res.status = 'A' and res.Vehicle_Class_Code IN ('H') THEN res.status END)) +
    --    --(COUNT(CASE WHEN res.status = 'O' and res.Vehicle_Class_Code IN ('H') THEN res.status END)) +
        (COUNT(CASE WHEN res.status = 'A' and res.Vehicle_Class_Code IN ('X', '_') THEN res.status END)) +
    --    --(COUNT(CASE WHEN res.status = 'O' and res.Vehicle_Class_Code IN ('X', '_') THEN res.status END)) +
        (COUNT(CASE WHEN res.status = 'A' and res.Vehicle_Class_Code IN ('W', '`') THEN res.status END)) +
    --    --(COUNT(CASE WHEN res.status = 'O' and res.Vehicle_Class_Code IN ('W', '`') THEN res.status END)) +
        (COUNT(CASE WHEN res.status = 'A' and res.Vehicle_Class_Code IN ('9','-', '}') THEN res.status END)) +
    --    --(COUNT(CASE WHEN res.status = 'O' and res.Vehicle_Class_Code IN ('9', '}') THEN res.status END)) +
        (COUNT(CASE WHEN res.status = 'A' and res.Vehicle_Class_Code IN ('V', '0', 'O', '+', '5') THEN res.status END)) +
    --    --(COUNT(CASE WHEN res.status = 'O' and res.Vehicle_Class_Code IN ('V', '0', 'O', '+', '5') THEN res.status END)) +
        (COUNT(CASE WHEN res.status = 'A' and res.Vehicle_Class_Code IN ('^', 'P') THEN res.status END)) +
    --    --(COUNT(CASE WHEN res.status = 'O' and res.Vehicle_Class_Code IN ('^', 'P') THEN res.status END)) 
        COUNT(CASE WHEN res.status = 'A' and res.Vehicle_Class_Code IN ('U','6') THEN res.status END)
        AS 'Total'

    FROM
        [dbo].[Reservation] Res
    --INNER JOIN [SVBVM080].[gisdata].[dbo].[Contract] Con ON Res.Confirmation_Number = Con.Confirmation_Number
    --INNER JOIN [SVBVM080].[gisdata].[dbo].[Vehicle_On_Contract] VOC ON Con.Contract_Number = VOC.Contract_Number
    --INNER JOIN [SVBVM080].[gisdata].[dbo].[Vehicle] Veh ON VOC.Unit_Number = Veh.Unit_Number
    
    WHERE
        DATEDIFF(dd, getdate(), Res.Pick_Up_On) = 0
    GROUP BY
        DATEPART(hh, Res.Pick_Up_On)
        --CONVERT(datetime, CONVERT(varchar(12), res.Pick_Up_On, 112))
    ORDER BY
        DATEPART(hh, Res.Pick_Up_On)
        --CONVERT(datetime, CONVERT(varchar(12), res.Drop_Off_On, 112)),
        --CONVERT(datetime,CONVERT(varchar(12), GETDATE(), 112))
END
GO

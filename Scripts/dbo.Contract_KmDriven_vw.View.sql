USE [GISData]
GO
/****** Object:  View [dbo].[Contract_KmDriven_vw]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE VIEW [dbo].[Contract_KmDriven_vw]
AS
SELECT dbo.Contract.Contract_Number, 
      (case when (SUM(dbo.Vehicle_On_Contract.Km_In - dbo.Vehicle_On_Contract.Km_Out)) < 5
		     then 50
		     else SUM(dbo.Vehicle_On_Contract.Km_In - dbo.Vehicle_On_Contract.Km_Out)
		     end
		
      		)AS KmDriven
FROM dbo.Contract INNER JOIN
      dbo.Vehicle_On_Contract ON 
      dbo.Contract.Contract_Number = dbo.Vehicle_On_Contract.Contract_Number
GROUP BY dbo.Contract.Contract_Number

GO

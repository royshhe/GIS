USE [GISData]
GO
/****** Object:  View [dbo].[ViewLastCheckinOnContract]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[ViewLastCheckinOnContract]
AS
SELECT DISTINCT Contract_Number, Actual_Check_In, unit_number
FROM         dbo.Vehicle_On_Contract WITH (NOLOCK)
WHERE     (Actual_Check_In =
                          (SELECT     MAX(voc.actual_check_in)
                            FROM          Vehicle_On_Contract voc
                            WHERE      voc.contract_Number = Vehicle_On_Contract.Contract_Number))

GO

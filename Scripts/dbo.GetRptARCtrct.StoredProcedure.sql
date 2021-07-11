USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRptARCtrct]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetRptARCtrct]
@ToDate VARCHAR (24), @Days VARCHAR (4)
AS
DECLARE @cntDays AS INT, @dFrom AS DATETIME, @dTo AS DATETIME;
SELECT @cntDays = CAST (NULLIF (@Days, '') AS INT),
       @dTo = CAST (NULLIF (@ToDate, '') AS DATETIME);
SELECT @dFrom = DATEADD(day, 1 - @cntDays, @dTo);
SELECT   v.*
FROM     (SELECT DISTINCT 'RAArchive' AS Customer_Code,
                          c.Contract_number,
                          c.Status
          FROM   contract AS c
                 INNER JOIN
                 Business_Transaction AS bt
                 ON bt.Contract_Number = c.Contract_Number
          WHERE  (bt.Transaction_Type = 'con')
                 AND (bt.Transaction_Description IN ('check in', 'foreign check in'))
                 AND c.Status = 'CI'
                 AND bt.RBR_Date >= '2017-11-01'
                 AND bt.RBR_Date < '2018-03-01') AS v
ORDER BY v.Contract_Number
OFFSET 16900 ROWS;
RETURN @@ROWCOUNT;
RESTORE HEADERONLY FROM DISK = 'e:\MSSQL\BACKUP\GISData\Current\gisdatacurrentvan20190216.bak';

GO

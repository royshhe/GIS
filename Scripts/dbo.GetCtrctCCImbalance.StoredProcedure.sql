USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctCCImbalance]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
CREATE  PROCEDURE [dbo].[GetCtrctCCImbalance]	 --2174617


	@ContractNum	Varchar(10)
AS
DECLARE @nContractNum Integer
 
SELECT @nContractNum = Convert(Int, NULLIF(@ContractNum,''))

SELECT distinct cc.Credit_Card_Key, 
				cct.Short_Token, 
				cc.Credit_Card_Type_ID, 
				cct.Authorization_Number, 
				cct.Terminal_ID, 
				cct.Trx_Receipt_Ref_Num, 
				cct.Trx_ISO_Response_Code, 
				cct.Trx_Remarks
FROM  dbo.Credit_Card_Transaction AS cct INNER JOIN
               dbo.Credit_Card AS cc ON cct.Short_Token = cc.Short_Token
WHERE Added_to_GIS=0

--(cct.RBR_Date = '2017-08-04')
--AND (cct.Collected_By = 'TOLLCHARGE')-- and contract_number=2174680
--And cc.Credit_Card_Key<>2043253
--And cct.Contract_Number=@nContractNum


 
GO

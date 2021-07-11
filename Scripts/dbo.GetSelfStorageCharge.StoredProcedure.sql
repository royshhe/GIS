USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetSelfStorageCharge]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[GetSelfStorageCharge]
As 
SELECT ssr.Transaction_ID,cc.Credit_Card_Key,ssr.Amount, ssr.First_Name, ssr.Last_Name , cc.Short_Token,  ssr.Expiry_Date,
  cc.Credit_Card_Type_ID, ssr.Unit_Number, ssr.Site_Name
FROM  dbo.Self_Storage_Rental AS ssr INNER JOIN
               (
Select MAX(cc.Credit_Card_Key) Credit_Card_Key, cc.Short_Token, cc.Credit_Card_Type_ID from dbo.credit_card cc
Group by  cc.Short_Token, cc.Credit_Card_Type_ID 
)  cc ON ssr.CCToken = cc.Short_Token
Where  ssr.Processed=0
GO

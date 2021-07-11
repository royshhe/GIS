USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAllChargeGL]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
PURPOSE: 	To retrieve the charge parameter for the given category..
MOD HISTORY:
Name    Date        Comments
Roy He  2006-03-03
*/
/* updated to ver 80 */

create PROCEDURE [dbo].[GetAllChargeGL]
AS

	Select  LK.Code, LK.Value, Vehicle_Type_ID, GL_Revenue_Account
	From
		 Charge_GL
   LEFT JOIN (SELECT  distinct   Code, Value, Alias
			  FROM         Lookup_Table
              WHERE Category IN( 'Charge Type Adjustment', 
								 'Charge Type Calculated', 
								 'Charge Type Manual', 
								 'Charge Type Reimbursement', 
								 'Charge Type Rentback')) LK on 
			 LK.Code = Charge_Type_ID
	ORDER BY Vehicle_Type_ID
Return 1
GO

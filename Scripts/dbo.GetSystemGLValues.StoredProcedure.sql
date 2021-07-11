USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetSystemGLValues]    Script Date: 2021-07-10 1:50:49 PM ******/
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

create PROCEDURE [dbo].[GetSystemGLValues]
AS

	SELECT     AR_Debit_Card_Account, AR_Canadian_Cash_Account, AR_US_Cash_Account, GL_US_Exchange_Account, GL_Receivables_Clear_Acct, 
                      GL_Csh_Refnd_Payables_Clr_Acct, GL_Ticket_Payables_Clear_Acct, GL_CDN_Interbranch_Clear_Acct, GL_US_Interbranch_Clear_Acct, GL_Deposit_Account, 
                      AR_Cash_Ticket_Account, AR_Cash_Damage_Charge_Account
     FROM         System_Values

Return 1
GO

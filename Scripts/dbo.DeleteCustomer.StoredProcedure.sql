USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteCustomer]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.DeleteCustomer    Script Date: 2/18/99 12:11:42 PM ******/
/****** Object:  Stored Procedure dbo.DeleteCustomer    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DeleteCustomer    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.DeleteCustomer    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To logical delete record from Customer table by setting the inactive flag.
MOD HISTORY:
Name    Date        	Comments
NP	Jan/17/2000	Added Last_chaged_On
 */

CREATE PROCEDURE [dbo].[DeleteCustomer]
	@CustId Varchar(10),
	@UserName Varchar(20)
AS
	/* perform logical delete of customer */
	UPDATE	Customer
	SET	Inactive = 1,
		Last_changed_by = @UserName,
		Last_Changed_On = GetDate()
	WHERE	Customer_Id = Convert(Int,@CustId)
	RETURN 1














GO

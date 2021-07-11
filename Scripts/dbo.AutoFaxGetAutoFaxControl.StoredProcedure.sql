USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AutoFaxGetAutoFaxControl]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO








------------------------------------------------------------------------------------------------------
--  Programmer :   Jack Jian
--  Date :              Apr 04, 2001
--  Details: 	 Get AutoFax Service Control Infomation 
------------------------------------------------------------------------------------------------------



CREATE PROCEDURE [dbo].[AutoFaxGetAutoFaxControl] 
  @control_ID int
as

if @control_ID <> 0 
	select * from autofaxcontrol where control_id = @control_ID
else
	select * from autofaxcontrol



GO

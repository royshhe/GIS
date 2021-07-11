USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRateDropOffLocCount]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetRateDropOffLocCount    Script Date: 2/18/99 12:12:03 PM ******/
/****** Object:  Stored Procedure dbo.GetRateDropOffLocCount    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetRateDropOffLocCount    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetRateDropOffLocCount    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetRateDropOffLocCount]
@Rate_ID varchar(10),
@LocID   varchar(15),
@PickupDate varchar(20)
AS
         Select Count(*)
from     Rate_Location_Set RLS, Rate_Drop_Off_Location RDL
         where RLS.Rate_Location_Set_ID = RDL.Rate_Location_Set_ID
         And   RLS.Rate_ID = RDL.Rate_ID
         And   RLS.Rate_ID = Convert(int, @Rate_ID)
         And   RDL.Location_ID = Convert(int, @LocID)
         And   RLS.Allow_All_Auth_Drop_Off_Locs = Convert(Bit, 0)
         And   RDL.Effective_date <= Convert(datetime, @PickupDate)
         And   RDL.Termination_Date >= Convert(datetime, @PickupDate)












GO

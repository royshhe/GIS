USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateSSCProcessStatus]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Erase QueryParam
--    QueryParam(0) = 3
--    QueryParam(1) = sTrxID
--    QueryParam(3) = sBusTrxID
   
CREATE Procedure [dbo].[UpdateSSCProcessStatus]   
	@TrxID Varchar(20),	
	@BusTrxID Varchar(20)
As
Update Self_Storage_Rental  
Set Processed =1,
	Business_Transaction_ID= Convert(int, NULLIF(@BusTrxID, '')) 
	Where Processed=0 and 	transaction_id=Convert(int, NULLIF(@TrxID, '')) 
			
			
--Update	 Toll_Charge set processed=0
--select * from Self_Storage_Rental
GO

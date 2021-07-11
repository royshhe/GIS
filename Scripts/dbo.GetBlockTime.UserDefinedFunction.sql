USE [GISData]
GO
/****** Object:  UserDefinedFunction [dbo].[GetBlockTime]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create Function [dbo].[GetBlockTime]  
(
	@BlockType char(02),
	@Time char(05),	
	@OwningCompanyID int
)
Returns char(05)
As
	


Begin
 
DECLARE   @BlockTime as Varchar(5)
 
 
 
select @BlockTime =Block_Time from Truck_Time_Block where 
(Owning_Company_id=@OwningCompanyID and Block_Type=@BlockType)
 and 
(
		( Block_Name <>'OV' And (@Time between Block_start and Block_end))
		 Or 
		 (	
			Block_Name ='OV' And 
			(
			      (@Time between Block_start and '23:59') 
			      or 
			      (@Time  between '00:00' and Block_end)
			 )
		 )
)
Return	@BlockTime 
End
GO

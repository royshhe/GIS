USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetTollReportingRecords]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetTollReportingRecords]   -- '26986696us2',2030614, 'leonard' 
		@ForeignConfirmNum Varchar(20),
		@ContractNumber Varchar(10),
        @LastName varchar(50)


AS
    --Declare @iResCount integer
    Declare @iRACount integer
    
	--select @iResCount=count(*)  From Reservation 
	--where Foreign_Confirm_number = @ForeignConfirmNum
	--AND	Last_Name LIKE LTRIM(@LastName + '%') --and Status<>'C'
	Select RA.Contract_number, VC.FA_Vehicle_Type_ID as VehicleType, RA.Email_Address, RA.First_Name, RA.Last_Name
	From	
	(
		SELECT Con.Contract_number, 
			  (Case When VOC.Vehicle_Class_Code is not null Then VOC.Vehicle_Class_Code
				   Else Con.Vehicle_Class_Code
			  End) Vehicle_Class_Code, Con.Email_Address , Con.First_Name, Con.Last_Name
			  from  
			   dbo.Contract AS Con    
			   Left Join
			   (SELECT LVOC.Contract_number,  v.Vehicle_Class_Code      FROM  dbo.Vehicle AS v INNER JOIN
			   dbo.RP__Last_Vehicle_On_Contract AS LVOC ON v.Unit_Number = LVOC.Unit_Number
			   ) VOC
			   On Con.Contract_number=VOC.Contract_Number
		--where Con.Contract_number=2022002
	           
		--select count(*)   From Contract 
		where Con.Confirmation_number in 
		(select Confirmation_number  From Reservation  
			where Foreign_Confirm_number = @ForeignConfirmNum
			AND	Last_Name LIKE LTRIM(@LastName + '%') 
		)
		Or
		(Con.Contract_Number=@ContractNumber
		AND	CON.Last_Name LIKE LTRIM(@LastName + '%')
		)
	)RA
	Inner Join dbo.Vehicle_Class VC
	On RA.Vehicle_Class_Code=VC.Vehicle_Class_Code
	
	--if (@iResCount>0 or @iRACount>0 )
	--   Select 1
	--Else
	--   Select 0
	   

RETURN @@ROWCOUNT
--select * from VEhicle_Class
GO

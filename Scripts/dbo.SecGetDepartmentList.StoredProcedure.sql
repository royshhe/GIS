USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SecGetDepartmentList]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






-------------------------------------------------------------------------------------------------------------------
----  Programmer:  Roy He
----  Date: 	 Dec 12, 2014
----  Details:	 Get Department list
-------------------------------------------------------------------------------------------------------------------

Create PROCEDURE [dbo].[SecGetDepartmentList]


as

	SET NOCOUNT ON	

	 

	Select Department_Name, Department_ID from Employee_Departments	
	where Active=1 
	order  by Department_Name  


	SET NOCOUNT Off




GO

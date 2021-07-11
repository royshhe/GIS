USE [GISData]
GO
/****** Object:  Table [dbo].[CustomerBak1000]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerBak1000](
	[Customer_ID] [int] IDENTITY(1000,1) NOT NULL,
	[Last_Name] [varchar](25) NOT NULL,
	[First_Name] [varchar](25) NOT NULL,
	[Address_1] [varchar](50) NULL,
	[Address_2] [varchar](50) NULL,
	[City] [varchar](25) NULL,
	[Province] [varchar](25) NULL,
	[Postal_Code] [varchar](10) NULL,
	[Country] [varchar](25) NULL,
	[Phone_Number] [varchar](31) NULL,
	[Email_Address] [varchar](50) NULL,
	[Birth_Date] [datetime] NULL,
	[Gender] [char](1) NULL,
	[Driver_Licence_Number] [varchar](25) NULL,
	[Driver_Licence_Expiry] [datetime] NULL,
	[Jurisdiction] [varchar](20) NULL,
	[Program_Number] [varchar](15) NULL,
	[Payment_Method] [varchar](20) NULL,
	[Do_Not_Rent] [bit] NOT NULL,
	[Remarks] [varchar](255) NULL,
	[Vehicle_Class_Code] [char](1) NULL,
	[Organization_ID] [int] NULL,
	[Add_LDW] [bit] NOT NULL,
	[Add_PAI] [bit] NOT NULL,
	[Add_PEC] [bit] NOT NULL,
	[Smoking_Non_Smoking] [char](1) NOT NULL,
	[Inactive] [bit] NOT NULL,
	[Last_Changed_By] [varchar](20) NOT NULL,
	[Last_Changed_On] [datetime] NOT NULL,
	[Preferred_FF_Plan_ID] [smallint] NULL,
	[Preferred_FF_Member_Number] [varchar](20) NULL,
	[Driver_Licence_Class] [char](1) NULL,
	[Company_Name] [varchar](30) NULL,
	[Company_Phone_Number] [varchar](31) NULL
) ON [PRIMARY]
GO

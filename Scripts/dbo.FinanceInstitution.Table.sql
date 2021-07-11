USE [GISData]
GO
/****** Object:  Table [dbo].[FinanceInstitution]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FinanceInstitution](
	[Institution_ID] [int] IDENTITY(1,1) NOT NULL,
	[InstitutionName] [varchar](50) NOT NULL,
	[Address_1] [varchar](50) NOT NULL,
	[Address_2] [varchar](50) NULL,
	[City] [varchar](25) NOT NULL,
	[Province] [varchar](25) NULL,
	[Country] [varchar](25) NOT NULL,
	[Postal_Code] [varchar](10) NULL,
	[Phone_Number] [varchar](31) NOT NULL,
	[Fax_Number] [varchar](31) NULL,
	[Contact_Name] [varchar](25) NULL,
	[Contact_Position] [varchar](25) NULL,
	[Contact_Phone_Number] [varchar](31) NULL,
	[Contact_Fax_Number] [varchar](31) NULL,
	[Contact_Email_Address] [varchar](50) NULL,
	[Remarks] [varchar](255) NULL,
	[Inactive] [bit] NOT NULL,
	[Update_Ctrl] [timestamp] NULL,
	[Last_Updated_By] [varchar](20) NOT NULL,
	[Last_Updated_On] [datetime] NOT NULL
) ON [PRIMARY]
GO

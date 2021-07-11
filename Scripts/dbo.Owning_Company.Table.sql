USE [GISData]
GO
/****** Object:  Table [dbo].[Owning_Company]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Owning_Company](
	[Owning_Company_ID] [smallint] NOT NULL,
	[Vendor_code] [char](12) NULL,
	[Customer_code] [char](12) NULL,
	[Name] [varchar](50) NOT NULL,
	[Address1] [varchar](50) NULL,
	[Address2] [varchar](50) NULL,
	[City] [varchar](25) NULL,
	[Province] [varchar](20) NULL,
	[Country] [varchar](25) NULL,
	[Postal_Code] [varchar](10) NULL,
	[Zone] [char](2) NULL,
	[IB_Zone] [char](10) NULL,
	[Phone_Number] [varchar](31) NULL,
	[Fax_Number] [varchar](31) NULL,
	[Contact_Name] [varchar](25) NULL,
	[Contact_Position] [varchar](25) NULL,
	[Contact_Phone_Number] [char](31) NULL,
	[Contact_Fax_Number] [char](31) NULL,
	[Contact_Email_Address] [varchar](50) NULL,
	[AP_Currency_ID] [tinyint] NULL,
	[AP_Interbranch_Account] [varchar](25) NULL,
	[AR_Interbranch_CAN_Account] [varchar](25) NULL,
	[AR_Interbranch_US_Account] [varchar](25) NULL,
	[Remarks] [varchar](255) NULL,
	[Delete_Flag] [bit] NOT NULL,
	[Last_Update_By] [varchar](20) NOT NULL,
	[Last_Update_On] [datetime] NOT NULL,
	[Resnet_Charge] [decimal](9, 2) NULL,
	[System_ID] [char](10) NULL,
	[Vendor_Number] [char](20) NULL,
	[Wizard_Location] [bit] NULL,
	[Contact_Email_CC] [varchar](60) NULL,
 CONSTRAINT [PK_Owning_Company] PRIMARY KEY CLUSTERED 
(
	[Owning_Company_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UC_Owning_Company1] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Owning_Company] ADD  CONSTRAINT [DF__Owning_Co__Delet__257252FF]  DEFAULT (0) FOR [Delete_Flag]
GO

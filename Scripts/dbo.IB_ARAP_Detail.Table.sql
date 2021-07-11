USE [GISData]
GO
/****** Object:  Table [dbo].[IB_ARAP_Detail]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IB_ARAP_Detail](
	[IB_Trans_ID] [int] IDENTITY(1,1) NOT NULL,
	[RBR_Date] [datetime] NOT NULL,
	[Contract_number] [int] NOT NULL,
	[Revenue_Account] [varchar](20) NOT NULL,
	[Amount] [decimal](9, 2) NULL,
	[Commission_Rate] [decimal](9, 2) NULL,
	[Vehicle_Ownership_Vendor_Code] [char](12) NULL,
	[Vehicle_Ownership_Customer_code] [char](12) NULL,
	[Renting_Compay_Vendor_Code] [char](12) NULL,
	[Renting_Compay_Customer_Code] [char](12) NULL,
	[Receiving_Company_Vendor_Code] [char](12) NULL,
	[Receiving_Company_Customer_Code] [char](12) NULL,
	[Subleger] [char](10) NULL,
	[Customer_Type] [char](10) NULL,
	[Vendor_Type] [char](10) NULL,
	[Customer_code] [char](12) NULL,
	[Vendor_code] [char](12) NULL,
	[IB_Zone] [char](10) NULL,
	[Contract_Currency_ID] [smallint] NULL,
 CONSTRAINT [PK_IB_ARAP_Detail] PRIMARY KEY CLUSTERED 
(
	[IB_Trans_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO

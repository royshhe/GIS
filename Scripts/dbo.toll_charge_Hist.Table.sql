USE [GISData]
GO
/****** Object:  Table [dbo].[toll_charge_Hist]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[toll_charge_Hist](
	[Toll_Charge_ID] [int] IDENTITY(1,1) NOT NULL,
	[Toll_Charge_Date] [datetime] NOT NULL,
	[Charge_Amount] [decimal](9, 2) NOT NULL,
	[Licence_Plate] [varchar](10) NOT NULL,
	[Direction] [varchar](50) NULL,
	[Vehicle_Class] [varchar](50) NULL,
	[Issuer] [varchar](10) NOT NULL,
	[Processed] [bit] NOT NULL,
	[Email_Sent] [bit] NOT NULL,
	[Business_Transaction_ID] [int] NULL,
	[Decal] [varchar](15) NULL,
	[Nick_Name] [varchar](20) NULL,
	[Bridge] [varchar](15) NULL,
	[Tolling_Method] [varchar](10) NULL
) ON [PRIMARY]
GO

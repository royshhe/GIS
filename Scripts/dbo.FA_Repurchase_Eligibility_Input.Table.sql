USE [GISData]
GO
/****** Object:  Table [dbo].[FA_Repurchase_Eligibility_Input]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FA_Repurchase_Eligibility_Input](
	[Repurchase_Year] [char](25) NULL,
	[Sold_FIN] [varchar](20) NULL,
	[Vin] [varchar](30) NOT NULL,
	[Vehicle_Line_Name] [varchar](100) NULL,
	[ISD] [smalldatetime] NULL,
	[Contract_End_Min_Date] [smalldatetime] NULL,
	[Mileage_Penalty] [decimal](9, 2) NULL,
	[Capitalized] [decimal](10, 2) NULL,
	[Rep_Payment] [decimal](10, 2) NULL,
	[Repurchase_Payment_Date] [smalldatetime] NULL,
	[Avg_Days_In_Service] [int] NULL,
	[Contract_End_Max_Date] [smalldatetime] NULL,
 CONSTRAINT [PK_FA_Repurchase_Eligibility_Input] PRIMARY KEY CLUSTERED 
(
	[Vin] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO

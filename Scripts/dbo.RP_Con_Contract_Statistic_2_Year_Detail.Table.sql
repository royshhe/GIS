USE [GISData]
GO
/****** Object:  Table [dbo].[RP_Con_Contract_Statistic_2_Year_Detail]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RP_Con_Contract_Statistic_2_Year_Detail](
	[Vehicle_Type_ID] [varchar](18) NOT NULL,
	[Location_ID] [smallint] NOT NULL,
	[Items] [varchar](50) NULL,
	[Curr_Total] [numeric](9, 2) NULL,
	[Pre_Total] [numeric](9, 2) NULL,
	[Curr_RPU] [numeric](9, 2) NULL,
	[Pre_RPU] [numeric](9, 2) NULL,
	[Fleet_Volume_Variance] [numeric](9, 2) NULL,
	[Rate_Variance] [numeric](9, 2) NULL,
	[Curr_DDA] [numeric](9, 2) NULL,
	[Pre_DDA] [numeric](9, 2) NULL,
	[Rental_Volume_Variance] [numeric](9, 2) NULL,
	[DDA_Variance] [numeric](9, 2) NULL,
	[Total_Variance] [numeric](9, 2) NULL
) ON [PRIMARY]
GO

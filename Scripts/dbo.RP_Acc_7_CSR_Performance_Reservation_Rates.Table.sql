USE [GISData]
GO
/****** Object:  Table [dbo].[RP_Acc_7_CSR_Performance_Reservation_Rates]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RP_Acc_7_CSR_Performance_Reservation_Rates](
	[Run_ID] [int] NOT NULL,
	[Confirmation_Number] [int] NOT NULL,
	[Rate_Name] [varchar](50) NULL,
	[Late_Day_Rate] [decimal](9, 2) NULL,
	[Daily_Rate] [decimal](9, 2) NULL,
	[Weekly_Rate] [decimal](9, 2) NULL,
	[Monthly_Rate] [decimal](9, 2) NULL
) ON [PRIMARY]
GO

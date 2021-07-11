USE [GISData]
GO
/****** Object:  Table [dbo].[Rate_Charge_Amount_Input]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rate_Charge_Amount_Input](
	[VCRateChargeAmtID] [int] IDENTITY(1,1) NOT NULL,
	[Vehicle_Class_Code] [char](1) NOT NULL,
	[Rate_ID] [int] NOT NULL,
	[Rate_Level_ID] [int] NULL,
	[Rate_Level] [char](10) NULL,
	[Time_Period] [char](10) NULL,
	[Time_Period_Start] [int] NULL,
	[Time_Period_End] [int] NULL,
	[Type] [char](10) NULL,
	[Amount] [decimal](9, 2) NULL,
	[Per_KM_Charge] [decimal](9, 2) NULL,
 CONSTRAINT [PK_Rate_Charge_Amount_Input] PRIMARY KEY CLUSTERED 
(
	[VCRateChargeAmtID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [IX_Rate_Charge_Amount_Input_1] UNIQUE NONCLUSTERED 
(
	[Vehicle_Class_Code] ASC,
	[Rate_ID] ASC,
	[Rate_Level] ASC,
	[Time_Period] ASC,
	[Time_Period_Start] ASC,
	[Time_Period_End] ASC,
	[Type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_Rate_Charge_Amount_Input]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [IX_Rate_Charge_Amount_Input] ON [dbo].[Rate_Charge_Amount_Input]
(
	[VCRateChargeAmtID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO

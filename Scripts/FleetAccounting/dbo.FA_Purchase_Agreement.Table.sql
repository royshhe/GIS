USE [GISData]
GO
/****** Object:  Table [dbo].[FA_Purchase_Agreement]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FA_Purchase_Agreement](
	[Agreement_ID] [smallint] IDENTITY(1,1) NOT NULL,
	[Vehicle_Model_ID] [smallint] NOT NULL,
	[Program] [bit] NOT NULL,
	[Order] [char](10) NULL,
	[Agreement_Year] [char](4) NOT NULL,
	[Purchase_Cycle] [char](1) NOT NULL,
	[Monthly_Dep_Amount] [decimal](9, 2) NULL,
	[Monthly_Dep_Rate] [decimal](9, 2) NULL,
	[Vehicle_Price] [decimal](10, 2) NOT NULL,
	[PDI_Amount] [decimal](9, 2) NULL,
	[Price_Include_PDI] [bit] NOT NULL,
	[PDI_Performer] [char](25) NULL,
	[Dep_Type] [char](10) NULL,
	[Volume] [smallint] NULL,
	[Volume_Incentive] [decimal](9, 2) NULL,
	[Incentive_from] [char](5) NULL,
	[Rebate] [decimal](9, 2) NULL,
	[Rebate_From] [char](5) NULL,
	[Days_InService_Start] [smallint] NULL,
	[Days_InService_End] [smallint] NULL,
	[Allowance_days] [smallint] NULL,
	[Inservice_Days] [smallint] NULL,
	[Mark_Down] [decimal](9, 2) NULL,
	[Exercise_Tax] [decimal](9, 2) NULL,
	[Battery_Levy] [decimal](9, 2) NULL,
 CONSTRAINT [PK_FA_Purchase_Agreement] PRIMARY KEY CLUSTERED 
(
	[Agreement_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [IX_FA_Purchase_Agreement] UNIQUE NONCLUSTERED 
(
	[Vehicle_Model_ID] ASC,
	[Order] ASC,
	[Agreement_Year] ASC,
	[Purchase_Cycle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FA_Purchase_Agreement] ADD  CONSTRAINT [DF_FA_Purchase_Agreement_Program]  DEFAULT (0) FOR [Program]
GO
ALTER TABLE [dbo].[FA_Purchase_Agreement] ADD  CONSTRAINT [DF_FA_Purchase_Agreement_Vehicle_Price]  DEFAULT (0) FOR [Vehicle_Price]
GO
ALTER TABLE [dbo].[FA_Purchase_Agreement] ADD  CONSTRAINT [DF_FA_Purchase_Agreement_Dep_Type]  DEFAULT ('Monthly') FOR [Dep_Type]
GO
ALTER TABLE [dbo].[FA_Purchase_Agreement]  WITH NOCHECK ADD  CONSTRAINT [FK_FA_Purchase_Agreement_Vehicle_Model_Year] FOREIGN KEY([Vehicle_Model_ID])
REFERENCES [dbo].[Vehicle_Model_Year] ([Vehicle_Model_ID])
GO
ALTER TABLE [dbo].[FA_Purchase_Agreement] CHECK CONSTRAINT [FK_FA_Purchase_Agreement_Vehicle_Model_Year]
GO

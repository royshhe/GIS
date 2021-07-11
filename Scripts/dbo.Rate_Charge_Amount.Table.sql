USE [GISData]
GO
/****** Object:  Table [dbo].[Rate_Charge_Amount]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rate_Charge_Amount](
	[Rate_ID] [int] NOT NULL,
	[Effective_Date] [datetime] NOT NULL,
	[Termination_Date] [datetime] NOT NULL,
	[Rate_Level] [char](1) NOT NULL,
	[Rate_Time_Period_ID] [int] NOT NULL,
	[Rate_Vehicle_Class_ID] [int] NOT NULL,
	[Type] [varchar](15) NOT NULL,
	[Amount] [decimal](9, 2) NOT NULL,
 CONSTRAINT [PK_Rate_Charge_Amount] PRIMARY KEY CLUSTERED 
(
	[Rate_ID] ASC,
	[Effective_Date] ASC,
	[Rate_Level] ASC,
	[Rate_Time_Period_ID] ASC,
	[Rate_Vehicle_Class_ID] ASC,
	[Type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_Rate_Charge_Amount1]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [IX_Rate_Charge_Amount1] ON [dbo].[Rate_Charge_Amount]
(
	[Rate_Time_Period_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [IX_Rate_Charge_Amount2]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [IX_Rate_Charge_Amount2] ON [dbo].[Rate_Charge_Amount]
(
	[Rate_Vehicle_Class_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Rate_Charge_Amount]  WITH NOCHECK ADD  CONSTRAINT [FK_Rate_Charge_Amount_Rate_Level] FOREIGN KEY([Rate_ID], [Effective_Date], [Rate_Level])
REFERENCES [dbo].[Rate_Level] ([Rate_ID], [Effective_Date], [Rate_Level])
GO
ALTER TABLE [dbo].[Rate_Charge_Amount] NOCHECK CONSTRAINT [FK_Rate_Charge_Amount_Rate_Level]
GO
ALTER TABLE [dbo].[Rate_Charge_Amount]  WITH NOCHECK ADD  CONSTRAINT [FK_Rate_Charge_Amount_Rate_Vehicle_Class] FOREIGN KEY([Rate_Vehicle_Class_ID], [Rate_ID], [Effective_Date])
REFERENCES [dbo].[Rate_Vehicle_Class] ([Rate_Vehicle_Class_ID], [Rate_ID], [Effective_Date])
NOT FOR REPLICATION 
GO
ALTER TABLE [dbo].[Rate_Charge_Amount] NOCHECK CONSTRAINT [FK_Rate_Charge_Amount_Rate_Vehicle_Class]
GO

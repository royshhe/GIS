USE [GISData]
GO
/****** Object:  Table [dbo].[Rate_Time_Period]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rate_Time_Period](
	[Rate_Time_Period_ID] [int] IDENTITY(1,1) NOT NULL,
	[Rate_ID] [int] NOT NULL,
	[Effective_Date] [datetime] NOT NULL,
	[Termination_Date] [datetime] NOT NULL,
	[Time_Period] [char](10) NOT NULL,
	[Time_Period_Start] [smallint] NOT NULL,
	[Type] [char](7) NOT NULL,
	[Time_period_End] [smallint] NOT NULL,
	[Km_Cap] [smallint] NULL,
 CONSTRAINT [PK_Rate_Time_Period] PRIMARY KEY CLUSTERED 
(
	[Rate_Time_Period_ID] ASC,
	[Rate_ID] ASC,
	[Effective_Date] ASC,
	[Time_Period] ASC,
	[Time_Period_Start] ASC,
	[Type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Rate_Time_Period1]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [IX_Rate_Time_Period1] ON [dbo].[Rate_Time_Period]
(
	[Rate_ID] ASC,
	[Time_Period] ASC,
	[Time_Period_Start] ASC,
	[Type] ASC,
	[Termination_Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Rate_Time_Period]  WITH NOCHECK ADD  CONSTRAINT [FK_Rate_Time_Period_Vehicle_Rate] FOREIGN KEY([Rate_ID], [Effective_Date])
REFERENCES [dbo].[Vehicle_Rate] ([Rate_ID], [Effective_Date])
GO
ALTER TABLE [dbo].[Rate_Time_Period] NOCHECK CONSTRAINT [FK_Rate_Time_Period_Vehicle_Rate]
GO
ALTER TABLE [dbo].[Rate_Time_Period]  WITH CHECK ADD  CONSTRAINT [FK_Time_Period1] FOREIGN KEY([Time_Period])
REFERENCES [dbo].[Time_Period] ([Time_Period])
GO
ALTER TABLE [dbo].[Rate_Time_Period] CHECK CONSTRAINT [FK_Time_Period1]
GO

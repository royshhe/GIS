USE [GISData]
GO
/****** Object:  Table [dbo].[Frequent_Flyer_Plan]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Frequent_Flyer_Plan](
	[Frequent_Flyer_Plan_ID] [smallint] NOT NULL,
	[Airline] [varchar](20) NULL,
	[Frequent_Flyer_Plan] [varchar](20) NOT NULL,
	[Points] [int] NOT NULL,
	[Budget_Cost] [smallmoney] NULL,
	[Maestro_Code] [char](2) NULL,
	[Effective_Date] [datetime] NOT NULL,
	[Termination_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_Frequent_Flyer_Plan] PRIMARY KEY CLUSTERED 
(
	[Frequent_Flyer_Plan_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UC_Frequent_Flyer_Plan1] UNIQUE NONCLUSTERED 
(
	[Frequent_Flyer_Plan] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Frequent_Flyer_Plan] ADD  DEFAULT ('1999-01-01 00:00:00') FOR [Effective_Date]
GO
ALTER TABLE [dbo].[Frequent_Flyer_Plan] ADD  DEFAULT ('2078-12-31 23:59:00') FOR [Termination_Date]
GO

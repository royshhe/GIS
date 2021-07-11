USE [GISData]
GO
/****** Object:  Table [dbo].[Rate_Restriction]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rate_Restriction](
	[Rate_ID] [int] NOT NULL,
	[Effective_Date] [datetime] NOT NULL,
	[Termination_Date] [datetime] NOT NULL,
	[Restriction_ID] [smallint] NOT NULL,
	[Time_of_Day] [char](5) NULL,
	[Number_of_Days] [smallint] NULL,
	[Number_of_Hours] [smallint] NULL,
 CONSTRAINT [PK_Rate_Restriction] PRIMARY KEY CLUSTERED 
(
	[Rate_ID] ASC,
	[Effective_Date] ASC,
	[Restriction_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Rate_Restriction]  WITH NOCHECK ADD  CONSTRAINT [FK_Rate_Restriction_Vehicle_Rate] FOREIGN KEY([Rate_ID], [Effective_Date])
REFERENCES [dbo].[Vehicle_Rate] ([Rate_ID], [Effective_Date])
GO
ALTER TABLE [dbo].[Rate_Restriction] NOCHECK CONSTRAINT [FK_Rate_Restriction_Vehicle_Rate]
GO
ALTER TABLE [dbo].[Rate_Restriction]  WITH CHECK ADD  CONSTRAINT [FK_Restriction1] FOREIGN KEY([Restriction_ID])
REFERENCES [dbo].[Restriction] ([Restriction_ID])
GO
ALTER TABLE [dbo].[Rate_Restriction] CHECK CONSTRAINT [FK_Restriction1]
GO

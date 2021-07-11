USE [GISData]
GO
/****** Object:  Table [dbo].[Quoted_Time_Period_Rate]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Quoted_Time_Period_Rate](
	[Quoted_Rate_ID] [int] NOT NULL,
	[Rate_Type] [char](7) NOT NULL,
	[Time_Period] [char](10) NOT NULL,
	[Time_Period_Start] [smallint] NOT NULL,
	[Time_Period_End] [smallint] NOT NULL,
	[Amount] [decimal](9, 2) NOT NULL,
	[Km_Cap] [smallint] NULL,
 CONSTRAINT [PK_Quoted_Time_Period] PRIMARY KEY CLUSTERED 
(
	[Quoted_Rate_ID] ASC,
	[Rate_Type] ASC,
	[Time_Period] ASC,
	[Time_Period_Start] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Quoted_Time_Period_Rate]  WITH CHECK ADD  CONSTRAINT [FK_Quoted_Vehicle_Rate3] FOREIGN KEY([Quoted_Rate_ID])
REFERENCES [dbo].[Quoted_Vehicle_Rate] ([Quoted_Rate_ID])
GO
ALTER TABLE [dbo].[Quoted_Time_Period_Rate] CHECK CONSTRAINT [FK_Quoted_Vehicle_Rate3]
GO
ALTER TABLE [dbo].[Quoted_Time_Period_Rate]  WITH CHECK ADD  CONSTRAINT [FK_Time_Period2] FOREIGN KEY([Time_Period])
REFERENCES [dbo].[Time_Period] ([Time_Period])
GO
ALTER TABLE [dbo].[Quoted_Time_Period_Rate] CHECK CONSTRAINT [FK_Time_Period2]
GO

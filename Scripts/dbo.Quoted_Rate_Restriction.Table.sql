USE [GISData]
GO
/****** Object:  Table [dbo].[Quoted_Rate_Restriction]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Quoted_Rate_Restriction](
	[Quoted_Rate_ID] [int] NOT NULL,
	[Restriction_ID] [smallint] NOT NULL,
	[Time_Of_Day] [char](5) NULL,
	[Number_Of_Days] [tinyint] NULL,
	[Number_Of_Hours] [tinyint] NULL,
 CONSTRAINT [PK_Quoted_Rate_Restriction] PRIMARY KEY CLUSTERED 
(
	[Quoted_Rate_ID] ASC,
	[Restriction_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Quoted_Rate_Restriction]  WITH CHECK ADD  CONSTRAINT [FK_Quoted_Vehicle_Rate2] FOREIGN KEY([Quoted_Rate_ID])
REFERENCES [dbo].[Quoted_Vehicle_Rate] ([Quoted_Rate_ID])
GO
ALTER TABLE [dbo].[Quoted_Rate_Restriction] CHECK CONSTRAINT [FK_Quoted_Vehicle_Rate2]
GO
ALTER TABLE [dbo].[Quoted_Rate_Restriction]  WITH CHECK ADD  CONSTRAINT [FK_Restriction2] FOREIGN KEY([Restriction_ID])
REFERENCES [dbo].[Restriction] ([Restriction_ID])
GO
ALTER TABLE [dbo].[Quoted_Rate_Restriction] CHECK CONSTRAINT [FK_Restriction2]
GO

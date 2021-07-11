USE [GISData]
GO
/****** Object:  Table [dbo].[Frequent_Flyer_Plan_Member]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Frequent_Flyer_Plan_Member](
	[Frequent_Flyer_Plan_ID] [smallint] NOT NULL,
	[Customer_ID] [int] NULL,
	[FF_Member_Number] [varchar](20) NOT NULL,
 CONSTRAINT [PK_Frequent_Flyer_Plan_Member] PRIMARY KEY CLUSTERED 
(
	[Frequent_Flyer_Plan_ID] ASC,
	[FF_Member_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Frequent_Flyer_Plan_Member]  WITH CHECK ADD  CONSTRAINT [FK_Customer4] FOREIGN KEY([Customer_ID])
REFERENCES [dbo].[Customer] ([Customer_ID])
GO
ALTER TABLE [dbo].[Frequent_Flyer_Plan_Member] CHECK CONSTRAINT [FK_Customer4]
GO
ALTER TABLE [dbo].[Frequent_Flyer_Plan_Member]  WITH NOCHECK ADD  CONSTRAINT [FK_Frequent_Flyer_Plan1] FOREIGN KEY([Frequent_Flyer_Plan_ID])
REFERENCES [dbo].[Frequent_Flyer_Plan] ([Frequent_Flyer_Plan_ID])
GO
ALTER TABLE [dbo].[Frequent_Flyer_Plan_Member] CHECK CONSTRAINT [FK_Frequent_Flyer_Plan1]
GO

USE [GISData]
GO
/****** Object:  Table [dbo].[Rate_Availability]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rate_Availability](
	[Rate_ID] [int] NOT NULL,
	[Effective_Date] [datetime] NOT NULL,
	[Termination_Date] [datetime] NOT NULL,
	[Valid_From] [datetime] NOT NULL,
	[Valid_To] [datetime] NULL,
 CONSTRAINT [PK_Rate_Availability] PRIMARY KEY CLUSTERED 
(
	[Rate_ID] ASC,
	[Effective_Date] ASC,
	[Valid_From] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Rate_Availability]  WITH NOCHECK ADD  CONSTRAINT [FK_Rate_Availability_Vehicle_Rate] FOREIGN KEY([Rate_ID], [Effective_Date])
REFERENCES [dbo].[Vehicle_Rate] ([Rate_ID], [Effective_Date])
GO
ALTER TABLE [dbo].[Rate_Availability] NOCHECK CONSTRAINT [FK_Rate_Availability_Vehicle_Rate]
GO

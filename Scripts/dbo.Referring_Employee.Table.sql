USE [GISData]
GO
/****** Object:  Table [dbo].[Referring_Employee]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Referring_Employee](
	[Organization_ID] [int] NOT NULL,
	[Referring_Employee_ID] [smallint] IDENTITY(1,1) NOT NULL,
	[Last_Name] [varchar](25) NOT NULL,
	[First_Name] [varchar](25) NOT NULL,
 CONSTRAINT [PK_Referring_Employee] PRIMARY KEY CLUSTERED 
(
	[Referring_Employee_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UC_Referring_Employee1] UNIQUE NONCLUSTERED 
(
	[Organization_ID] ASC,
	[Last_Name] ASC,
	[First_Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Referring_Employee]  WITH CHECK ADD  CONSTRAINT [FK_Organization3] FOREIGN KEY([Organization_ID])
REFERENCES [dbo].[Organization] ([Organization_ID])
GO
ALTER TABLE [dbo].[Referring_Employee] CHECK CONSTRAINT [FK_Organization3]
GO

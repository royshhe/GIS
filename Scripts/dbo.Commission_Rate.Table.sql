USE [GISData]
GO
/****** Object:  Table [dbo].[Commission_Rate]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Commission_Rate](
	[Commission_Rate_ID] [int] IDENTITY(1,1) NOT NULL,
	[Organization_ID] [int] NOT NULL,
	[Valid_From] [datetime] NOT NULL,
	[Valid_To] [datetime] NULL,
	[Flat_Rate] [decimal](9, 2) NULL,
	[Percentage] [decimal](5, 2) NULL,
	[Remarks] [varchar](255) NULL,
	[Per_Day] [decimal](9, 2) NULL,
 CONSTRAINT [PK_Commission_Rate] PRIMARY KEY CLUSTERED 
(
	[Commission_Rate_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UC_Commission_Rate1] UNIQUE NONCLUSTERED 
(
	[Organization_ID] ASC,
	[Valid_From] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Commission_Rate]  WITH NOCHECK ADD  CONSTRAINT [FK_Organization7] FOREIGN KEY([Organization_ID])
REFERENCES [dbo].[Organization] ([Organization_ID])
GO
ALTER TABLE [dbo].[Commission_Rate] CHECK CONSTRAINT [FK_Organization7]
GO

USE [GISData]
GO
/****** Object:  Table [dbo].[Location_Exchange_Rate]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Location_Exchange_Rate](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Location_ID] [smallint] NOT NULL,
	[Currency_ID] [tinyint] NOT NULL,
	[Valid_From] [datetime] NOT NULL,
	[Rate] [decimal](9, 4) NOT NULL,
	[Valid_To] [datetime] NULL,
	[Created_By] [varchar](20) NOT NULL,
	[Created_On] [datetime] NOT NULL,
 CONSTRAINT [PK_Location_Exchange_Rate] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UC_Location_Exchange_Rate1] UNIQUE NONCLUSTERED 
(
	[Location_ID] ASC,
	[Currency_ID] ASC,
	[Valid_From] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Location_Exchange_Rate]  WITH NOCHECK ADD  CONSTRAINT [FK_Location15] FOREIGN KEY([Location_ID])
REFERENCES [dbo].[Location] ([Location_ID])
GO
ALTER TABLE [dbo].[Location_Exchange_Rate] CHECK CONSTRAINT [FK_Location15]
GO

USE [GISData]
GO
/****** Object:  Table [dbo].[Optional_Extra_Mix]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Optional_Extra_Mix](
	[Mix_ID] [int] IDENTITY(1,1) NOT NULL,
	[Rpt_Date] [datetime] NULL,
	[Optional_Extra_ID] [int] NULL,
	[Optional_Extra] [varchar](50) NULL,
	[Current_Location_ID] [int] NULL,
	[On_Rent] [int] NULL,
	[Available] [int] NULL,
 CONSTRAINT [PK_Optional_Extra_Mix] PRIMARY KEY CLUSTERED 
(
	[Mix_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO

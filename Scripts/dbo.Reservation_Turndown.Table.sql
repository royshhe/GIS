USE [GISData]
GO
/****** Object:  Table [dbo].[Reservation_Turndown]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reservation_Turndown](
	[Created_By] [varchar](20) NOT NULL,
	[Created_On] [datetime] NOT NULL,
	[Turndown_Reason_ID] [int] NOT NULL,
	[Description] [varchar](255) NULL,
 CONSTRAINT [PK_Reservation_Turndown] PRIMARY KEY CLUSTERED 
(
	[Created_By] ASC,
	[Created_On] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO

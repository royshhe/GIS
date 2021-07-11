USE [GISData]
GO
/****** Object:  Table [dbo].[Reservation_Comment]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reservation_Comment](
	[Confirmation_Number] [int] NOT NULL,
	[Reservation_Comment_ID] [smallint] NOT NULL,
 CONSTRAINT [PK_Reservation_Comment] PRIMARY KEY CLUSTERED 
(
	[Confirmation_Number] ASC,
	[Reservation_Comment_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO

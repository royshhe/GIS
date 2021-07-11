USE [GISData]
GO
/****** Object:  Table [dbo].[Reservation_Summary]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reservation_Summary](
	[Location] [varchar](25) NOT NULL,
	[DW] [nvarchar](66) NULL,
	[confirmation_number] [int] NOT NULL
) ON [PRIMARY]
GO

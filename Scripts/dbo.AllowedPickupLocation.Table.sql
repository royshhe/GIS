USE [GISData]
GO
/****** Object:  Table [dbo].[AllowedPickupLocation]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AllowedPickupLocation](
	[IDKey] [int] IDENTITY(1,1) NOT NULL,
	[LocationID] [smallint] NOT NULL,
	[AllowedPickUPLocationID] [smallint] NOT NULL,
	[Comments] [varchar](50) NULL,
 CONSTRAINT [PK_AllowedPickupLocation] PRIMARY KEY CLUSTERED 
(
	[IDKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO

USE [GISData]
GO
/****** Object:  Table [dbo].[Credit_Card_Range]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Credit_Card_Range](
	[Credit_Card_Type_ID] [char](3) NOT NULL,
	[Lower_Bound] [int] NOT NULL,
	[Upper_Bound] [int] NOT NULL,
	[Lengths] [varchar](20) NULL,
 CONSTRAINT [PK_Credit_Card_Range] PRIMARY KEY CLUSTERED 
(
	[Credit_Card_Type_ID] ASC,
	[Lower_Bound] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Credit_Card_Range]  WITH NOCHECK ADD  CONSTRAINT [FK_Credit_Card_Type2] FOREIGN KEY([Credit_Card_Type_ID])
REFERENCES [dbo].[Credit_Card_Type] ([Credit_Card_Type_ID])
GO
ALTER TABLE [dbo].[Credit_Card_Range] CHECK CONSTRAINT [FK_Credit_Card_Type2]
GO

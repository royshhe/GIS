USE [GISData]
GO
/****** Object:  Table [dbo].[Location_Specific_Fees]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Location_Specific_Fees](
	[Spec_Fee_ID] [smallint] IDENTITY(1,1) NOT NULL,
	[Location_ID] [smallint] NOT NULL,
	[Fee_Type] [char](3) NOT NULL,
	[Fee_Description] [varchar](50) NULL,
	[Flat_Fee] [decimal](7, 2) NULL,
	[Percentage_fee] [decimal](5, 2) NULL,
	[Per_Day_fee] [decimal](7, 2) NULL,
	[GSTExempt] [bit] NULL,
	[PSTExempt] [bit] NULL,
	[GL_Number] [varchar](32) NULL,
	[Valid_From] [datetime] NOT NULL,
	[Valid_To] [datetime] NULL,
 CONSTRAINT [PK_Location_Specific_Fees] PRIMARY KEY CLUSTERED 
(
	[Spec_Fee_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Location_Specific_Fees]  WITH NOCHECK ADD  CONSTRAINT [FK_Location_Specific_Fees_Location] FOREIGN KEY([Location_ID])
REFERENCES [dbo].[Location] ([Location_ID])
GO
ALTER TABLE [dbo].[Location_Specific_Fees] CHECK CONSTRAINT [FK_Location_Specific_Fees_Location]
GO

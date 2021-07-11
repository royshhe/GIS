USE [GISData]
GO
/****** Object:  Table [dbo].[dbo_RP_Sunny_Cloudy]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dbo_RP_Sunny_Cloudy](
	[RP_date] [datetime] NULL,
	[Type] [nvarchar](50) NULL
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy', @level2type=N'COLUMN',@level2name=N'RP_date'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Caption', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy', @level2type=N'COLUMN',@level2name=N'RP_date'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy', @level2type=N'COLUMN',@level2name=N'RP_date'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy', @level2type=N'COLUMN',@level2name=N'RP_date'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy', @level2type=N'COLUMN',@level2name=N'RP_date'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DefaultValue', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy', @level2type=N'COLUMN',@level2name=N'RP_date'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy', @level2type=N'COLUMN',@level2name=N'RP_date'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Format', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy', @level2type=N'COLUMN',@level2name=N'RP_date'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy', @level2type=N'COLUMN',@level2name=N'RP_date'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentenceMode', @value=0x03 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy', @level2type=N'COLUMN',@level2name=N'RP_date'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_InputMask', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy', @level2type=N'COLUMN',@level2name=N'RP_date'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Required', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy', @level2type=N'COLUMN',@level2name=N'RP_date'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ShowDatePicker', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy', @level2type=N'COLUMN',@level2name=N'RP_date'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SmartTags', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy', @level2type=N'COLUMN',@level2name=N'RP_date'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy', @level2type=N'COLUMN',@level2name=N'RP_date'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ValidationRule', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy', @level2type=N'COLUMN',@level2name=N'RP_date'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ValidationText', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy', @level2type=N'COLUMN',@level2name=N'RP_date'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AggregateType', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy', @level2type=N'COLUMN',@level2name=N'Type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_AllowZeroLength', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy', @level2type=N'COLUMN',@level2name=N'Type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Caption', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy', @level2type=N'COLUMN',@level2name=N'Type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy', @level2type=N'COLUMN',@level2name=N'Type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy', @level2type=N'COLUMN',@level2name=N'Type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy', @level2type=N'COLUMN',@level2name=N'Type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DefaultValue', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy', @level2type=N'COLUMN',@level2name=N'Type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy', @level2type=N'COLUMN',@level2name=N'Type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=109 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy', @level2type=N'COLUMN',@level2name=N'Type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Format', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy', @level2type=N'COLUMN',@level2name=N'Type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy', @level2type=N'COLUMN',@level2name=N'Type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentenceMode', @value=0x03 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy', @level2type=N'COLUMN',@level2name=N'Type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_InputMask', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy', @level2type=N'COLUMN',@level2name=N'Type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Required', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy', @level2type=N'COLUMN',@level2name=N'Type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SmartTags', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy', @level2type=N'COLUMN',@level2name=N'Type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TextAlign', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy', @level2type=N'COLUMN',@level2name=N'Type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_UnicodeCompression', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy', @level2type=N'COLUMN',@level2name=N'Type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ValidationRule', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy', @level2type=N'COLUMN',@level2name=N'Type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ValidationText', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy', @level2type=N'COLUMN',@level2name=N'Type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DefaultView', @value=0x02 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Filter', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_FilterOnLoad', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_HideNewField', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderBy', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOn', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOnLoad', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Orientation', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TableMaxRecords', @value=10000 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TotalsRow', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ValidationRule', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ValidationText', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'dbo_RP_Sunny_Cloudy'
GO

CREATE TABLE [Master].[ConfigurationModels] (
    [Id]              INT          IDENTITY (1, 1) NOT NULL,
    [Weight]          VARCHAR (10) NULL,
    [BatteryCapacity] VARCHAR (15) NULL,
    [MemoryCapacity]  VARCHAR (15) NULL,
    [Processor]       VARCHAR (50) NULL,
    [ScreenDiagonal]  VARCHAR (29) NULL,
    [Color]           VARCHAR (20) NULL,
    CONSTRAINT [PK_Master_Сharacteristics] PRIMARY KEY CLUSTERED ([Id] ASC)
);


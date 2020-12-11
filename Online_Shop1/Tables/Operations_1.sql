CREATE TABLE [Log].[Operations] (
    [Id]            INT           IDENTITY (1, 1) NOT NULL,
    [OperationName] VARCHAR (100) NULL,
    [Description]   VARCHAR (100) NULL,
    CONSTRAINT [PK_Log_Operations] PRIMARY KEY CLUSTERED ([Id] ASC)
);


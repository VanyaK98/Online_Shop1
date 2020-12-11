CREATE TABLE [Config].[Version] (
    [Id]          INT  IDENTITY (10000, 10000) NOT NULL,
    [CreatedDate] DATE NULL,
    [RunID]       INT  NULL,
    CONSTRAINT [PK_Version] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_L_Version_OperationRuns] FOREIGN KEY ([RunID]) REFERENCES [Log].[OperationRuns] ([Id])
);


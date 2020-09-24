program ScreenThiefServer;

uses
  Forms,
  MainUnitServer in 'MainUnitServer.pas' {MainFormServer};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Screen Thief SERVER';
  Application.CreateForm(TMainFormServer, MainFormServer);
  Application.Run;
end.

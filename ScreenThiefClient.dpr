program ScreenThiefClient;

uses
  Forms,
  MainUnitClient in 'MainUnitClient.pas' {MainFormClient};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Screen Thief CLIENT';
  Application.CreateForm(TMainFormClient, MainFormClient);
  Application.Run;
end.

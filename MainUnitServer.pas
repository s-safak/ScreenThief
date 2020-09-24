unit MainUnitServer;

{

Article:

ScreenThief - stealing screen shots over the Network

http://delphi.about.com/library/weekly/aa012004a.htm

A free network screen shot grabber application,
with source code. Learn how to send / receive raw (binary)
data (screen shot JPG images) using TCP connections.
ScreenThief is a network application designed to "steal"
screen shot images from client computers and display them
in one central location (server application).

..............................................
Zarko Gajic, BSCS
About Guide to Delphi Programming
http://delphi.about.com
how to advertise: http://delphi.about.com/library/bladvertise.htm
free newsletter: http://delphi.about.com/library/blnewsletter.htm
forum: http://forums.about.com/ab-delphi/start/
..............................................
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IdTCPServer, IdSocketHandle, IdThreadMgr, IdThreadMgrDefault, IdBaseComponent,
  IdComponent, Buttons, ExtCtrls, Jpeg, ImgList, ComCtrls, ToolWin,
  IdAntiFreezeBase, IdAntiFreeze, IdStack, SyncObjs;

type
  PClient   = ^TClient;
  TClient   = record
    PeerIP      : string[15];            { Cleint IP address }
    HostName    : String[40];            { Hostname }
    TakeShot    : boolean;
    Connected,                           { Time of connect }
    LastAction  : TDateTime;             { Time of last transaction }
    Thread      : Pointer;               { Pointer to thread }
  end;

  TMainFormServer = class(TForm)
    TCPServer: TIdTCPServer;
    ThreadManager: TIdThreadMgrDefault;
    pnlMain: TPanel;
    ImageScrollBox: TScrollBox;
    Image: TImage;
    InfoLabel: TStaticText;
    pnlLeft: TPanel;
    ClientsBox: TGroupBox;
    ClientsListBox: TListBox;
    DetailsBox: TGroupBox;
    DetailsMemo: TMemo;
    ActionPanel: TPanel;
    AutoCaptureCheckBox: TCheckBox;
    SecondsCombo: TComboBox;
    GetImageNowButton: TBitBtn;
    Protocol: TMemo;
    Timer: TTimer;
    IdAntiFreeze: TIdAntiFreeze;
    procedure TCPServerConnect(AThread: TIdPeerThread);
    procedure TCPServerExecute(AThread: TIdPeerThread);
    procedure TCPServerDisconnect(AThread: TIdPeerThread);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ClientsListBoxClick(Sender: TObject);
    procedure AutoCaptureCheckBoxClick(Sender: TObject);
    procedure GetImageNowButtonClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    procedure RefreshListDisplay;
    procedure RefreshImage(const ClientDNS, ImageName : string);
  public
  end;

const
//  DefaultServerIP = '192.168.0.1';
  DefaultServerIP = '127.0.0.1';
  DefaultServerPort = 7676;

var
  MainFormServer  : TMainFormServer;
  Clients         : TThreadList;     // Holds the data of all clients

implementation
{$R *.DFM}

procedure TMainFormServer.TCPServerConnect(AThread: TIdPeerThread);
var
  NewClient: PClient;
begin
  GetMem(NewClient, SizeOf(TClient));

  NewClient.PeerIP      := AThread.Connection.Socket.Binding.PeerIP;
  NewClient.HostName    := GStack.WSGetHostByAddr(NewClient.PeerIP);
  NewClient.TakeShot    := False;
  NewClient.Connected   := Now;
  NewClient.LastAction  := NewClient.Connected;
  NewClient.Thread      := AThread;

  AThread.Data := TObject(NewClient);

  try
    Clients.LockList.Add(NewClient);
  finally
    Clients.UnlockList;
  end;

  Protocol.Lines.Add(TimeToStr(Time)+' Connection from "' + NewClient.HostName + '" on ' + NewClient.PeerIP);
  RefreshListDisplay;
end; (* TCPServer Connect *)

procedure TMainFormServer.TCPServerExecute(AThread: TIdPeerThread);
var
  Client : PClient;
  Command : string;
  Size : integer;
  PicturePathName : string;
  ftmpStream : TFileStream;
begin
  if not AThread.Terminated and AThread.Connection.Connected then
  begin
    Client := PClient(AThread.Data);
    Client.LastAction := Now;

    Command := AThread.Connection.ReadLn;
    if Command = 'CheckMe' then
    begin
      if Client.TakeShot = True then
      begin
        Client.TakeShot := False;

        AThread.Connection.WriteLn('TakeShot');

        PicturePathName := ExtractFileDir(ParamStr(0)) + '\' + Client.HostName + '_Screen.JPG';

        if FileExists (PicturePathName) then DeleteFile(PicturePathName);
        ftmpStream := TFileStream.Create(PicturePathName,fmCreate);
        Size := AThread.Connection.ReadInteger;
        AThread.Connection.ReadStream(fTmpStream,Size,False);
        FreeAndNil(fTmpStream);

        AThread.Connection.WriteLn('DONE');

        RefreshImage(Client.HostName, PicturePathName);
        ClientsListBoxClick(nil);
      end
      else
        AThread.Connection.WriteLn('DONE');
    end;
  end;
end;

procedure TMainFormServer.TCPServerDisconnect(AThread: TIdPeerThread);
var
  Client: PClient;
begin
  Client := PClient(AThread.Data);
  Protocol.Lines.Add (TimeToStr(Time)+' Disconnect from "' + Client.HostName+'"');
  try
    Clients.LockList.Remove(Client);
  finally
    Clients.UnlockList;
  end;
  FreeMem(Client);
  AThread.Data := nil;

  RefreshListDisplay;
end; (* TCPServer Disconnect *)

procedure TMainFormServer.FormCreate(Sender: TObject);
var
  Bindings: TIdSocketHandles;
begin

  //setup and start TCPServer
  Bindings := TIdSocketHandles.Create(TCPServer);
  try
    with Bindings.Add do
    begin
      IP := DefaultServerIP;
      Port := DefaultServerPort;
    end;
    try
      TCPServer.Bindings:=Bindings;
      TCPServer.Active:=True;
    except on E:Exception do
      ShowMessage(E.Message);
    end;
  finally
    Bindings.Free;
  end;
  //setup TCPServer

  //other startup settings
  Clients := TThreadList.Create;
  Clients.Duplicates := dupAccept;

  SecondsCombo.ItemIndex := 0;
  Timer.Enabled := False;
  DetailsMemo.Clear;
  InfoLabel.Caption := 'Waiting...';

  RefreshListDisplay;

  if TCPServer.Active then
  begin
    Protocol.Lines.Add('ScreenThief Server running on ' + TCPServer.Bindings[0].IP + ':' + IntToStr(TCPServer.Bindings[0].Port));
  end;
end; (* Form Create *)

procedure TMainFormServer.FormClose(Sender: TObject; var Action: TCloseAction);
var
  ClientsCount : integer;
begin
  try
    ClientsCount := Clients.LockList.Count;
  finally
    Clients.UnlockList;
  end;

  if (ClientsCount > 0) then //and (TCPServer.Active) then
    begin
      Action := caNone;
      ShowMessage('Can''t close ScreenThief while there are connected clients!');
    end
  else
  begin
    TCPServer.Active := False;
    Clients.Free;
  end;
end; (* Form Close *)

procedure TMainFormServer.RefreshListDisplay;
var
  AClient :PClient;
  i:integer;
begin
  GetImageNowButton.Enabled := False;

  ClientsListBox.Clear;
  DetailsMemo.Clear;

  with Clients.LockList do
  try
    for i := 0 to Count-1 do
    begin
      AClient := Items[i];
      ClientsListBox.AddItem(AClient.HostName,TObject(AClient));
    end;
  finally
    Clients.UnlockList;
  end;

  GetImageNowButton.Enabled := ClientsListBox.Items.Count > 0;
  AutoCaptureCheckBox.Enabled := GetImageNowButton.Enabled;
end; (* RefreshListDisplay *)

procedure TMainFormServer.ClientsListBoxClick(Sender: TObject);
var
  SelClient: PClient;
begin
    DetailsMemo.Clear;

    if ClientsListBox.ItemIndex <> -1 then
    begin
      try
        SelClient := PClient(Clients.LockList.Items[ClientsListBox.ItemIndex]);
        with DetailsMemo do
        begin
          Lines.Add('IP : ' + SelClient.PeerIP);
          Lines.Add('Host name : ' + SelClient.HostName);
          Lines.Add('Connected : ' + DateTimeToStr(SelClient.Connected));
          Lines.Add('Last shot : ' + DateTimeToStr(SelClient.LastAction));
          Lines.Add('Waiting : ' + BoolToStr(SelClient.TakeShot, True));
        end;
      finally
        Clients.UnlockList;
      end;
    end;
end; (* ClientsListBox Click *)

procedure TMainFormServer.AutoCaptureCheckBoxClick(Sender: TObject);
begin
  GetImageNowButton.Enabled := NOT AutoCaptureCheckBox.Checked;

  Timer.Interval := 1000 * StrToInt(SecondsCombo.Items[SecondsCombo.ItemIndex]);
  Timer.Enabled := AutoCaptureCheckBox.Checked;
end; (* AutoCaptureCheckBoxClick *)

procedure TMainFormServer.GetImageNowButtonClick(Sender: TObject);
var
  SelClient : PClient;
begin
  if ClientsListBox.ItemIndex = -1 then
  begin
    if Sender is TBitBtn then ShowMessage('Please select a client from the list!');
    Exit;
  end;

  try
    SelClient := PClient(Clients.LockList.Items[ClientsListBox.ItemIndex]);
    SelClient.TakeShot := True;
  finally
    Clients.UnLockList
  end;

  //refresh DetailsMemo
  ClientsListBoxClick(Sender);
end; (* GetImageNowButton Click *)

procedure TMainFormServer.RefreshImage(const ClientDNS, ImageName : string);
begin
    Image.Picture.LoadFromFile(ImageName);
    InfoLabel.Caption := 'Screen shot from: ' + ClientDNS;
end; (* RefreshImage *)

procedure TMainFormServer.TimerTimer(Sender: TObject);
begin
  Timer.Enabled := False;
  GetImageNowButtonClick(Sender);
  Timer.Enabled := True;
end; (* TimerTimer *)

end.


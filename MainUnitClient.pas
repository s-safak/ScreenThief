unit MainUnitClient;

{

Article:

ScreenThief - stealing screen shots over the Network

http://delphi.about.com/library/weekly/aa012004a.htm

A free network screen shot grabber application, with source code.
Learn how to send / receive raw (binary) data (screen shot images) using TCP connections.

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
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, StdCtrls,
  ExtCtrls, Jpeg, IdAntiFreezeBase, IdAntiFreeze;

type
  TMainFormClient = class(TForm)
    IncomingMessages: TMemo;
    ProtocolLabel: TLabel;
    TCPClient: TIdTCPClient;
    Timer: TTimer;
    IdAntiFreeze: TIdAntiFreeze;
    procedure TimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TCPClientConnected(Sender: TObject);
    procedure TCPClientDisconnected(Sender: TObject);
  private
    procedure ScreenShot(x : integer; y : integer; Width : integer; Height : integer; bm : TBitMap);
  public
  end;

const
//  DefaultServerIP = '192.168.0.1';
  DefaultServerIP = '127.0.0.1';
  DefaultServerPort = 7676;

var
  MainFormClient: TMainFormClient;

implementation

{$R *.DFM}
// convert BMP to JPEG
procedure BMPtoJPGStream(const Bitmap : TBitmap; var AStream: TMemoryStream);
var
  JpegImg: TJpegImage;
begin
   JpegImg := TJpegImage.Create;
   try
//    JpegImg.CompressionQuality := 50;
    JpegImg.PixelFormat := jf8Bit;
    JpegImg.Assign(Bitmap);
    JpegImg.SaveToStream(AStream);
   finally
    JpegImg.Free
   end;
end; (* BMPtoJPG *)


procedure TMainFormClient.TimerTimer(Sender: TObject);
var
  JpegStream : TMemoryStream;
  pic : TBitmap;
  sCommand : string;
begin
  if not TCPClient.Connected then Exit;

  Timer.Enabled := False;

  TCPClient.WriteLn('CheckMe'); //command handler
  sCommand := TCPClient.ReadLn;
  if sCommand = 'TakeShot' then
  begin
    IncomingMessages.Lines.Insert(0,'About to make a screen shot: ' + DateTimeToStr(Now));

    pic := TBitmap.Create;
    JpegStream := TMemoryStream.Create;
    ScreenShot(0,0,Screen.Width,Screen.Height,pic);
    BMPtoJPGStream(pic, JpegStream);
    pic.FreeImage;
    FreeAndNil(pic);

    IncomingMessages.Lines.Insert(0,'Sending screen shot...');

    // copy file stream to write stream
    TCPClient.WriteInteger(JpegStream.Size);
    TCPClient.OpenWriteBuffer;
    TCPClient.WriteStream(JpegStream);
    TCPClient.CloseWriteBuffer;
    FreeAndNil(JpegStream);

    //making sure!
    TCPClient.ReadLn;
  end;

  Timer.Enabled := True;
end;

procedure TMainFormClient.ScreenShot(x : integer; y : integer; Width : integer; Height : integer; bm : TBitMap);
var
  dc: HDC; lpPal : PLOGPALETTE;
begin
{test width and height}
  if ((Width = 0) OR (Height = 0)) then exit;
  bm.Width := Width;
  bm.Height := Height;
{get the screen dc}
  dc := GetDc(0);
  if (dc = 0) then exit;
{do we have a palette device?}
  if (GetDeviceCaps(dc, RASTERCAPS) AND RC_PALETTE = RC_PALETTE) then
  begin
    {allocate memory for a logical palette}
    GetMem(lpPal, sizeof(TLOGPALETTE) + (255 * sizeof(TPALETTEENTRY)));
    {zero it out to be neat}
    FillChar(lpPal^, sizeof(TLOGPALETTE) + (255 * sizeof(TPALETTEENTRY)), #0);
    {fill in the palette version}
    lpPal^.palVersion := $300;
    {grab the system palette entries}
    lpPal^.palNumEntries :=GetSystemPaletteEntries(dc,0,256,lpPal^.palPalEntry);
    if (lpPal^.PalNumEntries <> 0) then
    begin
      {create the palette}
      bm.Palette := CreatePalette(lpPal^);
    end;
    FreeMem(lpPal, sizeof(TLOGPALETTE) + (255 * sizeof(TPALETTEENTRY)));
  end;
  {copy from the screen to the bitmap}
  BitBlt(bm.Canvas.Handle,0,0,Width,Height,Dc,x,y,SRCCOPY);
  {release the screen dc}
  ReleaseDc(0, dc);
end; (* ScreenShot *)


procedure TMainFormClient.FormCreate(Sender: TObject);
begin
  IncomingMessages.Clear;

  try
    TCPClient.Host := DefaultServerIP;
    TCPClient.Port := DefaultServerPort;
    TCPClient.Connect;
  except
    on E: Exception do MessageDlg ('Error while connecting to ScreenThiefSERVER:'+#13+E.Message, mtError, [mbOk], 0);
  end;
end;

procedure TMainFormClient.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if TCPClient.Connected then TCPClient.Disconnect;
end;

procedure TMainFormClient.TCPClientConnected(Sender: TObject);
begin
  IncomingMessages.Lines.Insert(0,'Connected to Server');
end;

procedure TMainFormClient.TCPClientDisconnected(Sender: TObject);
begin
  IncomingMessages.Lines.Insert(0,'Disconnected from Server');
end;

end.

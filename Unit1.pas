unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,AmUserScale, Vcl.StdCtrls,math,AmUserType,IniFiles;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    ComboBox1: TComboBox;
    Button1: TButton;
    Label1: TLabel;
    ScrollBox1: TScrollBox;
    procedure FormAfterMonitorDpiChanged(Sender: TObject; OldDPI,
      NewDPI: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ComboBox1DropDown(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ScrollBox1MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    CounterPanel:Integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var P:TPanel;
 function LocRandomColor:TColor;
 begin
    // нет модуля AmUserType
   // Result:= Random(Integer.MaxValue); //тогда цвета могут перекрывать надписи
   Result:=AmColorConvert2.ColorRamdom(140,150,90,120);
 end;
begin

   P:=TPanel.Create(self);
   P.ParentBackground:=false;
   P.Caption:='0';
   P.Align:=alTop;
   P.Parent:=ScrollBox1;
   P.Font.Size:=AmScale.Value(10);
   P.Height:=AmScale.Value(50);
   P.Caption:='Panel№:'+CounterPanel.ToString+ '   Высота при создании:'+P.Height.ToString;
   P.Color:=LocRandomColor;
   inc(CounterPanel);
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
var Ini:TIniFile;
begin
  AmScale.SetAppFromList(ComboBox1.Text);
  Ini:=TIniFile.Create( ExtractFilePath (Application.ExeName)+'scaleApp.ini');
  try
    Ini.WriteString('scale','value',AmScale.AppScaleNow.ToString);
  finally
   Ini.Free;
  end;

end;

procedure TForm1.ComboBox1DropDown(Sender: TObject);
begin
  AmScale.GetAppToList(ComboBox1.Items);
end;

procedure TForm1.FormAfterMonitorDpiChanged(Sender: TObject; OldDPI,
  NewDPI: Integer);
begin
    AmScale.ChangeDPI(NewDPI,OldDPI);
end;

procedure TForm1.FormCreate(Sender: TObject);
var Ini:TIniFile;
begin
  Ini:=TIniFile.Create( ExtractFilePath (Application.ExeName)+ 'scaleApp.ini');
  try
    AmScale.Init(AmInt(Ini.ReadString('scale','value','100'),100));
  finally
   Ini.Free;
  end;

  CounterPanel:=0;
end;

procedure TForm1.FormShow(Sender: TObject);
begin

AmScale.Show;
AmScale.GetAppToList(ComboBox1.Items);
ComboBox1.ItemIndex:= AmScale.GetIndexFromList(ComboBox1.Items)
end;

procedure TForm1.ScrollBox1MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
   TScrollBox(Sender).VertScrollBar.Position:=
   TScrollBox(Sender).VertScrollBar.Position - (WheelDelta div 3);
   Handled:=true;
end;

end.

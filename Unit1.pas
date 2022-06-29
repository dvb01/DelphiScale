unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,Vcl.StdCtrls,math,AmUserScale,AmUserType,IniFiles;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    ComboBox1: TComboBox;
    Button1: TButton;
    Label1: TLabel;
    ScrollBox1: TScrollBox;
    Button2: TButton;
    Panel2: TPanel;
    procedure FormAfterMonitorDpiChanged(Sender: TObject; OldDPI,
      NewDPI: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ComboBox1DropDown(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ScrollBox1MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  protected
     procedure ChangeScale(M, D: Integer; isDpiChange: Boolean); override;
  public
    { Public declarations }
    CounterPanel,
    HTest:Integer;
    TestP:TPanel;
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
    TestP:=P;
    P.ParentBackground:=false;
    P.Caption:='0';
    P.Align:=alTop;
    P.Top:=-10000;
    P.Color:=LocRandomColor;
    P.Parent:= ScrollBox1;
    // только так входной size на выходе Height
    P.Font.Height:=AmScale.DinamicValueFontHeight(10);
    P.Height:=AmScale.DinamicValue(50);
    P.Caption:='Panel№:'+CounterPanel.ToString+ '   H:'+P.Height.ToString +' F:'+P.Font.Size.ToString;

   inc(CounterPanel);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  //HTest посто перемнная хранит отдельно высоту TestP
  //  HTest измененяется на автомате в  TForm1.ChangeScale
  Showmessage(HTest.ToString+' ' +TestP.Height.ToString +' ' +TestP.font.Size.ToString);
end;

procedure TForm1.ChangeScale(M, D: Integer; isDpiChange: Boolean);
begin
  inherited;
  HTest:= AmScale.ChangeScaleValue(HTest,M, D);

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
    AmScale.AfterMonitorDpiChanged(NewDPI,OldDPI);
    HTest:= AmScale.ChangeScaleValue(HTest,NewDPI, OldDPI);
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
  HTest:=  AmScale.DinamicValue(50);
  CounterPanel:=0;
  Button1Click(self);

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

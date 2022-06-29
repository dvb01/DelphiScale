unit AmUserScale;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,AmUserType,Math;
 type
  TAmPosControl = record
    L,//left
    T,//top
    W,//������
    H,//������
    F:Integer;//TFont.Size
    procedure Clear;
  end;

  AmScale = class
    private
      class procedure SetScaleAppCustom(New,Old:integer);
    public
     //������ ��������  ������� �� ���������
     //  AppScaleDesing ��������� ��������� � 100 ��� �������� ����� � �� �����
     //  WinScaleDPIDesing ��������� ��������� � 96 ��� �������� ����� ��� ����� WinApi.Windows.USER_DEFAULT_SCREEN_DPI  � �� �����
     // ��� �������� ����� ��������� ����� AmScale.Init;

     //���� �� �������������� ����� � � ��� �� ����� ���������� ������ 120 �� ��� � ���������� �� ��������� � WinScaleDPIDesing
     // ���� � ��� ������ ���������� ������ 96 �� ������ ������������� �� ����� �� initialization �  AmScale.Init;

      class var AppScaleDesing:Integer; //  ����� ������ ��� �� ����� ����������
      class var AppScaleNow:Integer;    //����� ������ ������ � ����������
      class var WinScaleDPIDesing:Integer; //����� ���������� ������ ������� ���  �� ����� ����������
      class var WinScaleDPINow:Integer; //����� ���������� ������ ������� ������ � ����������
      class var IsInit:boolean;     //Init ���� ���������
      class var IsShow:boolean;     //Show ���� ���������
      class var IsShowning:boolean; // ������ ����������� Show
      class var IsAppScaled:boolean; // ������ ����������� SetScaleAppCustom
      class var IsWinScaled:boolean; // ������ ����������� WinScaled ���� 2 ������� �� ����� � ��� ����������� FormAfterMonitorDpiChanged FormBeforeMonitorDpiChanged

      // ��� �������� ������� ����� ��������� Init
      // ����� �������� �������� ������������ ������� ���������� �������� � ����� �� ���� ������
      // ��� ������� �� 30 �� 200 ������ ��� 100 ��������� �� ������� ���������� �� ����� ����������
      class procedure Init(ASavedProcent:Integer=100);

      // � �������� FormShow ��������� Show
      class procedure Show;
      //  ��������� � ������� ������� ����� FormBeforeMonitorDpiChanged
      // ��������� ����� � ������� ��������� �������� ������
      class procedure BeforeMonitorDpiChanged(NewDPI,OldDPI:integer);
      //  ��������� � ������� ������� ����� FormAfterMonitorDpiChanged
      // ��������� ����� � ������� ��������� �������� ������
      class procedure AfterMonitorDpiChanged(NewDPI,OldDPI:integer);

      //.............................................................
      // Dinamic ������������ ��� ����������� ����������� ���������
      // ������� �������� ���������� parent � ����� value
      // �������� ����� �������� ������� ��� ����� val �������� ���� ��������
      // ���� ������ ��  P:=Tpanel.create(self); P.height:=  AmScale.DinamicValue(88);
      class function DinamicValue(val:integer):integer; static;
      //��� font.Height := AmScale.DinamicValueFontSize(10);
      // ���������� ������� ������ ��� font.Height c ������� ����������  Font.Size
      // �.� ��� ��������� � ����������  ����������  ��������� ��������  Font.Size  � ������� Font.Size �  font.Height
      class function DinamicValueFontHeight(FontSize:integer):integer; static;
     // .........................................................


      // value � ��������� �������
      class function DinamicValueNoRound(val:Double):Double; static;

      // ���� �� ������������ ��� ������� �������� DinamicValue
      // �� �� �������� �������� �������� �������
      // DinamicScaleApp ��� ������ ����������
      // DinamicScaleWin ���������� ������
      class procedure DinamicScaleApp(Control:TWinControl); static;
      class procedure DinamicScaleWin(Control:TWinControl); static;

       // ��� �� font �� ��� �������� ����� ��� ��������������
      class function DinamicValueFontSizeCorrect(val:integer):integer; static;

      // ����������� font ��� �������� �������
      class function FontSizeToHeight(val:integer):integer; static;
      class function FontHeightToSize(val:integer):integer; static;
      // ChangeScaleValue
      // ���� ������ ����� � ���� ��������� �������� ���� ����� �� ����������
      // ������� �� ���������� ��� ��������� ������� ���� � ����� ������ ��� ��������
      // �������� ����� ���������� ������ ������� �������� � ������� ��� ����� ��������� ������ ���� ��������� ����� �����
      // � ���� ������ � ���� �������� ����� � protected ����������� ���������
      {
        protected
             procedure ChangeScale(M, D: Integer; isDpiChange: Boolean); override;
      }
      // � ��������� ����� ��������
      {
        inherited;
        HTest:= AmScale.ChangeScaleValue(HTest,M, D);
      }
      class function ChangeScaleValue(valOld:integer;M, D: Integer):integer; static;


      // ���� ����� �������� ������ ����� ����������  SetScaleApp(120,100) ���������� �� 20%
      class procedure SetScaleApp(New:integer;Old:integer=0);

      // �������� ������ ��� ����� ��������� �������� ����������
      class procedure GetAppToList(L:TStrings);

      // � ��� ���� �������� �� �� ������ ����� ��� � ������  = �������
      class function GetIndexFromList(L:TStrings;value:integer=0):integer;

      // �������� �������� � ������ ������� ����  �������� � GetAppToList
      class function GetValueFromStr(S:String):integer;
      // �������� ������ ����� ���� ������ ����� �������� �� ������
      class procedure SetAppFromListInt(New:Integer);
      //�������� ���� ����� �� ������ ����������� � GetAppToList
      class procedure SetAppFromList(S:String);
  end;

  function UserMainScale(val:integer):integer;
  function AmScaleV(ValuePosition:integer):integer;
  function AmScaleF(FontSize:integer):integer;
{
  ��� ������ �������� ����� ��� �� ������ ����� �������� ��������

  �������� ������ ������ � ������������ �� ���� create ������� �������� � UserMainScaleGetConst

 ���
 Width_now ��� ������ ����� ����� ������ �����������
 Width_debag ��� ������ ����� �� ����� ����������
 � ����� �������� ������� ��������� , �.� ������
USER_MAIN_SCALE_CREATE:= UserMainScaleGetConst(MyForm.Width,500);
USER_MAIN_SCALE_CREATE ������ ������� ������ ������� 125.67 �� ������ 100

����� ���� ������� ���������� ������������ �� ��������� ������ � ������ � ������� ���
P:=Tpanel.create(self);
P.parent:=self;
P.height:=  UserMainScale(88);  //���� ������ �� ������ ���  P.height:=  88;
P.font.size:=  UserMainScale(10);


  ��������� ��������� �� ������������� �������� ��������
  ����� TWinControl.Create
  � �� ���������� Parent
  ����� ������� �������� ����� ������ �.�
  P:=TPanel.Create(self);
  P.ParentFont:=false;
  P.parent:=self;
  ����� ���������  Parent
  P.height:=  UserMainScale(88);
  P.Font.Height := AmScale.DinamicValueFontHeight(8); 8 ��� Forn.Size
}

implementation
 type
 TLocContrrol =class(TControl);

procedure TAmPosControl.Clear;
begin
   AmRecordHlp.RecFinal(self);
end;





{ AmScale }
function UserMainScale(val:integer):integer;
begin
   Result:=AmScale.DinamicValue(val);
end;
function AmScaleV(ValuePosition:integer):integer;
begin
   Result:=AmScale.DinamicValue(ValuePosition);
end;
function AmScaleF(FontSize:integer):integer;
begin
  Result:=AmScale.DinamicValueFontHeight(FontSize);
end;
class procedure AmScale.GetAppToList(L: TStrings);
begin
    L.Clear;
    if not IsInit then exit;
   // L.Add('50 %');
    L.Add('75 %');
   // L.Add('85 %');
    L.Add('100 % (������������)');
   // L.Add('115 %');
    L.Add('125 %');
    L.Add('150 %');
    L.Add('175 %');
    L.Add('200 %');
end;
class function AmScale.GetIndexFromList(L: TStrings; value: integer=0): integer;
begin
    Result:=-1;
    if not IsInit then exit;
    if value<30 then
    value:= AppScaleNow;
    for Result := 0 to L.Count-1 do
    if GetValueFromStr(L[Result]) = value then exit;
    Result:=-1;
end;

class function AmScale.GetValueFromStr(S: String): integer;
var tok:integer;
begin
    Result:=0;
    if not IsInit then exit;
    tok:=  pos(' ',S);
    if (tok<>1) and (tok<>0) then
    begin
       S:=s.Split([' '])[0];
       TryStrToInt(S,Result);
    end;
end;

class procedure AmScale.SetAppFromList(S: String);
begin
    if not IsInit then exit;
    SetAppFromListInt(GetValueFromStr(S));
end;
class procedure AmScale.SetAppFromListInt(New: Integer);
begin
   if not IsInit then exit;
   SetScaleApp(New,AppScaleNow);
end;

class procedure AmScale.SetScaleApp(New:integer;Old:integer=0);
begin
   if not IsInit then exit;
   if New<30 then exit;
   if Old<30 then
   Old:= AppScaleNow;
   if Old<30 then exit;

   if New<>AppScaleNow then
   begin
       AppScaleNow:= New;
       SetScaleAppCustom(New,Old);
   end;
end;
class procedure AmScale.SetScaleAppCustom(New, Old: integer);
var i:integer;
begin
    if IsAppScaled then exit;    
    IsAppScaled:=true;
    try
     for  I := 0 to Screen.FormCount-1 do
     Screen.Forms[i].ScaleBy(New,Old);
    finally
       IsAppScaled:=false;
    end;
end;

class procedure AmScale.Show;
begin
    if not IsInit then exit;

    if not IsShow then
    begin
      IsShow:=true;
      if IsShowning then exit;
      
      IsShowning:=true;
      try

         SetScaleAppCustom(AppScaleNow,AppScaleDesing);
      finally
         IsShowning:=false;
      end;

    end;


end;

class procedure AmScale.BeforeMonitorDpiChanged(NewDPI,OldDPI:integer);
begin
  IsWinScaled:=true;
  WinScaleDPINow:= NewDPI;
end;
class procedure AmScale.AfterMonitorDpiChanged(NewDPI, OldDPI: integer);
begin
   WinScaleDPINow:= NewDPI;
   IsWinScaled:=false;
end;
class procedure AmScale.Init(ASavedProcent:Integer=100);
var LMonitor:TMonitor;
    LForm: TForm;
    LPlacement: TWindowPlacement;
begin
      if ASavedProcent<=30 then
      ASavedProcent:=100;
      if ASavedProcent<30 then  ASavedProcent:=30;
      if ASavedProcent>300 then  ASavedProcent:=300;

      AppScaleDesing:=100;
      AppScaleNow:=ASavedProcent;



      WinScaleDPINow:=USER_DEFAULT_SCREEN_DPI;
      WinScaleDPIDesing:=USER_DEFAULT_SCREEN_DPI;

      if (Application<>nil) and (Screen<>nil) then
      begin
        LMonitor := Screen.MonitorFromWindow(Application.Handle);
        if LMonitor <> nil then
          WinScaleDPINow := LMonitor.PixelsPerInch
        else
         WinScaleDPINow := Screen.PixelsPerInch;
         {
        LForm := Application.MainForm;
        if (LForm <> nil)  then
        WinScaleDPIDesing := LForm.PixelsPerInch;
        }


      end
      else if (Screen<>nil) and (Mouse<>nil) then
      begin
        LMonitor := Screen.MonitorFromPoint(Mouse.CursorPos);
        if LMonitor <> nil then
          WinScaleDPINow := LMonitor.PixelsPerInch
        else
         WinScaleDPINow := Screen.PixelsPerInch;
         {
        LForm := Application.MainForm;
        if (LForm <> nil)  then
        WinScaleDPIDesing := LForm.PixelsPerInch;
        }
      end;


      IsInit:=true;

      //ScaleForPPI(GetParentCurrentDpi);

end;

class function AmScale.DinamicValue(val: integer): integer;
begin
    Result:= val;
    if not IsInit then exit;

    if  (WinScaleDPINow<>WinScaleDPIDesing) then
    Result:=MulDiv(Result,WinScaleDPINow,WinScaleDPIDesing);

    if IsShow and (AppScaleNow<>AppScaleDesing) then
    Result:=MulDiv(Result,AppScaleNow,AppScaleDesing);
end;
class function AmScale.DinamicValueNoRound(val:Double):Double;
begin
    Result:= val;
    if not IsInit then exit;
    if  (WinScaleDPINow<>WinScaleDPIDesing) then
    Result:=Result*WinScaleDPINow/WinScaleDPIDesing;

    if IsShow and (AppScaleNow<>AppScaleDesing) then
    Result:=Result*AppScaleNow/AppScaleDesing;
end;

class procedure AmScale.DinamicScaleWin(Control: TWinControl);
begin
   if not IsInit then exit;
   if (Control.Parent<>nil) and (WinScaleDPINow<>WinScaleDPIDesing)  then
   Control.ScaleBy(WinScaleDPINow,WinScaleDPIDesing);
end;
class procedure AmScale.DinamicScaleApp(Control: TWinControl);
begin
    if not IsInit then exit;
    if IsShow and (AppScaleNow<>AppScaleDesing) then
    Control.ScaleBy(AppScaleNow,AppScaleDesing);
end;
class function AmScale.DinamicValueFontHeight(FontSize: integer): integer;
var D,N:integer;
r:real;
begin
    if not IsInit then
    begin
        Result:=FontSizeToHeight(FontSize);
        exit;
    end;
    D:=WinScaleDPIDesing;

    D:=WinScaleDPIDesing;
    N:=WinScaleDPINow;
    Result:=-MulDiv(FontSize, D ,72); // convert Font.Size to Font.Height

    if  (N<>D) then
    Result:=MulDiv(Result,N,D);

    if IsShow and (AppScaleNow<>AppScaleDesing) then
    begin
       Result:=MulDiv(Result,AppScaleNow,AppScaleDesing);
     //  Result := -MulDiv(Result, 72, Screen.PixelsPerInch);
      // Result:=-MulDiv(val, Screen.PixelsPerInch ,72);
      // Result:=MulDiv(Result,AppScaleNow,AppScaleDesing);
      //Result:=-20;
    end ;

   // Result := -MulDiv(Result, 72, Screen.PixelsPerInch);// convert  Font.Height To Font.Size � ������ ������� ��� ������� ���������

   // D:=-MulDiv(Result, Screen.PixelsPerInch, 72);
  //  r:=-(val*Screen.PixelsPerInch/72); // convert Font.Size to Font.Height
  //  r:=SimpleRoundTo(r,0);
  //  r:=DinamicValueNoRound(r);
  //  r:=SimpleRoundTo(r,0);
  //  Result:=Round(r);
  //  Result:= -MulDiv(Result, 72, Screen.PixelsPerInch);
   // r := -(r*72/Screen.PixelsPerInch);// convert  Font.Height To Font.Size � ������ ������� ��� ������� ���������
   // Result := Round( SimpleRoundTo(r,0) );
    {
    D:=WinScaleDPIDesing;
    Result:=-MulDiv(val, D ,72); // convert Font.Size to Font.Height
    Result:=DinamicValue(Result);
    Result := -MulDiv(Result, 72, Screen.PixelsPerInch);// convert  Font.Height To Font.Size � ������ ������� ��� ������� ���������

     }
end;

class function  AmScale.DinamicValueFontSizeCorrect(val:integer):integer;
var D:integer;
begin
    D:=WinScaleDPIDesing;
    Result:=-MulDiv(val, D ,72); // convert Font.Size to Font.Height
    Result := -MulDiv(Result, 72, Screen.PixelsPerInch);// convert  Font.Height To Font.Size � ������ ������� ��� ������� ���������

end;
class function AmScale.ChangeScaleValue(valOld:integer;M, D: Integer):integer;
begin
    if not IsInit then exit(valOld);
    result:=MulDiv(valOld, M, D);
end;

 class function AmScale.FontHeightToSize(val: integer): integer;
begin
  Result:=-MulDiv(Result, 72, Screen.PixelsPerInch);// convert  Font.Height To Font.Size
end;
class function AmScale.FontSizeToHeight(val: integer): integer;
begin
    Result:=-MulDiv(val, Screen.PixelsPerInch ,72); // convert Font.Size to Font.Height
end;



{
class procedure AmScale.Start(Width_now, Width_debag: real);
begin

     USER_SCALE:=100;
   if Width_debag=0 then exit;
   USER_SCALE:=(Width_now/Width_debag)*100;

 c:=TMonitor.Create;
 c.PixelsPerInch

end;}
initialization
begin

   AmScale.AppScaleDesing:=100;
   AmScale.AppScaleNow:=100;
   AmScale.WinScaleDPIDesing:= WinApi.Windows.USER_DEFAULT_SCREEN_DPI;
   AmScale.WinScaleDPINow:=    WinApi.Windows.USER_DEFAULT_SCREEN_DPI;
   AmScale.IsInit:=false;
   AmScale.IsShow:=false;
   AmScale.IsShowning:=false;
   AmScale.IsAppScaled:=false;
   AmScale.IsWinScaled:=false;
end;
end.




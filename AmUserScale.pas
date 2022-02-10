unit AmUserScale;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

//type
  type
  AmScale = class
    private
      class procedure SetScaleAppCustom(New,Old:integer);
    public
     //хранит значение  маштаба по умолчанию
     //  AppScaleDesing рекомедую выстовить в 100 при создании формы а не здесь
     //  WinScaleDPIDesing рекомедую выстовить в 96 при создании формы что равно WinApi.Windows.USER_DEFAULT_SCREEN_DPI  а не здесь
     // эти значения нужно выставить после AmScale.Init;
     
     //если вы разрабатываете прогу и у вас на компе глобальный маштаб 120 то его и установите по умолчанию в WinScaleDPIDesing
     // если у вас всегда глобальный маштаб 96 то ничего устанавливать не нужно см initialization и AmScale.Init

      class var AppScaleDesing:Integer; //  какой маштаб был на этапе разработки
      class var AppScaleNow:Integer;    //какой маштаб сейчас в приложении
      class var WinScaleDPIDesing:Integer; //какой глобальный маштаб системы был  на этапе разработки
      class var WinScaleDPINow:Integer; //какой глобальный маштаб системы сейчас в приложении
      class var IsShow:boolean;
      // при создании главной формы запустить Init
      // можно передать параметр сохраненного маштаба приложения например с какой то базы данных
      // это процент от 30 до 200 обычно это 100 процентов от размера приложения на этапе разработки
      class procedure Init(ASavedProcent:Integer=100);

      // в собыитии FormShow запустить Show
      class procedure Show;
      //  запустить в событии главной формы FormAfterMonitorDpiChanged
      // проиходит когда в системе глобально меняется маштаб
      class procedure ChangeDPI(NewDPI,OldDPI:integer);

      // получить новое значение размера для числа val смотрите ниже описание
      // если кратко то  P:=Tpanel.create(self); P.height:=  AmScale.Value(88);
      class function Value(val:integer):integer; static;
      
      
      // ChangeScaleValue
      // есть случаи когда в вами написаном контроле есть какие то переменные
      // которые не изменяются при изменении маштаба хотя в вашей логике это заложено
      // например некая переменная ширины другого контрола в текущем или какая константа высоты всех элементов скрол бокса
      // в этот случаи в этот контроле нужно в protected перегрузить процедуру
      {
        protected
             procedure ChangeScale(M, D: Integer; isDpiChange: Boolean); override;
      }
      // и посчитать новое значение
      {
        inherited;
        HTest:= AmScale.ChangeScaleValue(HTest,M, D);
      }
      class function ChangeScaleValue(valOld:integer;M, D: Integer):integer; static;
      
      // если хотим поменять мастаб всего приложения  SetScaleApp(120,100) увеличится на 20%
      class procedure SetScaleApp(New,Old:integer);

      // получить список для юзера возможных маштабов приложения
      class procedure GetAppToList(L:TStrings);

      // у вас есть значение но не знаете индек его в списке  = найдите
      class function GetIndexFromList(L:TStrings;value:integer=0):integer;

      // получить значение с строки которая была  получена в GetAppToList
      class function GetValueFromStr(S:String):integer;
      // изменить маштаб когда юзер выбрал новое значение из списка
      class procedure SetAppFromListInt(New:Integer);
      //передать одну линию со списка полученного в GetAppToList
      class procedure SetAppFromList(S:String);
  end;

  function UserMainScale(val:integer):integer;

{
  ЭТО СТАРОЕ ОПИСАНИЕ СМЫСЛ ТОТ ЖЕ просто имена процедур изменены

  получает маштаб экрана у пользователя на форм create занести значение в UserMainScaleGetConst

 где
 Width_now это ширина формы когда програ запускается
 Width_debag это ширина формы на этапе разработки
 в ответ приходит процент изменения , т.е маштаб
USER_MAIN_SCALE_CREATE:= UserMainScaleGetConst(MyForm.Width,500);
USER_MAIN_SCALE_CREATE хранит текуший маштаб наример 125.67 но обычно 100

далее если создаем компоненты диначимичеки то указываем ширину и высоту и отступы как
P:=Tpanel.create(self);
P.parent:=self;
P.height:=  UserMainScale(88);  //хотя раньше бы писали как  P.height:=  88;
P.font.size:=  UserMainScale(10);


  небольшое замечание по динамическому созданию котролов
  после TWinControl.Create
  и до уставновки Parent
  нужно ставить значения высот обычно т.е
  P.height:=  88;
  P.parent:=self;
  после установки  Parent
  P.height:=  UserMainScale(88);
}

implementation



{ AmScale }
function UserMainScale(val:integer):integer;
begin
   Result:=AmScale.Value(val);
end;
class procedure AmScale.GetAppToList(L: TStrings);
begin
    L.Clear;
    L.Add('70 %');
    L.Add('80 %');
    L.Add('90 %');
    L.Add('95 %');
    L.Add('100 % (рекомедуется)');
    L.Add('110 %');
    L.Add('120 %');
    L.Add('130 %');
    L.Add('140 %');
    L.Add('150 %');
    L.Add('175 %');
    L.Add('200 %');
end;
class function AmScale.GetIndexFromList(L: TStrings; value: integer=0): integer;
begin
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
    tok:=  pos(' ',S);
    if (tok<>1) and (tok<>0) then
    begin
       S:=s.Split([' '])[0];
       TryStrToInt(S,Result);
    end;
end;

class procedure AmScale.SetAppFromList(S: String);
begin
    SetAppFromListInt(GetValueFromStr(S));
end;
class procedure AmScale.SetAppFromListInt(New: Integer);
begin
   SetScaleApp(New,AppScaleNow);
end;

class procedure AmScale.SetScaleApp(New,Old:integer);
begin
   if New<30 then exit;
   if Old<30 then
   Old:= AppScaleNow;
   if Old<30 then exit;

   if New<>AppScaleNow then
   begin
       SetScaleAppCustom(New,AppScaleNow);
       AppScaleNow:= New;
   end;
end;
class procedure AmScale.SetScaleAppCustom(New, Old: integer);
var i:integer;
begin
     for  I := 0 to Screen.FormCount-1 do
     Screen.Forms[i].ScaleBy(New,Old);
end;

class procedure AmScale.Show;
begin
    SetScaleAppCustom(AppScaleNow,AppScaleDesing);
    IsShow:=true;
end;

class procedure AmScale.ChangeDPI(NewDPI,OldDPI:integer);
begin
  WinScaleDPINow:= NewDPI;
end;
class procedure AmScale.Init(ASavedProcent:Integer=100);
var LMonitor:TMonitor;
    LForm: TForm;
    LPlacement: TWindowPlacement;
begin
      if ASavedProcent<=0 then
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
           



      //ScaleForPPI(GetParentCurrentDpi);

end;

class function AmScale.Value(val: integer): integer;
begin
  // result:=Round( Value(Real(val)) );
    // сначало маштаб системы потом маштаб приложения
    result:=MulDiv(val, WinScaleDPINow, WinScaleDPIDesing);
   if IsShow then 
    result:=MulDiv(result, AppScaleNow, AppScaleDesing);
end;
class function AmScale.ChangeScaleValue(valOld:integer;M, D: Integer):integer;
begin
    result:=MulDiv(valOld, M, D);
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
   AmScale.IsShow:=false;
   AmScale.AppScaleDesing:=100;
   AmScale.AppScaleNow:=100;
   AmScale.WinScaleDPIDesing:= WinApi.Windows.USER_DEFAULT_SCREEN_DPI;
   AmScale.WinScaleDPINow:=    WinApi.Windows.USER_DEFAULT_SCREEN_DPI;
end;
end.

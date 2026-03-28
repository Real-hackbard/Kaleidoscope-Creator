unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls;

type
  TForm2 = class(TForm)
    Image1: TImage;
    StatusBar1: TStatusBar;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses Unit1;

{$R *.dfm}

procedure TForm2.FormShow(Sender: TObject);
begin
  Form2.ClientHeight := Form1.SpinEdit1.Value + 20;
  Form2.ClientWidth := Form1.SpinEdit1.Value;
  Image1.Height := Form1.SpinEdit1.Value;
  Image1.Width := Form1.SpinEdit1.Value;

  Image1.Picture.Bitmap.Assign(Form1.Image4.Picture.Bitmap);

  case Form1.auswahl1.ItemIndex of
  0 : StatusBar1.SimpleText := 'Square - Rotation : ' + IntToStr(Form1.SpinEdit1.Value)+'x'+IntToStr(Form1.SpinEdit1.Value);
  1 : StatusBar1.SimpleText := 'Square - Rotation II : ' + IntToStr(Form1.SpinEdit1.Value)+'x'+IntToStr(Form1.SpinEdit1.Value);
  2 : StatusBar1.SimpleText := 'Square - Reflection : ' + IntToStr(Form1.SpinEdit1.Value)+'x'+IntToStr(Form1.SpinEdit1.Value);
  3 : StatusBar1.SimpleText := 'Square - Reflection II : ' + IntToStr(Form1.SpinEdit1.Value)+'x'+IntToStr(Form1.SpinEdit1.Value);
  4 : StatusBar1.SimpleText := 'Triangle - Reflection : ' + IntToStr(Form1.SpinEdit1.Value)+'x'+IntToStr(Form1.SpinEdit1.Value);
  5 : StatusBar1.SimpleText := 'Triangle - Rotation : ' + IntToStr(Form1.SpinEdit1.Value)+'x'+IntToStr(Form1.SpinEdit1.Value);
  end;
end;

end.

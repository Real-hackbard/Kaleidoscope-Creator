unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ComCtrls, Vcl.Shell.ShellCtrls, System.Math, Jpeg, PngImage, GIFImg,
  Vcl.ExtDlgs, Vcl.StdCtrls, Vcl.Samples.Spin, Vcl.ExtCtrls, Vcl.Buttons;

type
  TForm1 = class(TForm)
    OpenPicutreDialog1: TOpenPictureDialog;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel1: TPanel;
    auswahl1: TRadioGroup;
    auswahl2: TRadioGroup;
    SaveDialog1: TSaveDialog;
    RadioGroup1: TRadioGroup;
    StatusBar1: TStatusBar;
    ScrollBox1: TScrollBox;
    Image3: TImage;
    Image2: TImage;
    Image1: TImage;
    PaintBox2: TPaintBox;
    SpinEdit1: TSpinEdit;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Label1: TLabel;
    Button1: TButton;
    Panel5: TPanel;
    Image4: TImage;
    Button2: TButton;
    Button3: TButton;
    PaintBox1: TPaintBox;
    GroupBox1: TGroupBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure PaintBox2Paint(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure PB3MDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PB3MMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PB3MUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure auswahl2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image4MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CheckBox1Click(Sender: TObject);
    procedure Label4MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Schritt : integer;
    dreieck:integer;
  end;

var
  Form1: TForm1;
  xk,yk,xzie,yzie:integer;
  kaziehen : boolean;

implementation

uses Unit2;

{$R *.DFM}
{$R-}
function MainDir : string;
begin
  Result := ExtractFilePath(ParamStr(0));
end;

procedure ConvertBMP2GIF;
var
  bmp: TBitmap;
  gif: TGIFImage;
begin
  gif := TGifImage.Create;
  try
    bmp := TBitmap.Create;
    try
      bmp.LoadFromFile(MainDir + 'Data\Backup\_bmp');

      if Form1.CheckBox2.Checked = true then begin
        gif.Transparent := true;
      end;

      gif.Assign(bmp);
    finally
      bmp.Free;
    end;
    gif.SaveToFile(Form1.SaveDialog1.FileName + '.gif');
  finally
    gif.Free;
  end;
end;

procedure BitmapFileToPNG(const Source, Dest: String);
var
  Bitmap: TBitmap;
  PNG: TPNGObject;
begin
  Bitmap := TBitmap.Create;
  PNG := TPNGObject.Create;
  try
    Bitmap.LoadFromFile(Source);
    PNG.Assign(Bitmap);

    if Form1.CheckBox2.Checked = true then begin
      PNG.TransparentColor := clBlack;
      PNG.Transparent := true;
    end;

    if Form1.CheckBox3.Checked = true then begin
      PNG.CompressionLevel := 9;
    end;

    PNG.SaveToFile(Dest);
  finally
    Bitmap.Free;
    PNG.Free;
  end
end;

procedure Bmp2Jpeg(const BmpFileName, JpgFileName: string);
var
  Bmp: TBitmap;
  Jpg: TJPEGImage;
begin
  Bmp := TBitmap.Create;
  Jpg := TJPEGImage.Create;
  try
    Bmp.LoadFromFile(BmpFileName);
    Jpg.Assign(Bmp);

    if Form1.CheckBox2.Checked = true then begin
      Jpg.Transparent := true;
    end;

    if Form1.CheckBox3.Checked = true then begin
      Jpg.CompressionQuality := 100;
      Jpg.Compress;
    end;

    Jpg.SaveToFile(JpgFileName);
  finally
    Jpg.Free;
    Bmp.Free;
  end;
end;

procedure StretchGraphic(const src, dest: TGraphic;
  DestWidth, DestHeight: integer; Smooth: Boolean = true);
var
  temp, aCopy: TBitmap;
  faktor: double;
begin
  Assert(Assigned(src) and Assigned(dest));
  if (src.Width = 0) or (src.Height = 0) then
    raise Exception.CreateFmt('Invalid source dimensions: %d x %d',[src.Width, src.Height]);
  if src.Width > DestWidth then
    begin
      faktor := DestWidth / src.Width;
      if (src.Height * faktor) > DestHeight then
        faktor := DestHeight / src.Height;
    end
  else
    begin
      faktor := DestHeight / src.Height;
      if (src.Width * faktor) > DestWidth then
        faktor := DestWidth / src.Width;
    end;
  try
    aCopy := TBitmap.Create;
    try
      aCopy.PixelFormat := pf24Bit;
      aCopy.Assign(src);
      temp := TBitmap.Create;
      try
        temp.Width := round(src.Width * faktor);
        temp.Height := round(src.Height * faktor);
        if Smooth then
          SetStretchBltMode(temp.Canvas.Handle, HALFTONE);
        StretchBlt(temp.Canvas.Handle, 0, 0, temp.Width, temp.Height,
          aCopy.Canvas.Handle, 0, 0, aCopy.Width, aCopy.Height, SRCCOPY);
        dest.Assign(temp);
      finally
        temp.Free;
      end;
    finally
      aCopy.Free;
    end;
  except
    on E: Exception do
      MessageBox(0, PChar(E.Message), nil, MB_OK or MB_ICONERROR);
  end;
end;

procedure ImageGrayScale(var AnImage: TImage);
var
  JPGImage: TJPEGImage;
  BMPImage: TBitmap;
  MemStream: TMemoryStream;
begin
  BMPImage := TBitmap.Create;
  try
    BMPImage.Width  := AnImage.Picture.Bitmap.Width;
    BMPImage.Height := AnImage.Picture.Bitmap.Height;
    JPGImage := TJPEGImage.Create;
    try
      JPGImage.Assign(AnImage.Picture.Bitmap);
      JPGImage.CompressionQuality := 100;
      JPGImage.Compress;
      JPGImage.Grayscale := True;
      BMPImage.Canvas.Draw(0, 0, JPGImage);
      MemStream := TMemoryStream.Create;
      try
        BMPImage.SaveToStream(MemStream);
        MemStream.Position := 0;
        AnImage.Picture.Bitmap.LoadFromStream(MemStream);
        AnImage.Refresh;
      finally
        MemStream.Free;
      end;
    finally
      JPGImage.Free;
    end;
  finally
    BMPImage.Free;
  end;
end;

function InvertBitmap(MyBitmap: TBitmap): TBitmap;
var
  x, y: Integer;
  ByteArray: PByteArray;
begin
  MyBitmap.PixelFormat := pf24Bit;
  for y := 0 to MyBitmap.Height - 1 do
  begin
    ByteArray := MyBitmap.ScanLine[y];
    for x := 0 to MyBitmap.Width * 3 - 1 do
    begin
      ByteArray[x] := 255 - ByteArray[x];
    end;
  end;
  Result := MyBitmap;
end;

procedure puzzlejpgladen(const kk:string;image:timage);
var
  r :TResourceStream;
  j :TJpegImage;
begin
    r := TResourceStream.Create(hinstance, kk, 'Jpeg');
    j := TJpegImage.Create;
    try
      j.LoadFromStream(r);
      Image.Picture.Bitmap.Assign(j);
    finally
      j.Free;
      r.Free;
    end;
end;

procedure TForm1.PaintBox2Paint(Sender: TObject);
var
  bitmap, bmp :TBitmap;
  zrect, qrect : trect;
begin
    zrect.left:=0;
    zrect.top:=0;
    //zrect.right := 480;
    //zrect.bottom := 360;
    zrect.right := Image3.Width;
    zrect.bottom := Image3.Height;
    qrect := zrect;

    bitmap:= TBitmap.create;
    try
      bitmap.width:= PaintBox2.width;
      bitmap.height:= PaintBox2.height;
      bitmap.canvas.stretchdraw(zrect,image3.picture.bitmap);
      bitmap.canvas.brush.style:=bsclear;
      bitmap.canvas.pen.color:=clLime;
      bitmap.canvas.rectangle(xk,yk, xk+ 81, yk+ 81);
      PaintBox2.canvas.draw(0,0,bitmap);
    finally
      bitmap.free;
      PaintBox1paint(sender);
    end;

    case RadioGroup1.ItemIndex of
    0 : begin
          try
            bmp := TBitmap.Create;
            bmp.PixelFormat := pf32bit;
            bmp.Width:=PaintBox1.Width;
            bmp.Height:=PaintBox1.Height;
            bmp.Canvas.CopyRect(Bounds(0,0,bmp.Width, bmp.Height),
                                  PaintBox1.Canvas, PaintBox1.ClientRect);
            Image4.Picture.Bitmap := InvertBitmap(bmp);
            Image4.Refresh;
            Image4.Repaint;
          finally
            bmp.Free;
          end;
        end;

    1 : begin   // Grayscale
        try
          bmp := TBitmap.Create;
          bmp.PixelFormat := pf32bit;
          bmp.Width:=PaintBox1.Width;
          bmp.Height:=PaintBox1.Height;
          bmp.Canvas.CopyRect(Bounds(0,0,bmp.Width, bmp.Height),
                            PaintBox1.Canvas, PaintBox1.ClientRect);
          Image4.Picture.Bitmap.Assign(bmp);
          ImageGrayScale(Image4);
          Image4.Refresh;
        finally
          bmp.Free;
        end;
      end;

    2 : begin     // None
        try
          Bitmap := TBitmap.Create;
          Bitmap.PixelFormat := pf32bit;
          Bitmap.Width:=PaintBox1.Width;
          Bitmap.Height:=PaintBox1.Height;
          Bitmap.Canvas.CopyRect(Bounds(0,0,bitmap.Width, Bitmap.Height),
                            PaintBox1.Canvas, PaintBox1.ClientRect);
          Image4.Picture.Bitmap.Assign(Bitmap);
          Image4.Refresh;
        finally
          Bitmap.Free;
        end;
      end;
    end;
end;

procedure TForm1.PaintBox1Paint(Sender: TObject);
var
  bitmap:tbitmap;
  zrect,qrect:trect;
  ii,jj,v,v1,v2,modu,anz:integer;
  pu:array[0..4] of tpoint;
type
  TRGBArray = ARRAY[0..32767] OF TRGBTriple;
  pRGBArray = ^TRGBArray;
  TMyhelp = array[0..0] of TRGBQuad;

procedure Drehen90Grad(xBitmap:TBitmap);
var
  P       : PRGBQuad;
  x,y,b,h : Integer;
  RowOut  : ^TMyHelp;
  help    : TBitmap;
BEGIN
    xBitmap.PixelFormat := pf32bit;
    help := TBitmap.Create;
    help.PixelFormat := pf32bit;
    b := xbitmap.Height;
    h := xbitmap.Width;
    help.Width := b;
    help.height := h;
    for y := 0 to (h-1) do
    begin
      rowOut := help.ScanLine[y];
      P  := xBitmap.scanline[xbitmap.height-1];
      inc(p,y);
      for x := 0 to (b-1) do
      begin
        rowout[x] := p^;
        inc(p,h);
      end;
    end;
    xbitmap.Assign(help);
    help.free;
end;

procedure SpiegelnHorizontal(Bitmap:TBitmap);
var
  i,j,w :  INTEGER;
  RowIn :  pRGBArray;
  RowOut:  pRGBArray;
begin
    w := bitmap.width*sizeof(TRGBTriple);
    Getmem(rowin,w);
    for j := 0 to Bitmap.Height-1 do
    begin
      move(Bitmap.Scanline[j]^,rowin^,w);
      rowout := Bitmap.Scanline[j];
      for i := 0 to Bitmap.Width-1 do rowout[i] := rowin[Bitmap.Width-1-i];
    end;
    bitmap.Assign(bitmap);
    Freemem(rowin);
end;

procedure kopieren(x,y:integer);
var
  i,j : integer;
begin
    for i:=0 to anz do
    begin
      for j:=0 to anz do
      begin
        bitmap.canvas.draw((x+v+i*160) mod modu,(y+v+j*160) mod modu,image1.picture.bitmap);
      end
    end;
end;

procedure kopierend(x,y:integer);
var
  i,j:integer;
begin
    for i:=-1 to anz+1 do
    begin
      for j:=-1 to anz+1 do
      begin
        bitmap.canvas.draw((x+v+i*138),round(y+v+j*160),image1.picture.bitmap);
        bitmap.canvas.draw((x+v+i*138)+69,round(y+v+j*160)+40,image1.picture.bitmap);
      end
    end;
end;

procedure dreieckdrehen;
type
  SiCoDiType= record si, co, di:real; end;
var
  Center, NewCenter: record x,y:real end;
  theta: real;
  i: Integer;
  Bitmap, NewBitMap: Tbitmap;
function SiCoDiPoint ( const p1: tpoint; p2x,p2y:real ): SiCoDiType;
var
  dx, dy: real;
begin
    dx := ( p2x - p1.x );
    dy := ( p2y - p1.y );
    with RESULT do
    begin
      di := HYPOT( dx, dy );
      if abs( di )<1 then
      begin
        si := 0.0;
        co := 1.0
      end
      else
      begin
        si := dy/di;
        co := dx/di
      end;
    end;
end;

PROCEDURE RotateBitmap(
	const BitmapOriginal:TBitMap;
	out   BitMapRotated:TBitMap;
	const theta:real;
	const oldAxisx,oldaxisy:real;
	var   newAxisx,newaxisy:real);
	VAR
	cosTheta       :  Single;
	sinTheta       :  Single;
	i              :  INTEGER;
	iOriginal      :  INTEGER;
	iPrime         :  INTEGER;
	j              :  INTEGER;
	jOriginal      :  INTEGER;
	jPrime         :  INTEGER;
	NewWidth,NewHeight:INTEGER;
	Oht,Owi,Rht,Rwi: Integer;
	type 	TRGBQuadArray = array [0..32767]  of TRGBQuad;
		pRGBQuadArray = ^TRGBQuadArray;
	var     RowRotatedQ: pRGBquadArray;
		TransparentQ: TRGBQuad;

var  SiCoPhi: SiCoDiType;
begin
    with BitMapOriginal do
    begin
      PixelFormat := pf32bit; //nbytes:=4;
      BitmapRotated.Assign( BitMapOriginal);
      sinTheta := SIN( theta ); cosTheta := COS( theta );
      NewWidth  := ABS( ROUND( Height*sinTheta) ) + ABS( ROUND( Width*cosTheta ) );
      NewHeight := ABS( ROUND( Width*sinTheta ) ) + ABS( ROUND( Height*cosTheta) );
      if ( ABS(theta)*MAX( width,height ) ) > 1 then
      begin
      BitmapRotated.Width  := NewWidth; BitmapRotated.Height := NewHeight;
      Rwi := NewWidth - 1;
      Rht := NewHeight - 1;
      Owi := Width - 1;
      Oht := Height - 1;
            TransparentQ := pRGBquadArray  ( Scanline[ Oht ] )[0];
      FOR j := Rht DOWNTO 0 DO
            BEGIN
              RowRotatedQ := BitmapRotated.Scanline[ j ] ;
        jPrime := 2*j - NewHeight + 1 ;
              FOR i := Rwi DOWNTO 0 DO
              BEGIN
                iPrime := 2*i - NewWidth   + 1;
                iOriginal := ( ROUND( iPrime*CosTheta - jPrime*sinTheta ) -1 + width ) DIV 2;
          jOriginal := ( ROUND( iPrime*sinTheta + jPrime*cosTheta ) -1 + height) DIV 2 ;
                IF   ( iOriginal >= 0 ) AND ( iOriginal <= Owi ) AND
                 ( jOriginal >= 0 ) AND ( jOriginal <= Oht ) THEN
                BEGIN
                  RowRotatedQ[i] := pRGBquadArray(   Scanline[jOriginal] )[iOriginal];
                END
          ELSE
                BEGIN
                  RowRotatedQ[i] := TransparentQ;
            END
              END
            eND;
          end;
          sicoPhi := sicodiPoint(  POINT( width div 2, height div 2 ),oldaxisx,oldaxisy );
          with sicoPhi do
          begin
            NewAxisx := round(newWidth/2 + di*(CosTheta*co - SinTheta*si));
            NewAxisy := round(newHeight/2- di*(SinTheta*co + CosTheta*si));
          end;
        end;
END;
begin
    Bitmap := Tbitmap.Create;
    bitmap.width:=80;
    bitmap.height:=80;
    bitmap.canvas.draw(0,0,image1.picture.bitmap);
    NewBitmap := Tbitmap.Create;
    Bitmap.Transparent := true;
    Center.x := bitmap.width div 2;
    center.y := bitmap.Height div 2;
    for i:= 0 to 5 do
    begin
      theta := 60.0*i*pi/180 ;
      RotateBitmap( Bitmap, NewBitMap, theta, Center.x,center.y, NewCenter.x,newcenter.y );
      image2.Canvas.Draw(round(80+40.0*cos(theta)-newcenter.x),
                         round(80-40.0*sin(theta)-newcenter.y), NewBitmap );
    end;
    Bitmap.Free;
    NewBitMap.Free;
end;

begin
    bitmap:=tbitmap.create;
    //bitmap.width:=480;
    //bitmap.height:=360;

    bitmap.width:= Image3.Width;
    bitmap.height := Image3.Height;

    zrect.left:=0;
    zrect.top:=0;

    //zrect.right:=480;
    //zrect.bottom:=360;

    zrect.right:= Image3.Width;
    zrect.bottom:= Image3.Height;

    bitmap.canvas.stretchdraw(zrect,image3.picture.bitmap);
    zrect.left:=0;
    zrect.top:=0;
    zrect.right:=80;
    zrect.bottom:=80;
    qrect.left:=xk;
    qrect.top:=yk;
    qrect.right:=xk+80;
    qrect.bottom:=yk+80;
    image1.canvas.copyrect(zrect,bitmap.canvas,qrect);
    bitmap.free;
    if auswahl1.itemindex in [4] then
    begin
      image1.canvas.pen.style:=psclear;
      image1.canvas.brush.color:=clwhite;

      pu[0].x:=0; pu[0].y:=39;
      pu[1].x:=0; pu[1].y:=0;
      pu[2].x:=69; pu[2].y:=0;

      image1.canvas.polygon(slice(pu,3));

      pu[0].x:=0; pu[0].y:=41;
      pu[1].x:=0; pu[1].y:=80;
      pu[2].x:=69; pu[2].y:=80;

      image1.canvas.polygon(slice(pu,3));

      pu[0].x:=69; pu[0].y:=0;
      pu[1].x:=81; pu[1].y:=0;
      pu[2].x:=81; pu[2].y:=80;
      pu[3].x:=69; pu[3].y:=80;

      image1.canvas.polygon(slice(pu,4));
    end;

    if auswahl1.itemindex in [5] then
    begin
      image1.Picture.bitmap.PixelFormat := pf24bit;
      image1.canvas.pen.style:=psclear;
      image1.canvas.brush.color:=clwhite;

      pu[0].x:=0; pu[0].y:=39;
      pu[1].x:=0; pu[1].y:=-1;
      pu[2].x:=69; pu[2].y:=-1;

      image1.canvas.polygon(slice(pu,3));

      pu[0].x:=0; pu[0].y:=41;
      pu[1].x:=0; pu[1].y:=81;
      pu[2].x:=69; pu[2].y:=81;

      image1.canvas.polygon(slice(pu,3));

      pu[0].x:=72; pu[0].y:=0;
      pu[1].x:=81; pu[1].y:=0;
      pu[2].x:=81; pu[2].y:=80;
      pu[3].x:=72; pu[3].y:=80;

      image1.canvas.polygon(slice(pu,4));
      image1.Picture.bitmap.PixelFormat := pf24bit;
      image2.canvas.brush.color:=clwhite;
      image2.canvas.rectangle(-1,-1,image2.width+1,image2.width+1);

      dreieckdrehen;

      image2.canvas.brush.color:=clwhite;
      image2.canvas.pen.color:=clwhite;
      image2.canvas.rectangle(-1,-1,11,163);
      image2.canvas.rectangle(151,-1,163,163);

      pu[2].x:=-1; pu[2].y:=-1;
      pu[0].x:=-1; pu[0].y:=46;
      pu[1].x:=79; pu[1].y:=-1;

      image2.canvas.polygon(slice(pu,3));

      pu[0].x:=161; pu[0].y:=161;
      pu[1].x:=80; pu[1].y:=161;
      pu[2].x:=161; pu[2].y:=114;

      image2.canvas.polygon(slice(pu,3));

      pu[0].x:=1; pu[0].y:=161;
      pu[1].x:=79; pu[1].y:=161;
      pu[2].x:=1; pu[2].y:=114;

      image2.canvas.polygon(slice(pu,3));

      pu[2].x:=161; pu[2].y:=-2;
      pu[0].x:=161; pu[0].y:=46;
      pu[1].x:=80; pu[1].y:=-2;

      image2.canvas.polygon(slice(pu,3));
    end;

    v1:=1;
    v2:=3;
    modu:=320;
    anz:=1;

    if auswahl2.itemindex=1 then
    begin
      v1:=0;
      v2:=2;
      modu:=480;
      anz:=2;
    end;

    bitmap:=tbitmap.create;
    bitmap.width:=PaintBox1.width;
    bitmap.height:=PaintBox1.height;
    v:=0;

    case auswahl1.itemindex of
      0,1 : begin
              if auswahl1.itemindex=v1 then v:=80;
              image1.Picture.bitmap.PixelFormat := pf24bit;
              kopieren(0,0);
              Drehen90Grad(image1.picture.Bitmap);
              Drehen90Grad(image1.picture.Bitmap);
              kopieren(80,80);
              Drehen90Grad(image1.picture.Bitmap);
              kopieren(0,80);
              Drehen90Grad(image1.picture.Bitmap);
              Drehen90Grad(image1.picture.Bitmap);
              kopieren(80,0);
            end;
      2,3 : begin
              if auswahl1.itemindex=v2 then v:=80;
              image1.Picture.bitmap.PixelFormat := pf24bit;
              kopieren(0,0);
              spiegelnhorizontal(image1.picture.Bitmap);
              kopieren(80,0);
              spiegelnhorizontal(image1.picture.Bitmap);
              Drehen90Grad(image1.picture.Bitmap);
              Drehen90Grad(image1.picture.Bitmap);
              kopieren(80,80);
              image1.Picture.bitmap.PixelFormat := pf24bit;
              spiegelnhorizontal(image1.picture.Bitmap);
              kopieren(0,80);
            end;
        4 : begin
              v:=-10;
              image1.Picture.bitmap.PixelFormat := pf24bit;
              bitmap.canvas.copymode:=cmsrcand;
              kopierend(11,0);
              spiegelnhorizontal(image1.picture.Bitmap);
              kopierend(69,0);
              spiegelnhorizontal(image1.picture.Bitmap);
              Drehen90Grad(image1.picture.Bitmap);
              Drehen90Grad(image1.picture.Bitmap);
              kopierend(69,81);
              image1.Picture.bitmap.PixelFormat := pf24bit;
              spiegelnhorizontal(image1.picture.Bitmap);
              kopierend(11,81);
              bitmap.canvas.copymode:=cmsrccopy;
            end;
        5 : begin
              bitmap.canvas.copymode:=cmsrcand;
              ii:=-2;
              repeat
                jj:=-1;
                repeat
                  if odd(jj) then
                  begin
                    bitmap.canvas.draw(80+ii*140,round(80+jj*120),image2.picture.bitmap);
                  end
                  else
                    bitmap.canvas.draw(80+ii*140+70,round(80+jj*120),image2.picture.bitmap);
                  inc(jj,1);
                until 80+jj*120>PaintBox1.width;
                inc(ii);
              until 80+ii*140>PaintBox1.width;
              bitmap.canvas.copymode:=cmsrccopy;
            end;
    end;
    PaintBox1.canvas.draw(0,0,bitmap);
    bitmap.free;
end;

procedure TForm1.PB3MDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    if (x>xk) and (x<xk+81) and (y>yk) and (y<yk+81) then
    begin
      kaziehen:=true;
      xzie:=x-xk;
      yzie:=y-yk;
    end;
end;

procedure TForm1.PB3MMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
    if kaziehen then
    begin
      xk:=x-xzie;
      yk:=y-yzie;
      if xk<0 then xk:=0;
      if yk<0 then yk:=0;
      //if xk>400 then xk:=400;
      //if yk>280 then yk:=280;

      if xk> Image3.Width then xk:= Image3.Width;
      if yk> Image3.Height then yk := Image3.Height;
      PaintBox2paint(sender);
      StatusBar1.Panels[9].Text := IntToStr(xk)+'x'+IntToStr(yk);
    end;
end;

procedure TForm1.PB3MUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    kaziehen := false;
end;

procedure ladejpg(const FileName: String; Bild: TBitMap);
var
  Jpeg: TJpegImage;
begin
  try
    Jpeg:=TJpegImage.Create;
    jpeg.LoadFromFile(filename);
    Bild.Assign(Jpeg);
  finally
    jpeg.free;
  end;
end;

procedure TForm1.auswahl2Click(Sender: TObject);
var
  b:integer;
begin
    if auswahl2.itemindex = 0 then begin
      b:=320;
      Form1.Height := 593;
      Panel4.Height := 344;
      Panel4.Width := 344;
      SpinEdit1.Value := 320;
      Form1.Constraints.MinHeight := 615;
    end else begin
      Form1.Height := 750;
      Panel4.Height := 500;
      Panel4.Width := 500;
      SpinEdit1.Value := 480;
      b:=480;
      Form1.Constraints.MinHeight := 775;
    end;

    PaintBox1.width:=b;
    PaintBox1.height:=b;
    PaintBox2paint(sender);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;
end;

procedure TForm1.Image4MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  BitmapStretch : TBitmap;
begin
  if Image4.Picture.Graphic = nil then Exit;

  if CheckBox1.Checked = true then
  begin
    try
      BitmapStretch := TBitmap.Create;
      BitmapStretch.PixelFormat := pf32bit;
      BitmapStretch.Assign(Image4.Picture.Bitmap);
      StretchGraphic(Image4.Picture.Bitmap, BitmapStretch,
      SpinEdit1.Value, SpinEdit1.Value,  true);
      Image4.Picture.Bitmap.Assign(BitmapStretch);
    finally
      BitmapStretch.Free;
    end;
  end;

  form2.ShowModal;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
var
  x, y : integer;
begin
  xk := xk+1;

  if xk<0 then xk:=0;
  if yk<0 then yk:=0;
  if xk> Image3.Width then xk:= Image3.Width;
  if yk> Image3.Height then yk := Image3.Height;

  PaintBox2paint(sender);
  StatusBar1.Panels[9].Text := IntToStr(xk)+'x'+IntToStr(yk);
  StatusBar1.SetFocus;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
var
  x, y : integer;
begin
  yk := yk+1;

  if xk<0 then xk:=0;
  if yk<0 then yk:=0;
  if xk> Image3.Width then xk:= Image3.Width;
  if yk> Image3.Height then yk := Image3.Height;

  PaintBox2paint(sender);
  StatusBar1.Panels[9].Text := IntToStr(xk)+'x'+IntToStr(yk);
  StatusBar1.SetFocus;
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
var
  x, y : integer;
begin
  xk := xk-1;

  if xk<0 then xk:=0;
  if yk<0 then yk:=0;
  if xk> Image3.Width then xk:= Image3.Width;
  if yk> Image3.Height then yk := Image3.Height;

  PaintBox2paint(sender);
  StatusBar1.Panels[9].Text := IntToStr(xk)+'x'+IntToStr(yk);
  StatusBar1.SetFocus;
end;

procedure TForm1.BitBtn4Click(Sender: TObject);
var
  x, y : integer;
begin
  yk := yk-1;

  if xk<0 then xk:=0;
  if yk<0 then yk:=0;
  if xk> Image3.Width then xk:= Image3.Width;
  if yk> Image3.Height then yk := Image3.Height;

  PaintBox2paint(sender);
  StatusBar1.Panels[9].Text := IntToStr(xk)+'x'+IntToStr(yk);
  StatusBar1.SetFocus;
end;

procedure TForm1.BitBtn5Click(Sender: TObject);
var
  x, y : integer;
begin
  yk := 0;
  xk := 0;

  //if xk<0 then xk:=0;
  //if yk<0 then yk:=0;
  if xk> Image3.Width then xk:= Image3.Width;
  if yk> Image3.Height then yk := Image3.Height;

  PaintBox2paint(sender);
  StatusBar1.Panels[9].Text := IntToStr(xk)+'x'+IntToStr(yk);
  StatusBar1.SetFocus;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Image1.Picture.Graphic := nil;
  Image2.Picture.Graphic := nil;
  Image3.Picture.Graphic := nil;
  Image4.Picture.Graphic := nil;

  PaintBox2.Width := 0;
  PaintBox2.Height := 0;

  PaintBox1.Invalidate;
  PaintBox2.Invalidate;


  with PaintBox2.Canvas do
  begin
  Brush.Style := bsClear;
  Brush.Color := clBtnFace;
  Repaint;
  FillRect(ClientRect);
  end;

  with PaintBox1.Canvas do
  begin
  Brush.Style := bsClear;
  Brush.Color := clBtnFace;
  Repaint;
  FillRect(ClientRect);
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  FileHeader: TBitmapFileHeader;
  InfoHeader: TBitmapInfoHeader;
  Stream    : TFileStream;
begin
  if OpenPicutreDialog1.Execute then
    begin

    case auswahl2.ItemIndex of
    0 : begin
          PaintBox1.Width := 320;
          PaintBox1.Height := 320;
    end;
    1 : begin
          PaintBox1.Width := 480;
          PaintBox1.Height := 480;
        end;
    end;

    xzie:=0;
    yzie:=0;
    xk:=0;
    yk:=0;

    PaintBox2.Visible := true;
    PaintBox2.Invalidate;
    Image3.Picture.Graphic := nil;

      case OpenPicutreDialog1.filterindex of
        1: Image3.Picture.LoadFromFile(OpenPicutreDialog1.FileName);
        2: ladejpg(OpenPicutreDialog1.FileName,image3.picture.bitmap);
      end;

      PaintBox2.Height := Image3.Height;
      PaintBox2.Width := Image3.Width;
      PaintBox2paint(sender);
    end;
    Image3.Picture.Bitmap.SaveToFile(MainDir + 'Data\Backup\_bmp');
    Stream := TFileStream.Create(MainDir + 'Data\Backup\_bmp',
                                    fmOpenRead or fmShareDenyNone);
  try
    Stream.Read(FileHeader, SizeOf(FileHeader));
    Stream.Read(InfoHeader, SizeOf(InfoHeader));
    StatusBar1.Panels[1].Text := ExtractFileName(OpenPicutreDialog1.FileName);
    StatusBar1.Panels[3].Text := Format('%d', [InfoHeader.biWidth]) +
                                        'x' + Format('%d ', [InfoHeader.biHeight]);
    StatusBar1.Panels[5].Text := Format('%d', [FileHeader.bfSize div 1000]) + ' Kb';
    StatusBar1.Panels[7].Text := Format('%d', [InfoHeader.biBitCount]);
  finally
    Stream.Free;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  Bitmap, BitmapStretch: TBitmap;
begin
  if SaveDialog1.Execute then begin
  try

    if CheckBox1.Checked = true then begin
      BitmapStretch := TBitmap.Create;
      BitmapStretch.PixelFormat := pf32bit;
      BitmapStretch.Assign(Image4.Picture.Bitmap);
      StretchGraphic(Image4.Picture.Bitmap, BitmapStretch,
      SpinEdit1.Value, SpinEdit1.Value,  true);
      Image4.Picture.Bitmap.Assign(BitmapStretch);
    end;


    if SaveDialog1.FilterIndex = 1 then begin       // Bitmap
      Image4.Picture.Bitmap.SaveToFile(SaveDialog1.FileName + '.bmp');
    end;

    if SaveDialog1.FilterIndex = 2 then begin       // Jpg
      Image4.Picture.Bitmap.SaveToFile(MainDir + 'Data\Backup\_bmp');
      Bmp2Jpeg(MainDir + 'Data\Backup\_bmp', SaveDialog1.FileName + '.jpg');
    end;

    if SaveDialog1.FilterIndex = 3 then begin       // Png
      Image4.Picture.Bitmap.SaveToFile(MainDir + 'Data\Backup\_bmp');
      BitmapFileToPNG(MainDir + 'Data\Backup\_bmp', SaveDialog1.FileName + '.png');
    end;

    if SaveDialog1.FilterIndex = 4 then begin       // Gif
      Image4.Picture.Bitmap.SaveToFile(MainDir + 'Data\Backup\_bmp');
      ConvertBMP2GIF;
    end;
  finally
    if CheckBox1.Checked = true then begin
      BitmapStretch.Free;
    end;
  end;

  end;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked = true then
  begin
    SpinEdit1.Enabled := true;
  end else begin
    SpinEdit1.Enabled := false;

  case auswahl2.ItemIndex of
    0 : SpinEdit1.Value := 320;
    1 : SpinEdit1.Value := 480;
  end;
  end;
end;

procedure TForm1.Label4MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  BitmapStretch : TBitmap;
begin
  if Image4.Picture.Graphic = nil then Exit;

  if CheckBox1.Checked = true then
  begin
    try
      BitmapStretch := TBitmap.Create;
      BitmapStretch.PixelFormat := pf32bit;
      BitmapStretch.Assign(Image4.Picture.Bitmap);
      StretchGraphic(Image4.Picture.Bitmap, BitmapStretch,
      SpinEdit1.Value, SpinEdit1.Value,  true);
      Image4.Picture.Bitmap.Assign(BitmapStretch);
    finally
      BitmapStretch.Free;
    end;
  end;

  try
    form2 := TForm2.Create(nil);
    form2.ShowModal;
    finally
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  PaintBox1.Width := 0;
  PaintBox1.Height := 0;
end;

end.

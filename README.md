# Kaleidoscope-Creator

</br>

![Compiler](https://github.com/user-attachments/assets/a916143d-3f1b-4e1f-b1e0-1067ef9e0401) ![10 Seattle](https://github.com/user-attachments/assets/c70b7f21-688a-4239-87c9-9a03a8ff25ab) ![10 1 Berlin](https://github.com/user-attachments/assets/bdcd48fc-9f09-4830-b82e-d38c20492362) ![10 2 Tokyo](https://github.com/user-attachments/assets/5bdb9f86-7f44-4f7e-aed2-dd08de170bd5) ![10 3 Rio](https://github.com/user-attachments/assets/e7d09817-54b6-4d71-a373-22ee179cd49c)  ![10 4 Sydney](https://github.com/user-attachments/assets/e75342ca-1e24-4a7e-8fe3-ce22f307d881) ![11 Alexandria](https://github.com/user-attachments/assets/64f150d0-286a-4edd-acab-9f77f92d68ad) ![12 Athens](https://github.com/user-attachments/assets/59700807-6abf-4e6d-9439-5dc70fc0ceca)  
![Components](https://github.com/user-attachments/assets/d6a7a7a4-f10e-4df1-9c4f-b4a1a8db7f0e) ![None](https://github.com/user-attachments/assets/30ebe930-c928-4aaf-a8e1-5f68ec1ff349)  
![Description](https://github.com/user-attachments/assets/dbf330e0-633c-4b31-a0ef-b1edb9ed5aa7) ![Kaleidoscope Creator](https://github.com/user-attachments/assets/20c8cd45-05e5-4840-9618-609ac05b05f6)  
![Last Update](https://github.com/user-attachments/assets/e1d05f21-2a01-4ecf-94f3-b7bdff4d44dd) ![032026](https://github.com/user-attachments/assets/0fc2f280-2ec1-45b1-8947-57bfc6683ea0)  
![License](https://github.com/user-attachments/assets/ff71a38b-8813-4a79-8774-09a2f3893b48) ![Freeware](https://github.com/user-attachments/assets/1fea2bbf-b296-4152-badd-e1cdae115c43)  

</br>

A kaleidoscope is an [optical instrument](https://en.wikipedia.org/wiki/Optical_instrument) with two or more reflecting surfaces (or mirrors) tilted to each other at an angle, so that one or more (parts of) objects on one end of these [mirrors](https://en.wikipedia.org/wiki/Mirror) are shown as a [symmetrical](https://en.wikipedia.org/wiki/Symmetry) pattern when viewed from the other end, due to repeated [reflection](https://en.wikipedia.org/wiki/Reflection_(physics)). These reflectors are often enclosed in a tube, usually containing on one end a cell with loose, colored pieces of glass or other transparent (and/or [opaque](https://en.wikipedia.org/wiki/Opacity)) materials to be reflected into the viewed pattern. Rotation of the cell causes motion of the materials, resulting in an ever-changing view being presented.

</br>

![Kaleidoscope](https://github.com/user-attachments/assets/68f32b58-e714-4698-b084-006ade492b8d)

</br>

The term "kaleidoscope" was coined by its Scottish inventor [David Brewster](https://en.wikipedia.org/wiki/David_Brewster). It is derived from the [Ancient Greek](https://en.wikipedia.org/wiki/Ancient_Greek) word καλός (kalos), "beautiful, beauty", εἶδος (eidos), "form, appearance" and σκοπέω (skopeō), "to look, to examine", hence "observation of beautiful forms". It was first published in the patent that was granted on July 10, 1817.

</br>

# Calculation from an image:
```pascal
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
```

</br>

# Light polarization:
In 1814, Sir David Brewster conducted experiments on [light polarization](https://en.wikipedia.org/wiki/Light_polarization) by successive reflections between plates of glass and first noted "the circular arrangement of the images of a candle round a center, and the multiplication of the sectors formed by the extremities of the plates of glass". He forgot about it, but noticed a more impressive version of the effect during further experiments in February 1815. A while later, he was impressed by the multiplied reflection of a bit of cement that was pressed through at the end of a triangular glass trough, which appeared more regular and almost perfectly symmetrical in comparison to the reflected objects that had been situated further away from the reflecting plates in earlier experiments. This triggered more experiments to find the conditions for the most beautiful and symmetrically perfect conditions. An early version had pieces of colored glass and other irregular objects fixed permanently and was admired by some Members of the Royal [Society of Edinburgh](https://en.wikipedia.org/wiki/Royal_Society_of_Edinburgh), including [Sir George Mackenzie](https://en.wikipedia.org/wiki/Sir_George_Mackenzie,_7th_Baronet) who predicted its popularity. A version followed in which some of the objects and pieces of glass could move when the tube was rotated. The last step, regarded as most important by Brewster, was to place the reflecting panes in a draw tube with a concave lens to distinctly introduce surrounding objects into the reflected pattern.

### Example:

</br>

![Kaleidoscope](https://github.com/user-attachments/assets/dfc02790-cfe8-4e70-90cd-c0dce4bd7dfb)

</br>

# General variations:
* variations in size (Brewster deemed a length of five to ten inches convenient, for one to four inches he suggested the use of a lens with a focus length equal to the length of the reflectors)
* variations in the angle of inclination of the reflecting surfaces. In his patent Brewster deemed 18°, 20° or 22 1/2° most pleasing. In the treatise 45°, 36° and 30° are the primary examples.
* variations in material of the reflecting surfaces (plates of plain glass, quicksilvered glass (mirror) or metal, or the reflecting inner surfaces of a solid prism of glass or rock crystal) The choice of material can have some influence of the tint and the quality of the image.
* a wide variety of objects, small figures, fragments, liquids and materials of different colors and shapes can be used in object cells (apart from the more usual transparent fragments, for instance twisted pieces of iron or brass wire, or some lace, can produce very fine effects).

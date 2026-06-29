program serce_raylib;

{$mode objfpc}{$H+}

uses
  cmem, raylib, math;

const
  ScreenWidth  = 900;
  ScreenHeight = 900;
  PointCount   = 360;
  HeartScale   = 16.0;
  AnimTime     = 9.5;

var
  Progress: Single;

function Vec2(x, y: Single): TVector2;
begin
  Result.x := x;
  Result.y := y;
end;

function Ease(t: Single): Single;
begin
  if t < 0.0 then t := 0.0;
  if t > 1.0 then t := 1.0;

  Result := t * t * (3.0 - 2.0 * t);
end;

function ShapePoint(i: Integer; morph: Single): TVector2;
var
  u, a, s, x, y: Single;
  line, heart: TVector2;
begin
  u := i / (PointCount - 1);

  line := Vec2(
    60 + u * 780.0,
    ScreenHeight / 2.0
  );

  a := u * 2.0 * Pi;
  s := Sin(a);

  x := 16.0 * s * s * s;
  y := 13.0 * Cos(a)
     - 5.0 * Cos(2.0 * a)
     - 2.0 * Cos(3.0 * a)
     -       Cos(4.0 * a);

  heart := Vec2(
    ScreenWidth / 2.0 + x * HeartScale,
    ScreenHeight / 2.0 - y * HeartScale
  );

  Result := Vec2(
    line.x + (heart.x - line.x) * morph,
    line.y + (heart.y - line.y) * morph
  );
end;

procedure DrawMorphingLine(morph: Single);
var
  i: Integer;
begin
  for i := 0 to PointCount - 2 do
    DrawLineEx(
      ShapePoint(i, morph),
      ShapePoint(i + 1, morph),
      5.0,
      RED
    );
end;

begin
  InitWindow(ScreenWidth, ScreenHeight, 'Linia tworzy serce - raylib Pascal');
  SetTargetFPS(60);

  Progress := 0.0;

  while not WindowShouldClose() do
  begin
    if IsKeyPressed(KEY_R) then
      Progress := 0.0;

    if Progress < 1.0 then
      Progress := Progress + GetFrameTime() / AnimTime;

    BeginDrawing();
      ClearBackground(BLACK);

      DrawText('Linia wygina sie w serce', 20, 20, 24, RAYWHITE);
      DrawText('R - powtorz animacje', 20, 52, 18, LIGHTGRAY);

      DrawMorphingLine(Ease(Progress));
    EndDrawing();
  end;

  CloseWindow;
end.

unit fTest;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.AppEvnts, Vcl.StdCtrls, Vcl.CheckLst;

type
  TfrmELOTest = class(TForm)
    CheckListBox1: TCheckListBox;
    btnPlayMatch: TButton;
    ApplicationEvents1: TApplicationEvents;
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure btnPlayMatchClick(Sender: TObject);
  private
    function CheckCount: integer;
    procedure SortList;
  public
    { Public declarations }
  end;

var
  frmELOTest: TfrmELOTest;

implementation

uses
  uELO, fMatchResult;

{$R *.dfm}

procedure TfrmELOTest.ApplicationEvents1Idle(Sender: TObject;
  var Done: Boolean);
begin
  btnPlayMatch.Enabled := CheckCount > 1;
end;

procedure TfrmELOTest.btnPlayMatchClick(Sender: TObject);
var
  i: integer;
  LELOMatch: TELOMatch;
  LPlace: integer;
  LPlayerName: string;
  LELO: integer;
begin
  LELOMatch := TELOMatch.Create;
  try
    LPlace := 0;
    for i := 0 to CheckListBox1.Items.Count -1 do
    begin
      if CheckListBox1.Checked[i] then
      begin
        LELOMatch.AddPlayer(i, CheckListBox1.Items[i], LPlace, integer(CheckListBox1.Items.Objects[i]));
        inc(LPlace);
      end;
    end;

    frmMatchResult.Init(LELOMatch);
    if frmMatchResult.ShowModal = mrOK then
    begin
      LELOMatch.CalculateELOs;

      for i := 0 to CheckListBox1.Items.Count -1 do
      begin
        if CheckListBox1.Checked[i] then
        begin
          LPlayerName := CheckListBox1.Items[i];
          LELO := LELOMatch.GetElo(i);
          CheckListBox1.Items.Objects[i] := TObject(LELO);
          LPlayerName := trim(Copy(LPlayerName, 1, pos('(', LPlayerName) -1 ));

          CheckListBox1.Items[i] := Format('%s (%d)', [LPlayerName, LELO]);
        end;
      end;

    end;

  finally
    LELOMatch.Free;
  end;
  SortList;
end;

function TfrmELOTest.CheckCount: integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to CheckListBox1.Items.Count -1 do
  begin
    if CheckListBox1.Checked[i] then
      inc(Result);
  end;
end;

procedure TfrmELOTest.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  for i := 1 to 32 do
  begin
    CheckListBox1.Items.AddObject(Format('Player %0.2d', [i]) + ' (1500)', TObject(1500));
  end;
end;


function SortScore(List: TStringList; Index1, Index2: Integer): Integer;
var
  LScore1, LScore2: integer;
begin
  LScore1 := integer(List.Objects[Index1]);
  LScore2 := integer(List.Objects[Index2]);
  if LScore1 < LScore2 then
    Result := 1
  else if LScore1 > LScore2 then
    Result := -1
  else
    Result := CompareText(List[Index1], List[Index2]);
end;

procedure TfrmELOTest.SortList;
var
  LSortList: TStringList;
begin
  LSortList := TStringList.Create;
  try
    LSortList.Assign(CheckListBox1.Items);
    LSortList.CustomSort(SortScore);
    CheckListBox1.Items.Assign(LSortList);
  finally
    LSortList.Free;
  end;
end;

end.

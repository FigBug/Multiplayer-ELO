unit fMatchResult;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  uELO, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Menus;

type
  TfrmMatchResult = class(TForm)
    Panel1: TPanel;
    btnCancel: TButton;
    btnOK: TButton;
    ListView1: TListView;
    PopupMenu1: TPopupMenu;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListView1Data(Sender: TObject; Item: TListItem);
  private
    FELOMatch: TELOMatch;
    procedure SetPlaceClick(Sender: TObject);
  public
    procedure Init(AELOMatch: TELOMatch);
  end;

var
  frmMatchResult: TfrmMatchResult;

implementation

{$R *.dfm}

{ TfrmMatchResult }

procedure TfrmMatchResult.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ListView1.Items.Count := 0;
  FELOMatch := nil;
end;

procedure TfrmMatchResult.Init(AELOMatch: TELOMatch);
var
  i: integer;
  LMenuItem: TMenuItem;
begin
  FELOMatch := AELOMatch;
  ListView1.Items.Count := FELOMatch.Players.Count;

  PopupMenu1.Items.Clear;
  for i := 0 to FELOMatch.Players.Count-1 do
  begin
    LMenuItem := TMenuItem.Create(Self);
    LMenuItem.Caption := Format('Place %d', [i]);
    LMenuItem.Tag := i;
    LMenuItem.OnClick := SetPlaceClick;
    PopupMenu1.Items.Add(LMenuItem);
  end;
end;

procedure TfrmMatchResult.ListView1Data(Sender: TObject; Item: TListItem);
begin
  Item.Caption := FELOMatch.Players[Item.Index].Name;
  Item.SubItems.Add(IntToStr(FELOMatch.Players[Item.Index].Place));
end;

procedure TfrmMatchResult.SetPlaceClick(Sender: TObject);
var
  i: integer;
  LNewPlace: integer;
begin
  LNewPlace := (Sender as TMenuItem).Tag;
  for i := 0 to ListView1.Items.Count-1 do
  begin
    if ListView1.Items[i].Selected then
      FELOMatch.Players[i].Place := LNewPlace;
  end;
  ListView1.Repaint;
end;

end.

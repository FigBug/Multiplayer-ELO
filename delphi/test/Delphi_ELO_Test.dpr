program Delphi_ELO_Test;

uses
  Vcl.Forms,
  fTest in 'fTest.pas' {frmELOTest},
  uELO in '..\uELO.pas',
  fMatchResult in 'fMatchResult.pas' {frmMatchResult};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmELOTest, frmELOTest);
  Application.CreateForm(TfrmMatchResult, frmMatchResult);
  Application.Run;
end.

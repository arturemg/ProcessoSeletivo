program prjPS;

uses
  Forms,
  uCad in 'uCad.pas' {frmCad};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmCad, frmCad);
  Application.Run;
end.

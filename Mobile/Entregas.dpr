program Entregas;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitPrincipal in 'UnitPrincipal.pas' {FrmPrincipal},
  uFunctions in 'Units\uFunctions.pas',
  uLoading in 'Units\uLoading.pas',
  UnitNovaRemessa in 'UnitNovaRemessa.pas' {FrmNovaRemessa},
  UnitStatusRemessa in 'UnitStatusRemessa.pas' {FrmStatusRemessa},
  uSession in 'Units\uSession.pas',
  DataModule.Remessa in 'DataModule\DataModule.Remessa.pas' {DmRemessa: TDataModule},
  u99Permissions in 'Units\u99Permissions.pas',
  UnitMapa in 'UnitMapa.pas' {FrmMapa};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.CreateForm(TFrmNovaRemessa, FrmNovaRemessa);
  Application.CreateForm(TFrmStatusRemessa, FrmStatusRemessa);
  Application.CreateForm(TDmRemessa, DmRemessa);
  Application.CreateForm(TFrmMapa, FrmMapa);
  Application.Run;
end.

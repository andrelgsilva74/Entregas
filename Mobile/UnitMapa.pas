unit UnitMapa;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, System.Sensors, FMX.Maps,
  System.Generics.Collections, uLoading, uFunctions, uSession;

type
  TFrmMapa = class(TForm)
    rectToolbar1: TRectangle;
    lblTitulo: TLabel;
    imgVoltar: TImage;
    MapView: TMapView;
    imgLocation: TImage;
    procedure imgVoltarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MapViewMarkerClick(Marker: TMapMarker);
  private
    FMinhaPosicao: TLocationCoord2D;
    FMarkers: TList<TMapMarker>;
    procedure LimparMarcadores;
    procedure AddMarcador(posicao: TMapCoordinate; titulo, descricao: string;
      icone: TBitmap);
    procedure ThreadLoadTerminate(Sender: TObject);
    { Private declarations }
  public
    property MinhaPosicao: TLocationCoord2D read FMinhaPosicao write FMinhaPosicao;
  end;

var
  FrmMapa: TFrmMapa;

implementation

{$R *.fmx}

uses DataModule.Remessa;

procedure TFrmMapa.LimparMarcadores;
var
    Marker: TMapMarker;
begin
    for Marker in FMarkers do
            Marker.Remove;

    FMarkers.Clear;
end;

procedure TFrmMapa.MapViewMarkerClick(Marker: TMapMarker);
begin
    showmessage(Marker.Descriptor.Title);
end;

procedure TFrmMapa.AddMarcador(posicao: TMapCoordinate; titulo, descricao : string;
                               icone: TBitmap);
var
    marcador : TMapMarkerDescriptor;
begin
    // Criar o marcador...
    marcador := TMapMarkerDescriptor.Create(posicao, titulo);
    marcador.Snippet := descricao;
    marcador.Visible := true;

    if icone <> nil then
        marcador.Icon := icone;


    // Adiciona marcador no lista e no mapa...
    FMarkers.Add(MapView.AddMarker(marcador));
end;

procedure TFrmMapa.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    FMarkers.DisposeOf;

    Action := TCloseAction.caFree;
    FrmMapa := nil;
end;

procedure TFrmMapa.FormCreate(Sender: TObject);
begin
    FMarkers := TList<TMapMarker>.create;
end;

procedure TFrmMapa.ThreadLoadTerminate(Sender: TObject);
begin
    TLoading.Hide;

    if ErroThread(Sender) then
        exit;
end;

procedure TFrmMapa.FormShow(Sender: TObject);
var
    posicao : TMapCoordinate;
    t : TThread;
begin
    // Centralizar o mapa na nossa localizacao...
    posicao.Latitude := MinhaPosicao.Latitude;
    posicao.Longitude := MinhaPosicao.Longitude;
    MapView.Location := posicao;

    // Adiciona minha localizacao no mapa...
    AddMarcador(posicao, '', '', imgLocation.Bitmap);

    // Zoom...
    MapView.Zoom := 13;

    // Request entregas mais proximas...
    TLoading.Show(FrmMapa, '');
    t := TThread.CreateAnonymousThread(procedure
    begin
        sleep(1000);

        DmRemessa.ListarLocalizacao(TSession.ID_USUARIO,
                                    MinhaPosicao.Latitude,
                                    MinhaPosicao.Longitude);

        with DmRemessa.TabRemessas do
        begin
            while NOT eof do
            begin
                posicao.Latitude := fieldbyname('origem_latitude').AsFloat;
                posicao.Longitude := fieldbyname('origem_longitude').AsFloat;

                TThread.Synchronize(TThread.CurrentThread, procedure
                begin
                    //showmessage(posicao.Latitude.ToString);

                    AddMarcador(posicao,
                                fieldbyname('descricao').AsString,
                                fieldbyname('origem').AsString,
                                nil);
                end);

                Next;
            end;
        end;

    end);

    t.OnTerminate := ThreadLoadTerminate;
    t.Start;
end;

procedure TFrmMapa.imgVoltarClick(Sender: TObject);
begin
    close;
end;

end.

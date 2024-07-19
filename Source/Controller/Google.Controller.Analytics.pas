unit Google.Controller.Analytics;

interface

uses
  Google.Controller.Analytics.Interfaces,
  Google.Model.Analytics.Interfaces, System.JSON;

type
  TControllerGoogleAnalytics = Class(TInterfacedObject, iControllerGoogleAnalytics)
  private
  class var
    FInstance: TControllerGoogleAnalytics;

    FGooglePropertyID: String;
    FGoogleApiSecret: string;
    FClienteID: String;
    FUserID: String;

    FSystemPlatform: String;
    FScreenResolution: String;

    FURL: String;

    FAppInfo: iModelGoogleAppInfo;

    function GuidCreate: string;
    function GetSystemPlatform: string;
    function GetScreenResolution: string;
    procedure ValidaDados;
  public
    constructor Create(AGooglePropertyID: String; AGoogleApiSecret: string; AUserID: String = '');
    destructor Destroy; override;
    class function New(AGooglePropertyID: String; AGoogleApiSecret: string; AUserID: String = ''): iControllerGoogleAnalytics;

    function GooglePropertyID: String; overload;
    function GooglePropertyID(Value: String): iControllerGoogleAnalytics; overload;
    function GoogleApiSecret: String; overload;
    function GoogleApiSecret(Value: String): iControllerGoogleAnalytics; overload;
    function ClienteID: String; overload;
    function ClienteID(Value: String): iControllerGoogleAnalytics; overload;
    function UserID: String; overload;
    function UserID(Value: String): iControllerGoogleAnalytics; overload;

    function SystemPlatform: String;
    function ScreenResolution: String;

    function URL: String; overload;
    function URL(Value: String): iControllerGoogleAnalytics; overload;

    function AppInfo: iModelGoogleAppInfo;

    function Event(ACategory, AAction, ALabel: String; AValue: Integer = 0): iControllerGoogleAnalytics;
    function Exception(ADescription: String; AIsFatal: Boolean): iControllerGoogleAnalytics;
    function ScreenView(AScreenName: String): iControllerGoogleAnalytics;
    function PageView(ADocumentHostName, APage, ATitle: String): iControllerGoogleAnalytics;
    function Login(AMethod: String): iControllerGoogleAnalytics;
    function Purchase(aCoupon: string; AValue: currency; aTransactionId: string; aUserData: iModelUserData; aItems: TArray<iModelGooglePurchaseItems>): iControllerGoogleAnalytics;
    function AddPayment(aCoupon: string; AValue: currency; aPaymentType: string;
      aUserData: iModelUserData; aItems: TArray<iModelGoogleAddPaymentInfoItems>): iControllerGoogleAnalytics;
  End;

implementation

uses
  Winapi.ActiveX,
  Winapi.Windows,
  System.Classes,
  System.SysUtils,
  System.Win.Registry,
  Vcl.Forms, Google.Model.Analytics.Factory, Google.Model.Analytics.Invoker,
  System.Hash;

{ TControllerGoogleAnalytics }

function TControllerGoogleAnalytics.AppInfo: iModelGoogleAppInfo;
begin
  Result := FAppInfo;
end;

function TControllerGoogleAnalytics.ClienteID(
  Value: String): iControllerGoogleAnalytics;
begin
  Result := Self;

  FClienteID := THashSHA2.GetHashString(Value);
end;

function TControllerGoogleAnalytics.ClienteID: String;
begin
  Result := FClienteID;
end;

constructor TControllerGoogleAnalytics.Create(AGooglePropertyID: String; AGoogleApiSecret: string; AUserID: String = '');
begin
  FGooglePropertyID := AGooglePropertyID;
  FUserID := AUserID;

  FClienteID := GuidCreate;

  FSystemPlatform := GetSystemPlatform;
  FScreenResolution := GetScreenResolution;

  // FURL := Format('https://www.google-analytics.com/debug/mp/collect?api_secret=%s&measurement_id=%s', [AGoogleApiSecret, AGooglePropertyID]);
  FURL := Format('https://www.google-analytics.com/mp/collect?api_secret=%s&measurement_id=%s', [AGoogleApiSecret, AGooglePropertyID]);

  FAppInfo := TModelGoogleAnalyticsFactory.New.AppInfo;
end;

destructor TControllerGoogleAnalytics.Destroy;
begin
  Sleep(500); // apenas para resolver o problema com a memoria ao fecha o sistema
  inherited;
end;

function TControllerGoogleAnalytics.Event(ACategory, AAction, ALabel: String; AValue: Integer = 0): iControllerGoogleAnalytics;
begin
  Result := Self;

  ValidaDados;

  TModelGoogleAnalyticsInvoker.New
    .Add(TModelGoogleAnalyticsFactory.New
    .Event(Self)
    .Category(ACategory)
    .Action(AAction)
    .EventLabel(ALabel)
    .EventValue(AValue)
    .Send)
    .Execute;
end;

function TControllerGoogleAnalytics.Exception(ADescription: String; AIsFatal: Boolean): iControllerGoogleAnalytics;
begin
  Result := Self;

  ValidaDados;

  TModelGoogleAnalyticsInvoker.New
    .Add(TModelGoogleAnalyticsFactory.New
    .Exception(Self)
    .Description(ADescription)
    .isFatal(AIsFatal)
    .Send)
    .Execute;
end;

function TControllerGoogleAnalytics.GetScreenResolution: string;
begin
  Result := Screen.Width.Tostring + 'x' + Screen.Height.Tostring;
end;

function TControllerGoogleAnalytics.GetSystemPlatform: string;
var
  Reg: TRegistry;
begin
  Result := '';

  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKeyReadOnly('SOFTWARE\Microsoft\Windows NT\CurrentVersion') then
    begin
      Result := Format('%s - %s', [Reg.ReadString('ProductName'),
        Reg.ReadString('BuildLabEx')]);
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

function TControllerGoogleAnalytics.GoogleApiSecret(Value: String): iControllerGoogleAnalytics;
begin
  Result := Self;

  FGoogleApiSecret := Value;
end;

function TControllerGoogleAnalytics.GoogleApiSecret: String;
begin
  Result := FGoogleApiSecret;
end;

function TControllerGoogleAnalytics.GooglePropertyID(
  Value: String): iControllerGoogleAnalytics;
begin
  Result := Self;

  FGooglePropertyID := Value;
end;

function TControllerGoogleAnalytics.GuidCreate: string;
var
  ID: TGUID;
begin
  Result := '';
  if CoCreateGuid(ID) = S_OK then
    Result := GUIDToString(ID);
end;

function TControllerGoogleAnalytics.Login(AMethod: String): iControllerGoogleAnalytics;
begin
  Result := Self;

  TModelGoogleAnalyticsInvoker.New
    .Add(TModelGoogleAnalyticsFactory.New
    .Login(Self)
    .Method(AMethod)
    .Send)
    .Execute;
end;

function TControllerGoogleAnalytics.GooglePropertyID: String;
begin
  Result := FGooglePropertyID;
end;

class function TControllerGoogleAnalytics.New(AGooglePropertyID: String; AGoogleApiSecret: string; AUserID: String = ''): iControllerGoogleAnalytics;
begin
  if not Assigned(FInstance) then
    FInstance := Self.Create(AGooglePropertyID, AGoogleApiSecret, AUserID)
  else
    FInstance
      .GooglePropertyID(AGooglePropertyID)
      .GoogleApiSecret(AGoogleApiSecret)
      .UserID(AUserID);

  Result := FInstance;
end;

function TControllerGoogleAnalytics.PageView(ADocumentHostName, APage, ATitle: String): iControllerGoogleAnalytics;
begin
  Result := Self;

  ValidaDados;

  TModelGoogleAnalyticsInvoker.New
    .Add(TModelGoogleAnalyticsFactory.New
    .PageView(Self)
    .DocumentHostName(ADocumentHostName)
    .Page(APage)
    .Title(ATitle)
    .Send)
    .Execute;
end;

function TControllerGoogleAnalytics.Purchase(aCoupon: string; AValue: currency; aTransactionId: string; aUserData: iModelUserData;
  aItems: TArray<iModelGooglePurchaseItems>): iControllerGoogleAnalytics;
begin
  Result := Self;

  TModelGoogleAnalyticsInvoker.New
    .Add(TModelGoogleAnalyticsFactory.New
    .Purchase(Self)
    .coupon(aCoupon)
    .transaction_id(aTransactionId)
    .Value(AValue)
    .items(aItems)
    .userData(aUserData)
    .Send)
    .Execute;
end;

function TControllerGoogleAnalytics.AddPayment(aCoupon: string;
  AValue: currency; aPaymentType: string; aUserData: iModelUserData;
  aItems: TArray<iModelGoogleAddPaymentInfoItems>): iControllerGoogleAnalytics;
begin
  Result := Self;

  TModelGoogleAnalyticsInvoker.New
    .Add(TModelGoogleAnalyticsFactory.New
    .AddPayment(Self)
    .coupon(aCoupon)
    .payment_type(aPaymentType)
    .Value(AValue)
    .items(aItems)
    .userData(aUserData)
    .Send)
    .Execute;
end;

function TControllerGoogleAnalytics.ScreenResolution: String;
begin
  Result := FScreenResolution;
end;

function TControllerGoogleAnalytics.ScreenView(AScreenName: String): iControllerGoogleAnalytics;
begin
  Result := Self;

  ValidaDados;

  TModelGoogleAnalyticsInvoker.New
    .Add(TModelGoogleAnalyticsFactory.New
    .ScreeView(Self)
    .ScreenName(AScreenName)
    .Send)
    .Execute;
end;

function TControllerGoogleAnalytics.SystemPlatform: String;
begin
  Result := FSystemPlatform;
end;

function TControllerGoogleAnalytics.URL(
  Value: String): iControllerGoogleAnalytics;
begin
  Result := Self;

  FURL := Value;
end;

function TControllerGoogleAnalytics.URL: String;
begin
  Result := FURL;
end;

function TControllerGoogleAnalytics.UserID(
  Value: String): iControllerGoogleAnalytics;
begin
  Result := Self;

  FUserID := THashSHA2.GetHashString(Value);
end;

procedure TControllerGoogleAnalytics.ValidaDados;
begin
  if Trim(FGooglePropertyID) = '' then
    raise System.SysUtils.Exception.Create('Google Property ID "TID" n�o informado!');
end;

function TControllerGoogleAnalytics.UserID: String;
begin
  Result := FUserID;
end;

end.

unit Google.Model.Analytics.Factory;

interface

uses
  Google.Model.Analytics.Factory.Interfaces,
  Google.Model.Analytics.Interfaces,
  Google.Controller.Analytics.Interfaces;

type
  TModelGoogleAnalyticsFactory = Class(TInterfacedObject, iModelGoogleAnalyticsFactory)
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iModelGoogleAnalyticsFactory;

    function AppInfo: iModelGoogleAppInfo;
    function ScreeView(AParent: iControllerGoogleAnalytics): iModelGoogleScreeView;
    function PageView(AParent: iControllerGoogleAnalytics): iModelGooglePageView;
    function Event(AParent: iControllerGoogleAnalytics): iModelGoogleEvent;
    function Exception(AParent: iControllerGoogleAnalytics): iModelGoogleException;
    function Login(AParent: iControllerGoogleAnalytics): iModelGoogleLogin;
    function Purchase(AParent: iControllerGoogleAnalytics): iModelGooglePurchase;
    function AddPayment(AParent: iControllerGoogleAnalytics): iModelGoogleAddPayment;
  End;

implementation

uses
  Google.Model.Analytics.AppInfo,
  Google.Model.Analytics.Event,
  Google.Model.Analytics.Exception,
  Google.Model.Analytics.PageView,
  Google.Model.Analytics.Login,
  Google.Model.Analytics.Purchase,
  Google.Model.Analytics.PaymentInfo,
  Google.Model.Analytics.ScreenView;

{ TModelGoogleAnalyticsFactory }

function TModelGoogleAnalyticsFactory.AddPayment(
  AParent: iControllerGoogleAnalytics): iModelGoogleAddPayment;
begin
  Result := TModelGooglePaymentInfo.New(AParent);
end;

function TModelGoogleAnalyticsFactory.AppInfo: iModelGoogleAppInfo;
begin
  Result := TModelGoogleAppInfo.New;
end;

constructor TModelGoogleAnalyticsFactory.Create;
begin

end;

destructor TModelGoogleAnalyticsFactory.Destroy;
begin

  inherited;
end;

function TModelGoogleAnalyticsFactory.Event(
  AParent: iControllerGoogleAnalytics): iModelGoogleEvent;
begin
  Result := TModelGoogleAnalyticsEvent.New(AParent);
end;

function TModelGoogleAnalyticsFactory.Exception(
  AParent: iControllerGoogleAnalytics): iModelGoogleException;
begin
  Result := TModelGoogleAnalyticsException.New(AParent);
end;

function TModelGoogleAnalyticsFactory.Login(
  AParent: iControllerGoogleAnalytics): iModelGoogleLogin;
begin
  Result := TModelGoogleAnalyticsLogin.New(AParent);
end;

class function TModelGoogleAnalyticsFactory.New: iModelGoogleAnalyticsFactory;
begin
  Result := Self.Create;
end;

function TModelGoogleAnalyticsFactory.PageView(
  AParent: iControllerGoogleAnalytics): iModelGooglePageView;
begin
  Result := TModelGoogleAnalyticsPageView.New(AParent);
end;

function TModelGoogleAnalyticsFactory.Purchase(
  AParent: iControllerGoogleAnalytics): iModelGooglePurchase;
begin
  Result := TModelGoogleAnalyticsPurchase.New(AParent);
end;

function TModelGoogleAnalyticsFactory.ScreeView(
  AParent: iControllerGoogleAnalytics): iModelGoogleScreeView;
begin
  Result := TModelGoogleAnalyticsScreenView.New(AParent);
end;

end.

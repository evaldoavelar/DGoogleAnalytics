unit Google.Model.Analytics.Factory.Interfaces;

interface

uses
  Google.Model.Analytics.Interfaces,
  Google.Controller.Analytics.Interfaces;

type
  iModelGoogleAnalyticsFactory = interface
    ['{8C1A956E-AC9B-4CB6-8C92-83C99374465D}']
    function AppInfo: iModelGoogleAppInfo;
    function ScreeView(AParent: iControllerGoogleAnalytics): iModelGoogleScreeView;
    function PageView(AParent: iControllerGoogleAnalytics): iModelGooglePageView;
    function Event(AParent: iControllerGoogleAnalytics): iModelGoogleEvent;
    function Exception(AParent: iControllerGoogleAnalytics): iModelGoogleException;
    function Login(AParent: iControllerGoogleAnalytics): iModelGoogleLogin;
    function Purchase(AParent: iControllerGoogleAnalytics): iModelGooglePurchase;
    function AddPayment(AParent: iControllerGoogleAnalytics): iModelGoogleAddPayment;
  end;

implementation

end.

unit Google.Controller.Analytics.Interfaces;

interface

uses
  Google.Model.Analytics.Interfaces, System.JSON;

type
  iControllerGoogleAnalytics = interface
    ['{7D7E3C3C-7A5C-4EBB-A7B0-65603FF317C6}']
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
    function Purchase(aCoupon: string; AValue: currency; aTransactionId: string;
      aUserData: iModelUserData; aItems: TArray<iModelGooglePurchaseItems>): iControllerGoogleAnalytics;
    function AddPayment(aCoupon: string; AValue: currency; aPaymentType: string;
      aUserData: iModelUserData; aItems: TArray<iModelGoogleAddPaymentInfoItems>): iControllerGoogleAnalytics;
  end;

implementation

end.

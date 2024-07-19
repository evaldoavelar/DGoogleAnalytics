unit Google.Model.Analytics.Interfaces;

interface

uses system.Generics.Collections, system.JSON;

type
  TOperationSession = (osStart, osEnd);

  iCommand = interface
    ['{B7514473-F219-4FC2-B67E-97D0138DE38C}']
    function Execute: iCommand;
  end;

  iInvoker = interface
    ['{7C0D535E-EB23-447A-82AE-EDE881C37F60}']
    function Add(Value: iCommand): iInvoker;
    function Execute: iInvoker;
  end;

  iModelGoogleAppInfo = interface
    ['{19A03691-80BC-413E-A6F5-EB27E91F1648}']
    function AppName: String; overload;
    function AppName(Value: String): iModelGoogleAppInfo; overload;
    function AppVersion: String; overload;
    function AppVersion(Value: String): iModelGoogleAppInfo; overload;
    function AppID: String; overload;
    function AppID(Value: String): iModelGoogleAppInfo; overload;
    function AppInstalerID: String; overload;
    function AppInstalerID(Value: String): iModelGoogleAppInfo; overload;
    function AppLicense: String; overload;
    function AppLicense(Value: String): iModelGoogleAppInfo; overload;
    function AppEdition: String; overload;
    function AppEdition(Value: String): iModelGoogleAppInfo; overload;
  end;

  iModelGoogleEvent = interface
    ['{42F17F3B-099D-4E0D-BCE7-FED8B78C97D6}']
    function Category: String; overload;
    function Category(Value: String): iModelGoogleEvent; overload;
    function Action: String; overload;
    function Action(Value: String): iModelGoogleEvent; overload;
    function EventLabel: String; overload;
    function EventLabel(Value: String): iModelGoogleEvent; overload;
    function EventValue: Integer; overload;
    function EventValue(Value: Integer): iModelGoogleEvent; overload;
    function Send: iCommand;
  end;

  iModelGoogleException = interface
    ['{B64974BB-1D90-4CF9-BB11-04D6FF7B573C}']
    function Description: String; overload;
    function Description(Value: String): iModelGoogleException; overload;
    function isFatal: Boolean; overload;
    function isFatal(Value: Boolean): iModelGoogleException; overload;
    function Send: iCommand;
  end;

  iModelGoogleScreeView = interface
    ['{0E97F395-EA31-4F46-8E21-CA0F1AF9FA35}']
    function ScreenName: String; overload;
    function ScreenName(Value: String): iModelGoogleScreeView; overload;
    function Send: iCommand;
  end;

  iModelGoogleLogin = interface
    ['{AAB822C9-A716-46A3-B244-6B0B4E2DF338}']
    function Method: String; overload;
    function Method(Value: String): iModelGoogleLogin; overload;
    function Send: iCommand;
  end;

  iModelGooglePageView = interface
    ['{91B15DC3-50AC-493B-894E-815AE8A40708}']
    function DocumentHostName: String; overload;
    function DocumentHostName(Value: String): iModelGooglePageView; overload;
    function Page: String; overload;
    function Page(Value: String): iModelGooglePageView; overload;
    function Title: String; overload;
    function Title(Value: String): iModelGooglePageView; overload;
    function Send: iCommand;
  end;

  iModelGoogleSession = interface
    ['{66E614FD-5CC5-4457-97EE-7173FB3274F0}']
    function Operation(AOperation: TOperationSession): iModelGoogleSession; overload;
    function Operation: TOperationSession; overload;
    function Send: iCommand;
  end;

  iModelGooglePurchaseItems = interface
    ['{392A8AF2-56A8-4EAF-8B92-402F173A1646}']
    function item_id: String; overload;
    function item_id(Value: String): iModelGooglePurchaseItems; overload;
    function item_name: String; overload;
    function item_name(Value: String): iModelGooglePurchaseItems; overload;
    function affiliation: String; overload;
    function affiliation(Value: String): iModelGooglePurchaseItems; overload;
    function coupon: String; overload;
    function coupon(Value: String): iModelGooglePurchaseItems; overload;
    function currency: String; overload;
    function currency(Value: String): iModelGooglePurchaseItems; overload;
    function discount: currency; overload;
    function discount(Value: currency): iModelGooglePurchaseItems; overload;
    function index: Integer; overload;
    function index(Value: Integer): iModelGooglePurchaseItems; overload;
    function item_brand: String; overload;
    function item_brand(Value: String): iModelGooglePurchaseItems; overload;
    function item_category: String; overload;
    function item_category(Value: String): iModelGooglePurchaseItems; overload;
    function item_category2: String; overload;
    function item_category2(Value: String): iModelGooglePurchaseItems; overload;
    function item_category3: String; overload;
    function item_category3(Value: String): iModelGooglePurchaseItems; overload;
    function item_category4: String; overload;
    function item_category4(Value: String): iModelGooglePurchaseItems; overload;
    function item_category5: String; overload;
    function item_category5(Value: String): iModelGooglePurchaseItems; overload;
    function item_list_id: String; overload;
    function item_list_id(Value: String): iModelGooglePurchaseItems; overload;
    function item_list_name: String; overload;
    function item_list_name(Value: String): iModelGooglePurchaseItems; overload;
    function item_variant: String; overload;
    function item_variant(Value: String): iModelGooglePurchaseItems; overload;
    function location_id: String; overload;
    function location_id(Value: String): iModelGooglePurchaseItems; overload;
    function price: currency; overload;
    function price(Value: currency): iModelGooglePurchaseItems; overload;
    function quantity: double; overload;
    function quantity(Value: double): iModelGooglePurchaseItems; overload;
  end;

  iModelUserData = interface
    ['{21380AAA-3326-4C60-A05E-84BD177B734C}']
    function UserDataEmailAdrress: String; overload;
    function UserDataEmailAdrress(Value: String): iModelUserData; overload;
    function UserDataCity: String; overload;
    function UserDataCity(Value: String): iModelUserData; overload;
    function UserDataFirstName: String; overload;
    function UserDataFirstName(Value: String): iModelUserData; overload;
    function UserDataPostalCode: String; overload;
    function UserDataPostalCode(Value: String): iModelUserData; overload;
    function UserDataRegion: String; overload;
    function UserDataRegion(Value: String): iModelUserData; overload;
    function UserDataCountry: String; overload;
    function UserDataCountry(Value: String): iModelUserData; overload;
    function ToJson: TJsonObject;
  end;

  iModelGooglePurchase = interface
    ['{D89447A8-E5B9-4CC8-926B-023884C976AE}']
    function currency: String; overload;
    function currency(Value: String): iModelGooglePurchase; overload;
    function transaction_id: String; overload;
    function transaction_id(Value: String): iModelGooglePurchase; overload;
    function Value: currency; overload;
    function Value(Value: currency): iModelGooglePurchase; overload;
    function coupon: String; overload;
    function coupon(Value: String): iModelGooglePurchase; overload;
    function shipping: currency; overload;
    function shipping(Value: currency): iModelGooglePurchase; overload;
    function tax: currency; overload;
    function tax(Value: currency): iModelGooglePurchase; overload;

    function items: TArray<iModelGooglePurchaseItems>; overload;
    function items(Value: TArray<iModelGooglePurchaseItems>): iModelGooglePurchase; overload;

    function UserData: iModelUserData; overload;
    function UserData(Value: iModelUserData): iModelGooglePurchase; overload;

    function Send: iCommand;
  end;

  iModelGoogleAddPaymentInfoItems = interface
    ['{D2D716CB-1B77-4CD2-B369-69B1FE2717B8}']
    function item_id: String; overload;
    function item_id(Value: String): iModelGoogleAddPaymentInfoItems; overload;
    function item_name: String; overload;
    function item_name(Value: String): iModelGoogleAddPaymentInfoItems; overload;
    function affiliation: String; overload;
    function affiliation(Value: String): iModelGoogleAddPaymentInfoItems; overload;
    function coupon: String; overload;
    function coupon(Value: String): iModelGoogleAddPaymentInfoItems; overload;
    function creative_name: String; overload;
    function creative_name(Value: String): iModelGoogleAddPaymentInfoItems; overload;
    function creative_slot: String; overload;
    function creative_slot(Value: String): iModelGoogleAddPaymentInfoItems; overload;
    function discount: currency; overload;
    function discount(Value: currency): iModelGoogleAddPaymentInfoItems; overload;
    function index: Integer; overload;
    function index(Value: Integer): iModelGoogleAddPaymentInfoItems; overload;
    function item_brand: String; overload;
    function item_brand(Value: String): iModelGoogleAddPaymentInfoItems; overload;
    function item_category: String; overload;
    function item_category(Value: String): iModelGoogleAddPaymentInfoItems; overload;
    function item_category2: String; overload;
    function item_category2(Value: String): iModelGoogleAddPaymentInfoItems; overload;
    function item_category3: String; overload;
    function item_category3(Value: String): iModelGoogleAddPaymentInfoItems; overload;
    function item_category4: String; overload;
    function item_category4(Value: String): iModelGoogleAddPaymentInfoItems; overload;
    function item_category5: String; overload;
    function item_category5(Value: String): iModelGoogleAddPaymentInfoItems; overload;
    function item_list_id: String; overload;
    function item_list_id(Value: String): iModelGoogleAddPaymentInfoItems; overload;
    function item_list_name: String; overload;
    function item_list_name(Value: String): iModelGoogleAddPaymentInfoItems; overload;
    function item_variant: String; overload;
    function item_variant(Value: String): iModelGoogleAddPaymentInfoItems; overload;
    function location_id: String; overload;
    function location_id(Value: String): iModelGoogleAddPaymentInfoItems; overload;
    function price: currency; overload;
    function price(Value: currency): iModelGoogleAddPaymentInfoItems; overload;
    function promotion_id: String; overload;
    function promotion_id(Value: String): iModelGoogleAddPaymentInfoItems; overload;
    function promotion_name: String; overload;
    function promotion_name(Value: String): iModelGoogleAddPaymentInfoItems; overload;
    function quantity: double; overload;
    function quantity(Value: double): iModelGoogleAddPaymentInfoItems; overload;
  end;

  iModelGoogleAddPayment = interface
    ['{8B9DCAE8-02CA-437A-B82E-87414927D18D}']
    function currency: String; overload;
    function currency(Value: String): iModelGoogleAddPayment; overload;
    function Value: currency; overload;
    function Value(Value: currency): iModelGoogleAddPayment; overload;
    function coupon: String; overload;
    function coupon(Value: String): iModelGoogleAddPayment; overload;
    function payment_type: String; overload;
    function payment_type(Value: String): iModelGoogleAddPayment; overload;
    function items: TArray<iModelGoogleAddPaymentInfoItems>; overload;
    function items(Value: TArray<iModelGoogleAddPaymentInfoItems>): iModelGoogleAddPayment; overload;

    function UserData: iModelUserData; overload;
    function UserData(Value: iModelUserData): iModelGoogleAddPayment; overload;

    function Send: iCommand;

  end;

implementation

end.

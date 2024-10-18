unit Google.Model.Analytics.PaymentInfo;

interface

uses
  system.Generics.Collections,
  Google.Model.Analytics.Interfaces,
  system.JSON,
  Google.Controller.Analytics.Interfaces;

type
  TModelGoogleAddPaymentInfoItems = Class(TInterfacedObject, iModelGoogleAddPaymentInfoItems)

  private
    FItemID: String;
    FItemName: String;
    FAffiliation: String;
    FCoupon: String;
    FDiscount: currency;
    Findex: Integer;
    FItemBrand: String;
    FItemCategory: String;
    FItemCategory2: String;
    FItemCategory3: String;
    FItemCategory4: String;
    FItemCategory5: String;
    FItemListID: String;
    FItemListName: String;
    FItemVariant: String;
    FLocationID: String;
    FPrice: currency;
    FQuantity: double;
    FPromotion_id: String;
    FPromotion_name: String;
    FCreative_name: String;
    FCreative_slot: String;

  public
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
  public
    class function New(): iModelGoogleAddPaymentInfoItems;
    constructor Create();
    destructor Destroy; override;
  end;

  TModelGooglePaymentInfo = Class(TInterfacedObject, iModelGoogleAddPayment, iCommand)
  private
    [weak]
    FParent: iControllerGoogleAnalytics;
    FItems: TArray<iModelGoogleAddPaymentInfoItems>;
    FCoupon: string;
    FCurrency: string;
    FPayment_type: string;
    FShipping: currency;
    FValue: currency;
    FTax: currency;
    FUserData: iModelUserData;
  public
    constructor Create(AParent: iControllerGoogleAnalytics);
    destructor Destroy; override;
    class function New(AParent: iControllerGoogleAnalytics): iModelGoogleAddPayment;

  public
    function currency: String; overload;
    function currency(aValue: String): iModelGoogleAddPayment; overload;
    function Value: currency; overload;
    function Value(aValue: currency): iModelGoogleAddPayment; overload;
    function coupon: String; overload;
    function coupon(aValue: String): iModelGoogleAddPayment; overload;
    function payment_type: String; overload;
    function payment_type(aValue: String): iModelGoogleAddPayment; overload;
    function items: TArray<iModelGoogleAddPaymentInfoItems>; overload;
    function items(aValue: TArray<iModelGoogleAddPaymentInfoItems>): iModelGoogleAddPayment; overload;

    function UserData: iModelUserData; overload;
    function UserData(aValue: iModelUserData): iModelGoogleAddPayment; overload;

    function Send: iCommand;
    // iCommand
    function Execute: iCommand;
  End;

implementation

uses
  system.Net.HttpClientComponent, system.Classes, system.SysUtils,
  system.StrUtils, system.Hash, Winapi.Windows;

function TModelGooglePaymentInfo.coupon: String;
begin
  result := FCoupon;
end;

function TModelGooglePaymentInfo.coupon(aValue: String): iModelGoogleAddPayment;
begin
  result := self;
  FCoupon := aValue;
end;

constructor TModelGooglePaymentInfo.Create(
  AParent: iControllerGoogleAnalytics);
begin
  FParent := AParent;
  FCurrency := 'BRL'
end;

function TModelGooglePaymentInfo.currency(
  aValue: String): iModelGoogleAddPayment;
begin
  result := self;
  FCurrency := aValue;
end;

function TModelGooglePaymentInfo.currency: String;
begin
  result := FCurrency;
end;

destructor TModelGooglePaymentInfo.Destroy;
begin
  inherited;
end;

function TModelGooglePaymentInfo.Execute: iCommand;
var
  HTTPClient: TNetHTTPClient;
  JSONObj: TJsonObject;
  JSONEvent: TJsonObject;
  JSONParams: TJsonObject;
  JSONArray: TJSONArray;
  JSONItems: TJSONArray;
  JSONItem: TJsonObject;
  JSON: TStringStream;
begin
  result := self;
  JSON := nil;
  HTTPClient := TNetHTTPClient.Create(nil);
  JSONObj := TJsonObject.Create;
  try

    JSONObj.AddPair('client_id', FParent.ClienteID);
    if FParent.UserID <> '' then
      JSONObj.AddPair('user_id', FParent.UserID);

    // JSONObj.AddPair('non_personalized_ads', 'false');

    (* Event *)
    JSONEvent := TJsonObject.Create;
    JSONEvent.AddPair('name', 'add_payment_info');
    JSONParams := TJsonObject.Create;
    JSONParams.AddPair('currency', FCurrency);
    JSONParams.AddPair('payment_type', FPayment_type);
    JSONParams.AddPair('value', FValue);
    JSONParams.AddPair('coupon', FCoupon);
    if FShipping > 0 then
      JSONParams.AddPair('shipping', FShipping);
    if FTax > 0 then
      JSONParams.AddPair('tax', FTax);

    JSONItems := TJSONArray.Create;
    for var item in FItems do
    begin
      JSONItem := TJsonObject.Create;

      JSONItem.AddPair('item_id', item.item_id);
      JSONItem.AddPair('item_name', item.item_name);
      if (item.affiliation <> '') then
        JSONItem.AddPair('affiliation', item.affiliation);
      if (item.coupon <> '') then
        JSONItem.AddPair('coupon', item.coupon);
      if (item.creative_name <> '') then
        JSONItem.AddPair('creative_name', item.creative_name);
      if (item.creative_slot <> '') then
        JSONItem.AddPair('creative_slot', item.creative_slot);
      if (item.promotion_id <> '') then
        JSONItem.AddPair('promotion_id', item.promotion_id);
      if (item.promotion_name <> '') then
        JSONItem.AddPair('promotion_name', item.promotion_name);
      JSONItem.AddPair('discount', item.discount);
      if (item.item_brand <> '') then
        JSONItem.AddPair('item_brand', item.item_brand);
      if (item.item_category <> '') then
        JSONItem.AddPair('item_category', item.item_category);
      if (item.item_category2 <> '') then
        JSONItem.AddPair('item_category2', item.item_category2);
      if (item.item_category3 <> '') then
        JSONItem.AddPair('item_category3', item.item_category3);
      if (item.item_category4 <> '') then
        JSONItem.AddPair('item_category4', item.item_category4);
      if (item.item_category5 <> '') then
        JSONItem.AddPair('item_category5', item.item_category5);
      if (item.item_variant <> '') then
        JSONItem.AddPair('item_variant', item.item_variant);
      if (item.item_list_name <> '') then
        JSONItem.AddPair('item_list_name', item.item_list_name);
      if (item.item_list_id <> '') then
        JSONItem.AddPair('item_list_id', item.item_list_id);
      if (item.promotion_id <> '') then
        JSONItem.AddPair('promotion_id', item.promotion_id);
      if (item.promotion_name <> '') then
        JSONItem.AddPair('promotion_name', item.promotion_name);
      JSONItem.AddPair('index', item.index);
      JSONItem.AddPair('quantity', item.quantity);
      JSONItem.AddPair('price', item.price);

      JSONItems.Add(JSONItem);
    end;

    JSONParams.AddPair('items', JSONItems);
    JSONEvent.AddPair('params', JSONParams);
    JSONArray := TJSONArray.Create;
    JSONArray.Add(JSONEvent);
    JSONObj.AddPair('events', JSONArray);

    JSONObj.AddPair('user_data', FUserData.ToJson);

    try
      JSON := TStringStream.Create(JSONObj.ToString, TEncoding.UTF8);
      //OutputDebugString(PWideChar(JSONObj.ToString));

      HTTPClient.ContentType := 'application/json';
      HTTPClient.AcceptEncoding := 'utf-8';
      var
      status := HTTPClient.Post(FParent.URL, JSON);

      //OutputDebugString(PWideChar(status.StatusCode.ToString));
      //OutputDebugString(PWideChar(status.ContentAsString(TEncoding.UTF8)));
    except
    end;
  finally
    HTTPClient.Free;
    JSONObj.Free;
    if Assigned(JSON) then
      JSON.Free;
  end;

end;

function TModelGooglePaymentInfo.items(aValue: TArray<iModelGoogleAddPaymentInfoItems>): iModelGoogleAddPayment;
begin
  result := self;

  FItems := aValue;
end;

function TModelGooglePaymentInfo.items: TArray<iModelGoogleAddPaymentInfoItems>;
begin
  result := FItems;
end;

class function TModelGooglePaymentInfo.New(
  AParent: iControllerGoogleAnalytics): iModelGoogleAddPayment;
begin
  result := TModelGooglePaymentInfo.Create(AParent);
end;

function TModelGooglePaymentInfo.payment_type(
  aValue: String): iModelGoogleAddPayment;
begin
  result := self;
  FPayment_type := aValue;
end;

function TModelGooglePaymentInfo.payment_type: String;
begin
  result := FPayment_type;
end;

function TModelGooglePaymentInfo.Send: iCommand;
begin
  result := self;
end;

function TModelGooglePaymentInfo.UserData(aValue: iModelUserData): iModelGoogleAddPayment;
begin
  result := self;

  FUserData := aValue;
end;

function TModelGooglePaymentInfo.UserData: iModelUserData;
begin
  result := FUserData;
end;

function TModelGooglePaymentInfo.Value: currency;
begin
  result := FValue;
end;

function TModelGooglePaymentInfo.Value(
  aValue: currency): iModelGoogleAddPayment;
begin
  result := self;
  FValue := aValue;
end;

{ TModelGoogleAddPaymentInfoItems }

function TModelGoogleAddPaymentInfoItems.affiliation(
  Value: String): iModelGoogleAddPaymentInfoItems;
begin
  result := self;
  FAffiliation := Value;
end;

function TModelGoogleAddPaymentInfoItems.affiliation: String;
begin
  result := FAffiliation;

end;

function TModelGoogleAddPaymentInfoItems.coupon: String;
begin
  result := FCoupon;
end;

function TModelGoogleAddPaymentInfoItems.coupon(
  Value: String): iModelGoogleAddPaymentInfoItems;
begin
  result := self;
  FCoupon := Value;
end;

constructor TModelGoogleAddPaymentInfoItems.Create();
begin

end;

function TModelGoogleAddPaymentInfoItems.creative_name: String;
begin
  result := FCreative_name;
end;

function TModelGoogleAddPaymentInfoItems.creative_name(
  Value: String): iModelGoogleAddPaymentInfoItems;
begin
  result := self;
  FCreative_name := Value;
end;

function TModelGoogleAddPaymentInfoItems.creative_slot(
  Value: String): iModelGoogleAddPaymentInfoItems;
begin
  result := self;
  FCreative_slot := Value;
end;

destructor TModelGoogleAddPaymentInfoItems.Destroy;
begin

  inherited;
end;

function TModelGoogleAddPaymentInfoItems.creative_slot: String;
begin
  result := FCreative_slot;
end;

function TModelGoogleAddPaymentInfoItems.discount(
  Value: currency): iModelGoogleAddPaymentInfoItems;
begin
  result := self;
  FDiscount := Value;
end;

function TModelGoogleAddPaymentInfoItems.discount: currency;
begin
  result := FDiscount;
end;

function TModelGoogleAddPaymentInfoItems.index: Integer;
begin
  result := Findex;
end;

function TModelGoogleAddPaymentInfoItems.index(
  Value: Integer): iModelGoogleAddPaymentInfoItems;
begin
  result := self;
  Findex := Value;
end;

function TModelGoogleAddPaymentInfoItems.item_brand(
  Value: String): iModelGoogleAddPaymentInfoItems;
begin
  result := self;
  FItemBrand := Value;
end;

function TModelGoogleAddPaymentInfoItems.item_brand: String;
begin
  result := FItemBrand;
end;

function TModelGoogleAddPaymentInfoItems.item_category(
  Value: String): iModelGoogleAddPaymentInfoItems;
begin
  result := self;
  FItemCategory := Value;
end;

function TModelGoogleAddPaymentInfoItems.item_category: String;
begin
  result := FItemCategory;
end;

function TModelGoogleAddPaymentInfoItems.item_category2: String;
begin
  result := FItemCategory2;
end;

function TModelGoogleAddPaymentInfoItems.item_category2(
  Value: String): iModelGoogleAddPaymentInfoItems;
begin
  result := self;
  FItemCategory2 := Value;
end;

function TModelGoogleAddPaymentInfoItems.item_category3(
  Value: String): iModelGoogleAddPaymentInfoItems;
begin
  result := self;
  FItemCategory3 := Value;
end;

function TModelGoogleAddPaymentInfoItems.item_category3: String;
begin
  result := FItemCategory3;
end;

function TModelGoogleAddPaymentInfoItems.item_category4(
  Value: String): iModelGoogleAddPaymentInfoItems;
begin
  result := self;
  FItemCategory4 := Value;
end;

function TModelGoogleAddPaymentInfoItems.item_category4: String;
begin
  result := FItemCategory4;
end;

function TModelGoogleAddPaymentInfoItems.item_category5: String;
begin
  result := FItemCategory5;
end;

function TModelGoogleAddPaymentInfoItems.item_category5(
  Value: String): iModelGoogleAddPaymentInfoItems;
begin
  result := self;
  FItemCategory5 := Value;
end;

function TModelGoogleAddPaymentInfoItems.item_id(
  Value: String): iModelGoogleAddPaymentInfoItems;
begin
  result := self;
  FItemID := Value;
end;

function TModelGoogleAddPaymentInfoItems.item_id: String;
begin
  result := FItemID;
end;

function TModelGoogleAddPaymentInfoItems.item_list_id: String;
begin
  result := FItemListID;
end;

function TModelGoogleAddPaymentInfoItems.item_list_id(
  Value: String): iModelGoogleAddPaymentInfoItems;
begin
  result := self;
  FItemListID := Value;
end;

function TModelGoogleAddPaymentInfoItems.item_list_name(
  Value: String): iModelGoogleAddPaymentInfoItems;
begin
  result := self;
  FItemListName := Value;
end;

function TModelGoogleAddPaymentInfoItems.item_list_name: String;
begin
  result := FItemListName;
end;

function TModelGoogleAddPaymentInfoItems.item_name(
  Value: String): iModelGoogleAddPaymentInfoItems;
begin
  result := self;
  FItemName := Value;
end;

function TModelGoogleAddPaymentInfoItems.item_name: String;
begin
  result := FItemName;
end;

function TModelGoogleAddPaymentInfoItems.item_variant(
  Value: String): iModelGoogleAddPaymentInfoItems;
begin
  result := self;
  FItemVariant := Value;
end;

function TModelGoogleAddPaymentInfoItems.item_variant: String;
begin
  result := FItemVariant;
end;

function TModelGoogleAddPaymentInfoItems.location_id(
  Value: String): iModelGoogleAddPaymentInfoItems;
begin
  result := self;
  FLocationID := Value;
end;

class function TModelGoogleAddPaymentInfoItems.New: iModelGoogleAddPaymentInfoItems;
begin
  result := TModelGoogleAddPaymentInfoItems.Create;
end;

function TModelGoogleAddPaymentInfoItems.location_id: String;
begin
  result := FLocationID;
end;

function TModelGoogleAddPaymentInfoItems.price(
  Value: currency): iModelGoogleAddPaymentInfoItems;
begin
  result := self;
  FPrice := Value;
end;

function TModelGoogleAddPaymentInfoItems.price: currency;
begin
  result := FPrice;
end;

function TModelGoogleAddPaymentInfoItems.promotion_id: String;
begin
  result := FPromotion_id;
end;

function TModelGoogleAddPaymentInfoItems.promotion_id(
  Value: String): iModelGoogleAddPaymentInfoItems;
begin
  result := self;
  FPromotion_id := Value;
end;

function TModelGoogleAddPaymentInfoItems.promotion_name(
  Value: String): iModelGoogleAddPaymentInfoItems;
begin
  result := self;
  FPromotion_name := Value;
end;

function TModelGoogleAddPaymentInfoItems.promotion_name: String;
begin
  result := FPromotion_name;
end;

function TModelGoogleAddPaymentInfoItems.quantity: double;
begin
  result := FQuantity;
end;

function TModelGoogleAddPaymentInfoItems.quantity(
  Value: double): iModelGoogleAddPaymentInfoItems;
begin
  result := self;
  FQuantity := Value;
end;

end.

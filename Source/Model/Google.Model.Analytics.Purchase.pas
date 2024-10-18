unit Google.Model.Analytics.Purchase;

interface

uses
  system.Generics.Collections,
  Google.Model.Analytics.Interfaces,
  system.JSON,
  Google.Controller.Analytics.Interfaces;

type

  TModelGoogleAnalyticsPurchaseItems = Class(TInterfacedObject, iModelGooglePurchaseItems)
  private
    FItemID: String;
    FItemName: String;
    FAffiliation: String;
    FCoupon: String;
    FCurrency: String;
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
  public
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
  public
    class function New: iModelGooglePurchaseItems;
  end;

  TModelGoogleAnalyticsPurchase = Class(TInterfacedObject, iModelGooglePurchase, iCommand)
  private
    [weak]
    FParent: iControllerGoogleAnalytics;
    FItems: TArray<iModelGooglePurchaseItems>;
    FCoupon: string;
    FCurrency: string;
    FTransactionID: string;
    FShipping: currency;
    FValue: currency;
    FTax: currency;
    FUserData: iModelUserData;
  public
    constructor Create(AParent: iControllerGoogleAnalytics);
    destructor Destroy; override;
    class function New(AParent: iControllerGoogleAnalytics): iModelGooglePurchase;

  public
    // iModelGooglePurchase
    function currency: String; overload;
    function currency(aValue: String): iModelGooglePurchase; overload;
    function transaction_id: String; overload;
    function transaction_id(aValue: String): iModelGooglePurchase; overload;
    function Value: currency; overload;
    function Value(aValue: currency): iModelGooglePurchase; overload;
    function coupon: String; overload;
    function coupon(aValue: String): iModelGooglePurchase; overload;
    function shipping: currency; overload;
    function shipping(aValue: currency): iModelGooglePurchase; overload;
    function tax: currency; overload;
    function tax(aValue: currency): iModelGooglePurchase; overload;
    function items: TArray<iModelGooglePurchaseItems>; overload;
    function items(aValue: TArray<iModelGooglePurchaseItems>): iModelGooglePurchase; overload;
    function UserData: iModelUserData; overload;
    function UserData(Value: iModelUserData): iModelGooglePurchase; overload;

    function Send: iCommand;

    // iCommand
    function Execute: iCommand;
  End;

implementation

uses
  system.Net.HttpClientComponent, system.Classes, system.SysUtils,
  system.StrUtils, system.Hash, Winapi.Windows;

{ TModelGoogleAnalyticsException }

function TModelGoogleAnalyticsPurchase.coupon: String;
begin
  result := FCoupon;
end;

function TModelGoogleAnalyticsPurchase.coupon(
  aValue: String): iModelGooglePurchase;
begin
  result := self;
  FCoupon := aValue;
end;

constructor TModelGoogleAnalyticsPurchase.Create(
  AParent: iControllerGoogleAnalytics);
begin
  FParent := AParent;
  FCurrency := 'BRL'
end;

function TModelGoogleAnalyticsPurchase.currency: String;
begin
  result := FCurrency;
end;

function TModelGoogleAnalyticsPurchase.currency(
  aValue: String): iModelGooglePurchase;
begin
  result := self;
  FCurrency := aValue;
end;

destructor TModelGoogleAnalyticsPurchase.Destroy;
begin
  inherited;
end;

function TModelGoogleAnalyticsPurchase.Execute: iCommand;
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
  try
    JSONObj := TJsonObject.Create;

    JSONObj.AddPair('client_id', FParent.ClienteID);
    if FParent.UserID <> '' then
      JSONObj.AddPair('user_id', FParent.UserID);

    // JSONObj.AddPair('non_personalized_ads', 'false');

    (* Event *)
    JSONEvent := TJsonObject.Create;
    JSONEvent.AddPair('name', 'purchase');
    JSONParams := TJsonObject.Create;
    JSONParams.AddPair('currency', FCurrency);
    JSONParams.AddPair('transaction_id', FTransactionID);
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
      JSONItem.AddPair('coupon', item.coupon);
      JSONItem.AddPair('currency', item.currency);
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

function TModelGoogleAnalyticsPurchase.items(
  aValue: TArray<iModelGooglePurchaseItems>): iModelGooglePurchase;
begin
  result := self;

  FItems := aValue;
end;

function TModelGoogleAnalyticsPurchase.items: TArray<iModelGooglePurchaseItems>;
begin
  result := FItems;
end;

class function TModelGoogleAnalyticsPurchase.New(
  AParent: iControllerGoogleAnalytics): iModelGooglePurchase;
begin
  result := TModelGoogleAnalyticsPurchase.Create(AParent);
end;

function TModelGoogleAnalyticsPurchase.Send: iCommand;
begin
  result := self;
end;

function TModelGoogleAnalyticsPurchase.shipping(
  aValue: currency): iModelGooglePurchase;
begin
  result := self;
  FShipping := aValue;
end;

function TModelGoogleAnalyticsPurchase.shipping: currency;
begin
  result := FShipping;
end;

function TModelGoogleAnalyticsPurchase.tax: currency;
begin
  result := FTax;

end;

function TModelGoogleAnalyticsPurchase.tax(
  aValue: currency): iModelGooglePurchase;
begin
  result := self;
  FTax := aValue;
end;

function TModelGoogleAnalyticsPurchase.transaction_id: String;
begin
  result := FTransactionID;
end;

function TModelGoogleAnalyticsPurchase.transaction_id(
  aValue: String): iModelGooglePurchase;
begin
  result := self;
  FTransactionID := aValue;
end;

function TModelGoogleAnalyticsPurchase.UserData(
  Value: iModelUserData): iModelGooglePurchase;
begin
  result := self;

  FUserData := Value;
end;

function TModelGoogleAnalyticsPurchase.UserData: iModelUserData;
begin
  result := FUserData;
end;

function TModelGoogleAnalyticsPurchase.Value: currency;
begin
  result := FValue;
end;

function TModelGoogleAnalyticsPurchase.Value(
  aValue: currency): iModelGooglePurchase;
begin
  result := self;
  FValue := aValue;
end;

{ TModelGoogleAnalyticsPurchaseItems }

function TModelGoogleAnalyticsPurchaseItems.affiliation(
  Value: String): iModelGooglePurchaseItems;
begin
  result := self;
  FAffiliation := Value;
end;

function TModelGoogleAnalyticsPurchaseItems.affiliation: String;
begin
  result := FAffiliation;
end;

function TModelGoogleAnalyticsPurchaseItems.coupon: String;
begin
  result := FCoupon;
end;

function TModelGoogleAnalyticsPurchaseItems.coupon(
  Value: String): iModelGooglePurchaseItems;
begin
  result := self;
  FCoupon := Value;
end;

function TModelGoogleAnalyticsPurchaseItems.currency: String;
begin
  result := FCurrency;
end;

function TModelGoogleAnalyticsPurchaseItems.currency(
  Value: String): iModelGooglePurchaseItems;
begin
  result := self;
  FCurrency := Value;
end;

function TModelGoogleAnalyticsPurchaseItems.discount: currency;
begin
  result := FDiscount;
end;

function TModelGoogleAnalyticsPurchaseItems.discount(
  Value: currency): iModelGooglePurchaseItems;
begin
  result := self;
  FDiscount := Value;
end;

function TModelGoogleAnalyticsPurchaseItems.index(
  Value: Integer): iModelGooglePurchaseItems;
begin
  result := self;
  Findex := Value;
end;

function TModelGoogleAnalyticsPurchaseItems.index: Integer;
begin
  result := Findex;
end;

function TModelGoogleAnalyticsPurchaseItems.item_brand(
  Value: String): iModelGooglePurchaseItems;
begin
  result := self;
  FItemBrand := Value;
end;

function TModelGoogleAnalyticsPurchaseItems.item_brand: String;
begin
  result := FItemBrand;
end;

function TModelGoogleAnalyticsPurchaseItems.item_category: String;
begin
  result := FItemCategory;
end;

function TModelGoogleAnalyticsPurchaseItems.item_category(
  Value: String): iModelGooglePurchaseItems;
begin
  result := self;
  FItemCategory := Value;
end;

function TModelGoogleAnalyticsPurchaseItems.item_category2: String;
begin
  result := FItemCategory2;
end;

function TModelGoogleAnalyticsPurchaseItems.item_category2(
  Value: String): iModelGooglePurchaseItems;
begin
  result := self;
  FItemCategory2 := Value;
end;

function TModelGoogleAnalyticsPurchaseItems.item_category3: String;
begin
  result := FItemCategory3;
end;

function TModelGoogleAnalyticsPurchaseItems.item_category3(
  Value: String): iModelGooglePurchaseItems;
begin
  result := self;
  FItemCategory3 := Value;
end;

function TModelGoogleAnalyticsPurchaseItems.item_category4: String;
begin
  result := FItemCategory4;
end;

function TModelGoogleAnalyticsPurchaseItems.item_category4(
  Value: String): iModelGooglePurchaseItems;
begin
  result := self;
  FItemCategory4 := Value;
end;

function TModelGoogleAnalyticsPurchaseItems.item_category5: String;
begin
  result := FItemCategory5;
end;

function TModelGoogleAnalyticsPurchaseItems.item_category5(
  Value: String): iModelGooglePurchaseItems;
begin
  result := self;
  FItemCategory5 := Value;
end;

function TModelGoogleAnalyticsPurchaseItems.item_id: String;
begin
  result := FItemID;
end;

function TModelGoogleAnalyticsPurchaseItems.item_id(
  Value: String): iModelGooglePurchaseItems;
begin
  result := self;
  FItemID := Value;
end;

function TModelGoogleAnalyticsPurchaseItems.item_list_id(
  Value: String): iModelGooglePurchaseItems;
begin
  result := self;
  FItemListID := Value;
end;

function TModelGoogleAnalyticsPurchaseItems.item_list_id: String;
begin
  result := FItemListID;
end;

function TModelGoogleAnalyticsPurchaseItems.item_list_name: String;
begin
  result := FItemListName;
end;

function TModelGoogleAnalyticsPurchaseItems.item_list_name(
  Value: String): iModelGooglePurchaseItems;
begin
  result := self;
  FItemListName := Value;
end;

function TModelGoogleAnalyticsPurchaseItems.item_name: String;
begin
  result := FItemName;
end;

function TModelGoogleAnalyticsPurchaseItems.item_name(
  Value: String): iModelGooglePurchaseItems;
begin
  result := self;
  FItemName := Value;
end;

function TModelGoogleAnalyticsPurchaseItems.item_variant: String;
begin
  result := FItemVariant;
end;

function TModelGoogleAnalyticsPurchaseItems.item_variant(
  Value: String): iModelGooglePurchaseItems;
begin
  result := self;
  FItemVariant := Value;
end;

function TModelGoogleAnalyticsPurchaseItems.location_id: String;
begin
  result := FLocationID;
end;

function TModelGoogleAnalyticsPurchaseItems.location_id(
  Value: String): iModelGooglePurchaseItems;
begin
  result := self;
  FLocationID := Value;
end;

class function TModelGoogleAnalyticsPurchaseItems.New: iModelGooglePurchaseItems;
begin
  result := TModelGoogleAnalyticsPurchaseItems.Create;
end;

function TModelGoogleAnalyticsPurchaseItems.price: currency;
begin
  result := FPrice;
end;

function TModelGoogleAnalyticsPurchaseItems.price(
  Value: currency): iModelGooglePurchaseItems;
begin
  result := self;
  FPrice := Value;
end;

function TModelGoogleAnalyticsPurchaseItems.quantity(
  Value: double): iModelGooglePurchaseItems;
begin
  result := self;
  FQuantity := Value;
end;

function TModelGoogleAnalyticsPurchaseItems.quantity: double;
begin
  result := FQuantity;
end;

end.

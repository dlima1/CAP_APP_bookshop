using {
    Currency,
    managed,
    sap,
    cuid
} from '@sap/cds/common';

namespace sap.capire.bookshop;

entity Books : managed {
    key ID       : Integer;
        title    : localized String(111);
        descr    : localized String(1111);
        author   : Association to Authors;
        genre    : Association to Genres;
        stock    : Integer;
        price    : Decimal(9, 2);
        currency : Currency;
}

@Aggregation.ApplySupported.PropertyRestrictions: true
view BooksAnalytics as select from Books {
  key ID,
  @Analytics.Dimension: true
  price,
  @Analytics.Measure: true
  @Aggregation.default: #SUM
  genre.descr,
  @Analytics.Dimension: true
  currency
};

entity Authors : managed {
    key ID           : Integer;
        name         : String(111);
        dateOfBirth  : Date;
        dateOfDeath  : Date;
        placeOfBirth : String;
        placeOfDeath : String;
        books        : Association to many Books
                           on books.author = $self;
}

/**
 * Hierarchically organized Code List for Genres
 */
entity Genres : sap.common.CodeList {
    key ID       : Integer;
        parent   : Association to Genres;
        children : Composition of many Genres
                       on children.parent = $self;
}

entity Customers {
    key BusinessPartner         : UUID;
        LastName                : String;
        FirstName               : String;
        Industry                : String;
        BusinessPartnerCategory : String;
}

entity Orders : cuid, managed {
    OrderNo  : String       @title : 'Order Number'; //> readable key
    Items    : Composition of many OrderItems
                   on Items.parent = $self;
    customer : String;
    total    : Decimal(9, 2)@readonly;
    currency : Currency;
}

entity OrderItems : cuid {
    parent    : Association to Orders;
    book      : Association to Books;
    customer  : String;
    amount    : Integer;
    netAmount : Decimal(9, 2);
}

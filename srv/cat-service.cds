using {sap.capire.bookshop as my} from '../db/schema';

service CatalogService @(path : '/browse') {

    @readonly
    entity Books as
        select from my.Books {
            *, author.name as author
        }
        excluding {
            createdBy,
            modifiedBy
        };

    @requires_ : 'authenticated-user'
    action submitOrder(book : Books:ID, amount : Integer);
}

annotate CatalogService.BooksAnalytics with @(
    UI: {
        Chart: {
            $Type: 'UI.ChartDefinitionType',
            ChartType: #Donut,
            Measures: ['price'],
            MeasureAttributes: [{
                $Type: 'UI.ChartMeasureAttributeType',
                Measure: 'price',
                Role: #Axis1
            }],             
            Dimensions: ['genre'],
            DimensionAttributes: [{
                $Type: 'UI.ChartDimensionAttributeType',
                Dimension: 'genre',
                Role: #Category
            }]       
        }
    }
);

annotate CatalogService.Books with @(
    UI: {
        SelectionFields: [author, genre.descr],
        LineItem: [
            { Value: title },
            { Value: author },
            { Value: genre.descr },
            { Value: stock },
            { Value: price },
            { Value: currency.code }
        ],   
    }
);

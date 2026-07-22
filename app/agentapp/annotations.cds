using { AgentService as service } from '../../srv/agent-service';

annotate service.Incidents with @(
    UI.SelectionFields : [
        status_code,
        customer_ID,
    ]
);
 
annotate service.Incidents with {
    customer @(
        Common.ValueList: {
            $Type : 'Common.ValueListType',
            CollectionPath : 'Customers',
            Parameters : [
                { 
                    $Type : 'Common.ValueListParameterInOut', 
                    LocalDataProperty : customer_ID,
                    ValueListProperty : 'ID',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'name',
                },
            ],
        },
        Common.Label : '{i18n>Customer}',
        Common.Text  : {
            $value : customerName,
            ![@UI.TextArrangement] : #TextOnly
        },
    );
    status @(
        Common.Text : { 
            $value  : status.name,
            ![@UI.TextArrangement] : #TextOnly
        },
        Common.Label : '{i18n>Status}',
        Common.ValueListWithFixedValues: true,
    );
};
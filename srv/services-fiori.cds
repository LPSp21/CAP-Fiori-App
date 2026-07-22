using {com.example.incident as db} from '../db/schema';
using { AgentService as service } from './agent-service';

annotate db.Incidents with @odata.draft.enabled;

annotate db.Incidents with {
    title @title: '{i18n>Title}';
    description @title: '{i18n>Description}';
    urgency @title: '{i18n>Urgency}';
    severity @title: '{i18n>Severity}';
    status @title: '{i18n>Status}';
};

annotate db.IncidentStatus with {
    code @(
        Common.Text: {
            $value: name,
            ![@UI.TextArrangement]: #TextOnly
        }
    );
};

annotate db.Customers with {
    name @title : '{i18n>Customer}';
};

annotate service.Incidents with @(
    UI.FieldGroup #GeneralInformationGroup: {
        $Type : 'UI.FieldGroupType',
        Data: [
            {
                $Type: 'UI.DataField',
                Value: description,
            },
            {
                $Type: 'UI.DataField',
                Value: customer_ID,
            },
            {
                $Type: 'UI.DataField',
                Value: urgency_code,
                Criticality: urgencyCriticality,
                CriticalityRepresentation: #WithIcon,
            },
            {
                $Type: 'UI.DataField',
                Value: severity_code,
                Criticality: severityCriticality,
                CriticalityRepresentation: #WithIcon,
            },
            {
                $Type: 'UI.DataField',
                Value: status_code,
            },
        ],
},

UI.Facets : [
    {
        $Type : 'UI.ReferenceFacet',
        ID : 'GeneralInformationFacet',
        Label : '{i18n>GeneralInformation}',
        Target : '@UI.FieldGroup#GeneralInformationGroup',
    },
    {
        $Type : 'UI.ReferenceFacet',
        Label : '{i18n>Comments}',
        ID : 'i18nComments',
        Target : 'comments/@UI.LineItem#li18nComments',
    },
],
UI.Identification : [{
    $Type : 'UI.DataFieldForAction',
    Action : 'AgentService.escalateIncident',
    Label : '{i18n>Escalate}',
    Criticality : #Negative,
}, ],
);

annotate service.Incidents with {
    description @UI.MultiLineText : true;

severity @(
    Common.Text : {
        $value : severity.name,
        ![@UI.TextArrangement] : #TextOnly
    },
    Common.ValueListWithFixedValues: true,
);
urgency @(
    Common.Text : {
        $value : urgency.name,
        ![@UI.TextArrangement] : #TextOnly
    },
    Common.ValueListWithFixedValues: true,
    );
};

annotate service.Incidents.comments with @(UI.LineItem #li18nComments: [
    {
        $Type : 'UI.DataField',
        Value : timestamp,
    },
    {
        $Type : 'UI.DataField',
        Value : author,
    },
    {
        $Type : 'UI.DataField',
        Value : message,
    },
]);

annotate service.Incidents.comments with {
    message @(
        Common.Label: '{i18n>Message}',
        UI.MultiLineText: true
    );
};

annotate service.Customers with {
    ID @(
        Common.Label: '{i18n>CustomerID}',
        Common.Text : {
            $value : name,
            ![@UI.TextArrangement] : #TextOnly
        }
    )
};

annotate service.Incidents with @(
    UI.LineItem : [
    {
        $Type : 'UI.DataField',
        Value : title,
    },
    {
        $Type: 'UI.DataField',
        Value : status_code,
    },
    {
        $Type: 'UI.DataField',
        Value : customerName,
    },
    {
        $Type: 'UI.DataField',
        Value : severity_code,
        Criticality : severityCriticality,
        CriticalityRepresentation: #WithIcon,
    },
    {
        $Type: 'UI.DataField',
        Value : urgency_code,
        Criticality: urgencyCriticality,
        CriticalityRepresentation: #WithIcon,
    },
    {
        $Type: 'UI.DataFieldForAction',
        Action : 'AgentService.escalateIncident',
        Label : '{i18n>Escalate}',
    },
],
UI.HeaderInfo : {
    TypeName : '{i18n>Incident}',
    TypeNamePlural : '{i18n>Incidents}',
    Title : {
        $Type : 'UI.DataField',
        Value : title,
    },
},);
annotate AgentService.Incidents with actions {
    escalateIncident @(
        Core.OperationAvailable : {$edmJson: {$Ne: [
            {$Path: 'in/urgency_code'},
            'C'
        ]}},
        Common.SideEffects.TargetProperties : ['in/urgency_code'],
    );
}
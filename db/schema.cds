using {
    cuid,
    managed,
    sap.common.CodeList
} from '@sap/cds/common';

using from '@sap/cds-common-content';

namespace com.example.incident;

type Status    : Association to IncidentStatus default 'R';
type Urgency   : Association to Urgencies default #medium;
type Severity  : Association to Severities default #medium;
type AgentRole : Association to AgentRoles;

type EMailAddress : String(254)
    @assert.format: '^[^@]+@[^@]+\.[^@]+$';

type PhoneNumber : String(15)
    @assert.format: '^[0-9+\-()\s]+$';

// Speichert nur Ziffern, keine Leerzeichen oder Bindestriche.
type CreditCardNumber : String(19)
    @assert.format: '^\d{13,19}$';


entity Customers : cuid, managed {
    firstName  : String;
    lastName   : String;

    name       : String =
        (firstName || ' ' || lastName) stored;

    email      : EMailAddress;
    phone      : PhoneNumber;
    creditCard : CreditCardNumber;

    address : {
        streetAddress : String;
        postCode      : String;
        city          : String;
    };

    incidents : Association to many Incidents
        on incidents.customer = $self;
}


entity Incidents : cuid, managed {
    customer : Association to Customers;

    assignments : Association to many IncidentAssignments
        on assignments.incident = $self;

    title       : String;
    description : String;

    status   : Status;
    urgency  : Urgency;
    severity : Severity;

    comments : Composition of many {
        key ID    : UUID;
        timestamp : type of managed:createdAt;
        author    : type of managed:createdBy;
        message   : String;
    };

    virtual priority : String;
}


entity Agents : cuid, managed {
    firstName : String;
    lastName  : String;
    email     : EMailAddress;
}


entity IncidentStatus : CodeList {
    key code : String enum {
        reported    = 'R';
        assigned    = 'A';
        in_progress = 'P';
        on_hold     = 'O';
        resolved    = 'S';
        closed      = 'C';
    };
}


entity Urgencies : CodeList {
    key code : String enum {
        critical = 'C';
        high     = 'H';
        medium   = 'M';
        low      = 'L';
    };
}


entity Severities : CodeList {
    key code : Integer enum {
        critical = 5;
        high     = 4;
        medium   = 3;
        low      = 2;
        trivial  = 1;
    };
}


entity AgentRoles : CodeList {
    key code : String enum {
        serviceDesk;
        technicalSupport;
        incidentManager;
        communicationLead;
    };
}


entity IncidentAssignments : cuid, managed {
    incident : Association to Incidents;
    agent    : Association to Agents;
    role     : AgentRole;
}
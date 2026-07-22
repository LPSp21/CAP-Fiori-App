using {
    AgentService
} from './agent-service.cds';

using {
    AdminService
} from './admin-service.cds';

annotate  AgentService with @(requires: 'agent');
annotate  AgentService.Customers with @readonly;

annotate AgentService with @restrict: [{
    grant: 'READ',
    where: '$user.guid = agentID'
}];

annotate AdminService with @requires: 'admin';
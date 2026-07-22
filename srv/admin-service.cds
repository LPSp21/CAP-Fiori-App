using {com.example.incident as db} from '../db/schema';

 /**
  * Service used by the administrators with complete access.
  */
  @(path: '/admin')
  service AdminService {
    function getAgentWorkload(agentID: UUID) returns Integer;
    
    entity Customers as projection on db.Customers;
    entity Incidents as projection on db.Incidents;
    entity Agents as projection on db.Agents;
  }
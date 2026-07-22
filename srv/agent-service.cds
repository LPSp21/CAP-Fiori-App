using {com.example.incident as db} from '../db/schema';
/**
 * Service used by the agents to process incidents.
 */
@(path: '/agent')
@requires: 'authenticated-user'
service AgentService {
  @cds.redirection.target
  entity Incidents as 
                    projection on db.Incidents {
                      *,
                      customer.name as customerName,
                      case
                          when urgency.code = 'C' then 1
                          when urgency.code = 'H' then 2
                          when urgency.code = 'M' then 5
                          when urgency.code = 'L' then 3
                          else 0
                      end as urgencyCriticality : Integer,
                      case
                          when severity.code = 5 then 1  // Kritisch    -> rot
                          when severity.code = 4 then 2  // Hoch        -> orange
                          when severity.code = 3 then 5  // Mittel      -> blau
                          when severity.code = 2 then 3  // Niedrig     -> grün
                          when severity.code = 1 then 0  // Unerheblich -> neutral
                          else 0
                      end as severityCriticality : Integer
                    }
  actions {
        // bound actions/functions
        action escalateIncident(comment : String) returns Incidents
  }
  entity Customers as
                    projection on db.Customers
                      excluding {
                        creditCard
                    }
@restrict: [{
  grant: 'READ',
  where: '$user.guid = agentID'
}]
  entity AgentInformation as
                          projection on db.Agents {
                            ID as agentID,
                            firstName || ' ' || lastName as agentFullName : String,
                            email as agentEmail
                          }
  entity LatestIncidents as
                          select from db.Incidents as latestIncident
                            where 
                                not exists(
                                  select from db.Incidents as olderIncident {
                                    olderIncident.customer.ID,
                                    olderIncident.createdAt
                                  }
                            where
                                    olderIncident.customer.ID = latestIncident.customer.ID
                                and olderIncident.createdAt > latestIncident.createdAt
                            );
  extend projection Customers with {
    latestIncident: Association to LatestIncidents on latestIncident.customer.ID = $self.ID
  }
}
const cds = require('@sap/cds')
const { SELECT } = require('@sap/cds/lib/ql/cds-ql')

module.exports = class AgentService extends cds.ApplicationService { init() {

  const { Incidents, Customers, LatestIncidents, AgentInformation } = cds.entities('AgentService')

  // Nur ein zugewiesener Agent darf den Incident bearbeiten
  this.before (['UPDATE'], Incidents, async (req) => {
  //Ermittlung von Agent und Incident aus der Anfrage
  const currentUser = req.user.attr?.guid
  const incidentId = req.data.ID 

  // Ermittlung der Agentuzuweisungen für den Incident
  const assignedAgents = await SELECT.from(Incidents).columns('assignments.agent_ID').where({ ID: incidentId })

  const agentIds = assignedAgents?.map(a => a.assignments_agent_ID) || []
  //Prüfung des aktuellen Agenten in den zugewiesenen Agents enthalten
  if(!agentIds.includes(currentUser)) {
    req.reject(403, 'Sie sind kein zuständiger Mitarbeiter.')
  }
})

  this.on('escalateIncident', async (req) => {
    const URGENCY = {
      CRITICAL: 'C',
      HIGH: 'H'
    }
  // Ermittlung von Incident und Kommentar aus der Anfrage
  const { comment } = req.data
  const incidentId = req.params?.[0];

  // Selektion der aktuellen Dringlichkeit
  const { urgency_code: currentUrgency } =
  await SELECT.from(Incidents, incidentId).columns('urgency.code')

  // Rückmeldung, dass höchste Dringlichkeit erreicht ist
  if(currentUrgency === URGENCY.CRITICAL) {
    return req.error(400, 'Incident hat bereits die höchste Dringlichkeit.');
  }

// Bestimmung neuer Dringlichkeitsstufe
  const nextUrgency = currentUrgency === URGENCY.HIGH ? URGENCY.CRITICAL : URGENCY.HIGH;

// Erhöhung der Dringlichkeit
await UPDATE(Incidents, incidentId).set({ urgency: { code: nextUrgency } })

// Hinzufügen des Kommentars
await INSERT.into('Incidents.comments').entries({
  up__ID: incidentId,
  author: req.user.id,
  message: `Dringlichkeit erhöht: ${comment}`

})

// Wiedergeben des aktualisierten Datensatzes
return SELECT.from(Incidents, incidentId);
})

this.on('getAgentWorkload', async (req) => {
  const STATUS = {
    RESOLVED: 'S',
    CLOSED: 'C'
  }
// Ermittlung des Agents aus der Anfrage
const { agentID } = req.data;
// Zählung der Incidents des Agenten, die nicht erledigt sind
const result = await SELECT.one.from(Incidents).columns([{ func: 'count', as: 'count', args: [{ ref: ['ID'] }] }]).where({'assignments.agent_ID': agentId, 'status_code': {'not in': [STATUS.RESOLVED, STATUS.CLOSED] }
});
return result.count || 0;

})
return super.init()
}}



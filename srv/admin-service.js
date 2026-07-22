const cds = require('@sap/cds');
const { SELECT } = require('@sap/cds/lib/ql/cds-ql');

module.exports = class AdminService extends cds.ApplicationService { init() {

  this.on('getAgentWorkload', async (req) => {
    const STATUS = {
      RESOLVED: 'S',
      CLOSED: 'C'
    }
    // Ermittlung des Agents aus der Anfrage
    const { agentID } = req.data;
    // Zählung der Incidents des Agenten, die nicht erledigt sind
    const result = await SELECT.one.from(Incidents).columns([{ func: 'count', as: 'count', args: [{ ref: ['ID'] }] }])
    .where({ 'assignments.agent_ID': agentID, 'status_code': { 'not in': [STATUS.RESOLVED, STATUS.CLOSED] } });
    return result.count || 0;
  })

  const { Customers, Incidents, Agents } = cds.entities('AdminService')

  this.before (['CREATE', 'UPDATE'], Customers, async (req) => {
    console.log('Before CREATE/UPDATE Customers', req.data)
  })
  this.after ('READ', Customers, async (customers, req) => {
    console.log('After READ Customers', customers)
  })
  this.before (['CREATE', 'UPDATE'], Incidents, async (req) => {
    console.log('Before CREATE/UPDATE Incidents', req.data)
  })
  this.after ('READ', Incidents, async (incidents, req) => {
    console.log('After READ Incidents', incidents)
  })
  this.before (['CREATE', 'UPDATE'], Agents, async (req) => {
    console.log('Before CREATE/UPDATE Agents', req.data)
  })
  this.after ('READ', Agents, async (agents, req) => {
    console.log('After READ Agents', agents)
  })


  return super.init()
}}

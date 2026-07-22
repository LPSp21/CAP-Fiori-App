const cds = require('@sap/cds')

module.exports = class AgentService extends cds.ApplicationService { init() {

  const { Incidents, Customers, LatestIncidents, AgentInformation } = cds.entities('AgentService')

  this.before (['CREATE', 'UPDATE'], Incidents, async (req) => {
    console.log('Before CREATE/UPDATE Incidents', req.data)
  })
  this.after ('READ', Incidents, async (incidents, req) => {
    console.log('After READ Incidents', incidents)
  })
  this.before (['CREATE', 'UPDATE'], Customers, async (req) => {
    console.log('Before CREATE/UPDATE Customers', req.data)
  })
  this.after ('READ', Customers, async (customers, req) => {
    console.log('After READ Customers', customers)
  })
  this.before (['CREATE', 'UPDATE'], LatestIncidents, async (req) => {
    console.log('Before CREATE/UPDATE LatestIncidents', req.data)
  })
  this.after ('READ', LatestIncidents, async (latestIncidents, req) => {
    console.log('After READ LatestIncidents', latestIncidents)
  })
  this.before (['CREATE', 'UPDATE'], AgentInformation, async (req) => {
    console.log('Before CREATE/UPDATE AgentInformation', req.data)
  })
  this.after ('READ', AgentInformation, async (agentInformation, req) => {
    console.log('After READ AgentInformation', agentInformation)
  })


  return super.init()
}}

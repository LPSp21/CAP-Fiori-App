using { com.example.incident as db } from '../db/schema';

annotate db.Incidents with {
    customer @mandatory @assert.target;
    title    @mandatory;
    urgency  @mandatory @assert.target;
    severity @mandatory @assert.target;
    status   @mandatory @assert.target;
};

annotate db.IncidentAssignments with {
    agent @mandatory @assert.target;
    role  @mandatory @assert.target;
};

annotate db.Customers with {
    firstName @mandatory;
    lastName  @mandatory;
    email     @mandatory;
};

annotate db.Agents with {
    firstName @mandatory;
    lastName  @mandatory;
    email     @mandatory;
};

annotate db.Urgencies with {
    code @assert.range: true;
};

annotate db.IncidentStatus with {
    code @assert.range: true;
};

annotate db.Severities with {
    code @assert.range: true;
};

annotate db.AgentRoles with {
    code @assert.range: true;
};
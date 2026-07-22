const cds = require('@sap/cds');

cds.on('bootstrap', app => {
    // Metadaten-Endpunkt ohne Authentifizierung freigeben
    app.use((req, res, next) => {
    if(req.path.endsWith('/') || req.path.endsWith('/$metadata')) {
        // Zugriff ohne Authentifizierung zulassen
        req.user = cds.User.privileged;
    }
    next(); // Fortfahren mit der normalen Verarbeitung
    });
});

module.exports = cds.server;
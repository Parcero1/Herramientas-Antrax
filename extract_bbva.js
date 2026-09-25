const https = require('https');

https.get('https://www.bbvanetcash.com/cuenta/', (res) => {
    let data = '';
    res.on('data', (chunk) => { data += chunk; });
    res.on('end', () => {
        const scriptMatch = data.match(/src="([^"]+producto[^"]+)"/);
        if (scriptMatch) {
            downloadAndParse(scriptMatch[1]);
        } else {
            downloadAndParse('https://www.bbvanetcash.com/73g8KiWKygVDsg1rC2_l/Yu1uw43mDuL5hwaiaE/dGlCBz05LA/JW5MSFN0/Rg8');
        }
    });
}).on('error', (e) => { console.log('Error:', e.message); });

function downloadAndParse(url) {
    https.get(url, (res) => {
        let jsCode = '';
        res.on('data', (chunk) => { jsCode += chunk; });
        res.on('end', () => {
            const actions = [...jsCode.matchAll(/action["\s:=]+['"]([^'"]+)['"]/g)].map(m => m[1]);
            const fields = [...jsCode.matchAll(/name["\s:=]+['"]([^'"]+)['"]/g)].map(m => m[1]);
            const usefulActions = actions.filter(a => a && !a.includes('#'));
            const usefulFields = fields.filter(f => f && (f.includes('user') || f.includes('pass') || f.includes('token') || f.includes('lt')));

            console.log("=== ACCIONES ===");
            usefulActions.forEach(a => console.log(a));
            console.log("=== CAMPOS ===");
            usefulFields.forEach(f => console.log(f));
        });
    }).on('error', (e) => { console.log('Error script:', e.message); });
}

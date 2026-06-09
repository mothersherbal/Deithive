const Mocha = require('mocha');
const fs = require('fs');
const path = require('path');

// Set headless environment to false so they can watch Chrome run the tests
process.env.HEADLESS = 'false';

const mocha = new Mocha({
    timeout: 60000
});

mocha.addFile(path.join(__dirname, 'frontend/selenium-tests/test/login.test.js'));

const results = [];

const runner = mocha.run(function(failures) {
    // Generate CSV content
    let csv = 'Suite,Test Case,Status,Duration (ms),Error Message\n';
    results.forEach(r => {
        csv += `"${r.suite.replace(/"/g, '""')}","${r.title.replace(/"/g, '""')}","${r.status}",${r.duration_ms},"${r.error.replace(/"/g, '""')}"\n`;
    });

    const outputPath = path.join(__dirname, 'test_results.csv');
    fs.writeFileSync(outputPath, csv, 'utf8');
    console.log(`\n==================================================`);
    console.log(`✓ Test execution completed with ${failures} failures.`);
    console.log(`📊 Excel-compatible CSV report generated:`);
    console.log(`   ${outputPath}`);
    console.log(`==================================================\n`);
    process.exitCode = failures ? 1 : 0;
});

runner.on('pass', function(test) {
    results.push({
        suite: test.parent.fullTitle(),
        title: test.title,
        status: 'Passed',
        duration_ms: test.duration || 0,
        error: ''
    });
});

runner.on('fail', function(test, err) {
    results.push({
        suite: test.parent.fullTitle(),
        title: test.title,
        status: 'Failed',
        duration_ms: test.duration || 0,
        error: err.message || 'Unknown error'
    });
});

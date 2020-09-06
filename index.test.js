// const core = require('@actions/core');
// const assert = require('assert');
const run = require('./index.js');

// jest.mock('@actions/core');

// const FAKE_ACCESS_KEY_ID = 'MY-AWS-ACCESS-KEY-ID';
// const FAKE_SECRET_ACCESS_KEY = 'MY-AWS-SECRET-ACCESS-KEY';
// const FAKE_REGION = 'fake-region-1';

test('it runs', async () => {
    await run();
});
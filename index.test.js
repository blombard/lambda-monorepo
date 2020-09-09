const core = require('@actions/core');
const run = require('./index.js');

const inputs = {
  'lambda-functions': '{"LambdaFunction1": "true", "LambdaFunction2": "false"}',
  'zip-params': '*.js *.json node_modules/',
  'alias-name': 'prod',
  'layer-name': '',
};

function mockGetInput(requestResponse) {
  return function (name, options) { // eslint-disable-line no-unused-vars
    return requestResponse[name];
  };
}

jest.mock('@actions/core');
jest.mock('shelljs', () => ({ exec: jest.fn(data => console.log(data)) }));

describe('Run the test suite', () => {
  test('it should be a success when the params are good', async () => {
    core.getInput = jest.fn().mockImplementation(mockGetInput(inputs));
    await run();
    expect(core.setFailed).not.toHaveBeenCalled();
  });
  test('it should be a failure when no params are given', async () => {
    core.getInput.mockReset()
    await run();
    expect(core.setFailed).toHaveBeenCalled();
  });
});

const core = require('@actions/core');
const fs = require('fs');
const YAML = require('yaml');
const shell = require('shelljs');

try {
  const lambdaFunctions = core.getInput('lambda-functions');
  const zipParams = core.getInput('zip-params');
  const alias = core.getInput('alias-name');
  const layer = core.getInput('layer-name');
  const functions = JSON.parse(lambdaFunctions);
  const file = fs.readFileSync('./.github/filters.yml', 'utf8');
  const yml = YAML.parse(file);

  for (const [key, value] of Object.entries(functions)) {
    if (value === 'true') shell.exec(`sh ./deploy.sh ${key} ${yml[key][0].split('*')[0]} ${zipParams} "${alias}" "${layer}"`);
  }
} catch (error) {
  core.setFailed(error.message);
}

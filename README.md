[![Maintainability](https://api.codeclimate.com/v1/badges/a76164161fd8916e0dd4/maintainability)](https://codeclimate.com/github/blombard/lambda-monorepo/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/a76164161fd8916e0dd4/test_coverage)](https://codeclimate.com/github/blombard/lambda-monorepo/test_coverage)

# AWS Lambda monorepo

Deploy your AWS Lambda functions based on the files changed in a mono repo with this [Github Action](https://github.com/features/actions).

## Prerequisites
Set you <b>AWS</b> credentials in the [secrets](https://docs.github.com/en/actions/configuring-and-managing-workflows/creating-and-storing-encrypted-secrets) of your repo:
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_REGION

Create a `filters.yml` file and put it in `.github/worklows` : `.github/worklows/filters.yml`

The structure of the file should be :
```
LambdaFunction1:
  - 'LambdaFunction1/**/*'
LambdaFunction2:
  - 'LambdaFunction2/**/*'
```

## Example

```yml
on:
  push:
    branches:
      - master

jobs:
  deploy:
    name: Deploy to AWS Lambda
    runs-on: ubuntu-latest

    steps:
    - name: Checkout
      uses: actions/checkout@v2

    - name: Configure AWS Credentials
      uses: aws-actions/configure-aws-credentials@v1
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: ${{ secrets.AWS_REGION }}

    - uses: dorny/paths-filter@v2.2.1
      id: filter
      with:
        filters: .github/filters.yml

    - uses: blombard/lambda-monorepo@master
      with:
        lambda-functions: '${{ toJson(steps.filter.outputs) }}'
        zip-params: '*.js *.json src/ node_modules/'
        alias-name: 'production'
        layer-name: 'MyLayer'
```

## Inputs
#### lambda-functions
By default should be `'${{ toJson(steps.filter.outputs) }}'`. Update this only if you know what you are doing.

#### zip-params
Arguments of the command `zip lambda.zip -r $ZIP_PARAMS`.
It is the files who will be uploaded to your Lambda function.

#### alias-name
A Lambda [alias](https://docs.aws.amazon.com/lambda/latest/dg/configuration-aliases.html) is like a pointer to a specific Lambda function version. This alias will now point to the new version of your function.

#### layer-name
If your Lambda use a [layer](https://docs.aws.amazon.com/lambda/latest/dg/configuration-layers.html), it will update you function with the latest version of this layer.

## Build your own deploy function

If your deployment script is very specific to your project you can override the default `deploy.sh` script with your own.
For that you'll need a `deploy.sh` file at the root of your project.

#### **`deploy.sh`**
```bash
FUNCTION_NAME=$1
PATH_NAME=$2
ZIP_PARAMS=$3

if [ -n "$PATH_NAME" ]; then cd $PATH_NAME; fi

zip lambda.zip -r $ZIP_PARAMS

aws lambda update-function-code --function-name $FUNCTION_NAME --zip-file fileb://lambda.zip
aws lambda update-function-configuration --function-name $FUNCTION_NAME --environment Variables="{`cat .env | xargs | sed 's/ /,/g'`}"

rm -f lambda.zip
```

### Note

Since the AWS CLI is really verbose, if you need to deploy sensitive data (in your env variables for example) you can use :
```bash
cmd > /dev/null
```
if you don't want to display stdout but still keep stderr.

## Sources

This action is based on those Github actions :
- [configure-aws-credentials](https://github.com/aws-actions/configure-aws-credentials)
- [paths-filter](https://github.com/dorny/paths-filter)
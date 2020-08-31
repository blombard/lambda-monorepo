# AWS Lambda monorepo

Deploy your AWS Lambda functions based on the files changed in a mono repo with this [Github Action](https://github.com/features/actions).

## Prerequisites
Set you <b>AWS</b> credentials in the [secrets](https://docs.github.com/en/actions/configuring-and-managing-workflows/creating-and-storing-encrypted-secrets) of your repo: 
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_REGION

Create a `filter.yml` file and put it in `.github/worklows` : `.github/worklows/filter.yml`

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

## Sources

This action is based on those Github actions : 
- [configure-aws-credentials](https://github.com/aws-actions/configure-aws-credentials)
- [paths-filter](https://github.com/dorny/paths-filter)
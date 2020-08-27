# Lambda-monorepo

Deploy your AWS Lambda functions based on the files changed in a mono repo with this [Github Action](https://github.com/features/actions).

## Prerequisite
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

## Usage

## Source

This action is based on : 
- [configure-aws-credentials](https://github.com/aws-actions/configure-aws-credentials)
- [paths-filter](https://github.com/dorny/paths-filter)
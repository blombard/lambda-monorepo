FUNCTION_NAME=$1

if [ -n "$2" ]; then cd $2; fi

zip lambda.zip -r *.js *.json *.key src/ node_modules/ bin/

aws lambda update-function-code --function-name $FUNCTION_NAME --zip-file fileb://lambda.zip
aws lambda update-function-configuration --function-name $FUNCTION_NAME --environment Variables="{`cat .env | xargs | sed 's/ /,/g'`}"

rm -f lambda.zip

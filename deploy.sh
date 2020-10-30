FUNCTION_NAME=$1
PATH_NAME=$2
ZIP_PARAMS=$3
ALIAS_NAME=$4
LAYER_NAME=$5

if [ -n "$PATH_NAME" ]; then cd $PATH_NAME; fi

if [[ $ZIP_PARAMS == *"node_modules"* ]]; then npm install --only=prod; fi

zip lambda.zip -r $ZIP_PARAMS

if [ -n "$LAYER_NAME" ]; then LAYER=$(aws lambda list-layer-versions --layer-name $LAYER_NAME | jq -r .LayerVersions[0].LayerVersionArn); fi

RETURNED_FUNCTION_NAME=$(aws lambda update-function-code --function-name $FUNCTION_NAME --zip-file fileb://lambda.zip | jq -r .FunctionName)

if [ -n "$LAYER_NAME" ]; then
  aws lambda update-function-configuration --function-name $FUNCTION_NAME --layers $LAYER --environment Variables="{`cat .env | xargs | sed 's/ /,/g'`}"
else
  aws lambda update-function-configuration --function-name $FUNCTION_NAME --environment Variables="{`cat .env | xargs | sed 's/ /,/g'`}"
fi

if [ -n "$ALIAS_NAME" ]
then
  VERSION=$(aws lambda publish-version --function-name $FUNCTION_NAME | jq -r .Version)
  aws lambda update-alias --function-name $FUNCTION_NAME --name $ALIAS_NAME --function-version $VERSION
  if [ -n "$LAYER_NAME" ]; then
    aws lambda update-function-configuration --function-name $FUNCTION_NAME --layers $LAYER --environment Variables="{`cat .env | xargs | sed 's/ /,/g'`}"
  else
    aws lambda update-function-configuration --function-name $FUNCTION_NAME --environment Variables="{`cat .env | xargs | sed 's/ /,/g'`}"
  fi
fi

rm -f lambda.zip

if [ "$RETURNED_FUNCTION_NAME" = "$FUNCTION_NAME" ]; then
  exit 0
else
  exit 1
fi

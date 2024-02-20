#!/bin/bash

APP="gitlab"

PASSWORD=$(kubectl get secret $APP-$APP-initial-root-password -o jsonpath='{.data.password}' -n $APP)
echo "$APP Credentials Username: admin and Password is: $(echo $PASSWORD | base64 --decode)"

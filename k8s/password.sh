#!/bin/bash

PASSWORD=$(kubectl get secret $APP-$APP-initial-root-password -o jsonpath='.data.password' -n $APP)
sh echo '$APP Credentials Username: admin and Password is: $(echo $PASSWORD | base64 --decode)'
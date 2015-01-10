#!/bin/bash

LOCAL_PORT=3000
CODE_LOCATION=$1

if [[ -z $CODE_LOCATION ]]; then
  CODE_LOCATION=$(pwd)
fi


echo 
echo "Starting database instance."
sudo docker run --name zenforms-postgres -d postgres 
echo 
echo "Preparing the database."
sudo docker run --rm -t -v $CODE_LOCATION:/var/www/zenforms --link zenforms-postgres:dblocal crypt1d/zenforms-app /bin/bash -l -c "rake db:create db:migrate"

echo 
echo "Starting rails."
sudo docker run --name zenforms-app -t -v $CODE_LOCATION:/var/www/zenforms -p 3000:$LOCAL_PORT --link zenforms-postgres:dblocal -d crypt1d/zenforms-app /bin/bash -l -c "rails server"

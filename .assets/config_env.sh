#!/bin/sh

echo "Starting..."
pip install -U pip
curl https://bootstrap.pypa.io/get-pip.py | python3
python3 -m pip install --upgrade -r requirements.txt
mkdir ~/.gdrive
echo {\"installed\":{\"client_id\":\"569778563380-6pkurt95qgur6gdgp61gpgcdmhv5u8d9.apps.googleusercontent.com\",\"project_id\":\"discord-gdrive\",\"auth_uri\":\"https://accounts.google.com/o/oauth2/auth\",\"token_uri\":\"https://oauth2.googleapis.com/token\",\"auth_provider_x509_cert_url\":\"https://www.googleapis.com/oauth2/v1/certs\",\"client_secret\":\"p2w3supEhnj_MXHVUKPOdd5R\",\"redirect_uris\":[\"urn:ietf:wg:oauth:2.0:oob\",\"http://localhost\"]}} >~/.gdrive/credentials.json
echo "Done!"

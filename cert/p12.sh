#!/bin/bash

openssl pkcs12 -export -inkey master-key.pem -in master.pem -out master.p12

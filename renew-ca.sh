#/bin/bash

#Get old certificate serial number
serialtxt=`openssl x509 -in ca.crt -serial -noout`

serialprefix="0x"
echo $serialtxt
serial=$serialprefix$(echo $serialtxt | cut -d'=' -f 2)
echo $serial

#Create New CSR
openssl x509 -x509toreq -in ca.crt -signkey ca.key -out new-server.csr

#Sign and generate new cert
openssl x509 -req -days 3650 -in new-server.csr -signkey ca.key -out new-ca.crt -set_serial $serial

echo "verify with old cert"
openssl verify -CAfile ca.crt -verbose server.crt

echo "Verify with new cert"
openssl verify -CAfile new-ca.crt -verbose server.crt                          
                                                                              
echo "Creating newca pem"                                                     
cat new-ca.crt > new-ca.pem                                                   
cat ca.key >> new-ca.pem                                                      
                                                                              
                                                                              
echo "verify with old cert"
openssl verify -CAfile ca.pem -verbose server.crt

echo "Verify with new pem"
openssl verify -CAfile new-ca.pem -verbose server.crt

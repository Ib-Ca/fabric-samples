
# Binarios y config
export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=${PWD}/../config

# Común (orderer TLS)
export ORDERER_ADDR=localhost:7050
export ORDERER_HOST=orderer.example.com
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

# Canal y CC por defecto (ajusta si querés)
export CHANNEL=foodtrace
export CCNAME=ricechaincode

# Switchers de identidad
useOrg1() {
  export CORE_PEER_TLS_ENABLED=true
  export CORE_PEER_LOCALMSPID="Org1MSP"
  export CORE_PEER_ADDRESS=localhost:7051
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
  export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
  echo "[✓] Contexto: Org1 (peer0.org1:7051)"
}

useOrg2() {
  export CORE_PEER_TLS_ENABLED=true
  export CORE_PEER_LOCALMSPID="Org2MSP"
  export CORE_PEER_ADDRESS=localhost:9051
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
  export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
  echo "[✓] Contexto: Org2 (peer0.org2:9051)"
}

# Helpers (invocar / consultar) – evitan escribir las rutas largas
ccInvoke() {
  local args_json="$1"
  peer chaincode invoke \
    -o ${ORDERER_ADDR} \
    --ordererTLSHostnameOverride ${ORDERER_HOST} \
    --tls --cafile ${ORDERER_CA} \
    -C ${CHANNEL} -n ${CCNAME} \
    --peerAddresses localhost:7051 \
    --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt \
    --peerAddresses localhost:9051 \
    --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt \
    -c "${args_json}"
}

ccQuery() {
  local args_json="$1"
  peer chaincode query -C ${CHANNEL} -n ${CCNAME} -c "${args_json}"
}

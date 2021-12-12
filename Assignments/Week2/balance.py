# This week you should import your addres to MetaMask and get some
# rETHER using one Ropsten faucet
# I will use this script (with correct 'a' list) to check

a = [
    ['Name',	'0xB51SOMEADDRESS'],
    ['Other',	'0xBCCSOMEADDRESS']
 ]




from web3 import Web3
INFURASTR='https://ropsten.infura.io/v3/YOURINFURASTR'
w3 = Web3(Web3.HTTPProvider(INFURASTR))

for _a in a:
    b = w3.eth.getBalance(_a[1])
    if b>0:
        print(_a,b)

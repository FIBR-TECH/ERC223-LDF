let secrets = require('./secrets.js');
const WalletProvider = require("truffle-wallet-provider");
const Wallet = require('ethereumjs-wallet');

let kovanPrivateKey = new Buffer(secrets.ropstenPK, "hex");
let kovanWallet = Wallet.fromPrivateKey(kovanPrivateKey);
let kovanProvider = new WalletProvider(kovanWallet,  "https://kovan.infura.io/");
module.exports = {
    networks: {
        development: {
              host: "localhost",
              port: 7545,
              network_id: "*" // Match any network id
        },
        kovan: { provider: kovanProvider, 
            network_id: "42", gas: 5687344 }
    },
    compilers: {
        solc: {
          version: "0.4.24",  
          docker: true,
          settings: {
            optimizer: {
              enabled: true, 
              runs: 200    
            }
          }
        }
      },
 };
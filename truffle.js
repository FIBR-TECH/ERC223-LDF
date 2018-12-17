let secrets = require('./secrets.js');
const WalletProvider = require("truffle-wallet-provider");
const Wallet = require('ethereumjs-wallet');
let ropstenPrivateKey = new Buffer(secrets.ropstenPK, "hex");
let ropstenWallet = Wallet.fromPrivateKey(ropstenPrivateKey);
let ropstenProvider = new WalletProvider(ropstenWallet,  "https://ropsten.infura.io/");

let kovanPrivateKey = new Buffer(secrets.ropstenPK, "hex");
let kovanWallet = Wallet.fromPrivateKey(kovanPrivateKey);
console.log(kovanWallet)
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
    }
 };
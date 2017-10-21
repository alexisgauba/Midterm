var Queue = artifacts.require("./Queue.sol");
var Token = artifacts.require("./Token.sol");
var Crowdsale = artifacts.require("./Crowdsale.sol");

var math = artifacts.require("./Math.sol");
var SafeMath = artifacts.require("./SafeMath.sol");

module.exports = function(deployer) {
    deployer.deploy(Queue);
    //deployer.deploy(Token);
    deployer.deploy(Crowdsale);
    deployer.deploy(math);
    deployer.deploy(SafeMath);
};

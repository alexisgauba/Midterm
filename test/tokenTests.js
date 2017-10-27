'use strict';

/* Add the dependencies you're testing */
const Token = artifacts.require('Token');
const BigNumber = web3.BigNumber
//
// YOUR CODE HERE

contract('TokenTest', function(accounts) {
	/* Define your constant variables and instantiate constantly changing 
	 * ones
	 */
	let token = null; 
	let expectedTokenSupply = new BigNumber(900);
	const owner = accounts[0]
	// YOUR CODE HERE

	/* Do something before every `describe` method */
	beforeEach(async function() {
		token = await Token.new(expectedTokenSupply, {from: owner}); 
	});

	/* Tests for Token.sol */
	describe('Tests for Token.sol', function() {
		it("Checks for balance", async function() {
			const balance = await token.balanceOf.call(owner);
			assert.strictEqual(balance.toNumber(), 0);
		});
		it("should transfer 100 to accounts[1]", async function() {
			await token.transfer(accounts[1], 100, {from: owner})
    		const balance = await token.balanceOf.call(accounts[1])
    		assert.strictEqual(balance.toNumber(), 100)
		});;
		it("supports 0 transfers", async function() {
			assert(await token.transfer.call(accounts[1], 0, {from: owner}), 'zero-transfer has failed')
		});
		it("should allow txn of 100 to accounts[1]", async function() {
			await token.approve(accounts[1], 100, {from: owner})
    		const allowance = await token.allowance.call(owner, accounts[1])
    		assert.strictEqual(allowance.toNumber(), 100)
		});
		it("Contract allows owner to burn tokens", async function() {
			const { logs } = await token.burn(100, { from: owner })
		});
		it("should fire transfer event properly", async function() {
			const res = await token.transfer(accounts[1], '100', {from: owner})
    		const transferLog = res.logs.find(element => element.event.match('Transfer'))
    		assert.strictEqual(transferLog.args._from, owner)
    		assert.strictEqual(transferLog.args._to, accounts[1])
    		assert.strictEqual(transferLog.args._value.toString(), '100')
		});
		it("should fire approval event properly", async function() {
			const res = await token.approve(accounts[1], '100', {from: owner})
   			const approvalLog = res.logs.find(element => element.event.match('Approval'))
    		assert.strictEqual(approvalLog.args._owner, owner)
    		assert.strictEqual(approvalLog.args._spender, accounts[1])
    		assert.strictEqual(approvalLog.args._value.toString(), '100')
		});
	});
});

'use strict';

/* Add the dependencies you're testing */
const Queue = artifacts.require("./Queue.sol");
// YOUR CODE HERE

contract('QueueTest', function(accounts) {
	/* Define your constant variables and instantiate constantly changing 
	 * ones
	 */
	const args = {Alice:0x1234, Bob:0x32145, Mallory: 0x99999, Time_Limit: 256};
	let Q, y, z;
	// YOUR CODE HERE

	/* Do something before every `describe` method */
	beforeEach(async function() {
		Q = await Queue.new();

	});

	/* Group test cases together 
	 * Make sure to provide descriptive strings for method arguements and
	 * assert statements
	 */
	describe('Basic Functionality of Queue', function() {
		it("Add and remove elements", async function() {
			
			await Q.enqueue(args.Alice);
			let var1 = await Q.getFirst();
			assert.equal(var1, args.Alice, "Alice should be the first one on the queue1"); 
			await Q.enqueue(args.Bob);
			let var2 = await Q.getFirst();
			assert.equal(var2, args.Alice, "Alice should be the first one on the queue2");
			await Q.enqueue(args.Mallory)
			let var3 = await Q.getFirst();
			assert.equal(var3, args.Alice, "Alice should be the first one on the queue3");
			//Crap
			await Q.unlock();
			await Q.dequeue();
			let var4 = await Q.getFirst();
			assert.equal(var4, args.Bob, "Bob should be the first one on the queue");
			await Q.unlock();
			await Q.dequeue();
			let var5 = await Q.getFirst();
			assert.equal(var5, args.Mallory, "Mallory should be the first one on the queue");
			await Q.unlock();
			await Q.dequeue();
			let var6 = await Q.empty();
			assert.equal(var6, true, "Queue should be empty");
			
		});
		// YOUR CODE HERE
	});

	describe('Your string here', function() {
		// YOUR CODE HERE
	});
});

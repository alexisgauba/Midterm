'use strict';

/* Add the dependencies you're testing */
const Queue = artifacts.require("./Queue.sol");
// YOUR CODE HERE

contract('testTemplate', function(accounts) {
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
			Q.enqueue(args.Alice);
			assert.equal(Q.getFirst(), args.Alice, "Alice should be the first one on the queue1"); 
			Q.enqueue(args.Bob);
			assert.equal(Q.getFirst(), args.Alice, "Alice should be the first one on the queue2");
			Q.enqueue(args.Mallory)
			assert.equal(Q.getFirst(), args.Alice, "Alice should be the first one on the queue3");
			setTimeout(function() {alert('Ready to dequeue'), args.Time_Limit});
			Q.dequeue();
			assert.equal(Q.getFirst(), args.Bob, "Bob should be the first one on the queue");
			setTimeout(function() {alert('Ready to dequeue'), args.Time_Limit});
			Q.dequeue();
			assert.equal(Q.getFirst(), args.Mallory, "Mallory should be the first one on the queue");
			setTimeout(function() {alert('Ready to dequeue'), args.Time_Limit});
			Q.dequeue();
			assert.equal(Q.empty(), True, "Queue should be empty");
		});
		// YOUR CODE HERE
	});

	describe('Your string here', function() {
		// YOUR CODE HERE
	});
});

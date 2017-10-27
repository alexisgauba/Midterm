pragma solidity ^0.4.15;

/**
 * @title Queue
 * @dev Data structure contract used in `Crowdsale.sol`
 * Allows buyers to line up on a first-in-first-out basis
 * See this example: http://interactivepython.org/courselib/static/pythonds/BasicDS/ImplementingaQueueinPython.html
 */

contract Queue {
	/* State variables */
	uint8 size = 5;
	uint8 elements; //size will be for the size of the whole array, elements for how much of it is filled
	uint256 time_limit = 1 << 8; //time limit, equal to 2^8 = 256 
	uint256 front_time;
	// YOUR CODE HERE
	address[] queue;
	bool lock;
	/* Add events */
	// YOUR CODE HERE
	event AddedClient(address Client, uint256 timestamp);
	event PurchaseCompleted(address Client);
	/* Add constructor */
	// YOUR CODE HERE
	
	function Queue () {
		queue = new address[](size);
		lock = false;
		elements = 0;
	}
	
	function resize() constant {
		if (elements == size - 1) {
			uint8 nSize = size * 2;
			assert(size == 0 || nSize / 2 == size);
			address[] memory newQueue= new address[](nSize);
			uint i;
			for (i = 0; i < size; i++) {
				newQueue[i] = queue[i];
			}
			for (; i < nSize; i++) {
				newQueue[i] = 0x0;
			}
			queue = newQueue;
			size = nSize;
		} 
	}
	
	/* Returns the number of people waiting in line */
	function qsize() constant returns(uint8) {
		return elements;
	}

	/* Returns whether the queue is empty or not */
	function empty() constant returns(bool) {
		return elements == 0;
	}
	
	/* Returns the address of the person in the front of the queue */
	function getFirst() constant returns(address) {
		return queue[0];
	}
	
	/* Allows `msg.sender` to check their position in the queue */
	function checkPlace() constant returns(uint8) {
		for (uint8 i = 0; i < elements; i++) {
			if (queue[i] == msg.sender) {
				return i;
			}
		}
		return 255; //for error
	}
	
	
	
	/* Allows anyone to expel the first person in line if their time
	 * limit is up
	 */
	function checkTime() {
		if (now - front_time >= time_limit) {
			lock = false;
		} else {
			lock = true;
		}
	}
	
	/* Removes the first person in line; either when their time is up or when
	 * they are done with their purchase
	 */
	function dequeue() {
		assert(empty() == false);
		checkTime();
		if (!lock ) {
				for (uint i = 0; i < elements - 1; i++) {
					queue[i] = queue[i + 1]; 
				}
			elements--;
			front_time = now;
		}
		
	}

	/* Places `addr` in the first empty position in the queue */
	function enqueue(address addr) {
		resize();
		queue[elements] = addr;
		elements += 1;
		AddedClient(addr, now);
	}
}

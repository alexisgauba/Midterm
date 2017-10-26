pragma solidity ^0.4.15;

import './Queue.sol';
import './Token.sol';

/**
 * @title Crowdsale
 * @dev Contract that deploys `Token.sol`
 * Is timelocked, manages buyer queue, updates balances on `Token.sol`
 */

contract Crowdsale {

	address owner;
	Token public token;
	Queue public queue;
	uint256 public price;
	uint256 public totalFunds;
	uint256 public tokensSold;
	uint256 public startTime;
	uint356 public endTime;
	
	// constructor
	function Crowdsale(uint256 _initSupply, uint256 _price, uint256 _start, uint256 _end) {
		owner = msg.sender;
		token = Token(_initSupply);
		queue = Queue();
		price = _price;
		totalFunds = 0;
		tokensSold = 0;
		startTime = _start;
		endTime = _end;
	}

	function mintTokens(uint256 _amount) isOwner {
		token.totalSupply += _amount;
	}

	function burnTokens(uint256 _amount) isOwner {
		token.burn(_amount);
	}

	function purchaseTokens(uint256 _amount) payable duringCrowdsale {
		bool approved = token.approve(msg.sender, _amount);
		uint256 balanceBefore = token.balanceOf(msg.sender); 
		bool transferred = token.transferFrom(owner, msg.sender, _amount);
		uint256 balanceAfter = token.balanceOf(msg.sender); 
		if (transferred) {
			assert(balanceAfter - balanceBefore == _amount);
			// totalFunds += msg.value;
			tokensSold += _amount;
			Purchase(msg.sender, _amount);
		} else {
			assert(balanceBefore == balanceAfter);
		}
	}

	function refundTokens(uint256 _amount) duringCrowdsale {
		uint256 balanceBefore = token.balanceOf(msg.sender); 
		bool transferred = token.transferFrom(msg.sender, owner, _amount);
		uint256 balanceAfter = token.balanceOf(msg.sender);
		if (transferred) {
			assert(balanceBefore - balanceAfter == _amount);
			tokensSold -= _amount;
			Refund(msg.sender, _amount);
		} else {
			assert(balanceBefore == balanceAfter);
		}
	}

	function recieveFunds() isOwner afterCrowdsale {
		this.transfer(totalFunds);
	}

	// modifiers
	modifier isOwner() {
        require(owner == msg.sender);
        _;
    }

	modifier duringCrowdsale() {
		require(now >= startTime && now < endTime);
		_;
	}

	modifier afterCrowdsale() {
		require(now >= endTime);
		_;
	}

	// TODO update this
	modifier validQueuePos() {
		require();
		_;
	}

	// events
	event Purchase(address _buyer, uint256 _amount);
	event Refund(address _buyer, uint256 _amount);

}

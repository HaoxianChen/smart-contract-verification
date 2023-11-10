// SPDX-License-Identifier: MIT
// pragma solidity ^0.8.0;

// source: https://github.com/eth-sri/verx-benchmarks/blob/master/overview/main.sol
/**
* @notice invariant  (!(onceRefund && onceWithdraw))
*/

contract Escrow {
  mapping(address => uint256) deposits;
  enum State {OPEN, SUCCESS, REFUND}
  State state = State.OPEN;
  address owner;
  address payable beneficiary;
  uint256 totalFunds;
  uint256 raised;

  bool onceWithdraw;
  bool onceRefund;

  constructor(address payable b) public {
    beneficiary = b;
    owner = msg.sender;
    totalFunds = 0;
    raised = 0;
    onceWithdraw=false;
    onceRefund=false;
  }

  function deposit(address p) onlyOwner public payable {
    deposits[p] = deposits[p] + msg.value;
    totalFunds += msg.value;
    raised += msg.value;
  }

  function withdraw() public {
    require(state == State.SUCCESS);
    beneficiary.transfer(address(this).balance);
    totalFunds = 0;
    onceWithdraw=true;
  }

  function claimRefund(address payable p) public {
    require(state == State.REFUND);
    uint256 amount = deposits[p];
    deposits[p] = 0;
    p.transfer(amount);
    totalFunds -= amount;
    onceRefund=true;
  }

  modifier onlyOwner {require(owner == msg.sender); _; }
  function close() onlyOwner public{state = State.SUCCESS;}
  function refund() onlyOwner public{state = State.REFUND;}
  function check() public view {
    assert(totalFunds == raised || state != State.OPEN);
  }
  function checkRefundWithdraw() public view {
     assert(!(onceRefund && onceWithdraw));
  }
}

/**
* @notice invariant (!(onceRefund && (raised >= goal)))
*/

contract Crowdsale {
  Escrow escrow;
  uint256 raised = 0;
  uint256 goal = 10000 * 10**18;
  uint256 closeTime = block.timestamp + 30 days;
  bool closed;
  bool onceRefund;

  //address payable constant init = payable(address(uint160(0xDEADBEEF)));

  constructor() public{
    escrow = new Escrow(payable(address(0xDEADBEEF)));
    closed = false;
	onceRefund=false;
  }

  function invest() payable public{
    // fix:
    require(block.timestamp<=closeTime);
    require(raised < goal);
    escrow.deposit{value: msg.value}(msg.sender);
    raised += msg.value;
  }

  function close() public{
    require(block.timestamp > closeTime || raised >= goal);
    if (raised >= goal) {
      escrow.close();
      closed = true;
    } else {
      escrow.refund();
onceRefund=true;
	 }
  }
  // function checkRefundAndRaised() public view {
  //    assert(!(onceRefund && (raised >= goal)));
  // }
}

contract Deployer{
    Crowdsale c = new Crowdsale();
}

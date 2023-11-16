// SPDX-License-Identifier: MIT
// pragma solidity ^0.8.0;

// source: https://github.com/eth-sri/verx-benchmarks/blob/master/overview/main.sol

contract Escrow {
  mapping(address => uint256) deposits;
  enum State {OPEN, SUCCESS, REFUND}
  State state = State.OPEN;
  address owner;
  address payable beneficiary;
  uint256 totalFunds;
  uint256 raised;
  uint256 goal = 10000 * 10**18;

  bool onceWithdraw;
  bool onceRefund;

  modifier check {
    require(totalFunds == raised || state != State.OPEN);
    _;
    assert(totalFunds == raised || state != State.OPEN);
    
  }
  modifier checkRefundWithdraw {
    require(!(onceRefund && onceWithdraw));
    _;
    assert(!(onceRefund && onceWithdraw));
  }
  modifier checkRefundAndRaised {
    require(!(onceRefund && (raised >= goal)));
    _;
    assert(!(onceRefund && (raised >= goal)));
  }
  Tx transaction;
  enum Tx {
    Deposit, Withdraw, ClaimRefund, Close, Refund
  }

  constructor(address payable b) public {
    beneficiary = b;
    owner = msg.sender;
    totalFunds = 0;
    raised = 0;
    onceWithdraw=false;
    onceRefund=false;
  }

  function deposit(address p) onlyOwner public checkRefundAndRaised   payable {
    deposits[p] = deposits[p] + msg.value;
    totalFunds += msg.value;
    raised += msg.value;
    transaction = Tx.Deposit;
  }

  function withdraw() public checkRefundAndRaised   {
    require(state == State.SUCCESS);
    beneficiary.transfer(address(this).balance);
    totalFunds = 0;
    onceWithdraw=true;
    transaction = Tx.Withdraw;
  }

  function claimRefund(address payable p) public checkRefundAndRaised   {
    require(state == State.REFUND);
    uint256 amount = deposits[p];
    deposits[p] = 0;
    p.transfer(amount);
    totalFunds -= amount;
    onceRefund=true;
    transaction = Tx.ClaimRefund;
  }

  modifier onlyOwner {require(owner == msg.sender); _; }
  function close() onlyOwner public checkRefundAndRaised   {
    state = State.SUCCESS;
    transaction = Tx.Close;
  }
  function refund() onlyOwner public checkRefundAndRaised   {
    state = State.REFUND;
    transaction = Tx.Refund;
  }
//  function check() public view {
//    assert(totalFunds == raised || state != State.OPEN);
//  }
//  function () public view {
//     assert(!(onceRefund && onceWithdraw));
//  }
//  function () public view {
//     assert(!(onceRefund && (raised >= goal)));
//  }
}

//contract Crowdsale {
//  Escrow escrow;
//  uint256 raised = 0;
//  uint256 goal = 10000 * 10**18;
//  uint256 closeTime = block.timestamp + 30 days;
//  bool closed;
//  bool onceRefund;
//
//  //address payable constant init = payable(address(uint160(0xDEADBEEF)));
//
//  Tx transaction;
//  enum Tx {
//    Invest, Close
//  }
//
//  modifier checkInvariant {
//    require(!(onceRefund && (raised >= goal)));
//    _;
//    assert(!(onceRefund && (raised >= goal)));
//  }
//
//  constructor() public{
//    escrow = new Escrow(payable(address(0xDEADBEEF)));
//    closed = false;
//	onceRefund=false;
//  }
//
//  function invest() payable public checkInvariant {
//    // fix:
//    require(block.timestamp<=closeTime);
//    require(raised < goal);
//    escrow.deposit{value: msg.value}(msg.sender);
//    raised += msg.value;
//    transaction = Tx.Invest;
//  }
//
//  function close() public checkInvariant {
//    require(block.timestamp > closeTime || raised >= goal);
//    if (raised >= goal) {
//      escrow.close();
//      closed = true;
//    } else {
//      escrow.refund();
//      onceRefund=true;
//	 }
//    transaction = Tx.Close;
//  }
////  function () public view {
////     assert(!(onceRefund && (raised >= goal)));
////  }
//}
//
//contract Deployer{
//    Crowdsale c = new Crowdsale();
//}

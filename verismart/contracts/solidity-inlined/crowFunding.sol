contract CrowFunding {
  struct TargetTuple {
    uint t;
    bool _valid;
  }
  struct OwnerTuple {
    address p;
    bool _valid;
  }
  struct RaisedTuple {
    uint n;
    bool _valid;
  }
  struct ClosedTuple {
    bool b;
    bool _valid;
  }
  struct TotalBalanceTuple {
    uint m;
    bool _valid;
  }
  struct BeneficiaryTuple {
    address payable p;
    bool _valid;
  }
  struct MissingFundTuple {
    uint m;
    uint r;
    bool _valid;
  }
  struct BalanceOfTuple {
    uint n;
    bool _valid;
  }
  TargetTuple target;
  RaisedTuple raised;
  ClosedTuple closed;
  TotalBalanceTuple totalBalance;
  mapping(address=>BalanceOfTuple) balanceOf;
  OwnerTuple owner;
  BeneficiaryTuple beneficiary;
  MissingFundTuple missingFund;
  event Refund(address p,uint n);
  event Invest(address p,uint n);
  event Closed(bool b);
  event Withdraw(address p,uint n);
  constructor(uint t,address payable b) public {
    updateTotalBalanceOnInsertConstructor_r12();
    updateTargetOnInsertConstructor_r11(t);
    updateRaisedOnInsertConstructor_r6();
    updateOwnerOnInsertConstructor_r7();
    updateBeneficiaryOnInsertConstructor_r16(b);
  }
  function getClosed() public view  returns (bool) {
      bool b = closed.b;
      return b;
  }
  function getRaised() public view  returns (uint) {
      uint n = raised.n;
      return n;
  }
  function withdraw() public  {
    require(totalBalance.m == raised.n || closed.b);
      bool r8 = updateWithdrawOnInsertRecv_withdraw_r8();
    assert(totalBalance.m == raised.n || closed.b);
      if(r8==false) {
        revert("Rule condition failed");
      }
  }
  function close() public  {
    require(totalBalance.m == raised.n || closed.b);
      bool r9 = updateClosedOnInsertRecv_close_r9();
    assert(totalBalance.m == raised.n || closed.b);
      if(r9==false) {
        revert("Rule condition failed");
      }
  }
  function refund() public  {
    require(totalBalance.m == raised.n || closed.b);
      bool r3 = updateRefundOnInsertRecv_refund_r3();
    assert(totalBalance.m == raised.n || closed.b);
      if(r3==false) {
        revert("Rule condition failed");
      }
  }
  function invest() public  payable  {
    require(totalBalance.m == raised.n || closed.b);
      bool r4 = updateInvestOnInsertRecv_invest_r4();
    assert(totalBalance.m == raised.n || closed.b);
      if(r4==false) {
        revert("Rule condition failed");
      }
  }
  function updateBeneficiaryOnInsertConstructor_r16(address payable p) private    {
      beneficiary = BeneficiaryTuple(p,true);
  }
  function updateTargetOnInsertConstructor_r11(uint t) private    {
      target = TargetTuple(t,true);
  }
  function updateInvestOnInsertRecv_invest_r4() private   returns (bool) {
      if(false==closed.b) {
        uint s = raised.n;
        uint t = target.t;
        uint n = msg.value;
        address p = msg.sender;
        if(s<t) {
          emit Invest(p,n);
          balanceOf[p].n += n;
          totalBalance.m += n;
          raised.n += n;
          return true;
        }
      }
      return false;
  }
  function updateWithdrawOnInsertRecv_withdraw_r8() private   returns (bool) {
      address payable p = beneficiary.p;
      uint t = target.t;
      uint r = raised.n;
      if(p==msg.sender) {
        if(r>=t) {
          emit Withdraw(p,r);
          p.send(r);
          return true;
        }
      }
      return false;
  }
  function updateClosedOnInsertRecv_close_r9() private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        closed = ClosedTuple(true,true);
        emit Closed(true);
        return true;
      }
      return false;
  }
  function updateTotalBalanceOnInsertConstructor_r12() private    {
      totalBalance = TotalBalanceTuple(0,true);
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateRefundOnInsertRecv_refund_r3() private   returns (bool) {
      if(true==closed.b) {
        address payable p = msg.sender;
        uint t = target.t;
        uint r = raised.n;
        uint n = balanceOf[p].n;
        if(r<t && n>0) {
          emit Refund(p,n);
          p.send(n);
          balanceOf[p].n -= n;
          totalBalance.m -= n;
          return true;
        }
      }
      return false;
  }
  function updateRaisedOnInsertConstructor_r6() private    {
      raised = RaisedTuple(0,true);
  }
  function updateOwnerOnInsertConstructor_r7() private    {
      address p = msg.sender;
      owner = OwnerTuple(p,true);
  }
  // function check() public view {
  //   assert(totalBalance.m == raised.n || closed.b);
  // }
}

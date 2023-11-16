contract Crowfunding {
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
  struct OnceRefundTuple {
    bool b;
    bool _valid;
  }
  struct IllegalRefundTuple {
    bool _valid;
  }
  struct OnceWithdrawTuple {
    bool b;
    bool _valid;
  }
  struct TotalBalanceTuple {
    uint m;
    bool _valid;
  }
  struct BeneficiaryTuple {
    address p;
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
  struct RefundAndWithdrawTuple {
    bool _valid;
  }
  TargetTuple target;
  RaisedTuple raised;
  ClosedTuple closed;
  OnceRefundTuple onceRefund;
  IllegalRefundTuple illegalRefund;
  OnceWithdrawTuple onceWithdraw;
  TotalBalanceTuple totalBalance;
  OwnerTuple owner;
  BeneficiaryTuple beneficiary;
  MissingFundTuple missingFund;
  mapping(address=>BalanceOfTuple) balanceOf;
  RefundAndWithdrawTuple refundAndWithdraw;
  event Refund(address p,uint n);
  event Invest(address p,uint n);
  event Closed(bool b);
  event Withdraw(address p,uint n);
  constructor(uint t,address b) public {
    updateOnceRefundOnInsertConstructor_r13();
    updateTotalBalanceOnInsertConstructor_r18();
    updateRaisedOnInsertConstructor_r7();
    updateOwnerOnInsertConstructor_r8();
    updateTargetOnInsertConstructor_r15(t);
    updateBeneficiaryOnInsertConstructor_r22(b);
    updateOnceWithdrawOnInsertConstructor_r16();
  }
    modifier checkMissingFund {
        require(totalBalance.m == raised.n);
        _;
        assert(totalBalance.m == raised.n);
    }
    modifier checkRefundAndWithdraw {
        require(!(onceRefund.b && onceWithdraw.b));
        _;
        assert(!(onceRefund.b && onceWithdraw.b));
    }
    modifier checkIllegalRefund {
        require(!(onceRefund.b && raised.n >= target.t));
        _;
        assert(!(onceRefund.b && raised.n >= target.t));
    }
  function getClosed() public view  returns (bool) {
      bool b = closed.b;
      return b;
  }
  function withdraw() public  checkMissingFund  {
      bool r10 = updateWithdrawOnInsertRecv_withdraw_r10();
      if(r10==false) {
        revert("Rule condition failed");
      }
  }
  function close() public  checkMissingFund  {
      bool r11 = updateClosedOnInsertRecv_close_r11();
      if(r11==false) {
        revert("Rule condition failed");
      }
  }
  function invest() public  checkMissingFund payable  {
      bool r5 = updateInvestOnInsertRecv_invest_r5();
      if(r5==false) {
        revert("Rule condition failed");
      }
  }
  function refund() public  checkMissingFund  {
      bool r4 = updateRefundOnInsertRecv_refund_r4();
      if(r4==false) {
        revert("Rule condition failed");
      }
  }
  function getRaised() public view  returns (uint) {
      uint n = raised.n;
      return n;
  }
  function updateClosedOnInsertRecv_close_r11() private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        closed = ClosedTuple(true,true);
        emit Closed(true);
        uint r = raised.n;
        uint m = totalBalance.m;
        if(m!=r && true==false) {
          missingFund = MissingFundTuple(m,r,true);
        }
        return true;
      }
      return false;
  }
  function updateOwnerOnInsertConstructor_r8() private    {
      address p = msg.sender;
      owner = OwnerTuple(p,true);
  }
  function updateBeneficiaryOnInsertConstructor_r22(address p) private    {
      beneficiary = BeneficiaryTuple(p,true);
  }
  function updateInvestOnInsertRecv_invest_r5() private   returns (bool) {
      if(false==closed.b) {
        uint s = raised.n;
        uint t = target.t;
        uint n = msg.value;
        address p = msg.sender;
        if(s<t) {
          emit Invest(p,n);
          balanceOf[p].n += n;
          totalBalance.m += n;
          bool b = closed.b;
          uint r = raised.n;
          if(n!=r && b==false) {
            missingFund = MissingFundTuple(n,r,true);
          }
          raised.n += n;
          bool b = closed.b;
          uint n = totalBalance.m;
          if(n!=n && b==false) {
            missingFund = MissingFundTuple(n,n,true);
          }
          uint t = target.t;
          if(true==onceRefund.b) {
            if(n>=t) {
              illegalRefund = IllegalRefundTuple(true);
            }
          }
          bool b = closed.b;
          uint n = totalBalance.m;
          if(n!=n && b==false) {
            missingFund = MissingFundTuple(n,r,true);
          }
          uint t = target.t;
          if(true==onceRefund.b) {
            if(n>=t) {
              illegalRefund = IllegalRefundTuple(true);
            }
          }
          return true;
        }
      }
      return false;
  }
  function updateTotalBalanceOnInsertConstructor_r18() private    {
      totalBalance = TotalBalanceTuple(0,true);
  }
  function updateOnceWithdrawOnInsertConstructor_r16() private    {
      onceWithdraw = OnceWithdrawTuple(false,true);
  }
  function updateRaisedOnInsertConstructor_r7() private    {
      raised = RaisedTuple(0,true);
  }
  function updateTargetOnInsertConstructor_r15(uint t) private    {
      target = TargetTuple(t,true);
  }
  function updateOnceRefundOnInsertConstructor_r13() private    {
      onceRefund = OnceRefundTuple(false,true);
  }
  function updateWithdrawOnInsertRecv_withdraw_r10() private   returns (bool) {
      address p = beneficiary.p;
      uint t = target.t;
      uint r = raised.n;
      if(p==msg.sender) {
        if(r>=t) {
          emit Withdraw(p,r);
          payable(p).send(r);
          onceWithdraw = OnceWithdrawTuple(true,true);
          if(true==onceRefund.b) {
            refundAndWithdraw = RefundAndWithdrawTuple(true);
          }
          return true;
        }
      }
      return false;
  }
  function updateRefundOnInsertRecv_refund_r4() private   returns (bool) {
      if(true==closed.b) {
        address p = msg.sender;
        uint t = target.t;
        uint r = raised.n;
        uint n = balanceOf[p].n;
        if(r<t && n>0) {
          emit Refund(p,n);
          payable(p).send(n);
          onceRefund = OnceRefundTuple(true,true);
          if(true==onceWithdraw.b) {
            refundAndWithdraw = RefundAndWithdrawTuple(true);
          }
          uint t = target.t;
          uint r = raised.n;
          if(r>=t) {
            illegalRefund = IllegalRefundTuple(true);
          }
          balanceOf[p].n -= n;
          totalBalance.m -= n;
          bool b = closed.b;
          uint r = raised.n;
          if(-n!=n && b==false) {
            missingFund = MissingFundTuple(n,r,true);
          }
          return true;
        }
      }
      return false;
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
}

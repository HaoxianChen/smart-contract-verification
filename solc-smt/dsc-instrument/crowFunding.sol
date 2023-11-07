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
  function getClosed() public view  returns (bool) {
      bool b = closed.b;
      return b;
  }
  function withdraw() public  checkViolations  {
      bool r10 = updateWithdrawOnInsertRecv_withdraw_r10();
      if(r10==false) {
        revert("Rule condition failed");
      }
  }
  function close() public  checkViolations  {
      bool r11 = updateClosedOnInsertRecv_close_r11();
      if(r11==false) {
        revert("Rule condition failed");
      }
  }
  function invest() public  checkViolations payable  {
      bool r5 = updateInvestOnInsertRecv_invest_r5();
      if(r5==false) {
        revert("Rule condition failed");
      }
  }
  function refund() public  checkViolations  {
      bool r4 = updateRefundOnInsertRecv_refund_r4();
      if(r4==false) {
        revert("Rule condition failed");
      }
  }
  function getRaised() public view  returns (uint) {
      uint n = raised.n;
      return n;
  }
  function checkMissingFund() private    {
      MissingFundTuple memory missingFundTuple = missingFund;
      if(missingFundTuple._valid==true) {
	assert(false);
        revert("missingFund");
      }
  }
  function checkRefundAndWithdraw() private    {
      RefundAndWithdrawTuple memory refundAndWithdrawTuple = refundAndWithdraw;
      if(refundAndWithdrawTuple._valid==true) {
  	assert(false);
        revert("refundAndWithdraw");
      }
  }
  function checkIllegalRefund() private    {
      IllegalRefundTuple memory illegalRefundTuple = illegalRefund;
      if(illegalRefundTuple._valid==true) {
        assert(false);
        revert("illegalRefund");
      }
  }
  modifier checkViolations() {
      // Empty()
      _;
      checkMissingFund();
      checkRefundAndWithdraw();
      checkIllegalRefund();
  }
  function updateOnceRefundOnInsertConstructor_r13() private    {
      updateRefundAndWithdrawOnInsertOnceRefund_r1(bool(false));
      updateIllegalRefundOnInsertOnceRefund_r9(bool(false));
      onceRefund = OnceRefundTuple(false,true);
  }
  function updateRefundAndWithdrawOnInsertOnceRefund_r1(bool b) private    {
if (b) {
      if(onceWithdraw.b) {
        refundAndWithdraw = RefundAndWithdrawTuple(true);
      }
}
  }
  function updateIllegalRefundOnInsertOnceRefund_r9(bool b) private    {
if (b) {
      uint t = target.t;
      uint r = raised.n;
      if(r>=t) {
        illegalRefund = IllegalRefundTuple(true);
      }
}
  }
  function updateSendOnInsertWithdraw_r12(address p,uint r) private    {
      payable(p).send(r);
  }
  function updateOnceRefundOnInsertRefund_r2() private    {
      updateIllegalRefundOnInsertOnceRefund_r9(bool(true));
      updateRefundAndWithdrawOnInsertOnceRefund_r1(bool(true));
      onceRefund = OnceRefundTuple(true,true);
  }
  function updateMissingFundOnIncrementRaised_r14(int r) private    {
      int _delta = int(r);
      uint newValue = updateuintByint(raised.n,_delta);
      updateMissingFundOnInsertRaised_r14(newValue);
      updateIllegalRefundOnInsertRaised_r9(newValue);
  }
  function updateOnceWithdrawOnInsertWithdraw_r17() private    {
      updateRefundAndWithdrawOnInsertOnceWithdraw_r1(bool(true));
      onceWithdraw = OnceWithdrawTuple(true,true);
  }
  function updateOwnerOnInsertConstructor_r8() private    {
      address p = msg.sender;
      owner = OwnerTuple(p,true);
  }
  function updateTotalBalanceOnIncrementBalanceOf_r21(int n) private    {
      int delta1 = int(n);
      updateMissingFundOnIncrementTotalBalance_r14(delta1);
      int _delta = int(n);
      uint newValue = updateuintByint(totalBalance.m,_delta);
      totalBalance.m = newValue;
  }
  function updateSendOnInsertRefund_r0(address p,uint n) private    {
      payable(p).send(n);
  }
  function updateBalanceOfOnIncrementInvestTotal_r3(address p,int i) private    {
      int delta0 = int(i);
      updateTotalBalanceOnIncrementBalanceOf_r21(delta0);
      int _delta = int(i);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateInvestTotalOnInsertInvest_r6(address p,uint m) private    {
      int delta0 = int(m);
      updateBalanceOfOnIncrementInvestTotal_r3(p,delta0);
  }
  function updateBeneficiaryOnInsertConstructor_r22(address p) private    {
      beneficiary = BeneficiaryTuple(p,true);
  }
  function updateBalanceOfOnIncrementRefundTotal_r3(address p,int r) private    {
      int delta0 = int(-r);
      updateTotalBalanceOnIncrementBalanceOf_r21(delta0);
      int _delta = int(-r);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateMissingFundOnIncrementTotalBalance_r14(int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(totalBalance.m,_delta);
      updateMissingFundOnInsertTotalBalance_r14(newValue);
  }
  function updateRaisedOnInsertConstructor_r7() private    {
      updateMissingFundOnInsertRaised_r14(uint(0));
      updateIllegalRefundOnInsertRaised_r9(uint(0));
      raised = RaisedTuple(0,true);
  }
  function updateMissingFundOnInsertRaised_r14(uint r) private    {
      bool b = closed.b;
      uint m = totalBalance.m;
      if(m!=r && b==false) {
        missingFund = MissingFundTuple(m,r,true);
      }
  }
  function updateRefundOnInsertRecv_refund_r4() private   returns (bool) {
      if(true==closed.b) {
        address p = msg.sender;
        uint t = target.t;
        uint r = raised.n;
        uint n = balanceOf[p].n;
        if(r<t && n>0) {
          updateOnceRefundOnInsertRefund_r2();
          updateSendOnInsertRefund_r0(p,n);
          updateRefundTotalOnInsertRefund_r20(p,n);
          emit Refund(p,n);
          return true;
        }
      }
      return false;
  }
  function updateOnceWithdrawOnInsertConstructor_r16() private    {
      updateRefundAndWithdrawOnInsertOnceWithdraw_r1(bool(false));
      onceWithdraw = OnceWithdrawTuple(false,true);
  }
  function updateTotalBalanceOnInsertConstructor_r18() private    {
      updateMissingFundOnInsertTotalBalance_r14(uint(0));
      totalBalance = TotalBalanceTuple(0,true);
  }
  function updateIllegalRefundOnInsertRaised_r9(uint r) private    {
      uint t = target.t;
      if(true==onceRefund.b) {
        if(r>=t) {
          illegalRefund = IllegalRefundTuple(true);
        }
      }
  }
  function updateWithdrawOnInsertRecv_withdraw_r10() private   returns (bool) {
      address p = beneficiary.p;
      uint t = target.t;
      uint r = raised.n;
      if(p==msg.sender) {
        if(r>=t) {
          updateSendOnInsertWithdraw_r12(p,r);
          updateOnceWithdrawOnInsertWithdraw_r17();
          emit Withdraw(p,r);
          return true;
        }
      }
      return false;
  }
  function updateMissingFundOnInsertTotalBalance_r14(uint m) private    {
      bool b = closed.b;
      uint r = raised.n;
      if(m!=r && b==false) {
        missingFund = MissingFundTuple(m,r,true);
      }
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateRefundAndWithdrawOnInsertOnceWithdraw_r1(bool b) private    {
if (b) {
      if(true==onceRefund.b) {
        refundAndWithdraw = RefundAndWithdrawTuple(true);
      }
}
  }
  function updateMissingFundOnInsertClosed_r14(bool b) private    {
      uint r = raised.n;
      uint m = totalBalance.m;
      if(m!=r && b==false) {
        missingFund = MissingFundTuple(m,r,true);
      }
  }
  function updateInvestOnInsertRecv_invest_r5() private   returns (bool) {
      if(false==closed.b) {
        uint s = raised.n;
        uint t = target.t;
        uint n = msg.value;
        address p = msg.sender;
        if(s<t) {
          updateInvestTotalOnInsertInvest_r6(p,n);
          updateRaisedOnInsertInvest_r19(n);
          emit Invest(p,n);
          return true;
        }
      }
      return false;
  }
  function updateTargetOnInsertConstructor_r15(uint t) private    {
      target = TargetTuple(t,true);
  }
  function updateRaisedOnInsertInvest_r19(uint m) private    {
      int delta3 = int(m);
      updateIllegalRefundOnIncrementRaised_r9(delta3);
      int delta2 = int(m);
      updateMissingFundOnIncrementRaised_r14(delta2);
      raised.n += m;
  }
  function updateRefundTotalOnInsertRefund_r20(address p,uint m) private    {
      int delta0 = int(m);
      updateBalanceOfOnIncrementRefundTotal_r3(p,delta0);
  }
  function updateClosedOnInsertRecv_close_r11() private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        updateMissingFundOnInsertClosed_r14(bool(true));
        closed = ClosedTuple(true,true);
        emit Closed(true);
        return true;
      }
      return false;
  }
  function updateIllegalRefundOnIncrementRaised_r9(int r) private    {
      int _delta = int(r);
      uint newValue = updateuintByint(raised.n,_delta);
      updateMissingFundOnInsertRaised_r14(newValue);
      updateIllegalRefundOnInsertRaised_r9(newValue);
  }
}

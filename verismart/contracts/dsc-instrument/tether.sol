contract Tether {
  struct UnequalBalanceTuple {
    uint s;
    uint n;
    bool _valid;
  }
  struct OwnerTuple {
    address p;
    bool _valid;
  }
  struct TotalSupplyTuple {
    uint n;
    bool _valid;
  }
  struct IsBlackListedTuple {
    bool b;
    bool _valid;
  }
  struct MaxFeeTuple {
    uint m;
    bool _valid;
  }
  struct BalanceOfTuple {
    uint n;
    bool _valid;
  }
  struct AllowanceTuple {
    uint n;
    bool _valid;
  }
  struct RateTuple {
    uint r;
    bool _valid;
  }
  struct TotalBalancesTuple {
    uint m;
    bool _valid;
  }
  UnequalBalanceTuple unequalBalance;
  RateTuple rate;
  TotalSupplyTuple totalSupply;
  mapping(address=>IsBlackListedTuple) isBlackListed;
  TotalBalancesTuple totalBalances;
  MaxFeeTuple maxFee;
  mapping(address=>BalanceOfTuple) balanceOf;
  mapping(address=>mapping(address=>AllowanceTuple)) allowance;
  OwnerTuple owner;
  event Issue(address p,uint amount);
  event AddBlackList(address p);
  event TransferFromWithFee(address from,address to,address spender,uint fee,uint amount);
  event Redeem(address p,uint amount);
  event IncreaseAllowance(address p,address s,uint n);
  event TransferWithFee(address from,address to,uint fee,uint amount);
  event DestroyBlackFund(address p,uint n);
  constructor() public {
    updateTotalBalancesOnInsertConstructor_r29();
    updateTotalSupplyOnInsertConstructor_r4();
    updateOwnerOnInsertConstructor_r13();
  }
  function issue(address p,uint amount) public  {
    require(totalSupply.n == totalBalances.m);
      bool r11 = updateIssueOnInsertRecv_issue_r11(p,amount);
      if(r11==false) {
        revert("Rule condition failed");
      }
    assert(totalSupply.n == totalBalances.m);
  }
  function getAllowance(address p,address s) public view  returns (uint) {
      AllowanceTuple memory allowanceTuple = allowance[p][s];
      uint n = allowanceTuple.n;
      return n;
  }
  function getTotalSupply() public view  returns (uint) {
      uint n = totalSupply.n;
      return n;
  }
  function redeem(address p,uint amount) public  {
    require(totalSupply.n == totalBalances.m);
      bool r24 = updateRedeemOnInsertRecv_redeem_r24(p,amount);
      if(r24==false) {
        revert("Rule condition failed");
      }
    assert(totalSupply.n == totalBalances.m);
  }
  function transferFrom(address from,address to,uint amount) public  {
      bool r0 = updateTransferFromWithFeeOnInsertRecv_transferFrom_r0(from,to,amount);
      if(r0==false) {
        revert("Rule condition failed");
      }
  }
  function approve(address s,uint n) public  {
      bool r25 = updateIncreaseAllowanceOnInsertRecv_approve_r25(s,n);
      if(r25==false) {
        revert("Rule condition failed");
      }
  }
  function getBalanceOf(address p) public view  returns (uint) {
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      uint n = balanceOfTuple.n;
      return n;
  }
  function transfer(address to,uint amount) public  {
      bool r8 = updateTransferWithFeeOnInsertRecv_transfer_r8(to,amount);
      if(r8==false) {
        revert("Rule condition failed");
      }
  }
  function checkUnequalBalance() private    {
      UnequalBalanceTuple memory unequalBalanceTuple = unequalBalance;
      if(unequalBalanceTuple._valid==true) {
        revert("unequalBalance");
      }
  }
  modifier checkViolations() {
      // Empty()
      _;
      checkUnequalBalance();
  }
  function updateSpentTotalOnInsertTransferFrom_r12(address o,address s,uint n) private    {
      int delta = int(n);
      updateAllowanceOnIncrementSpentTotal_r15(o,s,delta);
  }
  function updateBalanceOfOnIncrementTotalOut_r7(address p,int o) private    {
      int delta = int(-o);
      updateTotalBalancesOnIncrementBalanceOf_r23(delta);
      int _delta = int(-o);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateTransferOnInsertTransferWithFee_r20(address s,address r,uint f,uint n) private    {
      if(true) {
        uint m = n-f;
        updateTotalOutOnInsertTransfer_r22(s,m);
        updateTotalInOnInsertTransfer_r27(r,m);
      }
  }
  function updateTotalBalancesOnIncrementBalanceOf_r23(int n) private    {
      int delta = int(n);
      updateUnequalBalanceOnIncrementTotalBalances_r9(delta);
      int _delta = int(n);
      uint newValue = updateuintByint(totalBalances.m,_delta);
      totalBalances.m = newValue;
  }
  function updateTransferFromWithFeeOnInsertRecv_transferFrom_r0(address o,address r,uint n) private   returns (bool) {
      if(true) {
        uint rt = rate.r;
        if(true) {
          uint mf = maxFee.m;
          if(true) {
            address s = msg.sender;
            BalanceOfTuple memory balanceOfTuple = balanceOf[o];
            if(true) {
              uint m = balanceOfTuple.n;
              IsBlackListedTuple memory isBlackListedTuple = isBlackListed[o];
              if(false==isBlackListedTuple.b) {
                AllowanceTuple memory allowanceTuple = allowance[o][s];
                if(true) {
                  uint k = allowanceTuple.n;
                  if(m>=n && k>=n) {
                    uint f = (rt*n)/10000 < mf ? (rt*n)/10000 : mf;
                    updateTransferFromOnInsertTransferFromWithFee_r21(o,r,s,f,n);
                    updateTransferFromOnInsertTransferFromWithFee_r10(o,r,s,f);
                    emit TransferFromWithFee(o,r,s,f,n);
                    return true;
                  }
                }
              }
            }
          }
        }
      }
      return false;
  }
  function updateBalanceOfOnIncrementTotalRedeem_r7(address p,int m) private    {
      int delta = int(-m);
      updateTotalBalancesOnIncrementBalanceOf_r23(delta);
      int _delta = int(-m);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateBalanceOfOnIncrementTotalIn_r7(address p,int i) private    {
      int delta = int(i);
      updateTotalBalancesOnIncrementBalanceOf_r23(delta);
      int _delta = int(i);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateTotalSupplyOnIncrementAllRedeem_r2(int b) private    {
      int delta = int(-b);
      updateUnequalBalanceOnIncrementTotalSupply_r9(delta);
      int _delta = int(-b);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateTotalSupplyOnInsertConstructor_r4() private    {
      if(true) {
        updateUnequalBalanceOnInsertTotalSupply_r9(uint(0));
        totalSupply = TotalSupplyTuple(0,true);
      }
  }
  function updateIssueOnInsertRecv_issue_r11(address p,uint n) private   returns (bool) {
      if(true) {
        address s = owner.p;
        if(s==msg.sender) {
          if(p!=address(0)) {
            updateAllIssueOnInsertIssue_r26(n);
            updateTotalIssueOnInsertIssue_r14(p,n);
            emit Issue(p,n);
            return true;
          }
        }
      }
      return false;
  }
  function updateUnequalBalanceOnIncrementTotalBalances_r9(int s) private    {
      int _delta = int(s);
      uint newValue = updateuintByint(totalBalances.m,_delta);
      updateUnequalBalanceOnInsertTotalBalances_r9(newValue);
  }
  function updateTransferWithFeeOnInsertRecv_transfer_r8(address r,uint n) private   returns (bool) {
      if(true) {
        uint rt = rate.r;
        if(true) {
          uint mf = maxFee.m;
          if(true) {
            address s = msg.sender;
            BalanceOfTuple memory balanceOfTuple = balanceOf[s];
            if(true) {
              uint m = balanceOfTuple.n;
              IsBlackListedTuple memory isBlackListedTuple = isBlackListed[s];
              if(false==isBlackListedTuple.b) {
                if(n<=m) {
                  uint f = (rt*n)/10000 < mf ? (rt*n)/10000 : mf;
                  updateTransferOnInsertTransferWithFee_r3(s,r,f);
                  updateTransferOnInsertTransferWithFee_r20(s,r,f,n);
                  emit TransferWithFee(s,r,f,n);
                  return true;
                }
              }
            }
          }
        }
      }
      return false;
  }
  function updateTransferFromOnInsertTransferFromWithFee_r21(address o,address r,address s,uint f,uint n) private    {
      if(true) {
        uint m = n-f;
        updateTransferOnInsertTransferFrom_r1(o,r,m);
        updateSpentTotalOnInsertTransferFrom_r12(o,s,m);
      }
  }
  function updateTotalBalancesOnInsertConstructor_r29() private    {
      if(true) {
        updateUnequalBalanceOnInsertTotalBalances_r9(uint(0));
        totalBalances = TotalBalancesTuple(0,true);
      }
  }
  function updateUnequalBalanceOnInsertTotalBalances_r9(uint s) private    {
      if(true) {
        uint n = totalSupply.n;
        if(s!=n) {
          unequalBalance = UnequalBalanceTuple(s,n,true);
        }
      }
  }
  function updateUnequalBalanceOnIncrementTotalSupply_r9(int n) private    {
      int _delta = int(n);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      updateUnequalBalanceOnInsertTotalSupply_r9(newValue);
  }
  function updateOwnerOnInsertConstructor_r13() private    {
      if(true) {
        address s = msg.sender;
        if(true) {
          owner = OwnerTuple(s,true);
        }
      }
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r25(address s,uint n) private   returns (bool) {
      if(true) {
        address o = msg.sender;
        AllowanceTuple memory allowanceTuple = allowance[o][s];
        if(true) {
          uint m = allowanceTuple.n;
          if(true) {
            uint d = n-m;
            updateAllowanceTotalOnInsertIncreaseAllowance_r28(o,s,d);
            emit IncreaseAllowance(o,s,d);
            return true;
          }
        }
      }
      return false;
  }
  function updateUnequalBalanceOnInsertTotalSupply_r9(uint n) private    {
      if(true) {
        uint s = totalBalances.m;
        if(s!=n) {
          unequalBalance = UnequalBalanceTuple(s,n,true);
        }
      }
  }
  function updateTransferFromOnInsertTransferFromWithFee_r10(address o,address r,address s,uint f) private    {
      if(true) {
        address p = owner.p;
        if(true) {
          updateTransferOnInsertTransferFrom_r1(o,p,f);
          updateSpentTotalOnInsertTransferFrom_r12(o,s,f);
        }
      }
  }
  function updateTransferOnInsertTransferWithFee_r3(address s,address r,uint f) private    {
      if(true) {
        address o = owner.p;
        if(true) {
          updateTotalInOnInsertTransfer_r27(o,f);
          updateTotalOutOnInsertTransfer_r22(s,f);
        }
      }
  }
  function updateAllowanceOnIncrementSpentTotal_r15(address o,address s,int l) private    {
      int _delta = int(-l);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function updateTotalRedeemOnInsertRedeem_r18(address p,uint n) private    {
      int delta = int(n);
      updateBalanceOfOnIncrementTotalRedeem_r7(p,delta);
  }
  function updateTotalInOnInsertTransfer_r27(address p,uint n) private    {
      int delta = int(n);
      updateBalanceOfOnIncrementTotalIn_r7(p,delta);
  }
  function updateTotalSupplyOnIncrementAllIssue_r2(int m) private    {
      int delta = int(m);
      updateUnequalBalanceOnIncrementTotalSupply_r9(delta);
      int _delta = int(m);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateRedeemOnInsertRecv_redeem_r24(address p,uint n) private   returns (bool) {
      if(true) {
        address s = owner.p;
        if(s==msg.sender) {
          BalanceOfTuple memory balanceOfTuple = balanceOf[p];
          if(true) {
            uint m = balanceOfTuple.n;
            if(p!=address(0) && n<=m) {
              updateTotalRedeemOnInsertRedeem_r18(p,n);
              updateAllRedeemOnInsertRedeem_r16(n);
              emit Redeem(p,n);
              return true;
            }
          }
        }
      }
      return false;
  }
  function updateAllowanceOnIncrementAllowanceTotal_r15(address o,address s,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function updateAllIssueOnInsertIssue_r26(uint n) private    {
      int delta = int(n);
      updateTotalSupplyOnIncrementAllIssue_r2(delta);
  }
  function updateBalanceOfOnIncrementTotalIssue_r7(address p,int n) private    {
      int delta = int(n);
      updateTotalBalancesOnIncrementBalanceOf_r23(delta);
      int _delta = int(n);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateTransferOnInsertTransferFrom_r1(address o,address r,uint n) private    {
      if(true) {
        updateTotalInOnInsertTransfer_r27(r,n);
        updateTotalOutOnInsertTransfer_r22(o,n);
      }
  }
  function updateAllRedeemOnInsertRedeem_r16(uint n) private    {
      int delta = int(n);
      updateTotalSupplyOnIncrementAllRedeem_r2(delta);
  }
  function updateTotalIssueOnInsertIssue_r14(address p,uint n) private    {
      int delta = int(n);
      updateBalanceOfOnIncrementTotalIssue_r7(p,delta);
  }
  function updateTotalOutOnInsertTransfer_r22(address p,uint n) private    {
      int delta = int(n);
      updateBalanceOfOnIncrementTotalOut_r7(p,delta);
  }
  function updateAllowanceTotalOnInsertIncreaseAllowance_r28(address o,address s,uint n) private    {
      int delta = int(n);
      updateAllowanceOnIncrementAllowanceTotal_r15(o,s,delta);
  }
  function equalBalance() public view {
    assert(totalSupply.n == totalBalances.m);
  }
}

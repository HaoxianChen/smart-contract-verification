contract LtcSwapAsset {
  struct TotalSupplyTuple {
    uint n;
    bool _valid;
  }
  struct NewOwnerTuple {
    address p;
    bool _valid;
  }
  struct OldOwnerTuple {
    address p;
    bool _valid;
  }
  struct AllowanceTuple {
    uint n;
    bool _valid;
  }
  struct UnequalBalanceTuple {
    uint s;
    uint n;
    bool _valid;
  }
  struct EffectiveTimeTuple {
    uint t;
    bool _valid;
  }
  struct TotalBalancesTuple {
    uint m;
    bool _valid;
  }
  struct BalanceOfTuple {
    uint n;
    bool _valid;
  }
  UnequalBalanceTuple unequalBalance;
  EffectiveTimeTuple effectiveTime;
  TotalSupplyTuple totalSupply;
  NewOwnerTuple newOwner;
  OldOwnerTuple oldOwner;
  mapping(address=>BalanceOfTuple) balanceOf;
  mapping(address=>mapping(address=>AllowanceTuple)) allowance;
  TotalBalancesTuple totalBalances;
  event TransferFrom(address from,address to,address spender,uint amount);
  event Burn(address p,uint amount);
  event Mint(address p,uint amount);
  event SwapOwner(address p,address q,uint t);
  event IncreaseAllowance(address p,address s,uint n);
  event Transfer(address from,address to,uint amount);
  constructor() public {
    updateTotalBalancesOnInsertConstructor_r27();
    updateTotalSupplyOnInsertConstructor_r11();
    updateOldOwnerOnInsertConstructor_r8();
  }
  function transferFrom(address from,address to,uint amount) public  checkViolations  {
      bool r22 = updateTransferFromOnInsertRecv_transferFrom_r22(from,to,amount);
      if(r22==false) {
        revert("Rule condition failed");
      }
  }
  function mint(address p,uint amount) public  checkViolations  {
      bool r21 = updateMintOnInsertRecv_mint_r21(p,amount);
      if(r21==false) {
        revert("Rule condition failed");
      }
  }
  function getTotalSupply() public view  returns (uint) {
      uint n = totalSupply.n;
      return n;
  }
  function approve(address s,uint n) public  checkViolations  {
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
  function swapOwner(address p,address q,uint d) public  checkViolations  {
      bool r18 = updateSwapOwnerOnInsertRecv_swapOwner_r18(p,q,d);
      if(r18==false) {
        revert("Rule condition failed");
      }
  }
  function getAllowance(address p,address s) public view  returns (uint) {
      AllowanceTuple memory allowanceTuple = allowance[p][s];
      uint n = allowanceTuple.n;
      return n;
  }
  function transfer(address to,uint amount) public  checkViolations  {
      bool r15 = updateTransferOnInsertRecv_transfer_r15(to,amount);
      if(r15==false) {
        revert("Rule condition failed");
      }
  }
  function burn(address p,uint amount) public  checkViolations  {
      bool r5 = updateBurnOnInsertRecv_burn_r5(p,amount);
      if(r5==false) {
        revert("Rule condition failed");
      }
  }
  function checkUnequalBalance() private    {
      UnequalBalanceTuple memory unequalBalanceTuple = unequalBalance;
      // if(unequalBalanceTuple._valid==true) {
      //   revert("unequalBalance");
      // }
  }
  modifier checkViolations() {
      // Empty()
      _;
      checkUnequalBalance();
  }
  function updateSpentTotalOnInsertTransferFrom_r7(address o,address s,uint n) private    {
      int delta = int(n);
      updateAllowanceOnIncrementSpentTotal_r20(o,s,delta);
  }
  function updateSwapOwnerOnInsertRecv_swapOwner_r18(address p,address q,uint d) private   returns (bool) {
      if(true) {
        address s = msg.sender;
        if(true) {
          uint t0 = block.timestamp;
          if(true) {
            uint t = t0+d;
            updateEffectiveTimeOnInsertSwapOwner_r1(t);
            updateOldOwnerOnInsertSwapOwner_r10(p);
            updateNewOwnerOnInsertSwapOwner_r24(q);
            emit SwapOwner(p,q,t);
            return true;
          }
        }
      }
      return false;
  }
  function updateTransferOnInsertRecv_transfer_r15(address r,uint n) private   returns (bool) {
      if(true) {
        address s = msg.sender;
        BalanceOfTuple memory balanceOfTuple = balanceOf[s];
        if(true) {
          uint m = balanceOfTuple.n;
          if(n<=m) {
            updateTotalOutOnInsertTransfer_r16(s,n);
            updateTotalInOnInsertTransfer_r9(r,n);
            emit Transfer(s,r,n);
            return true;
          }
        }
      }
      return false;
  }
  function updateMintOnInsertRecv_mint_r21(address p,uint n) private   returns (bool) {
      if(true) {
        address s = msg.sender;
        if(p!=address(0) && owner(s)) {
          updateTotalMintOnInsertMint_r13(p,n);
          updateAllMintOnInsertMint_r2(n);
          emit Mint(p,n);
          return true;
        }
      }
      return false;
  }
  function updateAllBurnOnInsertBurn_r23(uint n) private    {
      int delta = int(n);
      updateTotalSupplyOnIncrementAllBurn_r14(delta);
  }
  function updateTotalOutOnInsertTransfer_r16(address p,uint n) private    {
      int delta = int(n);
      updateBalanceOfOnIncrementTotalOut_r19(p,delta);
  }
  function updateTotalBalancesOnInsertConstructor_r27() private    {
      if(true) {
        updateUnequalBalanceOnInsertTotalBalances_r4(uint(0));
        totalBalances = TotalBalancesTuple(0,true);
      }
  }
  function updateOldOwnerOnInsertSwapOwner_r10(address p) private    {
      if(true) {
        oldOwner = OldOwnerTuple(p,true);
      }
  }
  function updateTotalInOnInsertTransfer_r9(address p,uint n) private    {
      int delta = int(n);
      updateBalanceOfOnIncrementTotalIn_r19(p,delta);
  }
  function updateUnequalBalanceOnIncrementTotalBalances_r4(int s) private    {
      int _delta = int(s);
      uint newValue = updateuintByint(totalBalances.m,_delta);
      updateUnequalBalanceOnInsertTotalBalances_r4(newValue);
  }
  function updateTransferOnInsertTransferFrom_r0(address o,address r,uint n) private    {
      if(true) {
        updateTotalOutOnInsertTransfer_r16(o,n);
        updateTotalInOnInsertTransfer_r9(r,n);
        emit Transfer(o,r,n);
      }
  }
  function updateAllowanceTotalOnInsertIncreaseAllowance_r26(address o,address s,uint n) private    {
      int delta = int(n);
      updateAllowanceOnIncrementAllowanceTotal_r20(o,s,delta);
  }
  function updateTotalSupplyOnInsertConstructor_r11() private    {
      if(true) {
        updateUnequalBalanceOnInsertTotalSupply_r4(uint(0));
        totalSupply = TotalSupplyTuple(0,true);
      }
  }
  function updateUnequalBalanceOnInsertTotalBalances_r4(uint s) private    {
      if(true) {
        uint n = totalSupply.n;
        if(s!=n) {
          unequalBalance = UnequalBalanceTuple(s,n,true);
        }
      }
  }
  function updateTotalBalancesOnIncrementBalanceOf_r17(int n) private    {
      int delta = int(n);
      updateUnequalBalanceOnIncrementTotalBalances_r4(delta);
      int _delta = int(n);
      uint newValue = updateuintByint(totalBalances.m,_delta);
      totalBalances.m = newValue;
  }
  function updateTotalMintOnInsertMint_r13(address p,uint n) private    {
      int delta = int(n);
      updateBalanceOfOnIncrementTotalMint_r19(p,delta);
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateAllowanceOnIncrementAllowanceTotal_r20(address o,address s,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function updateBalanceOfOnIncrementTotalBurn_r19(address p,int m) private    {
      int delta = int(-m);
      updateTotalBalancesOnIncrementBalanceOf_r17(delta);
      int _delta = int(-m);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateOldOwnerOnInsertConstructor_r8() private    {
      if(true) {
        address s = msg.sender;
        if(true) {
          oldOwner = OldOwnerTuple(s,true);
        }
      }
  }
  function updateTransferFromOnInsertRecv_transferFrom_r22(address o,address r,uint n) private   returns (bool) {
      if(true) {
        address s = msg.sender;
        AllowanceTuple memory allowanceTuple = allowance[o][s];
        if(true) {
          uint k = allowanceTuple.n;
          BalanceOfTuple memory balanceOfTuple = balanceOf[o];
          if(true) {
            uint m = balanceOfTuple.n;
            if(m>=n && k>=n) {
              updateTransferOnInsertTransferFrom_r0(o,r,n);
              updateSpentTotalOnInsertTransferFrom_r7(o,s,n);
              emit TransferFrom(o,r,s,n);
              return true;
            }
          }
        }
      }
      return false;
  }
  function updateTotalSupplyOnIncrementAllBurn_r14(int b) private    {
      int delta = int(-b);
      updateUnequalBalanceOnIncrementTotalSupply_r4(delta);
      int _delta = int(-b);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateBalanceOfOnIncrementTotalMint_r19(address p,int n) private    {
      int delta = int(n);
      updateTotalBalancesOnIncrementBalanceOf_r17(delta);
      int _delta = int(n);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateBurnOnInsertRecv_burn_r5(address p,uint n) private   returns (bool) {
      if(true) {
        address s = msg.sender;
        BalanceOfTuple memory balanceOfTuple = balanceOf[p];
        if(true) {
          uint m = balanceOfTuple.n;
          if(p!=address(0) && n<=m && owner(s)) {
            updateTotalBurnOnInsertBurn_r12(p,n);
            updateAllBurnOnInsertBurn_r23(n);
            emit Burn(p,n);
            return true;
          }
        }
      }
      return false;
  }
  function updateTotalSupplyOnIncrementAllMint_r14(int m) private    {
      int delta = int(m);
      updateUnequalBalanceOnIncrementTotalSupply_r4(delta);
      int _delta = int(m);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateAllowanceOnIncrementSpentTotal_r20(address o,address s,int l) private    {
      int _delta = int(-l);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function updateBalanceOfOnIncrementTotalIn_r19(address p,int i) private    {
      int delta = int(i);
      updateTotalBalancesOnIncrementBalanceOf_r17(delta);
      int _delta = int(i);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateEffectiveTimeOnInsertSwapOwner_r1(uint t) private    {
      if(true) {
        effectiveTime = EffectiveTimeTuple(t,true);
      }
  }
  function owner(address p) private view  returns (bool) {
      if(p==newOwner.p) {
        if(true) {
          uint t2 = effectiveTime.t;
          if(true) {
            uint t = block.timestamp;
            if(t>=t2) {
              return true;
            }
          }
        }
      }
      if(p==oldOwner.p) {
        if(true) {
          uint t2 = effectiveTime.t;
          if(true) {
            uint t = block.timestamp;
            if(t<t2) {
              return true;
            }
          }
        }
      }
      return false;
  }
  function updateBalanceOfOnIncrementTotalOut_r19(address p,int o) private    {
      int delta = int(-o);
      updateTotalBalancesOnIncrementBalanceOf_r17(delta);
      int _delta = int(-o);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateUnequalBalanceOnInsertTotalSupply_r4(uint n) private    {
      if(true) {
        uint s = totalBalances.m;
        if(s!=n) {
          unequalBalance = UnequalBalanceTuple(s,n,true);
        }
      }
  }
  function updateUnequalBalanceOnIncrementTotalSupply_r4(int n) private    {
      int _delta = int(n);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      updateUnequalBalanceOnInsertTotalSupply_r4(newValue);
  }
  function updateTotalBurnOnInsertBurn_r12(address p,uint n) private    {
      int delta = int(n);
      updateBalanceOfOnIncrementTotalBurn_r19(p,delta);
  }
  function updateNewOwnerOnInsertSwapOwner_r24(address q) private    {
      if(true) {
        newOwner = NewOwnerTuple(q,true);
      }
  }
  function updateAllMintOnInsertMint_r2(uint n) private    {
      int delta = int(n);
      updateTotalSupplyOnIncrementAllMint_r14(delta);
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r25(address s,uint n) private   returns (bool) {
      if(true) {
        address o = msg.sender;
        AllowanceTuple memory allowanceTuple = allowance[o][s];
        if(true) {
          uint m = allowanceTuple.n;
          if(true) {
            uint d = n-m;
            updateAllowanceTotalOnInsertIncreaseAllowance_r26(o,s,d);
            emit IncreaseAllowance(o,s,d);
            return true;
          }
        }
      }
      return false;
  }
  function equalBalance() public view {
    assert(totalSupply.n == totalBalances.m);
  }
}

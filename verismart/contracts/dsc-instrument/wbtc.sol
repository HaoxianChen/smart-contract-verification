contract Wbtc {
  struct OwnerTuple {
    address p;
    bool _valid;
  }
  struct PendingOwnerTuple {
    address p;
    bool _valid;
  }
  struct TotalSupplyTuple {
    uint n;
    bool _valid;
  }
  struct UnequalBalanceTuple {
    uint s;
    uint n;
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
  struct AllowanceTuple {
    uint n;
    bool _valid;
  }
  struct PausedTuple {
    bool b;
    bool _valid;
  }
  UnequalBalanceTuple unequalBalance;
  PendingOwnerTuple pendingOwner;
  TotalSupplyTuple totalSupply;
  TotalBalancesTuple totalBalances;
  mapping(address=>BalanceOfTuple) balanceOf;
  OwnerTuple owner;
  mapping(address=>mapping(address=>AllowanceTuple)) allowance;
  PausedTuple paused;
  event Burn(address p,uint amount);
  event ReclaimToken(address t,address s,uint n);
  event Mint(address p,uint amount);
  event PendingOwner(address p);
  event ClaimOwnership(address p);
  event IncreaseAllowance(address p,address s,uint n);
  event Transfer(address from,address to,uint amount);
  event Paused(bool b);
  event TransferFrom(address from,address to,address spender,uint amount);
  constructor() public {
    updateTotalSupplyOnInsertConstructor_r17();
    updateTotalBalancesOnInsertConstructor_r30();
    updateOwnerOnInsertConstructor_r12();
  }
  function transferFrom(address from,address to,uint amount) public  checkViolations  {
      bool r15 = updateTransferFromOnInsertRecv_transferFrom_r15(from,to,amount);
      if(r15==false) {
        revert("Rule condition failed");
      }
  }
  function unpause() public  checkViolations  {
      bool r24 = updatePausedOnInsertRecv_unpause_r24();
      if(r24==false) {
        revert("Rule condition failed");
      }
  }
  function burn(address p,uint amount) public  checkViolations  {
      bool r8 = updateBurnOnInsertRecv_burn_r8(p,amount);
      if(r8==false) {
        revert("Rule condition failed");
      }
  }
  function getAllowance(address p,address s) public view  returns (uint) {
      AllowanceTuple memory allowanceTuple = allowance[p][s];
      uint n = allowanceTuple.n;
      return n;
  }
  function claimOwnership() public  checkViolations  {
      bool r14 = updateClaimOwnershipOnInsertRecv_claimOwnership_r14();
      if(r14==false) {
        revert("Rule condition failed");
      }
  }
  function transfer(address to,uint amount) public  checkViolations  {
      bool r3 = updateTransferOnInsertRecv_transfer_r3(to,amount);
      if(r3==false) {
        revert("Rule condition failed");
      }
  }
  function getTotalSupply() public view  returns (uint) {
      uint n = totalSupply.n;
      return n;
  }
  function reclaimToken() public  checkViolations  {
      bool r7 = updateReclaimTokenOnInsertRecv_reclaimToken_r7();
      if(r7==false) {
        revert("Rule condition failed");
      }
  }
  function getBalanceOf(address p) public view  returns (uint) {
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      uint n = balanceOfTuple.n;
      return n;
  }
  function pause() public  checkViolations  {
      bool r16 = updatePausedOnInsertRecv_pause_r16();
      if(r16==false) {
        revert("Rule condition failed");
      }
  }
  function mint(address p,uint amount) public  checkViolations  {
      bool r25 = updateMintOnInsertRecv_mint_r25(p,amount);
      if(r25==false) {
        revert("Rule condition failed");
      }
  }
  function approve(address s,uint n) public  checkViolations  {
      bool r28 = updateIncreaseAllowanceOnInsertRecv_approve_r28(s,n);
      if(r28==false) {
        revert("Rule condition failed");
      }
  }
  function transferOwner(address p) public  checkViolations  {
      bool r10 = updatePendingOwnerOnInsertRecv_transferOwner_r10(p);
      if(r10==false) {
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
  function updateAllowanceTotalOnInsertIncreaseAllowance_r29(address o,address s,uint n) private    {
      int delta = int(n);
      updateAllowanceOnIncrementAllowanceTotal_r23(o,s,delta);
  }
  function updatePausedOnInsertRecv_unpause_r24() private   returns (bool) {
      if(true) {
        address s = owner.p;
        if(s==msg.sender) {
          if(true) {
            paused = PausedTuple(false,true);
            emit Paused(false);
            return true;
          }
        }
      }
      return false;
  }
  function updateBalanceOfOnIncrementTotalOut_r9(address p,int o) private    {
      int delta = int(-o);
      updateTotalBalancesOnIncrementBalanceOf_r22(delta);
      int _delta = int(-o);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateUnequalBalanceOnIncrementTotalBalances_r6(int s) private    {
      int _delta = int(s);
      uint newValue = updateuintByint(totalBalances.m,_delta);
      updateUnequalBalanceOnInsertTotalBalances_r6(newValue);
  }
  function updateOwnerOnInsertConstructor_r12() private    {
      if(true) {
        address s = msg.sender;
        if(true) {
          owner = OwnerTuple(s,true);
        }
      }
  }
  function updateTransferOnInsertRecv_transfer_r3(address r,uint n) private   returns (bool) {
      if(false==paused.b) {
        if(true) {
          address s = msg.sender;
          BalanceOfTuple memory balanceOfTuple = balanceOf[s];
          if(true) {
            uint m = balanceOfTuple.n;
            if(n<=m) {
              updateTotalOutOnInsertTransfer_r21(s,n);
              updateTotalInOnInsertTransfer_r13(r,n);
              emit Transfer(s,r,n);
              return true;
            }
          }
        }
      }
      return false;
  }
  function updateBurnOnInsertRecv_burn_r8(address p,uint n) private   returns (bool) {
      if(true) {
        address s = owner.p;
        if(s==msg.sender) {
          BalanceOfTuple memory balanceOfTuple = balanceOf[p];
          if(true) {
            uint m = balanceOfTuple.n;
            if(p!=address(0) && n<=m) {
              updateTotalBurnOnInsertBurn_r18(p,n);
              updateAllBurnOnInsertBurn_r26(n);
              emit Burn(p,n);
              return true;
            }
          }
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
  function updateAllMintOnInsertMint_r2(uint n) private    {
      int delta = int(n);
      updateTotalSupplyOnIncrementAllMint_r20(delta);
  }
  function updateTotalSupplyOnIncrementAllBurn_r20(int b) private    {
      int delta = int(-b);
      updateUnequalBalanceOnIncrementTotalSupply_r6(delta);
      int _delta = int(-b);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateBalanceOfOnIncrementTotalBurn_r9(address p,int m) private    {
      int delta = int(-m);
      updateTotalBalancesOnIncrementBalanceOf_r22(delta);
      int _delta = int(-m);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateReclaimTokenOnInsertRecv_reclaimToken_r7() private   returns (bool) {
      if(true) {
        address s = msg.sender;
        if(s==owner.p) {
          if(true) {
            address t = address(this);
            BalanceOfTuple memory balanceOfTuple = balanceOf[t];
            if(true) {
              uint n = balanceOfTuple.n;
              if(true) {
                updateSendOnInsertReclaimToken_r5(s,n);
                updateTransferOnInsertReclaimToken_r4(t,s,n);
                emit ReclaimToken(t,s,n);
                return true;
              }
            }
          }
        }
      }
      return false;
  }
  function updateMintOnInsertRecv_mint_r25(address p,uint n) private   returns (bool) {
      if(true) {
        address s = owner.p;
        if(s==msg.sender) {
          if(p!=address(0)) {
            updateAllMintOnInsertMint_r2(n);
            updateTotalMintOnInsertMint_r19(p,n);
            emit Mint(p,n);
            return true;
          }
        }
      }
      return false;
  }
  function updateAllBurnOnInsertBurn_r26(uint n) private    {
      int delta = int(n);
      updateTotalSupplyOnIncrementAllBurn_r20(delta);
  }
  function updateUnequalBalanceOnInsertTotalSupply_r6(uint n) private    {
      if(true) {
        uint s = totalBalances.m;
        if(s!=n) {
          unequalBalance = UnequalBalanceTuple(s,n,true);
        }
      }
  }
  function updateTotalMintOnInsertMint_r19(address p,uint n) private    {
      int delta = int(n);
      updateBalanceOfOnIncrementTotalMint_r9(p,delta);
  }
  function updateTotalInOnInsertTransfer_r13(address p,uint n) private    {
      int delta = int(n);
      updateBalanceOfOnIncrementTotalIn_r9(p,delta);
  }
  function updateAllowanceOnIncrementSpentTotal_r23(address o,address s,int l) private    {
      int _delta = int(-l);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function updatePendingOwnerOnInsertRecv_transferOwner_r10(address p) private   returns (bool) {
      if(true) {
        address s = owner.p;
        if(s==msg.sender) {
          if(true) {
            pendingOwner = PendingOwnerTuple(p,true);
            emit PendingOwner(p);
            return true;
          }
        }
      }
      return false;
  }
  function updatePausedOnInsertRecv_pause_r16() private   returns (bool) {
      if(true) {
        address s = owner.p;
        if(s==msg.sender) {
          if(true) {
            paused = PausedTuple(true,true);
            emit Paused(true);
            return true;
          }
        }
      }
      return false;
  }
  function updateSendOnInsertReclaimToken_r5(address s,uint n) private    {
      if(true) {
        payable(s).send(n);
      }
  }
  function updateUnequalBalanceOnInsertTotalBalances_r6(uint s) private    {
      if(true) {
        uint n = totalSupply.n;
        if(s!=n) {
          unequalBalance = UnequalBalanceTuple(s,n,true);
        }
      }
  }
  function updateTotalSupplyOnIncrementAllMint_r20(int m) private    {
      int delta = int(m);
      updateUnequalBalanceOnIncrementTotalSupply_r6(delta);
      int _delta = int(m);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateUnequalBalanceOnIncrementTotalSupply_r6(int n) private    {
      int _delta = int(n);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      updateUnequalBalanceOnInsertTotalSupply_r6(newValue);
  }
  function updateBalanceOfOnIncrementTotalIn_r9(address p,int i) private    {
      int delta = int(i);
      updateTotalBalancesOnIncrementBalanceOf_r22(delta);
      int _delta = int(i);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateSpentTotalOnInsertTransferFrom_r11(address o,address s,uint n) private    {
      int delta = int(n);
      updateAllowanceOnIncrementSpentTotal_r23(o,s,delta);
  }
  function updateAllowanceOnIncrementAllowanceTotal_r23(address o,address s,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function updateTotalBalancesOnIncrementBalanceOf_r22(int n) private    {
      int delta = int(n);
      updateUnequalBalanceOnIncrementTotalBalances_r6(delta);
      int _delta = int(n);
      uint newValue = updateuintByint(totalBalances.m,_delta);
      totalBalances.m = newValue;
  }
  function updateBalanceOfOnIncrementTotalMint_r9(address p,int n) private    {
      int delta = int(n);
      updateTotalBalancesOnIncrementBalanceOf_r22(delta);
      int _delta = int(n);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateTotalBalancesOnInsertConstructor_r30() private    {
      if(true) {
        updateUnequalBalanceOnInsertTotalBalances_r6(uint(0));
        totalBalances = TotalBalancesTuple(0,true);
      }
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r28(address s,uint n) private   returns (bool) {
      if(true) {
        address o = msg.sender;
        AllowanceTuple memory allowanceTuple = allowance[o][s];
        if(true) {
          uint m = allowanceTuple.n;
          if(true) {
            uint d = n-m;
            updateAllowanceTotalOnInsertIncreaseAllowance_r29(o,s,d);
            emit IncreaseAllowance(o,s,d);
            return true;
          }
        }
      }
      return false;
  }
  function updateTotalBurnOnInsertBurn_r18(address p,uint n) private    {
      int delta = int(n);
      updateBalanceOfOnIncrementTotalBurn_r9(p,delta);
  }
  function updateTransferOnInsertTransferFrom_r0(address o,address r,uint n) private    {
      if(true) {
        updateTotalInOnInsertTransfer_r13(r,n);
        updateTotalOutOnInsertTransfer_r21(o,n);
        emit Transfer(o,r,n);
      }
  }
  function updateTotalSupplyOnInsertConstructor_r17() private    {
      if(true) {
        updateUnequalBalanceOnInsertTotalSupply_r6(uint(0));
        totalSupply = TotalSupplyTuple(0,true);
      }
  }
  function updateOwnerOnInsertClaimOwnership_r27(address s) private    {
      if(true) {
        owner = OwnerTuple(s,true);
      }
  }
  function updateTransferOnInsertReclaimToken_r4(address t,address s,uint n) private    {
      if(true) {
        updateTotalInOnInsertTransfer_r13(s,n);
        updateTotalOutOnInsertTransfer_r21(t,n);
        emit Transfer(t,s,n);
      }
  }
  function updateTransferFromOnInsertRecv_transferFrom_r15(address o,address r,uint n) private   returns (bool) {
      if(true) {
        address s = msg.sender;
        if(false==paused.b) {
          BalanceOfTuple memory balanceOfTuple = balanceOf[o];
          if(true) {
            uint m = balanceOfTuple.n;
            AllowanceTuple memory allowanceTuple = allowance[o][s];
            if(true) {
              uint k = allowanceTuple.n;
              if(m>=n && k>=n) {
                updateSpentTotalOnInsertTransferFrom_r11(o,s,n);
                updateTransferOnInsertTransferFrom_r0(o,r,n);
                emit TransferFrom(o,r,s,n);
                return true;
              }
            }
          }
        }
      }
      return false;
  }
  function updatePendingOwnerOnInsertClaimOwnership_r1() private    {
      if(true) {
        pendingOwner = PendingOwnerTuple(address(0),true);
        emit PendingOwner(address(0));
      }
  }
  function updateTotalOutOnInsertTransfer_r21(address p,uint n) private    {
      int delta = int(n);
      updateBalanceOfOnIncrementTotalOut_r9(p,delta);
  }
  function updateClaimOwnershipOnInsertRecv_claimOwnership_r14() private   returns (bool) {
      if(true) {
        address s = pendingOwner.p;
        if(s==msg.sender) {
          if(true) {
            updatePendingOwnerOnInsertClaimOwnership_r1();
            updateOwnerOnInsertClaimOwnership_r27(s);
            emit ClaimOwnership(s);
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

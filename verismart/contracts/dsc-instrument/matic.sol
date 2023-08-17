contract Matic {
  struct OwnerTuple {
    address p;
    bool _valid;
  }
  struct TotalSupplyTuple {
    uint n;
    bool _valid;
  }
  struct IsPauserTuple {
    bool b;
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
  TotalSupplyTuple totalSupply;
  mapping(address=>IsPauserTuple) isPauser;
  TotalBalancesTuple totalBalances;
  mapping(address=>BalanceOfTuple) balanceOf;
  OwnerTuple owner;
  mapping(address=>mapping(address=>AllowanceTuple)) allowance;
  PausedTuple paused;
  event Burn(address p,uint amount);
  event Mint(address p,uint amount);
  event IncreaseAllowance(address p,address s,uint n);
  event IsPauser(address p,bool b);
  event Transfer(address from,address to,uint amount);
  event Paused(bool b);
  event TransferFrom(address from,address to,address spender,uint amount);
  constructor() public {
    updateTotalBalancesOnInsertConstructor_r27();
    updateOwnerOnInsertConstructor_r20();
    updateIsPauserOnInsertConstructor_r8();
    updateTotalSupplyOnInsertConstructor_r12();
    updatePausedOnInsertConstructor_r5();
  }
  function transferFrom(address from,address to,uint amount) public  {
    require(totalSupply.n == totalBalances.m);
      bool r1 = updateTransferFromOnInsertRecv_transferFrom_r1(from,to,amount);
      if(r1==false) {
        revert("Rule condition failed");
      }
    assert(totalSupply.n == totalBalances.m);
  }
  function getAllowance(address p,address s) public view  returns (uint) {
      AllowanceTuple memory allowanceTuple = allowance[p][s];
      uint n = allowanceTuple.n;
      return n;
  }
  function addPauser(address p) public  {
    require(totalSupply.n == totalBalances.m);
      bool r21 = updateIsPauserOnInsertRecv_addPauser_r21(p);
      if(r21==false) {
        revert("Rule condition failed");
      }
    assert(totalSupply.n == totalBalances.m);
  }
  function getTotalSupply() public view  returns (uint) {
      uint n = totalSupply.n;
      return n;
  }
  function mint(address p,uint amount) public  {
    require(totalSupply.n == totalBalances.m);
      bool r13 = updateMintOnInsertRecv_mint_r13(p,amount);
      if(r13==false) {
        revert("Rule condition failed");
      }
    assert(totalSupply.n == totalBalances.m);
  }
  function approve(address s,uint n) public  {
    require(totalSupply.n == totalBalances.m);
      bool r25 = updateIncreaseAllowanceOnInsertRecv_approve_r25(s,n);
      if(r25==false) {
        revert("Rule condition failed");
      }
    assert(totalSupply.n == totalBalances.m);
  }
  function burn(address p,uint amount) public  {
    require(totalSupply.n == totalBalances.m);
      bool r10 = updateBurnOnInsertRecv_burn_r10(p,amount);
      if(r10==false) {
        revert("Rule condition failed");
      }
    assert(totalSupply.n == totalBalances.m);
  }
  function unpause() public  {
    require(totalSupply.n == totalBalances.m);
      bool r23 = updatePausedOnInsertRecv_unpause_r23();
      if(r23==false) {
        revert("Rule condition failed");
      }
    assert(totalSupply.n == totalBalances.m);
  }
  function transfer(address to,uint amount) public  {
    require(totalSupply.n == totalBalances.m);
      bool r3 = updateTransferOnInsertRecv_transfer_r3(to,amount);
      if(r3==false) {
        revert("Rule condition failed");
      }
    assert(totalSupply.n == totalBalances.m);
  }
  function pause() public  {
    require(totalSupply.n == totalBalances.m);
      bool r11 = updatePausedOnInsertRecv_pause_r11();
      if(r11==false) {
        revert("Rule condition failed");
      }
    assert(totalSupply.n == totalBalances.m);
  }
  function renouncePauser(address p) public  {
    require(totalSupply.n == totalBalances.m);
      bool r14 = updateIsPauserOnInsertRecv_renouncePauser_r14(p);
      if(r14==false) {
        revert("Rule condition failed");
      }
    assert(totalSupply.n == totalBalances.m);
  }
  function getBalanceOf(address p) public view  returns (uint) {
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      uint n = balanceOfTuple.n;
      return n;
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
  function updateIsPauserOnInsertRecv_addPauser_r21(address p) private   returns (bool) {
      if(true) {
        address s = msg.sender;
        IsPauserTuple memory isPauserTuple = isPauser[s];
        if(true==isPauserTuple.b) {
          if(true) {
            isPauser[p] = IsPauserTuple(true,true);
            emit IsPauser(p,true);
            return true;
          }
        }
      }
      return false;
  }
  function updatePausedOnInsertRecv_pause_r11() private   returns (bool) {
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
  function updateMintOnInsertRecv_mint_r13(address p,uint n) private   returns (bool) {
      if(false==paused.b) {
        if(true) {
          address s = owner.p;
          if(s==msg.sender) {
            if(p!=address(0)) {
              updateAllMintOnInsertMint_r2(n);
              updateTotalMintOnInsertMint_r16(p,n);
              emit Mint(p,n);
              return true;
            }
          }
        }
      }
      return false;
  }
  function updateAllowanceTotalOnInsertIncreaseAllowance_r26(address o,address s,uint n) private    {
      int delta = int(n);
      updateAllowanceOnIncrementAllowanceTotal_r22(o,s,delta);
  }
  function updateBalanceOfOnIncrementTotalMint_r6(address p,int n) private    {
      int delta = int(n);
      updateTotalBalancesOnIncrementBalanceOf_r19(delta);
      int _delta = int(n);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateAllowanceOnIncrementAllowanceTotal_r22(address o,address s,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function updateIsPauserOnInsertConstructor_r8() private    {
      if(true) {
        address s = msg.sender;
        if(true) {
          isPauser[s] = IsPauserTuple(true,true);
          emit IsPauser(s,true);
        }
      }
  }
  function updateBalanceOfOnIncrementTotalOut_r6(address p,int o) private    {
      int delta = int(-o);
      updateTotalBalancesOnIncrementBalanceOf_r19(delta);
      int _delta = int(-o);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateBurnOnInsertRecv_burn_r10(address p,uint n) private   returns (bool) {
      if(true) {
        address s = msg.sender;
        if(false==paused.b) {
          if(s==owner.p) {
            BalanceOfTuple memory balanceOfTuple = balanceOf[p];
            if(true) {
              uint m = balanceOfTuple.n;
              if(p!=address(0) && n<=m) {
                updateAllBurnOnInsertBurn_r24(n);
                updateTotalBurnOnInsertBurn_r15(p,n);
                emit Burn(p,n);
                return true;
              }
            }
          }
        }
      }
      return false;
  }
  function updateTotalBalancesOnInsertConstructor_r27() private    {
      if(true) {
        updateUnequalBalanceOnInsertTotalBalances_r4(uint(0));
        totalBalances = TotalBalancesTuple(0,true);
      }
  }
  function updateBalanceOfOnIncrementTotalIn_r6(address p,int i) private    {
      int delta = int(i);
      updateTotalBalancesOnIncrementBalanceOf_r19(delta);
      int _delta = int(i);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updatePausedOnInsertRecv_unpause_r23() private   returns (bool) {
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
  function updateSpentTotalOnInsertTransferFrom_r7(address o,address s,uint n) private    {
      int delta = int(n);
      updateAllowanceOnIncrementSpentTotal_r22(o,s,delta);
  }
  function updateUnequalBalanceOnIncrementTotalBalances_r4(int s) private    {
      int _delta = int(s);
      uint newValue = updateuintByint(totalBalances.m,_delta);
      updateUnequalBalanceOnInsertTotalBalances_r4(newValue);
  }
  function updateTotalOutOnInsertTransfer_r18(address p,uint n) private    {
      int delta = int(n);
      updateBalanceOfOnIncrementTotalOut_r6(p,delta);
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
  function updateIsPauserOnInsertRecv_renouncePauser_r14(address p) private   returns (bool) {
      if(true) {
        address s = msg.sender;
        IsPauserTuple memory isPauserTuple = isPauser[s];
        if(true==isPauserTuple.b) {
          if(true) {
            isPauser[p] = IsPauserTuple(false,true);
            emit IsPauser(p,false);
            return true;
          }
        }
      }
      return false;
  }
  function updateBalanceOfOnIncrementTotalBurn_r6(address p,int m) private    {
      int delta = int(-m);
      updateTotalBalancesOnIncrementBalanceOf_r19(delta);
      int _delta = int(-m);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateTotalMintOnInsertMint_r16(address p,uint n) private    {
      int delta = int(n);
      updateBalanceOfOnIncrementTotalMint_r6(p,delta);
  }
  function updateOwnerOnInsertConstructor_r20() private    {
      if(true) {
        address s = msg.sender;
        if(true) {
          owner = OwnerTuple(s,true);
        }
      }
  }
  function updateTotalBalancesOnIncrementBalanceOf_r19(int n) private    {
      int delta = int(n);
      updateUnequalBalanceOnIncrementTotalBalances_r4(delta);
      int _delta = int(n);
      uint newValue = updateuintByint(totalBalances.m,_delta);
      totalBalances.m = newValue;
  }
  function updateTotalSupplyOnInsertConstructor_r12() private    {
      if(true) {
        updateUnequalBalanceOnInsertTotalSupply_r4(uint(0));
        totalSupply = TotalSupplyTuple(0,true);
      }
  }
  function updateTotalSupplyOnIncrementAllBurn_r17(int b) private    {
      int delta = int(-b);
      updateUnequalBalanceOnIncrementTotalSupply_r4(delta);
      int _delta = int(-b);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateTransferFromOnInsertRecv_transferFrom_r1(address o,address r,uint n) private   returns (bool) {
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
                updateTransferOnInsertTransferFrom_r0(o,r,n);
                updateSpentTotalOnInsertTransferFrom_r7(o,s,n);
                emit TransferFrom(o,r,s,n);
                return true;
              }
            }
          }
        }
      }
      return false;
  }
  function updateTotalBurnOnInsertBurn_r15(address p,uint n) private    {
      int delta = int(n);
      updateBalanceOfOnIncrementTotalBurn_r6(p,delta);
  }
  function updateUnequalBalanceOnInsertTotalBalances_r4(uint s) private    {
      if(true) {
        uint n = totalSupply.n;
        if(s!=n) {
          unequalBalance = UnequalBalanceTuple(s,n,true);
        }
      }
  }
  function updateTotalSupplyOnIncrementAllMint_r17(int m) private    {
      int delta = int(m);
      updateUnequalBalanceOnIncrementTotalSupply_r4(delta);
      int _delta = int(m);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateTransferOnInsertTransferFrom_r0(address o,address r,uint n) private    {
      if(true) {
        updateTotalOutOnInsertTransfer_r18(o,n);
        updateTotalInOnInsertTransfer_r9(r,n);
        emit Transfer(o,r,n);
      }
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateAllBurnOnInsertBurn_r24(uint n) private    {
      int delta = int(n);
      updateTotalSupplyOnIncrementAllBurn_r17(delta);
  }
  function updateAllMintOnInsertMint_r2(uint n) private    {
      int delta = int(n);
      updateTotalSupplyOnIncrementAllMint_r17(delta);
  }
  function updateTransferOnInsertRecv_transfer_r3(address r,uint n) private   returns (bool) {
      if(false==paused.b) {
        if(true) {
          address s = msg.sender;
          BalanceOfTuple memory balanceOfTuple = balanceOf[s];
          if(true) {
            uint m = balanceOfTuple.n;
            if(n<=m) {
              updateTotalOutOnInsertTransfer_r18(s,n);
              updateTotalInOnInsertTransfer_r9(r,n);
              emit Transfer(s,r,n);
              return true;
            }
          }
        }
      }
      return false;
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
  function updateTotalInOnInsertTransfer_r9(address p,uint n) private    {
      int delta = int(n);
      updateBalanceOfOnIncrementTotalIn_r6(p,delta);
  }
  function updatePausedOnInsertConstructor_r5() private    {
      if(true) {
        paused = PausedTuple(false,true);
        emit Paused(false);
      }
  }
  function updateAllowanceOnIncrementSpentTotal_r22(address o,address s,int l) private    {
      int _delta = int(-l);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function equalBalance() public view {
    assert(totalSupply.n == totalBalances.m);
  }
}

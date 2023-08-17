contract Shib {
  struct OwnerTuple {
    address p;
    bool _valid;
  }
  struct TotalSupplyTuple {
    uint n;
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
  struct TotalBalancesTuple {
    uint m;
    bool _valid;
  }
  struct BalanceOfTuple {
    uint n;
    bool _valid;
  }
  UnequalBalanceTuple unequalBalance;
  TotalSupplyTuple totalSupply;
  TotalBalancesTuple totalBalances;
  mapping(address=>BalanceOfTuple) balanceOf;
  mapping(address=>mapping(address=>AllowanceTuple)) allowance;
  OwnerTuple owner;
  event TransferFrom(address from,address to,address spender,uint amount);
  event Burn(address p,uint amount);
  event Mint(address p,uint amount);
  event IncreaseAllowance(address p,address s,uint n);
  event BurnFrom(address p,address from,uint n);
  event Transfer(address from,address to,uint amount);
  constructor() public {
    updateTotalSupplyOnInsertConstructor_r1();
    updateTotalBalancesOnInsertConstructor_r22();
    updateOwnerOnInsertConstructor_r8();
  }
  function burnFrom(address p,uint n) public  {
      bool r2 = updateBurnFromOnInsertRecv_burnFrom_r2(p,n);
      if(r2==false) {
        revert("Rule condition failed");
      }
  }
  function mint(address p,uint amount) public  {
      bool r18 = updateMintOnInsertRecv_mint_r18(p,amount);
      if(r18==false) {
        revert("Rule condition failed");
      }
  }
  function getAllowance(address p,address s) public view  returns (uint) {
      AllowanceTuple memory allowanceTuple = allowance[p][s];
      uint n = allowanceTuple.n;
      return n;
  }
  function transferFrom(address from,address to,uint amount) public  {
      require(totalSupply.n == totalBalances.m);
      bool r20 = updateTransferFromOnInsertRecv_transferFrom_r20(from,to,amount);
      assert(totalSupply.n == totalBalances.m);
      if(r20==false) {
        revert("Rule condition failed");
      }
  }
  function getTotalSupply() public view  returns (uint) {
      uint n = totalSupply.n;
      return n;
  }
  function approve(address s,uint n) public  {
    require(totalSupply.n == totalBalances.m);
      bool r19 = updateIncreaseAllowanceOnInsertRecv_approve_r19(s,n);
      assert(totalSupply.n == totalBalances.m);
      if(r19==false) {
        revert("Rule condition failed");
      }
  }
  function getBalanceOf(address p) public view  returns (uint) {
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      uint n = balanceOfTuple.n;
      return n;
  }
  function transfer(address to,uint amount) public  {
      bool r13 = updateTransferOnInsertRecv_transfer_r13(to,amount);
      if(r13==false) {
        revert("Rule condition failed");
      }
  }
  function burn(address p,uint amount) public  {
      bool r5 = updateBurnOnInsertRecv_burn_r5(p,amount);
      if(r5==false) {
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
  function updateIncreaseAllowanceOnInsertRecv_approve_r19(address s,uint n) private   returns (bool) {
      if(true) {
        address o = msg.sender;
        AllowanceTuple memory allowanceTuple = allowance[o][s];
        if(true) {
          uint m = allowanceTuple.n;
          if(true) {
            uint d = n-m;
            updateAllowanceTotalOnInsertIncreaseAllowance_r24(o,s,d);
            emit IncreaseAllowance(o,s,d);
            return true;
          }
        }
      }
      return false;
  }
  function updateBalanceOfOnIncrementTotalOut_r6(address p,int o) private    {
      int delta = int(-o);
      updateTotalBalancesOnIncrementBalanceOf_r16(delta);
      int _delta = int(-o);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateTransferFromOnInsertRecv_transferFrom_r20(address o,address r,uint n) private   returns (bool) {
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
  function updateTransferFromOnInsertBurnFrom_r23(address s,address p,uint n) private    {
      if(true) {
        updateTransferOnInsertTransferFrom_r0(s,p,n);
        updateSpentTotalOnInsertTransferFrom_r7(s,address(0),n);
        emit TransferFrom(s,p,address(0),n);
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
  function updateBurnFromOnInsertRecv_burnFrom_r2(address p,uint n) private   returns (bool) {
      if(true) {
        address s = msg.sender;
        AllowanceTuple memory allowanceTuple = allowance[p][s];
        if(true) {
          uint k = allowanceTuple.n;
          BalanceOfTuple memory balanceOfTuple = balanceOf[p];
          if(true) {
            uint m = balanceOfTuple.n;
            if(p!=address(0) && m>=n && k>=m) {
              updateBurnOnInsertBurnFrom_r14(p,n);
              updateTransferFromOnInsertBurnFrom_r23(s,p,n);
              emit BurnFrom(s,p,n);
              return true;
            }
          }
        }
      }
      return false;
  }
  function updateSpentTotalOnInsertTransferFrom_r7(address o,address s,uint n) private    {
      int delta = int(n);
      updateAllowanceOnIncrementSpentTotal_r17(o,s,delta);
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateOwnerOnInsertConstructor_r8() private    {
      if(true) {
        address s = msg.sender;
        if(true) {
          owner = OwnerTuple(s,true);
        }
      }
  }
  function updateTotalSupplyOnInsertConstructor_r1() private    {
      if(true) {
        updateUnequalBalanceOnInsertTotalSupply_r4(uint(0));
        totalSupply = TotalSupplyTuple(0,true);
      }
  }
  function updateAllBurnOnInsertBurn_r21(uint n) private    {
      int delta = int(n);
      updateTotalSupplyOnIncrementAllBurn_r12(delta);
  }
  function updateTotalSupplyOnIncrementAllMint_r12(int m) private    {
      int delta = int(m);
      updateUnequalBalanceOnIncrementTotalSupply_r4(delta);
      int _delta = int(m);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateAllowanceTotalOnInsertIncreaseAllowance_r24(address o,address s,uint n) private    {
      int delta = int(n);
      updateAllowanceOnIncrementAllowanceTotal_r17(o,s,delta);
  }
  function updateTotalSupplyOnIncrementAllBurn_r12(int b) private    {
      int delta = int(-b);
      updateUnequalBalanceOnIncrementTotalSupply_r4(delta);
      int _delta = int(-b);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateBalanceOfOnIncrementTotalMint_r6(address p,int n) private    {
      int delta = int(n);
      updateTotalBalancesOnIncrementBalanceOf_r16(delta);
      int _delta = int(n);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateTotalBurnOnInsertBurn_r10(address p,uint n) private    {
      int delta = int(n);
      updateBalanceOfOnIncrementTotalBurn_r6(p,delta);
  }
  function updateBurnOnInsertBurnFrom_r14(address p,uint n) private    {
      if(true) {
        updateTotalBurnOnInsertBurn_r10(p,n);
        updateAllBurnOnInsertBurn_r21(n);
        emit Burn(p,n);
      }
  }
  function updateTotalOutOnInsertTransfer_r15(address p,uint n) private    {
      int delta = int(n);
      updateBalanceOfOnIncrementTotalOut_r6(p,delta);
  }
  function updateBurnOnInsertRecv_burn_r5(address p,uint n) private   returns (bool) {
      if(true) {
        address s = owner.p;
        if(s==msg.sender) {
          BalanceOfTuple memory balanceOfTuple = balanceOf[p];
          if(true) {
            uint m = balanceOfTuple.n;
            if(p!=address(0) && n<=m) {
              updateTotalBurnOnInsertBurn_r10(p,n);
              updateAllBurnOnInsertBurn_r21(n);
              emit Burn(p,n);
              return true;
            }
          }
        }
      }
      return false;
  }
  function updateTotalBalancesOnInsertConstructor_r22() private    {
      if(true) {
        updateUnequalBalanceOnInsertTotalBalances_r4(uint(0));
        totalBalances = TotalBalancesTuple(0,true);
      }
  }
  function updateAllowanceOnIncrementSpentTotal_r17(address o,address s,int l) private    {
      int _delta = int(-l);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function updateAllowanceOnIncrementAllowanceTotal_r17(address o,address s,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function updateTransferOnInsertTransferFrom_r0(address o,address r,uint n) private    {
      if(true) {
        updateTotalOutOnInsertTransfer_r15(o,n);
        updateTotalInOnInsertTransfer_r9(r,n);
        emit Transfer(o,r,n);
      }
  }
  function updateBalanceOfOnIncrementTotalIn_r6(address p,int i) private    {
      int delta = int(i);
      updateTotalBalancesOnIncrementBalanceOf_r16(delta);
      int _delta = int(i);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateAllMintOnInsertMint_r3(uint n) private    {
      int delta = int(n);
      updateTotalSupplyOnIncrementAllMint_r12(delta);
  }
  function updateTransferOnInsertRecv_transfer_r13(address r,uint n) private   returns (bool) {
      if(true) {
        address s = msg.sender;
        BalanceOfTuple memory balanceOfTuple = balanceOf[s];
        if(true) {
          uint m = balanceOfTuple.n;
          if(n<=m) {
            updateTotalOutOnInsertTransfer_r15(s,n);
            updateTotalInOnInsertTransfer_r9(r,n);
            emit Transfer(s,r,n);
            return true;
          }
        }
      }
      return false;
  }
  function updateUnequalBalanceOnIncrementTotalBalances_r4(int s) private    {
      int _delta = int(s);
      uint newValue = updateuintByint(totalBalances.m,_delta);
      updateUnequalBalanceOnInsertTotalBalances_r4(newValue);
  }
  function updateTotalBalancesOnIncrementBalanceOf_r16(int n) private    {
      int delta = int(n);
      updateUnequalBalanceOnIncrementTotalBalances_r4(delta);
      int _delta = int(n);
      uint newValue = updateuintByint(totalBalances.m,_delta);
      totalBalances.m = newValue;
  }
  function updateTotalMintOnInsertMint_r11(address p,uint n) private    {
      int delta = int(n);
      updateBalanceOfOnIncrementTotalMint_r6(p,delta);
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
  function updateBalanceOfOnIncrementTotalBurn_r6(address p,int m) private    {
      int delta = int(-m);
      updateTotalBalancesOnIncrementBalanceOf_r16(delta);
      int _delta = int(-m);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateMintOnInsertRecv_mint_r18(address p,uint n) private   returns (bool) {
      if(true) {
        address s = owner.p;
        if(s==msg.sender) {
          if(p!=address(0)) {
            updateAllMintOnInsertMint_r3(n);
            updateTotalMintOnInsertMint_r11(p,n);
            emit Mint(p,n);
            return true;
          }
        }
      }
      return false;
  }
  // function equalBalance() public view {
  //   assert(totalSupply.n == totalBalances.m);
  // }
}

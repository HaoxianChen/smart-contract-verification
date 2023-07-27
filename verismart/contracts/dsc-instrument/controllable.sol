contract Controllable {
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
  event ControllerRedeem(address p,uint amount);
  event IncreaseAllowance(address p,address s,uint n);
  event ControllerTransfer(address from,address to,uint amount);
  event Transfer(address from,address to,uint amount);
  constructor() public {
    updateTotalSupplyOnInsertConstructor_r1();
    updateOwnerOnInsertConstructor_r7();
    updateTotalBalancesOnInsertConstructor_r25();
  }
  function transferFrom(address from,address to,uint amount) public  checkViolations  {
      bool r22 = updateTransferFromOnInsertRecv_transferFrom_r22(from,to,amount);
      if(r22==false) {
        revert("Rule condition failed");
      }
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
  function mint(address p,uint amount) public  checkViolations  {
      bool r20 = updateMintOnInsertRecv_mint_r20(p,amount);
      if(r20==false) {
        revert("Rule condition failed");
      }
  }
  function getBalanceOf(address p) public view  returns (uint) {
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      uint n = balanceOfTuple.n;
      return n;
  }
  function approve(address s,uint n) public  checkViolations  {
      bool r21 = updateIncreaseAllowanceOnInsertRecv_approve_r21(s,n);
      if(r21==false) {
        revert("Rule condition failed");
      }
  }
  function transfer(address to,uint amount) public  checkViolations  {
      bool r14 = updateTransferOnInsertRecv_transfer_r14(to,amount);
      if(r14==false) {
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
      if(unequalBalanceTuple._valid==true) {
        revert("unequalBalance");
      }
  }
  modifier checkViolations() {
      // Empty()
      _;
      checkUnequalBalance();
  }
  function updateTotalSupplyOnInsertConstructor_r1() private    {
      if(true) {
        updateUnequalBalanceOnInsertTotalSupply_r3(uint(0));
        totalSupply = TotalSupplyTuple(0,true);
      }
  }
  function updateTransferOnInsertTransferFrom_r0(address o,address r,uint n) private    {
      if(true) {
        updateTotalInOnInsertTransfer_r8(r,n);
        updateTotalOutOnInsertTransfer_r15(o,n);
        emit Transfer(o,r,n);
      }
  }
  function updateTotalBalancesOnIncrementBalanceOf_r16(int n) private    {
      int delta = int(n);
      updateUnequalBalanceOnIncrementTotalBalances_r3(delta);
      int _delta = int(n);
      uint newValue = updateuintByint(totalBalances.m,_delta);
      totalBalances.m = newValue;
  }
  function updateTotalBalancesOnInsertConstructor_r25() private    {
      if(true) {
        updateUnequalBalanceOnInsertTotalBalances_r3(uint(0));
        totalBalances = TotalBalancesTuple(0,true);
      }
  }
  function updateTotalOutOnInsertTransfer_r15(address p,uint n) private    {
      int delta = int(n);
      updateBalanceOfOnIncrementTotalOut_r18(p,delta);
  }
  function updateOwnerOnInsertConstructor_r7() private    {
      if(true) {
        address s = msg.sender;
        if(true) {
          owner = OwnerTuple(s,true);
        }
      }
  }
  function updateAllowanceOnIncrementAllowanceTotal_r19(address o,address s,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function updateBalanceOfOnIncrementTotalIn_r18(address p,int i) private    {
      int delta = int(i);
      updateTotalBalancesOnIncrementBalanceOf_r16(delta);
      int _delta = int(i);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateUnequalBalanceOnIncrementTotalSupply_r3(int n) private    {
      int _delta = int(n);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      updateUnequalBalanceOnInsertTotalSupply_r3(newValue);
  }
  function updateBalanceOfOnIncrementTotalMint_r18(address p,int n) private    {
      int delta = int(n);
      updateTotalBalancesOnIncrementBalanceOf_r16(delta);
      int _delta = int(n);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateTotalSupplyOnIncrementAllMint_r13(int m) private    {
      int delta = int(m);
      updateUnequalBalanceOnIncrementTotalSupply_r3(delta);
      int _delta = int(m);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateUnequalBalanceOnInsertTotalBalances_r3(uint s) private    {
      if(true) {
        uint n = totalSupply.n;
        if(s!=n) {
          unequalBalance = UnequalBalanceTuple(s,n,true);
        }
      }
  }
  function updateTransferOnInsertRecv_transfer_r14(address r,uint n) private   returns (bool) {
      if(true) {
        address s = msg.sender;
        BalanceOfTuple memory balanceOfTuple = balanceOf[s];
        if(true) {
          uint m = balanceOfTuple.n;
          if(n<=m) {
            updateTotalInOnInsertTransfer_r8(r,n);
            updateTotalOutOnInsertTransfer_r15(s,n);
            emit Transfer(s,r,n);
            return true;
          }
        }
      }
      return false;
  }
  function updateTotalSupplyOnIncrementAllBurn_r13(int b) private    {
      int delta = int(-b);
      updateUnequalBalanceOnIncrementTotalSupply_r3(delta);
      int _delta = int(-b);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r21(address s,uint n) private   returns (bool) {
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
  function updateUnequalBalanceOnInsertTotalSupply_r3(uint n) private    {
      if(true) {
        uint s = totalBalances.m;
        if(s!=n) {
          unequalBalance = UnequalBalanceTuple(s,n,true);
        }
      }
  }
  function updateAllBurnOnInsertBurn_r23(uint n) private    {
      int delta = int(n);
      updateTotalSupplyOnIncrementAllBurn_r13(delta);
  }
  function updateSpentTotalOnInsertTransferFrom_r6(address o,address s,uint n) private    {
      int delta = int(n);
      updateAllowanceOnIncrementSpentTotal_r19(o,s,delta);
  }
  function updateTotalInOnInsertTransfer_r8(address p,uint n) private    {
      int delta = int(n);
      updateBalanceOfOnIncrementTotalIn_r18(p,delta);
  }
  function updateMintOnInsertRecv_mint_r20(address p,uint n) private   returns (bool) {
      if(true) {
        address s = owner.p;
        if(s==msg.sender) {
          if(p!=address(0)) {
            updateAllMintOnInsertMint_r10(n);
            updateTotalMintOnInsertMint_r12(p,n);
            emit Mint(p,n);
            return true;
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
  function updateTotalBurnOnInsertBurn_r11(address p,uint n) private    {
      int delta = int(n);
      updateBalanceOfOnIncrementTotalBurn_r18(p,delta);
  }
  function updateAllowanceTotalOnInsertIncreaseAllowance_r24(address o,address s,uint n) private    {
      int delta = int(n);
      updateAllowanceOnIncrementAllowanceTotal_r19(o,s,delta);
  }
  function updateBalanceOfOnIncrementTotalBurn_r18(address p,int m) private    {
      int delta = int(-m);
      updateTotalBalancesOnIncrementBalanceOf_r16(delta);
      int _delta = int(-m);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateBurnOnInsertRecv_burn_r5(address p,uint n) private   returns (bool) {
      if(true) {
        address s = owner.p;
        if(s==msg.sender) {
          BalanceOfTuple memory balanceOfTuple = balanceOf[p];
          if(true) {
            uint m = balanceOfTuple.n;
            if(p!=address(0) && n<=m) {
              updateAllBurnOnInsertBurn_r23(n);
              updateTotalBurnOnInsertBurn_r11(p,n);
              emit Burn(p,n);
              return true;
            }
          }
        }
      }
      return false;
  }
  function updateAllowanceOnIncrementSpentTotal_r19(address o,address s,int l) private    {
      int _delta = int(-l);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function updateUnequalBalanceOnIncrementTotalBalances_r3(int s) private    {
      int _delta = int(s);
      uint newValue = updateuintByint(totalBalances.m,_delta);
      updateUnequalBalanceOnInsertTotalBalances_r3(newValue);
  }
  function updateBalanceOfOnIncrementTotalOut_r18(address p,int o) private    {
      int delta = int(-o);
      updateTotalBalancesOnIncrementBalanceOf_r16(delta);
      int _delta = int(-o);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateAllMintOnInsertMint_r10(uint n) private    {
      int delta = int(n);
      updateTotalSupplyOnIncrementAllMint_r13(delta);
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
              updateSpentTotalOnInsertTransferFrom_r6(o,s,n);
              emit TransferFrom(o,r,s,n);
              return true;
            }
          }
        }
      }
      return false;
  }
  function updateTotalMintOnInsertMint_r12(address p,uint n) private    {
      int delta = int(n);
      updateBalanceOfOnIncrementTotalMint_r18(p,delta);
  }
  function equalBalance() public view {
    assert(totalSupply.n == totalBalances.m);
  }
}

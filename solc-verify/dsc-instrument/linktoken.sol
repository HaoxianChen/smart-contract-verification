/**
* @notice invariant (totalSupply.n == totalBalances.m)
*/
contract Linktoken {
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
  event Transfer(address from,address to,uint amount);
  constructor() public {
    updateTotalSupplyOnInsertConstructor_r2();
    updateTotalBalancesOnInsertConstructor_r22();
    updateOwnerOnInsertConstructor_r10();
  }
  function mint(address p,uint amount) public  checkViolations  {
      bool r18 = updateMintOnInsertRecv_mint_r18(p,amount);
      if(r18==false) {
        revert("Rule condition failed");
      }
  }
  function transfer(address to,uint amount) public  checkViolations  {
      bool r6 = updateTransferOnInsertRecv_transfer_r6(to,amount);
      if(r6==false) {
        revert("Rule condition failed");
      }
  }
  function transferFrom(address from,address to,uint amount) public  checkViolations  {
      bool r0 = updateTransferFromOnInsertRecv_transferFrom_r0(from,to,amount);
      if(r0==false) {
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
  function getBalanceOf(address p) public view  returns (uint) {
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      uint n = balanceOfTuple.n;
      return n;
  }
  function burn(address p,uint amount) public  checkViolations  {
      bool r7 = updateBurnOnInsertRecv_burn_r7(p,amount);
      if(r7==false) {
        revert("Rule condition failed");
      }
  }
  function approve(address s,uint n) public  checkViolations  {
      bool r20 = updateIncreaseAllowanceOnInsertRecv_approve_r20(s,n);
      if(r20==false) {
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
  function updateSpentTotalOnInsertTransferFrom_r9(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementSpentTotal_r17(o,s,delta0);
  }
  function updateBalanceOfOnIncrementTotalBurn_r8(address p,int m) private    {
      int delta0 = int(-m);
      updateTotalBalancesOnIncrementBalanceOf_r16(delta0);
      int _delta = int(-m);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateBalanceOfOnIncrementTotalMint_r8(address p,int n) private    {
      int delta0 = int(n);
      updateTotalBalancesOnIncrementBalanceOf_r16(delta0);
      int _delta = int(n);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateAllowanceTotalOnInsertIncreaseAllowance_r21(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementAllowanceTotal_r17(o,s,delta0);
  }
  function updateAllowanceOnIncrementSpentTotal_r17(address o,address s,int l) private    {
      int _delta = int(-l);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function validRecipient(address p) private view  returns (bool) {
      if(true) {
        address t = address(this);
        if(p!=t && p!=address(0)) {
          return true;
        }
      }
      return false;
  }
  function updateAllowanceOnIncrementAllowanceTotal_r17(address o,address s,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function updateTotalOutOnInsertTransfer_r15(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalOut_r8(p,delta0);
  }
  function updateUnequalBalanceOnIncrementTotalSupply_r5(int n) private    {
      int _delta = int(n);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      updateUnequalBalanceOnInsertTotalSupply_r5(newValue);
  }
  function updateTransferOnInsertTransferFrom_r1(address o,address r,uint n) private    {
      if(true) {
        updateTotalInOnInsertTransfer_r11(r,n);
        updateTotalOutOnInsertTransfer_r15(o,n);
        emit Transfer(o,r,n);
      }
  }
  function updateTotalSupplyOnInsertConstructor_r2() private    {
      if(true) {
        updateUnequalBalanceOnInsertTotalSupply_r5(uint(0));
        totalSupply = TotalSupplyTuple(0,true);
      }
  }
  function updateUnequalBalanceOnInsertTotalSupply_r5(uint n) private    {
      if(true) {
        uint s = totalBalances.m;
        if(s!=n) {
          unequalBalance = UnequalBalanceTuple(s,n,true);
        }
      }
  }
  function updateTotalInOnInsertTransfer_r11(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalIn_r8(p,delta0);
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r20(address s,uint n) private   returns (bool) {
      if(true) {
        address o = msg.sender;
        AllowanceTuple memory allowanceTuple = allowance[o][s];
        if(true) {
          uint m = allowanceTuple.n;
          if(validRecipient(s)) {
            uint d = n-m;
            updateAllowanceTotalOnInsertIncreaseAllowance_r21(o,s,d);
            emit IncreaseAllowance(o,s,d);
            return true;
          }
        }
      }
      return false;
  }
  function updateTotalBurnOnInsertBurn_r12(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalBurn_r8(p,delta0);
  }
  function updateAllMintOnInsertMint_r3(uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyOnIncrementAllMint_r14(delta0);
  }
  function updateUnequalBalanceOnIncrementTotalBalances_r5(int s) private    {
      int _delta = int(s);
      uint newValue = updateuintByint(totalBalances.m,_delta);
      updateUnequalBalanceOnInsertTotalBalances_r5(newValue);
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateAllBurnOnInsertBurn_r19(uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyOnIncrementAllBurn_r14(delta0);
  }
  function updateBalanceOfOnIncrementTotalOut_r8(address p,int o) private    {
      int delta0 = int(-o);
      updateTotalBalancesOnIncrementBalanceOf_r16(delta0);
      int _delta = int(-o);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateTotalBalancesOnInsertConstructor_r22() private    {
      if(true) {
        updateUnequalBalanceOnInsertTotalBalances_r5(uint(0));
        totalBalances = TotalBalancesTuple(0,true);
      }
  }
  function updateBurnOnInsertRecv_burn_r7(address p,uint n) private   returns (bool) {
      if(true) {
        address s = owner.p;
        if(s==msg.sender) {
          BalanceOfTuple memory balanceOfTuple = balanceOf[p];
          if(true) {
            uint m = balanceOfTuple.n;
            if(p!=address(0) && n<=m) {
              updateTotalBurnOnInsertBurn_r12(p,n);
              updateAllBurnOnInsertBurn_r19(n);
              emit Burn(p,n);
              return true;
            }
          }
        }
      }
      return false;
  }
  function updateTotalMintOnInsertMint_r13(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalMint_r8(p,delta0);
  }
  function updateTotalSupplyOnIncrementAllBurn_r14(int b) private    {
      int delta0 = int(-b);
      updateUnequalBalanceOnIncrementTotalSupply_r5(delta0);
      int _delta = int(-b);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateBalanceOfOnIncrementTotalIn_r8(address p,int i) private    {
      int delta0 = int(i);
      updateTotalBalancesOnIncrementBalanceOf_r16(delta0);
      int _delta = int(i);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateTransferOnInsertRecv_transfer_r6(address r,uint n) private   returns (bool) {
      if(true) {
        address s = msg.sender;
        BalanceOfTuple memory balanceOfTuple = balanceOf[s];
        if(true) {
          uint m = balanceOfTuple.n;
          if(n<=m && validRecipient(r)) {
            updateTotalInOnInsertTransfer_r11(r,n);
            updateTotalOutOnInsertTransfer_r15(s,n);
            emit Transfer(s,r,n);
            return true;
          }
        }
      }
      return false;
  }
  function updateTransferFromOnInsertRecv_transferFrom_r0(address o,address r,uint n) private   returns (bool) {
      if(true) {
        address s = msg.sender;
        BalanceOfTuple memory balanceOfTuple = balanceOf[o];
        if(true) {
          uint m = balanceOfTuple.n;
          AllowanceTuple memory allowanceTuple = allowance[o][s];
          if(true) {
            uint k = allowanceTuple.n;
            if(m>=n && k>=n && validRecipient(r)) {
              updateSpentTotalOnInsertTransferFrom_r9(o,s,n);
              updateTransferOnInsertTransferFrom_r1(o,r,n);
              emit TransferFrom(o,r,s,n);
              return true;
            }
          }
        }
      }
      return false;
  }
  function updateTotalBalancesOnIncrementBalanceOf_r16(int n) private    {
      int delta1 = int(n);
      updateUnequalBalanceOnIncrementTotalBalances_r5(delta1);
      int _delta = int(n);
      uint newValue = updateuintByint(totalBalances.m,_delta);
      totalBalances.m = newValue;
  }
  function updateUnequalBalanceOnInsertTotalBalances_r5(uint s) private    {
      if(true) {
        uint n = totalSupply.n;
        if(s!=n) {
          unequalBalance = UnequalBalanceTuple(s,n,true);
        }
      }
  }
  function updateTotalSupplyOnIncrementAllMint_r14(int m) private    {
      int delta0 = int(m);
      updateUnequalBalanceOnIncrementTotalSupply_r5(delta0);
      int _delta = int(m);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateOwnerOnInsertConstructor_r10() private    {
      if(true) {
        address s = msg.sender;
        if(true) {
          owner = OwnerTuple(s,true);
        }
      }
  }
  function updateMintOnInsertRecv_mint_r18(address p,uint n) private   returns (bool) {
      if(true) {
        address s = owner.p;
        if(s==msg.sender) {
          if(p!=address(0)) {
            updateAllMintOnInsertMint_r3(n);
            updateTotalMintOnInsertMint_r13(p,n);
            emit Mint(p,n);
            return true;
          }
        }
      }
      return false;
  }
}

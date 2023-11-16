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
    updateTotalBalancesOnInsertConstructor_r28();
    updateNewOwnerOnInsertConstructor_r9();
    updateEffectiveTimeOnInsertConstructor_r1();
    updateTotalSupplyOnInsertConstructor_r13();
  }
  function transfer(address to,uint amount) public  {
    require(totalSupply.n == totalBalances.m);
      bool r17 = updateTransferOnInsertRecv_transfer_r17(to,amount);
      if(r17==false) {
        revert("Rule condition failed");
      }
    assert(totalSupply.n == totalBalances.m);
  }
  function burn(address p,uint amount) public  {
    require(totalSupply.n == totalBalances.m);
      bool r6 = updateBurnOnInsertRecv_burn_r6(p,amount);
      if(r6==false) {
        revert("Rule condition failed");
      }
    assert(totalSupply.n == totalBalances.m);
  }
  function transferFrom(address from,address to,uint amount) public  {
    require(totalSupply.n == totalBalances.m);
      bool r23 = updateTransferFromOnInsertRecv_transferFrom_r23(from,to,amount);
      if(r23==false) {
        revert("Rule condition failed");
      }
    assert(totalSupply.n == totalBalances.m);
  }
  function getAllowance(address p,address s) public view  returns (uint) {
      uint n = allowance[p][s].n;
      return n;
  }
  function getBalanceOf(address p) public view  returns (uint) {
      uint n = balanceOf[p].n;
      return n;
  }
  function mint(address p,uint amount) public  {
    require(totalSupply.n == totalBalances.m);
      bool r21 = updateMintOnInsertRecv_mint_r21(p,amount);
      if(r21==false) {
        revert("Rule condition failed");
      }
    assert(totalSupply.n == totalBalances.m);
  }
  function approve(address s,uint n) public  {
    require(totalSupply.n == totalBalances.m);
      bool r26 = updateIncreaseAllowanceOnInsertRecv_approve_r26(s,n);
      if(r26==false) {
        revert("Rule condition failed");
      }
    assert(totalSupply.n == totalBalances.m);
  }
  function getTotalSupply() public view  returns (uint) {
      uint n = totalSupply.n;
      return n;
  }
  function swapOwner(address p,address q,uint d) public  {
    require(totalSupply.n == totalBalances.m);
      bool r22 = updateSwapOwnerOnInsertRecv_swapOwner_r22(p,q,d);
      if(r22==false) {
        revert("Rule condition failed");
      }
    assert(totalSupply.n == totalBalances.m);
  }
  function updateMintOnInsertRecv_mint_r21(address p,uint n) private   returns (bool) {
      address s = msg.sender;
      if(p!=address(0) && owner(s)) {
        emit Mint(p,n);
        totalSupply.n += n;
        balanceOf[p].n += n;
        totalBalances.m += n;
        return true;
      }
      return false;
  }
  function updateSwapOwnerOnInsertRecv_swapOwner_r22(address p,address q,uint d) private   returns (bool) {
      address s = msg.sender;
      uint t0 = block.timestamp;
      if(owner(s)) {
        uint t = t0+d;
        emit SwapOwner(p,q,t);
        oldOwner = OldOwnerTuple(p,true);
        effectiveTime = EffectiveTimeTuple(t,true);
        newOwner = NewOwnerTuple(q,true);
        return true;
      }
      return false;
  }
  function updateTransferFromOnInsertRecv_transferFrom_r23(address o,address r,uint n) private   returns (bool) {
      address s = msg.sender;
      uint k = allowance[o][s].n;
      uint m = balanceOf[o].n;
      if(m>=n && k>=n) {
        emit TransferFrom(o,r,s,n);
        emit Transfer(o,r,n);
        balanceOf[o].n -= n;
        totalBalances.m -= n;
        balanceOf[r].n += n;
        totalBalances.m += n;
        allowance[o][s].n -= n;
        return true;
      }
      return false;
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r26(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      uint m = allowance[o][s].n;
      uint d = n-m;
      emit IncreaseAllowance(o,s,d);
      allowance[o][s].n += d;
      return true;
      return false;
  }
  function updateEffectiveTimeOnInsertConstructor_r1() private    {
      uint t = block.timestamp;
      effectiveTime = EffectiveTimeTuple(t,true);
  }
  function updateNewOwnerOnInsertConstructor_r9() private    {
      address s = msg.sender;
      newOwner = NewOwnerTuple(s,true);
  }
  function updateTransferOnInsertRecv_transfer_r17(address r,uint n) private   returns (bool) {
      address s = msg.sender;
      uint m = balanceOf[s].n;
      if(n<=m) {
        emit Transfer(s,r,n);
        balanceOf[s].n -= n;
        totalBalances.m -= n;
        balanceOf[r].n += n;
        totalBalances.m += n;
        return true;
      }
      return false;
  }
  function owner(address p) private view  returns (bool) {
      if(p==oldOwner.p) {
        uint t2 = effectiveTime.t;
        uint t = block.timestamp;
        if(t<t2) {
          return true;
        }
      }
      if(p==newOwner.p) {
        uint t2 = effectiveTime.t;
        uint t = block.timestamp;
        if(t>=t2) {
          return true;
        }
      }
      return false;
  }
  function updateTotalBalancesOnInsertConstructor_r28() private    {
      totalBalances = TotalBalancesTuple(0,true);
  }
  function updateBurnOnInsertRecv_burn_r6(address p,uint n) private   returns (bool) {
      address s = msg.sender;
      uint m = balanceOf[p].n;
      if(p!=address(0) && n<=m && owner(s)) {
        emit Burn(p,n);
        balanceOf[p].n -= n;
        totalBalances.m -= n;
        totalSupply.n -= n;
        return true;
      }
      return false;
  }
  function updateTotalSupplyOnInsertConstructor_r13() private    {
      totalSupply = TotalSupplyTuple(0,true);
  }
  // function equalBalance() public view {
  //   assert(totalSupply.n == totalBalances.m);
  // }
}

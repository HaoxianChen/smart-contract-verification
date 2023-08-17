contract Bnb {
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
  struct OwnerTuple {
    address payable p;
    bool _valid;
  }
  struct FreezeOfTuple {
    uint n;
    bool _valid;
  }
  struct FreezeSumTuple {
    uint m;
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
  mapping(address=>FreezeOfTuple) freezeOf;
  FreezeSumTuple freezeSum;
  event TransferFrom(address from,address to,address spender,uint amount);
  event Burn(address p,uint amount);
  event Mint(address p,uint amount);
  event WithdrawEther(address p,uint amount);
  event IncreaseAllowance(address p,address s,uint n);
  event Unfreeze(address p,uint n);
  event Freeze(address p,uint n);
  event Transfer(address from,address to,uint amount);
  constructor(uint initialSupply) public {
    updateTotalSupplyOnInsertConstructor_r5(initialSupply);
    updateOwnerOnInsertConstructor_r7();
    updateTotalInOnInsertConstructor_r30(initialSupply);
    updateAllMintOnInsertConstructor_r9(initialSupply);
    updateTotalMintOnInsertConstructor_r32(initialSupply);
    updateBalanceOfOnInsertConstructor_r4(initialSupply);
    updateTotalBalancesOnInsertConstructor_r25(initialSupply);
  }
  function approve(address s,uint n) public  {
      require(totalBalances.m + freezeSum.m == totalSupply.n);
      bool r29 = updateIncreaseAllowanceOnInsertRecv_approve_r29(s,n);
      if(r29==false) {
        revert("Rule condition failed");
      }
      assert(totalBalances.m + freezeSum.m == totalSupply.n);
  }
  function unfreeze(uint n) public  {
      bool r6 = updateUnfreezeOnInsertRecv_unfreeze_r6(n);
      if(r6==false) {
        revert("Rule condition failed");
      }
  }
  function burn(uint amount) public  {
      bool r16 = updateBurnOnInsertRecv_burn_r16(amount);
      if(r16==false) {
        revert("Rule condition failed");
      }
  }
  function getTotalSupply() public view  returns (uint) {
      uint n = totalSupply.n;
      return n;
  }
  function getAllowance(address p,address s) public view  returns (uint) {
      uint n = allowance[p][s].n;
      return n;
  }
  function getBalanceOf(address p) public view  returns (uint) {
      uint n = balanceOf[p].n;
      return n;
  }
  function transfer(address to,uint amount) public  {
      require(totalBalances.m + freezeSum.m == totalSupply.n);
      bool r8 = updateTransferOnInsertRecv_transfer_r8(to,amount);
      if(r8==false) {
        revert("Rule condition failed");
      }
      assert(totalBalances.m + freezeSum.m == totalSupply.n);
  }
  function freeze(uint n) public  {
      require(totalBalances.m + freezeSum.m == totalSupply.n);
      bool r24 = updateFreezeOnInsertRecv_freeze_r24(n);
      if(r24==false) {
        revert("Rule condition failed");
      }
      assert(totalBalances.m + freezeSum.m == totalSupply.n);
  }
  function transferFrom(address from,address to,uint amount) public  {
      require(totalBalances.m + freezeSum.m == totalSupply.n);
      bool r14 = updateTransferFromOnInsertRecv_transferFrom_r14(from,to,amount);
      if(r14==false) {
        revert("Rule condition failed");
      }
      assert(totalBalances.m + freezeSum.m == totalSupply.n);
  }
  function withdrawEther(uint amount) public  {
      require(totalBalances.m + freezeSum.m == totalSupply.n);
      bool r23 = updateWithdrawEtherOnInsertRecv_withdrawEther_r23(amount);
      if(r23==false) {
        revert("Rule condition failed");
      }
      assert(totalBalances.m + freezeSum.m == totalSupply.n);
  }
  function updateBalanceOfOnInsertConstructor_r4(uint n) private    {
      address s = msg.sender;
      balanceOf[s] = BalanceOfTuple(n,true);
  }
  function updateAllMintOnInsertConstructor_r9(uint n) private    {
      // Empty()
  }
  function updateTransferFromOnInsertRecv_transferFrom_r14(address o,address r,uint n) private   returns (bool) {
      address s = msg.sender;
      uint k = allowance[o][s].n;
      uint m = balanceOf[o].n;
      if(m>=n && r!=address(0) && n+m>=m && n>0 && k>=n) {
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
  function updateIncreaseAllowanceOnInsertRecv_approve_r29(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      uint m = allowance[o][s].n;
      uint d = n-m;
      emit IncreaseAllowance(o,s,d);
      allowance[o][s].n += d;
      return true;
      return false;
  }
  function updateBurnOnInsertRecv_burn_r16(uint n) private   returns (bool) {
      address p = msg.sender;
      uint m = balanceOf[p].n;
      if(p!=address(0) && n<=m) {
        emit Burn(p,n);
        balanceOf[p].n -= n;
        totalBalances.m -= n;
        totalSupply.n -= n;
        return true;
      }
      return false;
  }
  function updateUnfreezeOnInsertRecv_unfreeze_r6(uint n) private   returns (bool) {
      address p = msg.sender;
      uint m = freezeOf[p].n;
      if(n<=m && n>0) {
        emit Unfreeze(p,n);
        freezeOf[p].n -= n;
        balanceOf[p].n += n;
        totalBalances.m += n;
        freezeSum.m -= n;
        return true;
      }
      return false;
  }
  function updateTransferOnInsertRecv_transfer_r8(address r,uint n) private   returns (bool) {
      address s = msg.sender;
      uint m = balanceOf[s].n;
      if(n<=m && n>0 && r!=address(0) && n+m>=m) {
        emit Transfer(s,r,n);
        balanceOf[s].n -= n;
        totalBalances.m -= n;
        balanceOf[r].n += n;
        totalBalances.m += n;
        return true;
      }
      return false;
  }
  function updateFreezeOnInsertRecv_freeze_r24(uint n) private   returns (bool) {
      address p = msg.sender;
      uint m = balanceOf[p].n;
      if(n<=m && n>0) {
        emit Freeze(p,n);
        freezeOf[p].n += n;
        balanceOf[p].n -= n;
        totalBalances.m -= n;
        uint f = freezeSum.m;
        freezeSum.m += n;
        uint s = totalBalances.m;
        return true;
      }
      return false;
  }
  function updateTotalBalancesOnInsertConstructor_r25(uint n) private    {
      totalBalances = TotalBalancesTuple(n,true);
  }
  function updateTotalMintOnInsertConstructor_r32(uint n) private    {
      address s = msg.sender;
      // Empty()
  }
  function updateOwnerOnInsertConstructor_r7() private    {
      address payable s = msg.sender;
      owner = OwnerTuple(s,true);
  }
  function updateWithdrawEtherOnInsertRecv_withdrawEther_r23(uint n) private   returns (bool) {
      address payable p = owner.p;
      if(p==msg.sender) {
        emit WithdrawEther(p,n);
        p.send(n);
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
  function updateTotalInOnInsertConstructor_r30(uint n) private    {
      address s = msg.sender;
      // Empty()
  }
  function updateTotalSupplyOnInsertConstructor_r5(uint n) private    {
      totalSupply = TotalSupplyTuple(n,true);
  }
	function check() public view {
      assert(totalBalances.m + freezeSum.m == totalSupply.n);
	}
}

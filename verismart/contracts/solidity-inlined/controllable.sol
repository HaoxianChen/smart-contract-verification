contract Controllable {
  struct OwnerTuple {
    address p;
    bool _valid;
  }
  struct ControllerTuple {
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
  ControllerTuple controller;
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
  constructor(address p) public {
    updateOwnerOnInsertConstructor_r8();
    updateTotalSupplyOnInsertConstructor_r1();
    updateTotalBalancesOnInsertConstructor_r7();
    updateControllerOnInsertConstructor_r3(p);
  }
  function transferFrom(address from,address to,uint amount) public  {
    require(totalSupply.n == totalBalances.m);
      bool r25 = updateTransferFromOnInsertRecv_transferFrom_r25(from,to,amount);
      if(r25==false) {
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
  function transfer(address to,uint amount) public  {
    require(totalSupply.n == totalBalances.m);
      bool r17 = updateTransferOnInsertRecv_transfer_r17(to,amount);
      if(r17==false) {
        revert("Rule condition failed");
      }
    assert(totalSupply.n == totalBalances.m);
  }
  function approve(address s,uint n) public  {
    require(totalSupply.n == totalBalances.m);
      bool r24 = updateIncreaseAllowanceOnInsertRecv_approve_r24(s,n);
      if(r24==false) {
        revert("Rule condition failed");
      }
    assert(totalSupply.n == totalBalances.m);
  }
  function mint(address p,uint amount) public  {
    require(totalSupply.n == totalBalances.m);
      bool r23 = updateMintOnInsertRecv_mint_r23(p,amount);
      if(r23==false) {
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
  function getTotalSupply() public view  returns (uint) {
      uint n = totalSupply.n;
      return n;
  }
  function controllerRedeem(address p,uint amount) public  {
      bool r5 = updateControllerRedeemOnInsertRecv_controllerRedeem_r5(p,amount);
      if(r5==false) {
        revert("Rule condition failed");
      }
  }
  function updateOwnerOnInsertConstructor_r8() private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
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
  function updateMintOnInsertRecv_mint_r23(address p,uint n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        if(p!=address(0)) {
          emit Mint(p,n);
          totalSupply.n += n;
          balanceOf[p].n += n;
          totalBalances.m += n;
          return true;
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
  function updateControllerRedeemOnInsertRecv_controllerRedeem_r5(address p,uint n) private   returns (bool) {
      address c = controller.p;
      if(c==msg.sender) {
        uint m = balanceOf[p].n;
        if(p!=address(0) && n<=m) {
          emit ControllerRedeem(p,n);
          emit Burn(p,n);
          balanceOf[p].n -= n;
          totalBalances.m -= n;
          totalSupply.n -= n;
          return true;
        }
      }
      return false;
  }
  function updateTotalSupplyOnInsertConstructor_r1() private    {
      totalSupply = TotalSupplyTuple(0,true);
  }
  function updateControllerOnInsertConstructor_r3(address p) private    {
      controller = ControllerTuple(p,true);
  }
  function updateBurnOnInsertRecv_burn_r6(address p,uint n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        uint m = balanceOf[p].n;
        if(p!=address(0) && n<=m) {
          emit Burn(p,n);
          balanceOf[p].n -= n;
          totalBalances.m -= n;
          totalSupply.n -= n;
          return true;
        }
      }
      return false;
  }
  function updateTransferFromOnInsertRecv_transferFrom_r25(address o,address r,uint n) private   returns (bool) {
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
  function updateTotalBalancesOnInsertConstructor_r7() private    {
      totalBalances = TotalBalancesTuple(0,true);
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r24(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      uint m = allowance[o][s].n;
      uint d = n-m;
      emit IncreaseAllowance(o,s,d);
      allowance[o][s].n += d;
      return true;
      return false;
  }
  // function equalBalance() public view {
  //   assert(totalSupply.n == totalBalances.m);
  // }
}

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
  struct RateTuple {
    uint r;
    bool _valid;
  }
  struct TotalBalancesTuple {
    uint m;
    bool _valid;
  }
  struct AllowanceTuple {
    uint n;
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
  constructor(uint n) public {
    updateOwnerOnInsertConstructor_r24();
    updateBalanceOfOnInsertConstructor_r8(n);
    updateTotalSupplyOnInsertConstructor_r22(n);
    updateTotalBalancesOnInsertConstructor_r29(n);
  }
  function approve(address s,uint n) public  {
    require(totalSupply.n == totalBalances.m);
      bool r26 = updateIncreaseAllowanceOnInsertRecv_approve_r26(s,n);
      if(r26==false) {
        revert("Rule condition failed");
      }
    assert(totalSupply.n == totalBalances.m);
  }
  function issue(address p,uint amount) public  {
    require(totalSupply.n == totalBalances.m);
      bool r11 = updateIssueOnInsertRecv_issue_r11(p,amount);
      if(r11==false) {
        revert("Rule condition failed");
      }
    assert(totalSupply.n == totalBalances.m);
  }
  function redeem(address p,uint amount) public  {
    require(totalSupply.n == totalBalances.m);
      bool r25 = updateRedeemOnInsertRecv_redeem_r25(p,amount);
      if(r25==false) {
        revert("Rule condition failed");
      }
    assert(totalSupply.n == totalBalances.m);
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
    require(totalSupply.n == totalBalances.m);
      bool r7 = updateTransferWithFeeOnInsertRecv_transfer_r7(to,amount);
      if(r7==false) {
        revert("Rule condition failed");
      }
    assert(totalSupply.n == totalBalances.m);
  }
  function transferFrom(address from,address to,uint amount) public  {
    require(totalSupply.n == totalBalances.m);
      bool r0 = updateTransferFromWithFeeOnInsertRecv_transferFrom_r0(from,to,amount);
      if(r0==false) {
        revert("Rule condition failed");
      }
    assert(totalSupply.n == totalBalances.m);
  }
  function updateRedeemOnInsertRecv_redeem_r25(address p,uint n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        uint m = balanceOf[p].n;
        if(p!=address(0) && n<=m) {
          emit Redeem(p,n);
          totalSupply.n -= n;
          balanceOf[p].n -= n;
          totalBalances.m -= n;
          return true;
        }
      }
      return false;
  }
  function updateBalanceOfOnInsertConstructor_r8(uint n) private    {
      address s = msg.sender;
      balanceOf[s] = BalanceOfTuple(n,true);
  }
  function updateTransferWithFeeOnInsertRecv_transfer_r7(address r,uint n) private   returns (bool) {
      uint rt = rate.r;
      uint mf = maxFee.m;
      address s = msg.sender;
      uint m = balanceOf[s].n;
      if(false==isBlackListed[s].b) {
        if(n<=m) {
          uint f = (rt*n)/10000 < mf ? (rt*n)/10000 : mf;
          emit TransferWithFee(s,r,f,n);
          address o = owner.p;
          balanceOf[s].n -= f;
          totalBalances.m -= f;
          balanceOf[o].n += f;
          totalBalances.m += f;
          uint m = n-f;
          balanceOf[s].n -= m;
          totalBalances.m -= m;
          balanceOf[r].n += m;
          totalBalances.m += m;
          return true;
        }
      }
      return false;
  }
  function updateIssueOnInsertRecv_issue_r11(address p,uint n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        if(p!=address(0)) {
          emit Issue(p,n);
          balanceOf[p].n += n;
          totalBalances.m += n;
          totalSupply.n += n;
          return true;
        }
      }
      return false;
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
  function updateTotalBalancesOnInsertConstructor_r29(uint n) private    {
      totalBalances = TotalBalancesTuple(n,true);
  }
  function updateTransferFromWithFeeOnInsertRecv_transferFrom_r0(address o,address r,uint n) private   returns (bool) {
      uint rt = rate.r;
      uint mf = maxFee.m;
      address s = msg.sender;
      uint m = balanceOf[o].n;
      if(false==isBlackListed[o].b) {
        uint k = allowance[o][s].n;
        if(m>=n && k>=n) {
          uint f = (rt*n)/10000 < mf ? (rt*n)/10000 : mf;
          emit TransferFromWithFee(o,r,s,f,n);
          address p = owner.p;
          balanceOf[o].n -= f;
          totalBalances.m -= f;
          balanceOf[p].n += f;
          totalBalances.m += f;
          allowance[o][s].n -= f;
          uint m = n-f;
          balanceOf[o].n -= m;
          totalBalances.m -= m;
          balanceOf[r].n += m;
          totalBalances.m += m;
          allowance[o][s].n -= m;
          return true;
        }
      }
      return false;
  }
  function updateTotalSupplyOnInsertConstructor_r22(uint n) private    {
      totalSupply = TotalSupplyTuple(n,true);
  }
  function updateOwnerOnInsertConstructor_r24() private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  // function equalBalance() public view {
  //   assert(totalSupply.n == totalBalances.m);
  // }
}

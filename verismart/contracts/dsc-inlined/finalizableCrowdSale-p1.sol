contract FinalizableCrowdSale {
  struct RateTuple {
    uint r;
    bool _valid;
  }
  struct AllowanceTuple {
    uint n;
    bool _valid;
  }
  struct FinalizedTuple {
    bool b;
    bool _valid;
  }
  struct OwnerTuple {
    address p;
    bool _valid;
  }
  struct EndTuple {
    uint time;
    bool _valid;
  }
  struct StartTuple {
    uint time;
    bool _valid;
  }
  struct TotalSupplyTuple {
    uint n;
    bool _valid;
  }
  struct BalanceOfTuple {
    uint n;
    bool _valid;
  }
  EndTuple end;
  RateTuple rate;
  mapping(address=>BalanceOfTuple) balanceOf;
  mapping(address=>mapping(address=>AllowanceTuple)) allowance;
  FinalizedTuple finalized;
  OwnerTuple owner;
  StartTuple start;
  TotalSupplyTuple totalSupply;
  event Burn(address p,uint amount);
  event Mint(address p,uint amount);
  event IncreaseAllowance(address p,address s,uint n);
  event Transfer(address from,address to,uint amount);
  event TransferFrom(address from,address to,address spender,uint amount);
  event Finalize();
  bool onceFinalized;
  Tx transaction;
  enum Tx {
	BuyTokens,Finalize, TransferFrom, Approve, Mint, Burn, Transfer
  }

    modifier checkBuyAfterFinalization {
        require(!(transaction==Tx.BuyTokens && onceFinalized));
        _;
        assert(!(transaction==Tx.BuyTokens && onceFinalized));
    }
    modifier checkEndAfterFinalization {
        require(!(onceFinalized && block.timestamp < end.time));
        _;
        assert(!(onceFinalized && block.timestamp < end.time));
    }
  constructor() public {
    updateOnceFinalizeOnInsertConstructor_r5();
    updateOwnerOnInsertConstructor_r9();
    updateTotalSupplyOnInsertConstructor_r3();
    onceFinalized=false;
  }
  function transferFrom(address from,address to,uint amount) public    checkBuyAfterFinalization{
      bool r22 = updateTransferFromOnInsertRecv_transferFrom_r22(from,to,amount);
      if(r22==false) {
        revert("Rule condition failed");
      }
      transaction=Tx.TransferFrom;
  }
  function approve(address s,uint n) public    checkBuyAfterFinalization{
      bool r21 = updateIncreaseAllowanceOnInsertRecv_approve_r21(s,n);
      if(r21==false) {
        revert("Rule condition failed");
      }
      transaction=Tx.Approve;
  }
  function mint(address p,uint amount) public    checkBuyAfterFinalization{
      bool r20 = updateMintOnInsertRecv_mint_r20(p,amount);
      if(r20==false) {
        revert("Rule condition failed");
      }
      transaction=Tx.Mint;
  }
  function getTotalSupply() public view  returns (uint) {
      uint n = totalSupply.n;
      return n;
  }
  function buyToken(address p,uint amount) public    checkBuyAfterFinalization{
      bool r2 = updateMintOnInsertRecv_buyToken_r2(p,amount);
      if(r2==false) {
        revert("Rule condition failed");
      }
      transaction=Tx.BuyTokens;
  }
  function getAllowance(address p,address s) public view  returns (uint) {
      uint n = allowance[p][s].n;
      return n;
  }
  function finalize() public    checkBuyAfterFinalization{
      bool r24 = updateFinalizeOnInsertRecv_finalize_r24();
      if(r24==false) {
        revert("Rule condition failed");
      }
      onceFinalized=true;
      transaction=Tx.Finalize;
  }
  function burn(address p,uint amount) public    checkBuyAfterFinalization{
      bool r15 = updateBurnOnInsertRecv_burn_r15(p,amount);
      if(r15==false) {
        revert("Rule condition failed");
      }
      transaction=Tx.Burn;
  }
  function transfer(address to,uint amount) public    checkBuyAfterFinalization{
      bool r17 = updateTransferOnInsertRecv_transfer_r17(to,amount);
      if(r17==false) {
        revert("Rule condition failed");
      }
      transaction=Tx.Transfer;
  }
  function getBalanceOf(address p) public view  returns (uint) {
      uint n = balanceOf[p].n;
      return n;
  }
  function updateFinalizeOnInsertRecv_finalize_r24() private   returns (bool) {
      address s = msg.sender;
      uint e = end.time;
      if(false==finalized.b) {
        if(s==owner.p) {
          uint t = block.timestamp;
          if(t>e) {
            emit Finalize();
            finalized = FinalizedTuple(false,true);
            return true;
          }
        }
      }
      return false;
  }
  function updateOwnerOnInsertConstructor_r9() private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
  }
  function updateTotalSupplyOnInsertConstructor_r3() private    {
      totalSupply = TotalSupplyTuple(0,true);
  }
  function updateTransferOnInsertRecv_transfer_r17(address r,uint n) private   returns (bool) {
      address s = msg.sender;
      uint m = balanceOf[s].n;
      if(n<=m) {
        emit Transfer(s,r,n);
        balanceOf[s].n -= n;
        balanceOf[r].n += n;
        return true;
      }
      return false;
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r21(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      uint m = allowance[o][s].n;
      uint d = n-m;
      emit IncreaseAllowance(o,s,d);
      allowance[o][s].n += d;
      return true;
      return false;
  }
  function updateMintOnInsertRecv_mint_r20(address p,uint n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        if(p!=address(0)) {
          emit Mint(p,n);
          totalSupply.n += n;
          balanceOf[p].n += n;
          return true;
        }
      }
      return false;
  }
  function updateOnceFinalizeOnInsertConstructor_r5() private    {
      // Empty()
  }
  function updateBurnOnInsertRecv_burn_r15(address p,uint n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        uint m = balanceOf[p].n;
        if(p!=address(0) && n<=m) {
          emit Burn(p,n);
          balanceOf[p].n -= n;
          totalSupply.n -= n;
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
  function updateTransferFromOnInsertRecv_transferFrom_r22(address o,address r,uint n) private   returns (bool) {
      address s = msg.sender;
      uint k = allowance[o][s].n;
      uint m = balanceOf[o].n;
      if(m>=n && k>=n) {
        emit TransferFrom(o,r,s,n);
        emit Transfer(o,r,n);
        balanceOf[o].n -= n;
        balanceOf[r].n += n;
        allowance[o][s].n -= n;
        return true;
      }
      return false;
  }
  function updateMintOnInsertRecv_buyToken_r2(address p,uint m) private   returns (bool) {
      uint e = end.time;
      uint r = rate.r;
      uint s = start.time;
      uint t = block.timestamp;
      if(p!=address(0) && t<e && m!=0 && t>s) {
        uint n = m*r;
        emit Mint(p,n);
        totalSupply.n += n;
        balanceOf[p].n += n;
        return true;
      }
      return false;
  }
}

contract CappedCrowdSale {
  struct RaisedTuple {
    uint n;
    bool _valid;
  }
  struct EndTuple {
    uint time;
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
  struct CapTuple {
    uint n;
    bool _valid;
  }
  struct RateTuple {
    uint r;
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
  RaisedTuple raised;
  EndTuple end;
  mapping(address=>BalanceOfTuple) balanceOf;
  mapping(address=>mapping(address=>AllowanceTuple)) allowance;
  FinalizedTuple finalized;
  OwnerTuple owner;
  CapTuple cap;
  RateTuple rate;
  StartTuple start;
  TotalSupplyTuple totalSupply;
  event Burn(address p,uint amount);
  event Mint(address p,uint amount);
  event BuyToken(address p,uint amount);
  event IncreaseAllowance(address p,address s,uint n);
  event Transfer(address from,address to,uint amount);
  event TransferFrom(address from,address to,address spender,uint amount);
  event Finalize();
  bool onceFinalized;
  Tx transaction;
  enum Tx {
	BuyToken,Finalize, TransferFrom, Approve, Mint, Burn, Transfer
  }
  constructor() public {
    updateTotalSupplyOnInsertConstructor_r1();
    updateOnceFinalizeOnInsertConstructor_r16();
    updateOwnerOnInsertConstructor_r4();
  }
    modifier checkBuyAfterFinalization {
        require(!(transaction==Tx.BuyToken && onceFinalized));
        _;
        assert(!(transaction==Tx.BuyToken && onceFinalized));
    }

    modifier checkEndAfterFinalization {
        require(!(onceFinalized && block.timestamp < end.time && raised.n<cap.n));
        _;
        assert(!(onceFinalized && block.timestamp < end.time && raised.n<cap.n));
    }
  function approve(address s,uint n) public  checkEndAfterFinalization   {
      bool r24 = updateIncreaseAllowanceOnInsertRecv_approve_r24(s,n);
      if(r24==false) {
        revert("Rule condition failed");
      }
      transaction=Tx.Approve;
  }
  function transferFrom(address from,address to,uint amount) public    checkEndAfterFinalization{
      bool r25 = updateTransferFromOnInsertRecv_transferFrom_r25(from,to,amount);
      if(r25==false) {
        revert("Rule condition failed");
      }
      transaction=Tx.TransferFrom;
  }
  function mint(address p,uint amount) public    checkEndAfterFinalization{
      bool r23 = updateMintOnInsertRecv_mint_r23(p,amount);
      if(r23==false) {
        revert("Rule condition failed");
      }
      transaction=Tx.Mint;
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
  function finalize() public    checkEndAfterFinalization{
      bool r17 = updateFinalizeOnInsertRecv_finalize_r17();
      bool r27 = updateFinalizeOnInsertRecv_finalize_r27();
      if(r17==false && r27==false) {
        revert("Rule condition failed");
      }
      onceFinalized=true;
      transaction=Tx.Finalize;
  }
  function transfer(address to,uint amount) public    checkEndAfterFinalization{
      bool r20 = updateTransferOnInsertRecv_transfer_r20(to,amount);
      if(r20==false) {
        revert("Rule condition failed");
      }
      transaction=Tx.Transfer;
  }
  function buyToken(address p,uint amount) public    checkEndAfterFinalization{
      bool r10 = updateBuyTokenOnInsertRecv_buyToken_r10(p,amount);
      if(r10==false) {
        revert("Rule condition failed");
      }
      transaction=Tx.BuyToken;
  }
  function burn(address p,uint amount) public    checkEndAfterFinalization{
      bool r14 = updateBurnOnInsertRecv_burn_r14(p,amount);
      if(r14==false) {
        revert("Rule condition failed");
      }
      transaction=Tx.Burn;
  }
  function updateTransferOnInsertRecv_transfer_r20(address r,uint n) private   returns (bool) {
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
  function updateFinalizeOnInsertRecv_finalize_r17() private   returns (bool) {
      uint c = cap.n;
      address s = msg.sender;
      if(false==finalized.b) {
        uint m = raised.n;
        if(s==owner.p) {
          if(m>=c) {
            emit Finalize();
            finalized = FinalizedTuple(true,true);
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
  function updateTotalSupplyOnInsertConstructor_r1() private    {
      totalSupply = TotalSupplyTuple(0,true);
  }
  function updateTransferFromOnInsertRecv_transferFrom_r25(address o,address r,uint n) private   returns (bool) {
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
  function updateOnceFinalizeOnInsertConstructor_r16() private    {
      // Empty()
  }
  function updateOwnerOnInsertConstructor_r4() private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
  }
  function updateMintOnInsertRecv_mint_r23(address p,uint n) private   returns (bool) {
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
  function updateFinalizeOnInsertRecv_finalize_r27() private   returns (bool) {
      address s = msg.sender;
      uint e = end.time;
      if(false==finalized.b) {
        if(s==owner.p) {
          uint t = block.timestamp;
          if(t>e) {
            emit Finalize();
            finalized = FinalizedTuple(true,true);
            return true;
          }
        }
      }
      return false;
  }
  function updateBurnOnInsertRecv_burn_r14(address p,uint n) private   returns (bool) {
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
  function updateBuyTokenOnInsertRecv_buyToken_r10(address p,uint m) private   returns (bool) {
      uint e = end.time;
      uint r = rate.r;
      if(false==finalized.b) {
        uint s = start.time;
        uint t = block.timestamp;
        if(p!=address(0) && t<e && m!=0 && t>s) {
          uint n = m*r;
          emit BuyToken(p,n);
          raised.n += n;
          emit Mint(p,n);
          totalSupply.n += n;
          balanceOf[p].n += n;
          return true;
        }
      }
      return false;
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
}

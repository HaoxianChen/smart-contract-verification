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

  constructor() public {
    updateTotalSupplyOnInsertConstructor_r1();
    updateOnceFinalizeOnInsertConstructor_r16();
    updateOwnerOnInsertConstructor_r4();
  }
  function finalize() public  checkBuyAfterFinalization checkEndAfterFinalization  {
      bool r27 = updateFinalizeOnInsertRecv_finalize_r27();
      bool r17 = updateFinalizeOnInsertRecv_finalize_r17();
      if(r27==false && r17==false) {
        revert("Rule condition failed");
      }
      onceFinalized=true;
      transaction=Tx.Finalize;
  }
  function approve(address s,uint n) public  checkBuyAfterFinalization checkEndAfterFinalization  {
      bool r24 = updateIncreaseAllowanceOnInsertRecv_approve_r24(s,n);
      if(r24==false) {
        revert("Rule condition failed");
      }
      transaction=Tx.Approve;
  }
  function transferFrom(address from,address to,uint amount) public  checkBuyAfterFinalization checkEndAfterFinalization  {
      bool r25 = updateTransferFromOnInsertRecv_transferFrom_r25(from,to,amount);
      if(r25==false) {
        revert("Rule condition failed");
      }
      transaction=Tx.TransferFrom;
  }
  function mint(address p,uint amount) public  checkBuyAfterFinalization checkEndAfterFinalization  {
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
  function transfer(address to,uint amount) public  checkBuyAfterFinalization checkEndAfterFinalization  {
      bool r20 = updateTransferOnInsertRecv_transfer_r20(to,amount);
      if(r20==false) {
        revert("Rule condition failed");
      }
      transaction=Tx.Transfer;
  }
  function buyToken(address p,uint amount) public  checkBuyAfterFinalization checkEndAfterFinalization  {
      bool r10 = updateBuyTokenOnInsertRecv_buyToken_r10(p,amount);
      if(r10==false) {
        revert("Rule condition failed");
      }
      transaction=Tx.BuyToken;
  }
  function burn(address p,uint amount) public  checkBuyAfterFinalization checkEndAfterFinalization  {
      bool r14 = updateBurnOnInsertRecv_burn_r14(p,amount);
      if(r14==false) {
        revert("Rule condition failed");
      }
      transaction=Tx.Burn;
  }
  function updateMintOnInsertBuyToken_r18(address p,uint n) private    {
      updateAllMintOnInsertMint_r9(n);
      updateTotalMintOnInsertMint_r12(p,n);
      emit Mint(p,n);
  }
  function updateFinalizedOnInsertFinalize_r19() private    {
      finalized = FinalizedTuple(true,true);
  }
  function updateFinalizeOnInsertRecv_finalize_r17() private   returns (bool) {
      uint c = cap.n;
      address s = msg.sender;
      if(false==finalized.b) {
        uint m = raised.n;
        if(s==owner.p) {
          if(m>=c) {
            updateFinalizedOnInsertFinalize_r19();
            emit Finalize();
            return true;
          }
        }
      }
      return false;
  }
  function updateTotalOutOnInsertTransfer_r21(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalOut_r2(p,delta0);
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateBalanceOfOnIncrementTotalOut_r2(address p,int o) private    {
      int _delta = int(-o);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateAllMintOnInsertMint_r9(uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyOnIncrementAllMint_r13(delta0);
  }
  function updateTotalSupplyOnIncrementAllBurn_r13(int b) private    {
      int _delta = int(-b);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateTransferOnInsertTransferFrom_r0(address o,address r,uint n) private    {
      updateTotalInOnInsertTransfer_r28(r,n);
      updateTotalOutOnInsertTransfer_r21(o,n);
      emit Transfer(o,r,n);
  }
  function updateOnceFinalizeOnInsertConstructor_r16() private    {
      // Empty()
  }
  function updateAllowanceOnIncrementSpentTotal_r22(address o,address s,int l) private    {
      int _delta = int(-l);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function updateTransferOnInsertRecv_transfer_r20(address r,uint n) private   returns (bool) {
      address s = msg.sender;
      uint m = balanceOf[s].n;
      if(n<=m) {
        updateTotalInOnInsertTransfer_r28(r,n);
        updateTotalOutOnInsertTransfer_r21(s,n);
        emit Transfer(s,r,n);
        return true;
      }
      return false;
  }
  function updateTotalInOnInsertTransfer_r28(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalIn_r2(p,delta0);
  }
  function updateBalanceOfOnIncrementTotalIn_r2(address p,int i) private    {
      int _delta = int(i);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateBalanceOfOnIncrementTotalMint_r2(address p,int n) private    {
      int _delta = int(n);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateAllowanceOnIncrementAllowanceTotal_r22(address o,address s,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function updateAllBurnOnInsertBurn_r26(uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyOnIncrementAllBurn_r13(delta0);
  }
  function updateTotalMintOnInsertMint_r12(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalMint_r2(p,delta0);
  }
  function updateFinalizeOnInsertRecv_finalize_r27() private   returns (bool) {
      address s = msg.sender;
      uint e = end.time;
      if(false==finalized.b) {
        if(s==owner.p) {
          uint t = block.timestamp;
          if(t>e) {
            updateFinalizedOnInsertFinalize_r19();
            emit Finalize();
            return true;
          }
        }
      }
      return false;
  }
  function updateTransferFromOnInsertRecv_transferFrom_r25(address o,address r,uint n) private   returns (bool) {
      address s = msg.sender;
      uint k = allowance[o][s].n;
      uint m = balanceOf[o].n;
      if(m>=n && k>=n) {
        updateSpentTotalOnInsertTransferFrom_r3(o,s,n);
        updateTransferOnInsertTransferFrom_r0(o,r,n);
        emit TransferFrom(o,r,s,n);
        return true;
      }
      return false;
  }
  function updateTotalBurnOnInsertBurn_r11(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalBurn_r2(p,delta0);
  }
  function updateMintOnInsertRecv_mint_r23(address p,uint n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        if(p!=address(0)) {
          updateAllMintOnInsertMint_r9(n);
          updateTotalMintOnInsertMint_r12(p,n);
          emit Mint(p,n);
          return true;
        }
      }
      return false;
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r24(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      uint m = allowance[o][s].n;
      uint d = n-m;
      updateAllowanceTotalOnInsertIncreaseAllowance_r5(o,s,d);
      emit IncreaseAllowance(o,s,d);
      return true;
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
          updateMintOnInsertBuyToken_r18(p,n);
          updateRaisedOnInsertBuyToken_r8(n);
          emit BuyToken(p,n);
          return true;
        }
      }
      return false;
  }
  function updateTotalSupplyOnIncrementAllMint_r13(int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateTotalSupplyOnInsertConstructor_r1() private    {
      totalSupply = TotalSupplyTuple(0,true);
  }
  function updateAllowanceTotalOnInsertIncreaseAllowance_r5(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementAllowanceTotal_r22(o,s,delta0);
  }
  function updateBalanceOfOnIncrementTotalBurn_r2(address p,int m) private    {
      int _delta = int(-m);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateSpentTotalOnInsertTransferFrom_r3(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementSpentTotal_r22(o,s,delta0);
  }
  function updateBurnOnInsertRecv_burn_r14(address p,uint n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        uint m = balanceOf[p].n;
        if(p!=address(0) && n<=m) {
          updateTotalBurnOnInsertBurn_r11(p,n);
          updateAllBurnOnInsertBurn_r26(n);
          emit Burn(p,n);
          return true;
        }
      }
      return false;
  }
  function updateRaisedOnInsertBuyToken_r8(uint n) private    {
      raised.n += n;
  }
  function updateOwnerOnInsertConstructor_r4() private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
  }
//  function buyAfterFinalization() public view {
//    assert(!(transaction==Tx.BuyToken && onceFinalized));
//  }
//
//  function endAfterFinalization() public view {
//    assert(!(onceFinalized && block.timestamp < end.time && raised.n<cap.n));
//  }
}

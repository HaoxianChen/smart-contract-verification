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
  function transferFrom(address from,address to,uint amount) public  checkEndAfterFinalization   {
      bool r22 = updateTransferFromOnInsertRecv_transferFrom_r22(from,to,amount);
      if(r22==false) {
        revert("Rule condition failed");
      }
      transaction=Tx.TransferFrom;
  }
  function approve(address s,uint n) public  checkEndAfterFinalization   {
      bool r21 = updateIncreaseAllowanceOnInsertRecv_approve_r21(s,n);
      if(r21==false) {
        revert("Rule condition failed");
      }
      transaction=Tx.Approve;
  }
  function mint(address p,uint amount) public  checkEndAfterFinalization   {
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
  function buyToken(address p,uint amount) public  checkEndAfterFinalization   {
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
  function finalize() public  checkEndAfterFinalization   {
      bool r24 = updateFinalizeOnInsertRecv_finalize_r24();
      if(r24==false) {
        revert("Rule condition failed");
      }
      onceFinalized=true;
      transaction=Tx.Finalize;
  }
  function burn(address p,uint amount) public  checkEndAfterFinalization   {
      bool r15 = updateBurnOnInsertRecv_burn_r15(p,amount);
      if(r15==false) {
        revert("Rule condition failed");
      }
      transaction=Tx.Burn;
  }
  function transfer(address to,uint amount) public  checkEndAfterFinalization   {
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
  function updateIncreaseAllowanceOnInsertRecv_approve_r21(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      uint m = allowance[o][s].n;
      uint d = n-m;
      updateAllowanceTotalOnInsertIncreaseAllowance_r11(o,s,d);
      emit IncreaseAllowance(o,s,d);
      return true;
      return false;
  }
  function updateFinalizedOnInsertFinalize_r7() private    {
      finalized = FinalizedTuple(false,true);
  }
  function updateOnceFinalizeOnInsertFinalize_r16() private    {
      // Empty()
  }
  function updateAllowanceTotalOnInsertIncreaseAllowance_r11(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementAllowanceTotal_r19(o,s,delta0);
  }
  function updateAllowanceOnIncrementAllowanceTotal_r19(address o,address s,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function updateFinalizeOnInsertRecv_finalize_r24() private   returns (bool) {
      address s = msg.sender;
      uint e = end.time;
      if(false==finalized.b) {
        if(s==owner.p) {
          uint t = block.timestamp;
          if(t>e) {
            updateOnceFinalizeOnInsertFinalize_r16();
            updateFinalizedOnInsertFinalize_r7();
            emit Finalize();
            return true;
          }
        }
      }
      return false;
  }
  function updateMintOnInsertRecv_mint_r20(address p,uint n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        if(p!=address(0)) {
          updateTotalMintOnInsertMint_r13(p,n);
          updateAllMintOnInsertMint_r4(n);
          emit Mint(p,n);
          return true;
        }
      }
      return false;
  }
  function updateTransferOnInsertTransferFrom_r0(address o,address r,uint n) private    {
      updateTotalOutOnInsertTransfer_r18(o,n);
      updateTotalInOnInsertTransfer_r25(r,n);
      emit Transfer(o,r,n);
  }
  function updateOwnerOnInsertConstructor_r9() private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
  }
  function updateTransferFromOnInsertRecv_transferFrom_r22(address o,address r,uint n) private   returns (bool) {
      address s = msg.sender;
      uint k = allowance[o][s].n;
      uint m = balanceOf[o].n;
      if(m>=n && k>=n) {
        updateSpentTotalOnInsertTransferFrom_r8(o,s,n);
        updateTransferOnInsertTransferFrom_r0(o,r,n);
        emit TransferFrom(o,r,s,n);
        return true;
      }
      return false;
  }
  function updateSpentTotalOnInsertTransferFrom_r8(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementSpentTotal_r19(o,s,delta0);
  }
  function updateAllBurnOnInsertBurn_r23(uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyOnIncrementAllBurn_r14(delta0);
  }
  function updateOnceFinalizeOnInsertConstructor_r5() private    {
      // Empty()
  }
  function updateTransferOnInsertRecv_transfer_r17(address r,uint n) private   returns (bool) {
      address s = msg.sender;
      uint m = balanceOf[s].n;
      if(n<=m) {
        updateTotalInOnInsertTransfer_r25(r,n);
        updateTotalOutOnInsertTransfer_r18(s,n);
        emit Transfer(s,r,n);
        return true;
      }
      return false;
  }
  function updateTotalSupplyOnIncrementAllMint_r14(int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateBalanceOfOnIncrementTotalBurn_r6(address p,int m) private    {
      int _delta = int(-m);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateTotalBurnOnInsertBurn_r12(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalBurn_r6(p,delta0);
  }
  function updateAllMintOnInsertMint_r4(uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyOnIncrementAllMint_r14(delta0);
  }
  function updateAllowanceOnIncrementSpentTotal_r19(address o,address s,int l) private    {
      int _delta = int(-l);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function updateBalanceOfOnIncrementTotalMint_r6(address p,int n) private    {
      int _delta = int(n);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateTotalOutOnInsertTransfer_r18(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalOut_r6(p,delta0);
  }
  function updateTotalSupplyOnInsertConstructor_r3() private    {
      totalSupply = TotalSupplyTuple(0,true);
  }
  function updateMintOnInsertRecv_buyToken_r2(address p,uint m) private   returns (bool) {
      uint e = end.time;
      uint r = rate.r;
      uint s = start.time;
      uint t = block.timestamp;
      if(p!=address(0) && t<e && m!=0 && t>s) {
        uint n = m*r;
        updateTotalMintOnInsertMint_r13(p,n);
        updateAllMintOnInsertMint_r4(n);
        emit Mint(p,n);
        return true;
      }
      return false;
  }
  function updateBalanceOfOnIncrementTotalOut_r6(address p,int o) private    {
      int _delta = int(-o);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateBurnOnInsertRecv_burn_r15(address p,uint n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        uint m = balanceOf[p].n;
        if(p!=address(0) && n<=m) {
          updateTotalBurnOnInsertBurn_r12(p,n);
          updateAllBurnOnInsertBurn_r23(n);
          emit Burn(p,n);
          return true;
        }
      }
      return false;
  }
  function updateTotalInOnInsertTransfer_r25(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalIn_r6(p,delta0);
  }
  function updateTotalMintOnInsertMint_r13(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalMint_r6(p,delta0);
  }
  function updateBalanceOfOnIncrementTotalIn_r6(address p,int i) private    {
      int _delta = int(i);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateTotalSupplyOnIncrementAllBurn_r14(int b) private    {
      int _delta = int(-b);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }

//  function buyAfterFinalization() public view {
//    assert(!(transaction==Tx.BuyTokens && onceFinalized));
//  }
//
//  function endAfterFinalization() public view {
//    assert(!(onceFinalized && block.timestamp < end.time));
//  }
}

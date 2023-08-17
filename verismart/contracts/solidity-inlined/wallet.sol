contract Wallet {
  struct BalanceOfTuple {
    int n;
    bool _valid;
  }
  struct TotalSupplyTuple {
    int n;
    bool _valid;
  }
  struct NegativeBalanceTuple {
    int n;
    bool _valid;
  }
  struct OwnerTuple {
    address p;
    bool _valid;
  }
  struct NegativeBalanceKeyTuple {
    address p;
  }
  mapping(address=>BalanceOfTuple) balanceOf;
  TotalSupplyTuple totalSupply;
  mapping(address=>NegativeBalanceTuple) negativeBalance;
  OwnerTuple owner;
  NegativeBalanceKeyTuple[] negativeBalanceKeyArray;
  event Transfer(address from,address to,int amount);
  event Mint(address p,int amount);
  event Burn(address p,int amount);
  constructor() public {
    updateOwnerOnInsertConstructor_r2();
  }
  function mint(address p,int amount) public  {
	require(balanceOf[p].n >= 0);
      bool r9 = updateMintOnInsertRecv_mint_r9(p,amount);
      if(r9==false) {
        revert("Rule condition failed");
      }
	assert(balanceOf[p].n >= 0);
  }
  function getBalanceOf(address p) public view  returns (int) {
      int n = balanceOf[p].n;
      return n;
  }
  function transfer(address from,address to,int amount) public  {
	require(balanceOf[from].n >= 0);
	require(balanceOf[to].n >= 0);
      bool r12 = updateTransferOnInsertRecv_transfer_r12(from,to,amount);
      if(r12==false) {
        revert("Rule condition failed");
      }
	assert(balanceOf[from].n >= 0);
	assert(balanceOf[to].n >= 0);
  }
  function burn(address p,int amount) public  {
	require(balanceOf[p].n >= 0);
      bool r3 = updateBurnOnInsertRecv_burn_r3(p,amount);
      if(r3==false) {
        revert("Rule condition failed");
      }
	assert(balanceOf[p].n >= 0);
  }
  function getTotalSupply() public view  returns (int) {
      int n = totalSupply.n;
      return n;
  }
  function updateTransferOnInsertRecv_transfer_r12(address s,address r,int n) private   returns (bool) {
      int m = balanceOf[s].n;
      if(m>=n && n>0) {
        emit Transfer(s,r,n);
        balanceOf[r].n += n;
        balanceOf[s].n -= n;
        return true;
      }
      return false;
  }
  function updateBurnOnInsertRecv_burn_r3(address p,int n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        int m = balanceOf[p].n;
        if(p!=address(0) && n<=m) {
          emit Burn(p,n);
          totalSupply.n -= n;
          emit Transfer(p,address(0),n);
          balanceOf[address(0)].n += n;
          balanceOf[p].n -= n;
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
  function updateOwnerOnInsertConstructor_r2() private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
  }
  function updateMintOnInsertRecv_mint_r9(address p,int n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        if(n>0 && p!=address(0)) {
          emit Mint(p,n);
          totalSupply.n += n;
          emit Transfer(address(0),p,n);
          balanceOf[p].n += n;
          balanceOf[address(0)].n -= n;
          return true;
        }
      }
      return false;
  }
//  function check(address p) public view {
//	assert(balanceOf[p].n >= 0);
//	}
}

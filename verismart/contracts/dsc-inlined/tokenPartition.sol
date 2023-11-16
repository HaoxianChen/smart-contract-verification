contract TokenPartition {
  struct UnequalBalanceTuple {
    uint s;
    uint n;
    bool _valid;
  }
  struct OwnerTuple {
    address p;
    bool _valid;
  }
  struct TotalSupplyByPartitionTuple {
    uint n;
    bool _valid;
  }
  struct TotalSupplyTuple {
    uint n;
    bool _valid;
  }
  struct TotalBalancesByPartitionTuple {
    uint m;
    bool _valid;
  }
  struct BalanceOfByPartitionTuple {
    uint n;
    bool _valid;
  }
  struct UnequalBalanceKeyTuple {
    uint q;
  }
  mapping(uint=>UnequalBalanceTuple) unequalBalance;
  mapping(uint=>TotalSupplyByPartitionTuple) totalSupplyByPartition;
  TotalSupplyTuple totalSupply;
  mapping(address=>mapping(uint=>BalanceOfByPartitionTuple)) balanceOfByPartition;
  mapping(uint=>TotalBalancesByPartitionTuple) totalBalancesByPartition;
  OwnerTuple owner;
  UnequalBalanceKeyTuple[] unequalBalanceKeyArray;
  event TransferByPartition(address from,address to,uint q,uint amount);
  event IssueByPartition(address p,uint q,uint amount);
  event RedeemByPartition(address p,uint q,uint amount);
  constructor() public {
    updateOwnerOnInsertConstructor_r11();
    updateTotalSupplyOnInsertConstructor_r3();
  }
  function issueByPartition(address p,uint q,uint amount) public  {
		require(totalSupplyByPartition[q].n == totalBalancesByPartition[q].m);
      bool r1 = updateIssueByPartitionOnInsertRecv_issueByPartition_r1(p,q,amount);
      if(r1==false) {
        revert("Rule condition failed");
      }
		assert(totalSupplyByPartition[q].n == totalBalancesByPartition[q].m);
  }
  function transferByPartition(address to,uint q,uint amount) public  {
		require(totalSupplyByPartition[q].n == totalBalancesByPartition[q].m);
      bool r17 = updateTransferByPartitionOnInsertRecv_transferByPartition_r17(to,q,amount);
      if(r17==false) {
        revert("Rule condition failed");
      }
		assert(totalSupplyByPartition[q].n == totalBalancesByPartition[q].m);
  }
  function getTotalSupply() public view  returns (uint) {
      uint n = totalSupply.n;
      return n;
  }
  function redeemByPartition(address p,uint q,uint amount) public  {
		require(totalSupplyByPartition[q].n == totalBalancesByPartition[q].m);
      bool r9 = updateRedeemByPartitionOnInsertRecv_redeemByPartition_r9(p,q,amount);
      if(r9==false) {
        revert("Rule condition failed");
      }
		assert(totalSupplyByPartition[q].n == totalBalancesByPartition[q].m);
  }
  function getTotalSupplyByPartition(uint q) public view  returns (uint) {
      uint n = totalSupplyByPartition[q].n;
      return n;
  }
  function getBalanceOfByPartition(address p,uint q) public view  returns (uint) {
      uint n = balanceOfByPartition[p][q].n;
      return n;
  }
  function updateOwnerOnInsertConstructor_r11() private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
  }
  function updateIssueByPartitionOnInsertRecv_issueByPartition_r1(address p,uint q,uint n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        if(p!=address(0)) {
          emit IssueByPartition(p,q,n);
          totalSupply.n += n;
          totalSupplyByPartition[q].n += n;
          balanceOfByPartition[p][q].n += n;
          totalBalancesByPartition[q].m += n;
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
  function updateRedeemByPartitionOnInsertRecv_redeemByPartition_r9(address p,uint q,uint n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        uint m = balanceOfByPartition[p][q].n;
        if(p!=address(0) && n<=m) {
          emit RedeemByPartition(p,q,n);
          balanceOfByPartition[p][q].n -= n;
          totalBalancesByPartition[q].m -= n;
          totalSupply.n -= n;
          totalSupplyByPartition[q].n -= n;
          return true;
        }
      }
      return false;
  }
  function updateTransferByPartitionOnInsertRecv_transferByPartition_r17(address r,uint q,uint n) private   returns (bool) {
      address s = msg.sender;
      uint m = balanceOfByPartition[s][q].n;
      if(n<=m) {
        emit TransferByPartition(s,r,q,n);
        balanceOfByPartition[s][q].n -= n;
        totalBalancesByPartition[q].m -= n;
        balanceOfByPartition[r][q].n += n;
        totalBalancesByPartition[q].m += n;
        return true;
      }
      return false;
  }
  function updateTotalSupplyOnInsertConstructor_r3() private    {
      totalSupply = TotalSupplyTuple(0,true);
  }
	// function check(uint q) public view {
	// 	assert(totalSupplyByPartition[q].n == totalBalancesByPartition[q].m);
	// }
}

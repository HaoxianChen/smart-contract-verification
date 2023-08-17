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
      bool r1 = updateIssueByPartitionOnInsertRecv_issueByPartition_r1(p,q,amount);
      if(r1==false) {
        revert("Rule condition failed");
      }
  }
  function transferByPartition(address to,uint q,uint amount) public  {
      bool r17 = updateTransferByPartitionOnInsertRecv_transferByPartition_r17(to,q,amount);
      if(r17==false) {
        revert("Rule condition failed");
      }
  }
  function getTotalSupply() public view  returns (uint) {
      uint n = totalSupply.n;
      return n;
  }
  function redeemByPartition(address p,uint q,uint amount) public  {
      bool r9 = updateRedeemByPartitionOnInsertRecv_redeemByPartition_r9(p,q,amount);
      if(r9==false) {
        revert("Rule condition failed");
      }
  }
  function getTotalSupplyByPartition(uint q) public view  returns (uint) {
      uint n = totalSupplyByPartition[q].n;
      return n;
  }
  function getBalanceOfByPartition(address p,uint q) public view  returns (uint) {
      uint n = balanceOfByPartition[p][q].n;
      return n;
  }
  function checkUnequalBalance() private    {
      uint N = unequalBalanceKeyArray.length;
      for(uint i = 0; i<N; i = i+1) {
          UnequalBalanceKeyTuple memory unequalBalanceKeyTuple = unequalBalanceKeyArray[i];
          UnequalBalanceTuple memory unequalBalanceTuple = unequalBalance[unequalBalanceKeyTuple.q];
          if(unequalBalanceTuple._valid==true) {
            revert("unequalBalance");
          }
      }
  }
  function updateTotalSupplyOnIncrementAllMint_r7(int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateIssueByPartitionOnInsertRecv_issueByPartition_r1(address p,uint q,uint n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        if(p!=address(0)) {
          updateIssueTotalByPartitionOnInsertIssueByPartition_r5(q,n);
          updateTotalMintOnInsertIssueByPartition_r8(p,q,n);
          updateAllMintOnInsertIssueByPartition_r0(n);
          emit IssueByPartition(p,q,n);
          return true;
        }
      }
      return false;
  }
  function updateAllBurnOnInsertRedeemByPartition_r10(uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyOnIncrementAllBurn_r7(delta0);
  }
  function updateTotalSupplyOnIncrementAllBurn_r7(int b) private    {
      int _delta = int(-b);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateBalanceOfByPartitionOnIncrementTotalMint_r16(address p,uint q,int n) private    {
      int delta0 = int(n);
      updateTotalBalancesByPartitionOnIncrementBalanceOfByPartition_r2(q,delta0);
      int _delta = int(n);
      uint newValue = updateuintByint(balanceOfByPartition[p][q].n,_delta);
      balanceOfByPartition[p][q].n = newValue;
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateUnequalBalanceOnInsertTotalBalancesByPartition_r12(uint q,uint s) private    {
      TotalBalancesByPartitionTuple memory toDelete = totalBalancesByPartition[q];
      if(toDelete._valid==true) {
        updateUnequalBalanceOnDeleteTotalBalancesByPartition_r12(q,toDelete.m);
      }
      uint n = totalSupplyByPartition[q].n;
      if(s!=n) {
        unequalBalance[q] = UnequalBalanceTuple(s,n,true);
        unequalBalanceKeyArray.push(UnequalBalanceKeyTuple(q));
      }
  }
  function updateUnequalBalanceOnDeleteTotalBalancesByPartition_r12(uint q,uint s) private    {
      uint n = totalSupplyByPartition[q].n;
      if(s!=n) {
        if(s==unequalBalance[q].s && n==unequalBalance[q].n) {
          unequalBalance[q] = UnequalBalanceTuple(0,0,false);
        }
      }
  }
  function updateOwnerOnInsertConstructor_r11() private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
  }
  function updateTransferByPartitionOnInsertRecv_transferByPartition_r17(address r,uint q,uint n) private   returns (bool) {
      address s = msg.sender;
      uint m = balanceOfByPartition[s][q].n;
      if(n<=m) {
        updateTotalOutOnInsertTransferByPartition_r6(s,q,n);
        updateTotalInOnInsertTransferByPartition_r15(r,q,n);
        emit TransferByPartition(s,r,q,n);
        return true;
      }
      return false;
  }
  function updateUnequalBalanceOnDeleteTotalSupplyByPartition_r12(uint q,uint n) private    {
      uint s = totalBalancesByPartition[q].m;
      if(s!=n) {
        if(s==unequalBalance[q].s && n==unequalBalance[q].n) {
          unequalBalance[q] = UnequalBalanceTuple(0,0,false);
        }
      }
  }
  function updateRedeemByPartitionOnInsertRecv_redeemByPartition_r9(address p,uint q,uint n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        uint m = balanceOfByPartition[p][q].n;
        if(p!=address(0) && n<=m) {
          updateTotalBurnOnInsertRedeemByPartition_r14(p,q,n);
          updateRedeemTotalByPartitionOnInsertRedeemByPartition_r13(q,n);
          updateAllBurnOnInsertRedeemByPartition_r10(n);
          emit RedeemByPartition(p,q,n);
          return true;
        }
      }
      return false;
  }
  function updateUnequalBalanceOnInsertTotalSupplyByPartition_r12(uint q,uint n) private    {
      TotalSupplyByPartitionTuple memory toDelete = totalSupplyByPartition[q];
      if(toDelete._valid==true) {
        updateUnequalBalanceOnDeleteTotalSupplyByPartition_r12(q,toDelete.n);
      }
      uint s = totalBalancesByPartition[q].m;
      if(s!=n) {
        unequalBalance[q] = UnequalBalanceTuple(s,n,true);
        unequalBalanceKeyArray.push(UnequalBalanceKeyTuple(q));
      }
  }
  function updateTotalInOnInsertTransferByPartition_r15(address p,uint q,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfByPartitionOnIncrementTotalIn_r16(p,q,delta0);
  }
  function updateBalanceOfByPartitionOnIncrementTotalIn_r16(address p,uint q,int i) private    {
      int delta0 = int(i);
      updateTotalBalancesByPartitionOnIncrementBalanceOfByPartition_r2(q,delta0);
      int _delta = int(i);
      uint newValue = updateuintByint(balanceOfByPartition[p][q].n,_delta);
      balanceOfByPartition[p][q].n = newValue;
  }
  function updateTotalSupplyByPartitionOnIncrementRedeemTotalByPartition_r4(uint q,int r) private    {
      int delta0 = int(-r);
      updateUnequalBalanceOnIncrementTotalSupplyByPartition_r12(q,delta0);
      int _delta = int(-r);
      uint newValue = updateuintByint(totalSupplyByPartition[q].n,_delta);
      totalSupplyByPartition[q].n = newValue;
  }
  function updateBalanceOfByPartitionOnIncrementTotalBurn_r16(address p,uint q,int m) private    {
      int delta0 = int(-m);
      updateTotalBalancesByPartitionOnIncrementBalanceOfByPartition_r2(q,delta0);
      int _delta = int(-m);
      uint newValue = updateuintByint(balanceOfByPartition[p][q].n,_delta);
      balanceOfByPartition[p][q].n = newValue;
  }
  function updateTotalOutOnInsertTransferByPartition_r6(address p,uint q,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfByPartitionOnIncrementTotalOut_r16(p,q,delta0);
  }
  function updateTotalBalancesByPartitionOnIncrementBalanceOfByPartition_r2(uint q,int n) private    {
      // int delta1 = int(n);
      // updateUnequalBalanceOnIncrementTotalBalancesByPartition_r12(s,delta1);
      int _delta = int(n);
      uint newValue = updateuintByint(totalBalancesByPartition[q].m,_delta);
      totalBalancesByPartition[q].m = newValue;
  }
  function updateTotalMintOnInsertIssueByPartition_r8(address p,uint q,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfByPartitionOnIncrementTotalMint_r16(p,q,delta0);
  }
  function updateUnequalBalanceOnIncrementTotalSupplyByPartition_r12(uint q,int n) private    {
      int _delta = int(n);
      uint newValue = updateuintByint(totalSupplyByPartition[q].n,_delta);
      updateUnequalBalanceOnInsertTotalSupplyByPartition_r12(q,newValue);
  }
  // function updateUnequalBalanceOnIncrementTotalBalancesByPartition_r12(uint s,int s) private    {
  //     int _delta = int(s);
  //     uint newValue = updateuintByint(totalBalancesByPartition[s].m,_delta);
  //     updateUnequalBalanceOnInsertTotalBalancesByPartition_r12(q,newValue);
  // }
  function updateTotalSupplyByPartitionOnIncrementIssueTotalByPartition_r4(uint q,int i) private    {
      int delta0 = int(i);
      updateUnequalBalanceOnIncrementTotalSupplyByPartition_r12(q,delta0);
      int _delta = int(i);
      uint newValue = updateuintByint(totalSupplyByPartition[q].n,_delta);
      totalSupplyByPartition[q].n = newValue;
  }
  function updateRedeemTotalByPartitionOnInsertRedeemByPartition_r13(uint q,uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyByPartitionOnIncrementRedeemTotalByPartition_r4(q,delta0);
  }
  function updateIssueTotalByPartitionOnInsertIssueByPartition_r5(uint q,uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyByPartitionOnIncrementIssueTotalByPartition_r4(q,delta0);
  }
  function updateBalanceOfByPartitionOnIncrementTotalOut_r16(address p,uint q,int o) private    {
      int delta0 = int(-o);
      updateTotalBalancesByPartitionOnIncrementBalanceOfByPartition_r2(q,delta0);
      int _delta = int(-o);
      uint newValue = updateuintByint(balanceOfByPartition[p][q].n,_delta);
      balanceOfByPartition[p][q].n = newValue;
  }
  function updateAllMintOnInsertIssueByPartition_r0(uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyOnIncrementAllMint_r7(delta0);
  }
  function updateTotalBurnOnInsertRedeemByPartition_r14(address p,uint q,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfByPartitionOnIncrementTotalBurn_r16(p,q,delta0);
  }
  function updateTotalSupplyOnInsertConstructor_r3() private    {
      totalSupply = TotalSupplyTuple(0,true);
  }

	function check(uint q) public view {
		assert(totalSupplyByPartition[q].n == totalBalancesByPartition[q].m);
	}
}

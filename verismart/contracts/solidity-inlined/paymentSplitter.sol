contract PaymentSplitter {
  struct SharesTuple {
    uint n;
    bool _valid;
  }
  struct ReleasedTuple {
    uint n;
    bool _valid;
  }
  struct TotalReceivedTuple {
    uint n;
    bool _valid;
  }
  struct TotalSharesTuple {
    uint n;
    bool _valid;
  }
  mapping(address=>SharesTuple) shares;
  mapping(address=>ReleasedTuple) released;
  TotalReceivedTuple totalReceived;
  TotalSharesTuple totalShares;
  event Release(address p,uint n);
  function release(address payable p) public    {
      bool r6 = updateReleaseOnInsertRecv_release_r6(p);
      if(r6==false) {
        revert("Rule condition failed");
      }
  }
  function updateReleaseOnInsertRecv_release_r6(address payable p) private   returns (bool) {
      uint r = totalReceived.n;
      uint s = totalShares.n;
      uint m = shares[p].n;
      uint e = released[p].n;
      if((r*m)/s>e) {
        uint n = ((r*m)/s)-e;
        emit Release(p,n);
        totalReceived.n += n;
        p.send(n);
        released[p].n += n;
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
  function check(address p) public view {
    uint256 amount = (shares[p].n * totalReceived.n) / totalShares.n ;
    assert(released[p].n <= amount );
  }
}

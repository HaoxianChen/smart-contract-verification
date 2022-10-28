contract PaymentSpliter {
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
  struct OverpaidKeyTuple {
    address p;
  }
  TotalReceivedTuple totalReceived;
  TotalSharesTuple totalShares;
  mapping(address=>SharesTuple) shares;
  mapping(address=>ReleasedTuple) released;
  OverpaidKeyTuple[] overpaidKeyArray;
  event Release(address p,uint n);

    constructor(address[] memory payees, uint256[] memory shares_) payable {
        require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
        require(payees.length > 0, "PaymentSplitter: no payees");
        require(address(this).balance == 0);

        for (uint256 i = 0; i < payees.length; i++) {
          shares[payees[i]].n = shares_[i];
          totalShares.n = totalShares.n + shares_[i];
        }
    }

  function release(address p) public    {
      bool r5 = updateReleaseOnInsertRecv_release_r5(p);
      if(r5==false) {
        revert("Rule condition failed");
      }
  }
  function updateReleaseOnInsertRecv_release_r5(address p) private   returns (bool) {
      if(true) {
        uint r = totalReceived.n;
        if(true) {
          uint s = totalShares.n;
          SharesTuple memory sharesTuple = shares[p];
          if(true) {
            uint m = sharesTuple.n;
            ReleasedTuple memory releasedTuple = released[p];
            if(true) {
              uint e = releasedTuple.n;
              if((r*m)/s>e) {
                uint n = ((r*m)/s)-e;
                updateTotalReleasedOnInsertRelease_r1(n);
                updateReleasedOnInsertRelease_r4(p,n);
                emit Release(p,n);
                return true;
              }
            }
          }
        }
      }
      return false;
  }
  function updateTotalReleasedOnInsertRelease_r1(uint e) private    {
      int delta = int(e);
      updateTotalReceivedOnIncrementTotalReleased_r2(delta);
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateReleasedOnInsertRelease_r4(address p,uint n) private    {
      int _delta = int(n);
      uint newValue = updateuintByint(released[p].n,_delta);
      released[p].n = newValue;
  }
  function updateTotalReceivedOnIncrementTotalReleased_r2(int e) private    {
      int _delta = int(e);
      uint newValue = updateuintByint(totalReceived.n,_delta);
      totalReceived.n = newValue;
  }

  function check(address p) public view {
    uint256 amount = (shares[p].n * totalReceived.n) / totalShares.n ;
    assert(released[p].n <= amount );
  }
}

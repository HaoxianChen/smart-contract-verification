contract VestingWallet {
  struct BeneficiaryTuple {
    address p;
    bool _valid;
  }
  struct DurationTuple {
    uint t;
    bool _valid;
  }
  struct StartTuple {
    uint t;
    bool _valid;
  }
  struct ReleasedTuple {
    uint n;
    bool _valid;
  }
  ReleasedTuple released;
  BeneficiaryTuple beneficiary;
  DurationTuple duration;
  StartTuple start;
  event Release(uint n);
  constructor(uint s,uint d,address b) {
    updateStartOnInsertConstructor_r1(s);
    updateDurationOnInsertConstructor_r6(d);
    updateBeneficiaryOnInsertConstructor_r5(b);
  }
  function release() public    {
      bool r7 = updateReleaseOnInsertRecv_release_r7();
      bool r8 = updateReleaseOnInsertRecv_release_r8();
      if(r7==false && r8==false) {
        revert("Rule condition failed");
      }
  }
  function getReleased() public view  returns (uint) {
      uint n = released.n;
      return n;
  }
  function updateReleasedOnInsertRelease_r0(uint n) private    {
      int _delta = int(n);
      uint newValue = updateuintByint(released.n,_delta);
      released.n = newValue;
  }
  function updateDurationOnInsertConstructor_r6(uint d) private    {
      if(true) {
        duration = DurationTuple(d,true);
      }
  }
  function updateStartOnInsertConstructor_r1(uint a) private    {
      if(true) {
        uint t = block.timestamp;
        if(true) {
          uint s = a+t;
          start = StartTuple(s,true);
        }
      }
  }
  function updateuintByint(uint x,int delta) private pure  returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateBeneficiaryOnInsertConstructor_r5(address b) private    {
      if(true) {
        beneficiary = BeneficiaryTuple(b,true);
      }
  }
  function updateSendOnInsertRelease_r2(uint n) private    {
      if(true) {
        address b = beneficiary.p;
        if(n>0) {
          payable(b).transfer(n);
        }
      }
  }
  function updateReleaseOnInsertRecv_release_r7() private   returns (bool) {
      if(true) {
        uint d = duration.t;
        if(true) {
          uint e = released.n;
          if(true) {
            uint b = address(this).balance;
            if(true) {
              uint a = start.t;
              if(true) {
                uint t = block.timestamp;
                if(t>a && ((b+e)*(t-a))/d>e && d<a+d && b+e>=b && t<a+d && d>0 && b+e>=e && a<a+d) {
                  uint n = (((b+e)*(t-a))/d)-e;
                  updateSendOnInsertRelease_r2(n);
                  updateReleasedOnInsertRelease_r0(n);
                  emit Release(n);
                  return true;
                }
              }
            }
          }
        }
      }
      return false;
  }
  function updateReleaseOnInsertRecv_release_r8() private   returns (bool) {
      if(true) {
        uint d = duration.t;
        if(true) {
          uint e = released.n;
          if(true) {
            uint b = address(this).balance;
            if(true) {
              uint a = start.t;
              if(true) {
                uint t = block.timestamp;
                if(d<a+d && b>e && a<a+d && t>a+d) {
                  uint n = b-e;
                  updateSendOnInsertRelease_r2(n);
                  updateReleasedOnInsertRelease_r0(n);
                  emit Release(n);
                  return true;
                }
              }
            }
          }
        }
      }
      return false;
  }
  function earlyRelease() public view {
    assert(released.n == 0 || block.timestamp >= start.t);
  }
}

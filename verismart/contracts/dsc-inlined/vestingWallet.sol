contract VestingWallet {
  struct EarlyReleaseTuple {
    uint e;
    bool _valid;
  }
  struct BeneficiaryTuple {
    address payable p;
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
  EarlyReleaseTuple earlyRelease;
  ReleasedTuple released;
  BeneficiaryTuple beneficiary;
  DurationTuple duration;
  StartTuple start;
  event Release(uint n);
  constructor(uint s,uint d,address payable b) public {
    updateDurationOnInsertConstructor_r5(d);
    updateStartOnInsertConstructor_r1(s);
    updateBeneficiaryOnInsertConstructor_r4(b);
  }
  function release() public  {
    require(released.n == 0 || block.timestamp >= start.t);
      bool r7 = updateReleaseOnInsertRecv_release_r7();
      bool r6 = updateReleaseOnInsertRecv_release_r6();
      if(r7==false && r6==false) {
        revert("Rule condition failed");
      }
    assert(released.n == 0 || block.timestamp >= start.t);
  }
  function getReleased() public view  returns (uint) {
      uint n = released.n;
      return n;
  }
  function updateReleaseOnInsertRecv_release_r7() private   returns (bool) {
      uint d = duration.t;
      uint e = released.n;
      uint b = address(this).balance;
      uint a = start.t;
      uint t = block.timestamp;
      if(d<a+d && b>e && a<a+d && t>a+d) {
        uint n = b-e;
        emit Release(n);
        released.n += n;
        address payable b = beneficiary.p;
        if(n>0) {
          b.send(n);
        }
        return true;
      }
      return false;
  }
  function updateReleaseOnInsertRecv_release_r6() private   returns (bool) {
      uint d = duration.t;
      uint e = released.n;
      uint b = address(this).balance;
      uint a = start.t;
      uint t = block.timestamp;
      if(t>a && ((b+e)*(t-a))/d>e && d<a+d && b+e>=b && t<a+d && d>0 && b+e>=e && a<a+d) {
        uint n = (((b+e)*(t-a))/d)-e;
        emit Release(n);
        released.n += n;
        address payable b = beneficiary.p;
        if(n>0) {
          b.send(n);
        }
        return true;
      }
      return false;
  }
  function updateBeneficiaryOnInsertConstructor_r4(address payable b) private    {
      beneficiary = BeneficiaryTuple(b,true);
  }
  function updateDurationOnInsertConstructor_r5(uint d) private    {
      duration = DurationTuple(d,true);
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateStartOnInsertConstructor_r1(uint a) private    {
      uint t = block.timestamp;
      uint s = a+t;
      start = StartTuple(s,true);
  }
  // function check() public view {
  //   assert(released.n == 0 || block.timestamp >= start.t);
  // }
}

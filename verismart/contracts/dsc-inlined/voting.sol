contract Voting {
  struct QuorumSizeTuple {
    uint q;
    bool _valid;
  }
  struct IsVoterTuple {
    bool b;
    bool _valid;
  }
  struct WinningProposalTuple {
    uint proposal;
    bool _valid;
  }
  struct VotedTuple {
    bool b;
    bool _valid;
  }
  struct VotesTuple {
    uint c;
    bool _valid;
  }
  struct WinsTuple {
    bool b;
    bool _valid;
  }
  struct HasWinnerTuple {
    bool b;
    bool _valid;
  }
  mapping(address=>IsVoterTuple) isVoter;
  WinningProposalTuple winningProposal;
  mapping(address=>VotedTuple) voted;
  HasWinnerTuple hasWinner;
  mapping(uint=>VotesTuple) votes;
  mapping(uint=>WinsTuple) wins;
  QuorumSizeTuple quorumSize;
  event Vote(address p,uint proposal);
  function getWinningProposal() public view  returns (uint) {
      uint proposal = winningProposal.proposal;
      return proposal;
  }
  function getHasWinner() public view  returns (bool) {
      bool b = hasWinner.b;
      return b;
  }
  function getIsVoter(address v) public view  returns (bool) {
      bool b = isVoter[v].b;
      return b;
  }
  function getVoted(address p) public view  returns (bool) {
      bool b = voted[p].b;
      return b;
  }
  function getWins(uint proposal) public view  returns (bool) {
      bool b = wins[proposal].b;
      return b;
  }
  function getVotes(uint proposal) public view  returns (uint) {
      uint c = votes[proposal].c;
      return c;
  }
  function vote(uint proposal) public    {
      bool r5 = updateVoteOnInsertRecv_vote_r5(proposal);
      if(r5==false) {
        revert("Rule condition failed");
      }
  }
  function updateVoteOnInsertRecv_vote_r5(uint p) private   returns (bool) {
      if(false==hasWinner.b) {
        address v = msg.sender;
        if(true==isVoter[v].b) {
          if(false==voted[v].b) {
            emit Vote(v,p);
            votes[p].c += 1;
            uint r2_c = votes[p].c;
            uint q = quorumSize.q;
            if(r2_c>=q) {
              wins[p] = WinsTuple(true,true);
              hasWinner = HasWinnerTuple(true,true);
              winningProposal = WinningProposalTuple(p,true);
            }
            voted[v] = VotedTuple(true,true);
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
  function inconsistency(uint32 p1, uint32 p2) public view {
    assert(p1==p2 || !(wins[p1].b && wins[p2].b));
  }
}

// SPDX-License-Identifier: GPL-3.0

// Adopted from: https://github.com/ethereum/eips/issues/1411

contract TokenPartition {
    address owner;

    mapping(address => mapping(uint256 => uint256)) balanceOfByPartition;
    mapping(uint256 => uint256) totalSupplyByPartition;

    event IssueByPartition(address issuer, address acount, uint256 partition,
                          uint256 amount);
    event RedeemptionByPartition(address issuer, address acount, 
                                 uint256 partition, uint256 amount);
    event TransferByPartition(address from, address to, 
                                 uint256 partition, uint256 amount);

    mapping(uint256 => uint256) totalBalanceByPartition;

    constructor() public {
      owner = msg.sender;
    }

    modifier onlyOwner() {
      require(msg.sender == owner);
      _;
    }

    modifier checkInvariant(uint256 partition) {
      require(totalSupplyByPartition[partition] == totalBalanceByPartition[partition]);
      _;
      assert(totalSupplyByPartition[partition] == totalBalanceByPartition[partition]);
    }

    function issueByPartition(address account, uint256 partition, 
                              uint256 amount) public onlyOwner checkInvariant(partition) {
      // require(totalSupplyByPartition[partition] == totalBalanceByPartition[partition]);
      require(account!=address(0));
      balanceOfByPartition[account][partition] += amount;
      totalBalanceByPartition[partition] += amount;
      totalSupplyByPartition[partition] += amount;
      emit IssueByPartition(msg.sender, account, partition, amount);
      // assert(totalSupplyByPartition[partition] == totalBalanceByPartition[partition]);
    }

    function redeemByPartition(address account, uint256 partition,
                              uint256 amount) public onlyOwner {
      require(totalSupplyByPartition[partition] == totalBalanceByPartition[partition]);
      require(account!=address(0));
      require(balanceOfByPartition[account][partition] >= amount);
      balanceOfByPartition[account][partition] -= amount;
      totalBalanceByPartition[partition] -= amount;
      totalSupplyByPartition[partition] -=amount;
      emit RedeemptionByPartition(msg.sender, account, partition, amount);
      assert(totalSupplyByPartition[partition] == totalBalanceByPartition[partition]);
    }

    function transferByPartition(address from, address to, uint256 partition,
                                uint256 amount) public {
      require(totalSupplyByPartition[partition] == totalBalanceByPartition[partition]);
      require(from!=address(0));
      require(to!=address(0));
      require(balanceOfByPartition[from][partition] >= amount);

      balanceOfByPartition[from][partition] -= amount;
      totalBalanceByPartition[partition] -= amount;

      balanceOfByPartition[to][partition] += amount;
      totalBalanceByPartition[partition] += amount;

      emit TransferByPartition(from,to,partition,amount);
      assert(totalSupplyByPartition[partition] == totalBalanceByPartition[partition]);
    }

    function equalBalance(uint256 partition) public view {
      // assert(totalSupplyByPartition[partition] == totalBalanceByPartition[partition]);
    }


}
